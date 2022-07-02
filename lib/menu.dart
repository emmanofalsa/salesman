import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:salesman/data_privacy_notice/privacy_notice.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/hepe_sales/sales.dart';
import 'package:salesman/hepe_sync/sync.dart';
import 'package:salesman/providers/delivery_items.dart';
import 'package:salesman/providers/upload_length.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/url/url.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';
import 'home.dart';
// import 'package:salesman/collection/collection.dart';
import 'package:salesman/history/history.dart';
import 'package:salesman/profile/profile.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  SessionTimer sessionTimer = SessionTimer();
  ScrollController _scrollController = ScrollController();

  // final orangeColor = ColorsTheme.mainColor;
  // final yellowColor = Colors.amber;
  // final blueColor = Colors.blue;

  int _currentIndex = 0;

  String err1 = 'No Internet Connection';
  String err2 = 'No Connection to Server';
  String err3 = 'API Error';

  final db = DatabaseHelper();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  bool viewPol = true;
  bool testEnv = false;

  Timer? timer;

  final List<Widget> _children = [
    Home(),
    // Collection(),
    HepeSalesPage(),
    History(),
    SyncHepe(),
    Profile(),
  ];

  @override
  void initState() {
    if (mounted) {
      timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkStatus());
    }
    super.initState();
    checkAppEnvironment();
    OrderData.visible = true;
    _currentIndex = GlobalVariables.menuKey;
    GlobalVariables.dataPrivacyNoticeScrollBottom = false;
    checkStatus();
    _initializeTimer();
    // viewPolicy();
    getAppVersion();
    checkAppEnvironment();
  }

  checkAppEnvironment() {
    if (UrlAddress.url == 'https://distapp1.alturush.com/') {
      setState(() {
        testEnv = true;
      });
    } else {
      setState(() {
        testEnv = false;
      });
    }
  }

  getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    // String buildNumber = packageInfo.buildNumber;
    _initPackageInfo();
    print(_packageInfo);
    AppData.appVersion = version;
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void onTappedBar(int index) {
    _currentIndex = index;
    setState(() {
      // _currentIndex = index;
    });
  }

  void _initializeTimer() {
    sessionTimer.initializeTimer(context);
  }

  checkStatus() async {
    var stat = await db.checkStat();
    // print('HEPE FORM NOT DISPOSED!');
    // setState(() {
    if (stat == 'Connected') {
      NetworkData.connected = true;
      NetworkData.errorMsgShow = false;
      // upload();
      NetworkData.errorMsg = '';
      // print('Connected to Internet!');
    } else {
      if (stat == 'ERROR1') {
        NetworkData.connected = false;
        NetworkData.errorMsgShow = true;
        NetworkData.errorMsg = err1;
        NetworkData.errorNo = '1';
        // print('Network Error...');
      }
      if (stat == 'ERROR2') {
        NetworkData.connected = false;
        NetworkData.errorMsgShow = true;
        NetworkData.errorMsg = err2;
        NetworkData.errorNo = '2';
        // print('Connection to API Error...');
      }
      if (stat == 'ERROR3') {
        NetworkData.connected = false;
        NetworkData.errorMsgShow = true;
        NetworkData.errorMsg = err3;
        NetworkData.errorNo = '3';
        // print('API Error...');
      }
      if (stat == 'Updating') {
        NetworkData.connected = false;
        NetworkData.errorMsgShow = true;
        NetworkData.errorMsg = 'Updating Server';
        // print('Updating Server...');
      }
    }
    // });
    // checkDevice();
    if (viewPol == true) {
      if (GlobalVariables.viewPolicy == true) {
        viewPol = false;
        viewPolicy();
      }
    }
  }

  viewPolicy() {
    if (GlobalVariables.viewPolicy == true) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => WillPopScope(
          onWillPop: () async => false,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              _scrollController.addListener(() {
                if (_scrollController.position.pixels ==
                    _scrollController.position.maxScrollExtent) {
                  if (GlobalVariables.dataPrivacyNoticeScrollBottom == false) {
                    setState(() {
                      GlobalVariables.dataPrivacyNoticeScrollBottom = true;
                    });
                  }
                }
              });

              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      width: MediaQuery.of(context).size.width,
                      child: ListView(
                        controller: _scrollController,
                        children: <Widget>[
                          DataPrivacyNotice(),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      "Close",
                      style: TextStyle(
                          color:
                              GlobalVariables.dataPrivacyNoticeScrollBottom ==
                                      true
                                  ? ColorsTheme.mainColor
                                  : Colors.grey),
                    ),
                    onPressed: () {
                      if (GlobalVariables.dataPrivacyNoticeScrollBottom ==
                          true) {
                        Navigator.pop(context);
                        GlobalVariables.viewPolicy = false;
                      }
                    },
                  ),
                ],
              );
            },
          ),
        ),
      );
    }
  }

  checkDevice() async {
    if (NetworkData.connected == true) {
      // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // // print('Running on ${androidInfo.model}');
      // print(androidInfo.toString());
    }
  }

  void handleUserInteraction([_]) {
    // _initializeTimer();

    SessionTimer sessionTimer = SessionTimer();
    sessionTimer.initializeTimer(context);
  }

  @override
  void dispose() {
    timer?.cancel();
    print('Timer Disposed');
    super.dispose();
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
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          body: _children[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            fixedColor: testEnv ? Colors.blue : ColorsTheme.mainColor,
            onTap: onTappedBar,
            type: BottomNavigationBarType.fixed,
            currentIndex:
                _currentIndex, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: (int.parse(Provider.of<DeliveryCounter>(context)
                            .itmNo
                            .toString()) ==
                        0)
                    ? Icon(Icons.home)
                    : Container(
                        width: 30,
                        child: Stack(
                          children: [
                            Icon(Icons.home),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Container(
                                  // margin: EdgeInsets.only(top: 2),
                                  padding: EdgeInsets.only(top: 0),
                                  width: 20,
                                  height: 15,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue),
                                  child: Text(
                                    Provider.of<DeliveryCounter>(context)
                                        .itmNo
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.leaderboard_rounded), label: 'Sales'),
              // BottomNavigationBarItem(
              //     icon: new Icon(Icons.equalizer), title: new Text('Sales')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: 'History'),
              BottomNavigationBarItem(
                  icon: (int.parse(Provider.of<UploadLength>(context)
                              .itmNo
                              .toString()) ==
                          0)
                      ? Icon(Icons.sync)
                      : Container(
                          width: 30,
                          child: Stack(
                            children: [
                              Icon(Icons.sync),
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    // margin: EdgeInsets.only(top: 2),
                                    padding: EdgeInsets.only(top: 0),
                                    width: 20,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.green),
                                    child: Text(
                                      Provider.of<UploadLength>(context)
                                          .itmNo
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  label: 'Sync'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile')
            ],
          ),
        ),
      ),
    );
  }
}
