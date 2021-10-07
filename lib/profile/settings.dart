import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

class ViewSettings extends StatefulWidget {
  @override
  _ViewSettingsState createState() => _ViewSettingsState();
}

class _ViewSettingsState extends State<ViewSettings> {
  void handleUserInteraction([_]) {
    // _initializeTimer();

    SessionTimer sessionTimer = SessionTimer();
    sessionTimer.initializeTimer(context);
  }

  _toggle() {
    setState(() {
      GlobalVariables.viewImg = !GlobalVariables.viewImg;
      print(GlobalVariables.viewImg);
    });
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
                'Settings',
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
                    child: Column(
                      children: [
                        SizedBox(height: 15),
                        buildImageOption(context),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildImageOption(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          // if (NetworkData.connected == true) {
          //   _toggle();
          // } else {
          //   showGlobalSnackbar('Connectivity', 'Please connect to internet.',
          //       Colors.red.shade900, Colors.white);
          // }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                CupertinoIcons.photo_fill,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                'View Item Images',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14,
                ),
              ),
            ),
            // Icon(
            //   Icons.chevron_right,
            //   color: Colors.grey,
            // )
            Switcher(
              switcherRadius: 50,
              value: GlobalVariables.viewImg,
              colorOff: Colors.grey,
              colorOn: Colors.greenAccent,
              iconOff: CupertinoIcons.xmark,
              onChanged: (bool val) {
                // setState(() {
                GlobalVariables.viewImg = val;
                //   print(GlobalVariables.viewImg);
                // });
              },
              size: SwitcherSize.small,
            ),
          ],
        ),
      ),
    );
  }
}
