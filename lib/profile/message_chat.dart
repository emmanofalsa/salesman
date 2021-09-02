import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/snackbar.dart';

class ChatBox extends StatefulWidget {
  @override
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  Timer timer;
  bool viewspinkit = true;
  bool online = false;
  bool abletoSend = false;
  bool isMe = false;
  bool cust = false;
  bool viewdate = false;
  bool sending = false;
  List msgs = [];

  final db = DatabaseHelper();

  final msgController = TextEditingController();

  void initState() {
    if (mounted) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkStatus());
    }
    super.initState();
    checkStatus();
  }

  checkStatus() async {
    // print('CHATROOM TIMER RUNNING');
    // print(ChatData.status);
    setState(() {
      online = NetworkData.connected;
    });
    if (UserData.position == 'Salesman') {
      abletoSend = true;
    } else {
      abletoSend = false;
    }
    if (NetworkData.connected) {
      var getM = await db.getMessage(ChatData.refNo);
      if (!mounted) return;
      setState(() {
        msgs = getM;
        // print(msgs);
        if (msgs.isNotEmpty) {
          viewspinkit = false;
        }
        setMsgDateTime();
      });
      if (ChatData.newNotif && abletoSend == true) {
        // print('MISUD');
        await db.changeMsgStat(ChatData.refNo);
      } else {
        print(ChatData.newNotif);
        // print('WALA NISUD');
      }
    }
  }

  setMsgDateTime() {
    String date = "";
    String newDate = "";
    final date2 = DateTime.now();
    msgs.forEach((element) {
      // setState(() {
      date = element['msg_datetime'];
      DateTime s = DateTime.parse(date);
      // final difference = date2.difference(s).inDays;
      final difference = (date2.difference(s).inHours / 24).round();

      // print(difference);
      if (difference == 0) {
        newDate = DateFormat("hh:mm aaa").format(s);
      } else {
        newDate = DateFormat("MMM dd, yyyy").format(s) +
            ' at ' +
            DateFormat("hh:mm aaa").format(s);
      }
      element['msg_datetime'] = newDate;
      // });
    });
  }

  sendMessage(String msg) async {
    sending = true;
    var send = await db.sendMsg(ChatData.accountCode, ChatData.refNo, msg);
    if (send == true) {
      setState(() {
        sending = false;
      });
    }
  }

  void dispose() {
    timer?.cancel();
    print('CHATRoom Timer Disposed');
    super.dispose();
  }

  // void _toggle() {
  //   setState(() {
  //     _obscureText = !_obscureText;
  //   });
  // }

  void handleUserInteraction([_]) {
    // _initializeTimer();

    SessionTimer sessionTimer = SessionTimer();
    sessionTimer.initializeTimer(context);
  }

  _callNumber(String phone) async {
    // const number = '08592119XXXX'; //set the number here
    print(phone);
    bool res = await FlutterPhoneDirectCaller.callNumber(phone);
    print(res);
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
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: Container(child: Text(ChatData.accountName))),
              GestureDetector(
                onTap: () {
                  String _phone = '0' + ChatData.accountNum;
                  _callNumber(_phone);
                },
                child: Icon(
                  CupertinoIcons.phone_circle,
                  color: Colors.white,
                  size: 30,
                ),
              )
            ],
          ),
          centerTitle: false,
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
              if (!online)
                Container(
                  height: 20,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black87,
                  child: Center(
                    child: Text(
                      'No Internet Connection',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: viewspinkit
                      ? SpinKitFadingCircle(
                          color: ColorsTheme.mainColor,
                          size: 50,
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: msgs.length,
                          itemBuilder: (context, index) {
                            if (msgs[index]['sender'] == 'salesman' ||
                                msgs[index]['sender'] == 'Salesman') {
                              isMe = true;
                              msgs[index]['sender'] = 'Salesman';
                            } else {
                              isMe = false;
                              if (msgs[index]['sender'] == 'customer' ||
                                  msgs[index]['sender'] == 'Customer') {
                                cust = true;
                                msgs[index]['sender'] = 'Customer';
                              } else {
                                cust = false;
                              }
                            }
                            if (msgs[index]['sender'] == 'backend') {
                              msgs[index]['sender'] = 'Administrator';
                            }

                            return GestureDetector(
                              onTap: () {
                                // var val = msgs[index]['viewdate'].toString();
                                // bool b = val.toLowerCase() == true;
                                if (msgs[index]['viewdate'] == 'false') {
                                  setState(() {
                                    msgs[index]['viewdate'] = 'true';
                                  });
                                } else {
                                  setState(() {
                                    msgs[index]['viewdate'] = 'false';
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 8),
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(
                                        left: 35,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: isMe
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            msgs[index]['sender'],
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: isMe
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (!isMe)
                                          Icon(
                                            Icons.account_circle,
                                            size: 36,
                                            color: cust
                                                ? Colors.blue[300]
                                                : Colors.grey,
                                          ),
                                        Container(
                                            padding: EdgeInsets.all(10),
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.5),
                                            decoration: BoxDecoration(
                                                color: isMe
                                                    ? ColorsTheme.mainColorLight
                                                    : cust
                                                        ? Colors.blue[300]
                                                        : Colors.grey[100],
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  topRight: Radius.circular(16),
                                                  bottomLeft: Radius.circular(
                                                      isMe ? 12 : 0),
                                                  bottomRight: Radius.circular(
                                                      isMe ? 0 : 12),
                                                )),
                                            child: Text(
                                              msgs[index]['msg_body'],
                                              style: TextStyle(
                                                  color: isMe
                                                      ? Colors.white
                                                      : cust
                                                          ? Colors.white
                                                          : Colors.black),
                                            ))
                                      ],
                                    ),
                                    Visibility(
                                      visible:
                                          msgs[index]['viewdate'] == 'true',
                                      child: Container(
                                        padding: EdgeInsets.only(
                                          left: 35,
                                        ),
                                        child: Row(
                                          mainAxisAlignment: isMe
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              msgs[index]['msg_datetime'],
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.white,
                height: 100,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 60,
                        // margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.emoji_emotions_outlined,
                              color: Colors.grey[500],
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: TextField(
                                enabled: abletoSend,
                                maxLines: 10,
                                controller: msgController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: abletoSend
                                        ? 'Type your message ...'
                                        : 'Viewing only...',
                                    hintStyle:
                                        TextStyle(color: Colors.grey[500])),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (msgController.text == '') {
                        } else {
                          if (ChatData.status == 'closed') {
                            showGlobalSnackbar(
                                'Information',
                                'This conversation is already closed.',
                                Colors.blue,
                                Colors.white);
                          } else {
                            sendMessage(msgController.text);
                            msgController.text = '';
                          }
                        }
                      },
                      child: Transform.rotate(
                        angle: 320 * pi / 180,
                        child: sending
                            ? SpinKitRing(
                                lineWidth: 4.0,
                                color: ColorsTheme.mainColor,
                                size: 24,
                              )
                            : Icon(
                                Icons.send,
                                color: ColorsTheme.mainColor,
                                size: 36,
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
