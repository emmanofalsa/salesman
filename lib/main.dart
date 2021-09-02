import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:root_check/root_check.dart';
import 'package:salesman/customer/customer.dart';
// import 'package:salesman/homescreen.dart';
import 'package:salesman/menu.dart';
import 'package:salesman/option.dart';
// import 'package:salesman/rooted/rooted.dart';
// import 'package:salesman/router/router.dart';
import 'package:salesman/salesman_home/menu.dart';
import 'package:salesman/variables/assets.dart';
import 'package:salesman/variables/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return GetMaterialApp(
      title: 'Salesman',
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      theme: ThemeData(
        primarySwatch: ColorsTheme.mainColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: new HomeScreen(),
      // home: new RootedScreen(),
      // onGenerateRoute: Routers.onGenerateRoute,
      initialRoute: "/splash",
      routes: {
        "/splash": (context) => Splash(),
        "/option": (context) => MyOptionPage(),
        "/smmenu": (context) => SalesmanMenu(),
        "/smcustomer": (context) => Customer(),
        "/hepemenu": (context) => Menu(),
      },
      // home: Splash(),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isRootedDevice = false;
  // String _text = 'Unknown';

  // Future<void> initPlatformState() async {
  //   bool isRooted = await RootCheck.isRooted;

  //   if (!mounted) return;

  //   setState(() {
  //     // _text = t;
  //     isRootedDevice = isRooted;
  //   });
  // }

  @override
  void initState() {
    super.initState();
    //ROOT CHECK
    // initPlatformState();
    // isRootedDevice = false;
    new Timer(new Duration(seconds: 2), () {
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            Container(
              color: ColorsTheme.mainColor,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Center(
                        child: Container(
                          // padding: EdgeInsets.only(top: 50),
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.height / 3,
                          child: Column(
                            children: [
                              Image(
                                image: AssetsValues.mainlogo,
                              ),
                              // SpinKitThreeBounce(
                              //   color: Colors.white,
                              //   size: 60,
                              // )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                // height: 30,
                // color: Colors.grey,
                child: Text(
                  'E-COMMERCE COPYRIGHT 2020',
                  style: TextStyle(
                      color: ColorsTheme.mainColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future checkFirstSeen() async {
    // if (isRootedDevice == false) {
    print('WELCOME');
    dispose();
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: Duration(seconds: 1),
            transitionsBuilder: (context, animation, animationTimne, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            pageBuilder: (context, animation, animationTime) {
              return MyOptionPage();
            }));
  }
}
