import 'package:flutter/material.dart';

import 'package:salesman/data_privacy_notice/privacy_notice.dart';

import 'package:salesman/session/session_timer.dart';
import 'package:salesman/variables/colors.dart';

class ViewNotice extends StatefulWidget {
  @override
  _ViewNoticeState createState() => _ViewNoticeState();
}

class _ViewNoticeState extends State<ViewNotice> {
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
          // automaticallyImplyLeading: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Notice',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ],
          ),
          // centerTitle: true,
          elevation: 0,
          // toolbarHeight: 50,
        ),
        backgroundColor: ColorsTheme.mainColor,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        )),
                    child: DataPrivacyNotice()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
