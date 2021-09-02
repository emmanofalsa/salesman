import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  Timer timer;
  bool viewspinkit = true;
  bool online = false;
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
    print('CHATROOM TIMER RUNNING');
    setState(() {
      online = NetworkData.connected;
    });
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
      if (ChatData.newNotif) {
        await db.changeMsgStat(ChatData.refNo);
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
    var send = await db.sendMsg(CustomerData.accountCode, ChatData.refNo, msg);
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ChatData.senderName),
              Row(
                children: [
                  Text(
                    online ? 'Online' : 'Offline',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(width: 5),
                  Container(
                    // margin: EdgeInsets.only(top: 2),
                    padding: EdgeInsets.only(top: 3),
                    width: 15,
                    height: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: online
                            ? Colors.greenAccent[400]
                            : Colors.redAccent[400]),
                  ),
                ],
              ),
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
                                padding: EdgeInsets.all(8),
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
                                controller: msgController,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Type your message ...',
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
                          sendMessage(msgController.text);
                          msgController.text = '';
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
