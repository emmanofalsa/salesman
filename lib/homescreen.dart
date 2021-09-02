// import 'dart:async';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:salesman/option.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

//   Timer timer;

//   void initState() {
//     timer = Timer.periodic(Duration(seconds: 1), (Timer t) => navtoLogin());

//     super.initState();
//   }

//   navtoLogin() {
//     print('WELCOME');
//     dispose();
//     Navigator.push(
//         context,
//         PageRouteBuilder(
//             transitionDuration: Duration(seconds: 1),
//             transitionsBuilder: (context, animation, animationTimne, child) {
//               return FadeTransition(
//                 opacity: animation,
//                 child: child,
//               );
//             },
//             pageBuilder: (context, animation, animationTime) {
//               return MyOptionPage();
//             }));
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () => Future.value(false),
//       child: Scaffold(
//         key: _scaffoldKey,
//         body: Stack(
//           children: <Widget>[
//             Container(
//               color: Colors.deepOrange,
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: <Widget>[
//                   Stack(
//                     children: <Widget>[
//                       Center(
//                         child: Container(
//                           // padding: EdgeInsets.only(top: 50),
//                           width: MediaQuery.of(context).size.width / 2,
//                           height: MediaQuery.of(context).size.height / 3,
//                           child: Image(
//                             image: AssetImage('assets/images/ldi2.png'),
//                           ),
//                         ),
//                       ),
//                       Align(
//                         alignment: Alignment.center,
//                         child: Container(
//                           width: MediaQuery.of(context).size.width / 2,
//                           height: MediaQuery.of(context).size.height / 3,
//                           padding: EdgeInsets.only(top: 0, left: 0),
//                           child: SpinKitDualRing(
//                             color: Colors.white,
//                             size: 220,
//                             lineWidth: 10,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Container(
//                 width: MediaQuery.of(context).size.width,
//                 // height: 30,
//                 // color: Colors.grey,
//                 child: Text(
//                   'E-COMMERCE COPYRIGHT 2020',
//                   style: TextStyle(
//                       color: Colors.deepOrange,
//                       fontSize: 10,
//                       fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
