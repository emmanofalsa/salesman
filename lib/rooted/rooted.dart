import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesman/variables/assets.dart';
import 'package:salesman/widgets/elevated_button.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:salesman/option.dart';
// import 'package:timezone/timezone.dart';

class RootedScreen extends StatefulWidget {
  @override
  _RootedScreenState createState() => _RootedScreenState();
}

class _RootedScreenState extends State<RootedScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Timer? timer;

  String notice =
      'We are sorry but due to security concerns. This app cannot be used on rooted devices. Application will now exit.';

  void initState() {
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => navtoLogin());

    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
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
              // color: Colors.black,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetsValues.rootedImg,
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    // height: 200,
                    // color: Colors.grey,
                    decoration: BoxDecoration(
                        border: Border.all(width: 3, color: Colors.white),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Column(
                      children: [
                        Card(
                            // elevation: 10,
                            color: Colors.white24,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text('ROOTED DEVICE DETECTED',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            )),
                        Card(
                            // elevation: 10,
                            color: Colors.white24,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  notice,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            )),
                        ElevatedButton(
                            style: raisedButtonStyleBlack,
                            child: Text(
                              'OKAY',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: () {
                              exit(0);
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Align(
            //   alignment: Alignment.bottomCenter,
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     // height: 30,
            //     // color: Colors.grey,
            //     child: Text(
            //       'E-COMMERCE COPYRIGHT 2020',
            //       style: TextStyle(
            //           color: Colors.deepOrange,
            //           fontSize: 10,
            //           fontWeight: FontWeight.bold),
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
