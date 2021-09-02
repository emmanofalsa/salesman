import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/profile/message_chat.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';

class MessageInbox extends StatefulWidget {
  @override
  _MessageInboxState createState() => _MessageInboxState();
}

class _MessageInboxState extends State<MessageInbox> {
  // CustomerProfile customerProfile = CustomerProfile();

  Timer timer;

  List test = [];
  List msgList = [];

  bool online = false;
  bool active = false;
  bool newMsg = false;
  bool msgSeen = false;
  bool isMe = false;
  bool viewspinkit = true;

  final db = DatabaseHelper();

  void initState() {
    super.initState();
    if (mounted) {
      timer = Timer.periodic(Duration(seconds: 2), (Timer t) => checkStatus());
    }

    // checkStatus();
  }

  checkStatus() async {
    print('INBOX TIMER RUNNING');
    // if (!mounted) return;
    setState(() {
      online = NetworkData.connected;
    });
    if (NetworkData.connected) {
      var getM = await db.getAllMessageLog();
      if (!mounted) return;
      setState(() {
        msgList = getM;
        // print(msgList);
        if (msgList.isNotEmpty) {
          // if (!mounted) return;
          setState(() {
            viewspinkit = false;
          });
        }
        setDateTime();
      });
    }
  }

  setDateTime() {
    String date = "";
    String newDate = "";
    final date2 = DateTime.now();
    msgList.forEach((element) {
      setState(() {
        date = element['msgdate'];
        DateTime s = DateTime.parse(date);
        // final difference = date2.difference(s).inDays;
        final difference = (date2.difference(s).inHours / 24).round();
        if (difference > 7) {
          newDate = DateFormat("dd/MM/yyyy").format(s);
        }
        if (difference <= 7) {
          newDate = DateFormat("EEEE").format(s);
        }
        if (difference == 1) {
          newDate = 'Yesterday';
        }
        if (difference == 0) {
          newDate = DateFormat("hh:mm aaa").format(s);
        }
        element['msgdate'] = newDate;
      });
    });
  }

  void dispose() {
    timer?.cancel();
    // timer.cancel();
    print('Inbox Timer Disposed');
    super.dispose();
  }

  void handleUserInteraction([_]) {
    // _initializeTimer();

    SessionTimer sessionTimer = SessionTimer();
    sessionTimer.initializeTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        handleUserInteraction();
      },
      onPanDown: (details) {
        handleUserInteraction();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Messages',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          centerTitle: true,
          elevation: 0,
          // toolbarHeight: 50,
        ),
        backgroundColor: ColorsTheme.mainColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    child: viewspinkit
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SpinKitFadingCircle(
                                color: ColorsTheme.mainColor,
                                size: 50,
                              ),
                              Text(
                                "Loading Messages...",
                                style: TextStyle(color: ColorsTheme.mainColor),
                              )
                            ],
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: msgList.length,
                            itemBuilder: (context, index) {
                              if (msgList[index]['status'] == 'active') {
                                active = true;
                              } else {
                                active = false;
                              }
                              if (msgList[index]['lastmsgsender'] !=
                                      'salesman' &&
                                  msgList[index]['smmsgstat'] != 'seen') {
                                newMsg = true;
                              } else {
                                newMsg = false;
                              }
                              if (msgList[index]['lastmsgsender'] ==
                                      'salesman' &&
                                  msgList[index]['admmsgstat'] != 'unseen') {
                                msgSeen = true;
                              } else {
                                msgSeen = false;
                              }

                              if (msgList[index]['lastmsgsender'] ==
                                  'salesman') {
                                isMe = true;
                              } else {
                                isMe = false;
                              }

                              return GestureDetector(
                                onTap: () {
                                  if (msgList[index]['lastmsgsender'] !=
                                          'salesman' &&
                                      msgList[index]['smmsgstat'] != 'seen') {
                                    ChatData.newNotif = true;
                                  } else {
                                    ChatData.newNotif = false;
                                  }

                                  ChatData.senderName =
                                      msgList[index]['sender_backend'];
                                  ChatData.accountCode =
                                      msgList[index]['account_code'];
                                  ChatData.accountName =
                                      msgList[index]['account_name'];
                                  ChatData.accountNum =
                                      msgList[index]['account_num'];
                                  ChatData.refNo = msgList[index]['ref_no'];
                                  ChatData.status = msgList[index]['status'];
                                  // dispose();
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ChatBox();
                                  }));
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(40),
                                        topRight: Radius.circular(40),
                                        bottomLeft: Radius.circular(40),
                                        bottomRight: Radius.circular(40),
                                      )),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 40,
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  Icons.account_circle,
                                                  color: Colors.grey,
                                                  size: 70,
                                                ),
                                                // foregroundColor: Colors.grey,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            10,
                                                    child: Text(
                                                      msgList[index]
                                                          ['account_name'],
                                                      style: TextStyle(
                                                        color: active
                                                            ? ColorsTheme
                                                                .mainColorDark
                                                            : ColorsTheme
                                                                .mainColor,
                                                        fontWeight: active
                                                            ? FontWeight.bold
                                                            : FontWeight.w500,
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      textAlign: TextAlign.left,
                                                    ),
                                                  ),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            10,
                                                    // height: 30,
                                                    child: isMe
                                                        ? Text(
                                                            'You: ' +
                                                                msgList[index]
                                                                    ['lastmsg'],
                                                            style: TextStyle(
                                                              color: active
                                                                  ? Colors
                                                                      .grey[800]
                                                                  : Colors.grey,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          )
                                                        : Text(
                                                            msgList[index]
                                                                ['lastmsg'],
                                                            style: TextStyle(
                                                              color: active
                                                                  ? Colors
                                                                      .grey[800]
                                                                  : Colors.grey,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Visibility(
                                            visible: newMsg,
                                            child: Container(
                                              // margin: EdgeInsets.only(top: 2),
                                              // color: Colors.grey,
                                              padding: EdgeInsets.only(top: 3),
                                              width: 20,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red),
                                              child: Text(
                                                '1',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            msgList[index]['msgdate'],
                                            style: TextStyle(
                                                color: active
                                                    ? Colors.grey[800]
                                                    : Colors.grey,
                                                fontSize: 10),
                                            textAlign: TextAlign.left,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Visibility(
                                            visible: newMsg,
                                            child: SizedBox(
                                              height: 20,
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: Visibility(
                                          visible: !newMsg,
                                          child: msgSeen
                                              ? Icon(
                                                  Icons.check,
                                                  size: 15,
                                                  color: ColorsTheme.mainColor,
                                                )
                                              : Icon(
                                                  Icons.check_circle,
                                                  size: 15,
                                                  color: ColorsTheme.mainColor,
                                                ),
                                        ),
                                      )
                                      // Row(
                                      //   children: [
                                      //     Column(
                                      //       children: [
                                      //         Row(
                                      //           children: [

                                      //           ],
                                      //         ),
                                      //       ],
                                      //     )
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              );
                            })),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
