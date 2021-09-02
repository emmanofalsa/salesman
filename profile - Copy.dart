// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:salesman/data_privacy_notice/privacy_notice.dart';
// import 'package:salesman/db/db_helper.dart';
// import 'package:salesman/forget_pass/change_password.dart';
// // import 'package:salesman/option.dart';
// import 'package:salesman/session/session_timer.dart';
// import 'package:salesman/userdata.dart';

// // import '../api.dart';

// class Profile extends StatefulWidget {
//   @override
//   _ProfileState createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   ScrollController _scrollController = ScrollController();

//   void initState() {
//     super.initState();
//     GlobalVariables.dataPrivacyNoticeScrollBottom = false;
//   }

//   void handleUserInteraction([_]) {
//     // _initializeTimer();

//     SessionTimer sessionTimer = SessionTimer();
//     sessionTimer.initializeTimer(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       behavior: HitTestBehavior.translucent,
//       onTap: () {
//         handleUserInteraction();
//       },
//       onPanDown: (details) {
//         handleUserInteraction();
//       },
//       child: Scaffold(
//         body: Stack(
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 0),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 15,
//                   ),
//                   buildHeader(),
//                   buildIcon(),
//                   Text(
//                     UserData.firstname + " " + UserData.lastname,
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     UserData.position,
//                     style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Container(
//                     width: MediaQuery.of(context).size.width - 100,
//                     height: MediaQuery.of(context).size.height - 370,
//                     child: SingleChildScrollView(
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           buildLocationCont(),
//                           buildContactCont(),
//                           buildRouteCont(),
//                           buildChangePCont(),
//                           buildLogoutCont(),
//                           // buildPolicy(),
//                         ],
//                       ),
//                     ),
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
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         print('NACLICK');
//                         showDialog(
//                           barrierDismissible: false,
//                           context: context,
//                           builder: (BuildContext context) => WillPopScope(
//                             onWillPop: () async => false,
//                             child: StatefulBuilder(
//                               builder:
//                                   (BuildContext context, StateSetter setState) {
//                                 _scrollController.addListener(() {
//                                   if (_scrollController.position.pixels ==
//                                       _scrollController
//                                           .position.maxScrollExtent) {
//                                     if (GlobalVariables
//                                             .dataPrivacyNoticeScrollBottom ==
//                                         false) {
//                                       setState(() {
//                                         GlobalVariables
//                                                 .dataPrivacyNoticeScrollBottom =
//                                             true;
//                                       });
//                                     }
//                                   }
//                                 });

//                                 return AlertDialog(
//                                   content: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: <Widget>[
//                                       Container(
//                                         height:
//                                             MediaQuery.of(context).size.height /
//                                                 1.5,
//                                         width:
//                                             MediaQuery.of(context).size.width,
//                                         child: ListView(
//                                           controller: _scrollController,
//                                           children: <Widget>[
//                                             DataPrivacyNotice(),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       child: Text(
//                                         "Close",
//                                         style: TextStyle(
//                                             color: GlobalVariables
//                                                         .dataPrivacyNoticeScrollBottom ==
//                                                     true
//                                                 ? Colors.deepOrange
//                                                 : Colors.grey),
//                                       ),
//                                       onPressed: () {
//                                         if (GlobalVariables
//                                                 .dataPrivacyNoticeScrollBottom ==
//                                             true) {
//                                           Navigator.pop(context);
//                                         }
//                                       },
//                                     ),
//                                   ],
//                                 );
//                               },
//                             ),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         'Data Privacy Notice',
//                         style: TextStyle(
//                             color: Colors.deepOrange,
//                             fontWeight: FontWeight.w500,
//                             decoration: TextDecoration.underline),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       'E-COMMERCE(DISTRIBUTION APP) V1.' +
//                           GlobalVariables.appVersion +
//                           ' COPYRIGHT 2020',
//                       style: TextStyle(
//                           color: Colors.grey,
//                           fontSize: 10,
//                           fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Container buildPolicy() {
//     return Container(
//       margin: EdgeInsets.only(
//         top: 10,
//       ),
//       // width: 350,
//       // height: 80,
//       child: Column(
//         children: <Widget>[Text('Terms of Service & Privacy Policy')],
//       ),
//     );
//   }

//   Container buildLogoutCont() {
//     return Container(
//       margin: EdgeInsets.only(
//         top: 10,
//       ),
//       // width: 350,
//       height: 70,
//       child: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(255, 255, 255, 1),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color.fromRGBO(5, 5, 5, 0.10000000149011612),
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               showDialog(
//                   context: context,
//                   builder: (context) {
//                     return AlertDialog(
//                       title: Text('Confirmation'),
//                       content: Text('Are you sure you want to logout?'),
//                       actions: <Widget>[
//                         TextButton(
//                             onPressed: () {
//                               GlobalVariables.menuKey = 0;
//                               // Navigator.pop(context);
//                               // Navigator.push(context,
//                               //     MaterialPageRoute(builder: (context) {
//                               //   return MyOptionPage();
//                               // }));

//                               Navigator.of(context).pushNamedAndRemoveUntil(
//                                   '/splash', (Route<dynamic> route) => false);
//                             },
//                             child: Text('OK')),
//                         TextButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text('Cancel'))
//                       ],
//                     );
//                   });
//             },
//             child: Row(
//               children: <Widget>[
//                 Container(
//                   width: 3,
//                   height: MediaQuery.of(context).size.height,
//                   color: Colors.deepOrange,
//                 ),
//                 Container(
//                   margin: EdgeInsets.all(10),
//                   width: 70,
//                   height: 70,
//                   child: Image(
//                     image: AssetImage('assets/images/logout.png'),
//                   ),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       'LOGOUT ACCOUNT',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(
//                           color: Colors.black54,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     // Text(
//                     //   userData.routes,
//                     //   textAlign: TextAlign.right,
//                     //   style: TextStyle(
//                     //       color: Colors.grey,
//                     //       fontSize: 16,
//                     //       fontWeight: FontWeight.normal),
//                     // ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Container buildChangePCont() {
//     return Container(
//       margin: EdgeInsets.only(
//         top: 10,
//       ),
//       // width: 350,
//       height: 70,
//       child: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(255, 255, 255, 1),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color.fromRGBO(5, 5, 5, 0.10000000149011612),
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//           ),
//           InkWell(
//             onTap: () {
//               if (NetworkData.connected == true) {
//                 showDialog(
//                     barrierDismissible: false,
//                     context: context,
//                     builder: (context) => InputPassDialog());
//               } else {
//                 showDialog(
//                     context: context,
//                     builder: (context) => UnableDialog(
//                           title: 'Connection Problem!',
//                           description: 'Connection Problem.' + ' Try Again.',
//                           buttonText: 'Okay',
//                         ));
//               }
//             },
//             child: Row(
//               children: <Widget>[
//                 Container(
//                   width: 3,
//                   height: MediaQuery.of(context).size.height,
//                   color: Colors.deepOrange,
//                 ),
//                 Container(
//                   margin: EdgeInsets.all(10),
//                   width: 70,
//                   height: 70,
//                   child: Image(
//                     image: AssetImage('assets/images/changep.png'),
//                   ),
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Text(
//                       'CHANGE PASSWORD',
//                       textAlign: TextAlign.right,
//                       style: TextStyle(
//                           color: Colors.black54,
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     // Text(
//                     //   userData.routes,
//                     //   textAlign: TextAlign.right,
//                     //   style: TextStyle(
//                     //       color: Colors.grey,
//                     //       fontSize: 16,
//                     //       fontWeight: FontWeight.normal),
//                     // ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Container buildRouteCont() {
//     return Container(
//       margin: EdgeInsets.only(
//         top: 10,
//       ),
//       // width: 350,
//       height: 70,
//       child: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(255, 255, 255, 1),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color.fromRGBO(5, 5, 5, 0.10000000149011612),
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             children: <Widget>[
//               Container(
//                 width: 3,
//                 height: MediaQuery.of(context).size.height,
//                 color: Colors.deepOrange,
//               ),
//               Container(
//                 margin: EdgeInsets.all(10),
//                 width: 70,
//                 height: 70,
//                 child: Image(
//                   image: AssetImage('assets/images/route.png'),
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     'Routes',
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     UserData.routes,
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 16,
//                         fontWeight: FontWeight.normal),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Container buildContactCont() {
//     return Container(
//       margin: EdgeInsets.only(
//         top: 10,
//       ),
//       // width: 350,
//       height: 70,
//       child: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(255, 255, 255, 1),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color.fromRGBO(5, 5, 5, 0.10000000149011612),
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             children: <Widget>[
//               Container(
//                 width: 3,
//                 height: MediaQuery.of(context).size.height,
//                 color: Colors.deepOrange,
//               ),
//               Container(
//                 margin: EdgeInsets.all(10),
//                 width: 70,
//                 height: 70,
//                 child: Image(
//                   image: AssetImage('assets/images/contact.png'),
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     'Contact Information',
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     UserData.contact,
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 16,
//                         fontWeight: FontWeight.normal),
//                   ),
//                   Text(
//                     UserData.email,
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                         fontWeight: FontWeight.normal),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Container buildLocationCont() {
//     return Container(
//       margin: EdgeInsets.only(
//         top: 10,
//       ),
//       // width: 350,
//       height: 70,
//       child: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               color: Color.fromRGBO(255, 255, 255, 1),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color.fromRGBO(5, 5, 5, 0.10000000149011612),
//                   offset: Offset(0, 4),
//                 ),
//               ],
//             ),
//           ),
//           Row(
//             children: <Widget>[
//               Container(
//                 width: 3,
//                 height: MediaQuery.of(context).size.height,
//                 color: Colors.deepOrange,
//               ),
//               Container(
//                 margin: EdgeInsets.all(10),
//                 width: 70,
//                 height: 70,
//                 child: Image(
//                   image: AssetImage('assets/images/location.png'),
//                 ),
//               ),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     'Address',
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   Text(
//                     UserData.address + ', ' + UserData.postal,
//                     textAlign: TextAlign.right,
//                     style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 16,
//                         fontWeight: FontWeight.normal),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Container buildIcon() {
//     return Container(
//       margin: EdgeInsets.only(top: 0),
//       width: 120,
//       height: 150,
//       child: Center(
//         child: Image(
//           image: AssetImage('assets/images/person.png'),
//         ),
//       ),
//     );
//   }

//   Container buildHeader() {
//     return Container(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         "Profile",
//         textAlign: TextAlign.right,
//         style: TextStyle(
//             color: Colors.deepOrange,
//             fontSize: 45,
//             fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }

// class InputPassDialog extends StatefulWidget {
//   @override
//   _InputPassDialogState createState() => _InputPassDialogState();
// }

// class _InputPassDialogState extends State<InputPassDialog> {
//   final _formKey = GlobalKey<FormState>();
//   final db = DatabaseHelper();
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: dialogContent(context),
//     );
//   }

//   final oldPassController = TextEditingController();

//   @override
//   void dispose() {
//     oldPassController.dispose();
//     super.dispose();
//   }

//   dialogContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         SingleChildScrollView(
//           child: Column(
//             children: [
//               Container(
//                 // color: Colors.grey,
//                 padding: EdgeInsets.only(top: 5, bottom: 10, right: 5, left: 5),
//                 // margin: EdgeInsets.only(top: 16),
//                 decoration: BoxDecoration(
//                     color: Colors.grey[50],
//                     shape: BoxShape.rectangle,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black26,
//                         blurRadius: 10.0,
//                         offset: Offset(0.0, 10.0),
//                       ),
//                     ]),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     Container(
//                       // height: 280,
//                       margin: EdgeInsets.only(bottom: 5),
//                       width: MediaQuery.of(context).size.width,
//                       color: Colors.white,
//                       // decoration: BoxDecoration(),
//                       child: Column(
//                         children: <Widget>[
//                           Padding(
//                             padding: const EdgeInsets.all(10.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Container(
//                                   // color: Colors.grey,
//                                   width: MediaQuery.of(context).size.width / 2,
//                                   margin: EdgeInsets.only(left: 10),
//                                   child: Text(
//                                     'Old Password',
//                                     style: TextStyle(
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500),
//                                     // overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 Form(
//                                   key: _formKey,
//                                   child: Container(
//                                     height: 40,
//                                     child: TextFormField(
//                                       obscureText: true,
//                                       controller: oldPassController,
//                                       decoration: InputDecoration(
//                                         contentPadding: EdgeInsets.only(
//                                             left: 20, top: 10, bottom: 10),
//                                         enabledBorder: OutlineInputBorder(
//                                           borderSide:
//                                               BorderSide(color: Colors.black),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(20)),
//                                         ),
//                                         focusedBorder: OutlineInputBorder(
//                                           borderSide:
//                                               BorderSide(color: Colors.black),
//                                           borderRadius: BorderRadius.all(
//                                               Radius.circular(20)),
//                                         ),
//                                         // hintText: 'Password',
//                                       ),
//                                       // maxLines: 5,
//                                       // minLines: 3,
//                                       validator: (value) {
//                                         if (value.isEmpty) {
//                                           return 'Password cannot be empty';
//                                         }
//                                         return null;
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Container(
//                       // color: Colors.grey,
//                       child: Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             RaisedButton(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20)),
//                               color: Colors.deepOrange,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 40, vertical: 12),
//                               onPressed: () async {
//                                 if (_formKey.currentState.validate()) {
//                                   var pass = oldPassController.text;
//                                   if (!NetworkData.connected) {
//                                     print('CLICKED!');
//                                     if (NetworkData.errorNo == '1') {
//                                       print('ERROR 1');
//                                       showDialog(
//                                           context: context,
//                                           builder: (context) => UnableDialog(
//                                                 title: 'Connection Problem!',
//                                                 description:
//                                                     'Please check the internet connection' +
//                                                         ' to continue.',
//                                                 buttonText: 'Okay',
//                                               ));
//                                     }
//                                     if (NetworkData.errorNo == '2') {
//                                       showDialog(
//                                           context: context,
//                                           builder: (context) => UnableDialog(
//                                                 title: 'API Problem!',
//                                                 description:
//                                                     'API Problem. Please contact admin.',
//                                                 buttonText: 'Okay',
//                                               ));
//                                     }
//                                     if (NetworkData.errorNo == '3') {
//                                       showDialog(
//                                           context: context,
//                                           builder: (context) => UnableDialog(
//                                                 title: 'Server Problem!',
//                                                 description:
//                                                     'Cannot connect to server. Try again later.',
//                                                 buttonText: 'Okay',
//                                               ));
//                                     }
//                                   } else {
//                                     showDialog(
//                                         context: context,
//                                         builder: (context) => LoadingSpinkit(
//                                               description:
//                                                   'Checking Password...',
//                                             ));
//                                     if (UserData.position == 'Salesman') {
//                                       var rsp = await db.loginUser(
//                                           UserData.username, pass);
//                                       if (rsp == 'failed password') {
//                                         Navigator.pop(context);
//                                         print("Wrong Password!");
//                                         showDialog(
//                                             context: context,
//                                             builder: (context) => UnableDialog(
//                                                   title: 'Wrong Password!',
//                                                   description:
//                                                       'Wrong Password' +
//                                                           ' Try Again.',
//                                                   buttonText: 'Okay',
//                                                 ));
//                                       } else {
//                                         print("Correct Password!");
//                                         UserData.newPassword = '';
//                                         Navigator.pop(context);
//                                         Navigator.pop(context);
//                                         // showDialog(
//                                         //     barrierDismissible: false,
//                                         //     context: context,
//                                         //     builder: (context) =>
//                                         //         ChangePassDialog());
//                                         Navigator.push(context,
//                                             MaterialPageRoute(
//                                                 builder: (context) {
//                                           return ChangePass();
//                                         }));
//                                       }
//                                     }
//                                     if (UserData.position == 'Jefe de Viaje') {
//                                       var rsp = await db.loginHepe(
//                                           UserData.username, pass);
//                                       if (rsp == 'failed password') {
//                                         Navigator.pop(context);
//                                         print("Wrong Password!");
//                                         showDialog(
//                                             context: context,
//                                             builder: (context) => UnableDialog(
//                                                   title: 'Wrong Password!',
//                                                   description:
//                                                       'Wrong Password' +
//                                                           ' Try Again.',
//                                                   buttonText: 'Okay',
//                                                 ));
//                                       } else {
//                                         print("Correct Password!");
//                                         UserData.newPassword = '';
//                                         Navigator.pop(context);
//                                         Navigator.pop(context);
//                                         // showDialog(
//                                         //     barrierDismissible: false,
//                                         //     context: context,
//                                         //     builder: (context) =>
//                                         //         ChangePassDialog());
//                                         Navigator.push(context,
//                                             MaterialPageRoute(
//                                                 builder: (context) {
//                                           return ChangePass();
//                                         }));
//                                       }
//                                     }
//                                   }
//                                 }
//                               },
//                               child: Text(
//                                 'Continue',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             RaisedButton(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                   side: BorderSide(color: Colors.deepOrange)),
//                               color: Colors.white,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 40, vertical: 12),
//                               onPressed: () {
//                                 OrderData.pmtype = "";
//                                 OrderData.setSign = false;
//                                 Navigator.pop(context);
//                               },
//                               child: Text(
//                                 'Cancel',
//                                 style: TextStyle(color: Colors.deepOrange),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Positioned(
//         //   top: 0,
//         //   right: 16,
//         //   left: 16,
//         //   child: CircleAvatar(
//         //     backgroundColor: Colors.transparent,
//         //     radius: 100,
//         //     backgroundImage: AssetImage('assets/images/check2.gif'),
//         //   ),
//         // ),
//         // Container(
//         //   padding: EdgeInsets.only(left: 10),
//         //   height: 60,
//         //   width: MediaQuery.of(context).size.width,
//         //   // color: Colors.deepOrange,
//         //   decoration: BoxDecoration(
//         //       color: Colors.deepOrange,
//         //       shape: BoxShape.rectangle,
//         //       borderRadius: BorderRadius.only(
//         //           topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//         //   child: Column(
//         //     mainAxisAlignment: MainAxisAlignment.center,
//         //     crossAxisAlignment: CrossAxisAlignment.start,
//         //     children: <Widget>[
//         //       Text(
//         //         'Confirm Password',
//         //         style: TextStyle(
//         //           color: Colors.white,
//         //           fontSize: 24,
//         //           fontWeight: FontWeight.w500,
//         //         ),
//         //       ),
//         //     ],
//         //   ),
//         // ),
//       ],
//     );
//   }
// }

// class ChangePassDialog extends StatefulWidget {
//   @override
//   _ChangePassDialogState createState() => _ChangePassDialogState();
// }

// class _ChangePassDialogState extends State<ChangePassDialog> {
//   int newPassLength = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: dialogContent(context),
//     );
//   }

//   final newPassController = TextEditingController();
//   final confirmPassController = TextEditingController();

//   @override
//   void dispose() {
//     newPassController.dispose();
//     confirmPassController.dispose();
//     super.dispose();
//   }

//   dialogContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           // color: Colors.grey,
//           padding: EdgeInsets.only(top: 70, bottom: 10, right: 5, left: 5),
//           // margin: EdgeInsets.only(top: 16),
//           decoration: BoxDecoration(
//               color: Colors.grey[50],
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: Offset(0.0, 10.0),
//                 ),
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Container(
//                 // height: 280,
//                 margin: EdgeInsets.only(bottom: 5),
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.white,
//                 // decoration: BoxDecoration(),
//                 child: Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             // color: Colors.grey,
//                             width: MediaQuery.of(context).size.width / 2,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Text(
//                               'New Password',
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.w500),
//                               // overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Container(
//                             height: 40,
//                             child: TextFormField(
//                               textInputAction: TextInputAction.next,
//                               onFieldSubmitted: (_) =>
//                                   FocusScope.of(context).nextFocus(),
//                               obscureText: true,
//                               controller: newPassController,
//                               decoration: InputDecoration(
//                                 contentPadding: EdgeInsets.only(
//                                     left: 20, top: 10, bottom: 10),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black),
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(20)),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black),
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(20)),
//                                 ),
//                                 // hintText: 'Password',
//                               ),
//                               // maxLines: 5,
//                               // minLines: 3,
//                               onChanged: (String value) {
//                                 newPassLength = value.length;
//                               },
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'New Password cannot be empty';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             // color: Colors.grey,
//                             width: MediaQuery.of(context).size.width / 2,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Text(
//                               'Confirm Password',
//                               style: TextStyle(
//                                   fontSize: 16, fontWeight: FontWeight.w500),
//                               // overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           Container(
//                             height: 40,
//                             child: TextFormField(
//                               textInputAction: TextInputAction.next,
//                               onFieldSubmitted: (_) =>
//                                   FocusScope.of(context).nextFocus(),
//                               obscureText: true,
//                               controller: confirmPassController,
//                               decoration: InputDecoration(
//                                 contentPadding: EdgeInsets.only(
//                                     left: 20, top: 10, bottom: 10),
//                                 enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black),
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(20)),
//                                 ),
//                                 focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.black),
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(20)),
//                                 ),
//                                 // hintText: 'Password',
//                               ),
//                               // maxLines: 5,
//                               // minLines: 3,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Confirm Password cannot be empty';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 // color: Colors.grey,
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       RaisedButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         color: Colors.deepOrange,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                         onPressed: () {
//                           if (newPassLength < 8) {
//                             print('Below 8');
//                             showDialog(
//                                 barrierDismissible: false,
//                                 context: context,
//                                 builder: (context) => PassRestrictionDialog());
//                           } else {
//                             if ((newPassController.text).isNotEmpty &&
//                                 (confirmPassController.text).isNotEmpty) {
//                               if (newPassController.text ==
//                                   confirmPassController.text) {
//                                 print('Password Match');
//                                 UserData.newPassword = newPassController.text;
//                                 showDialog(
//                                     barrierDismissible: false,
//                                     context: context,
//                                     builder: (context) => ConfirmDialog());
//                               } else {
//                                 showDialog(
//                                     barrierDismissible: false,
//                                     context: context,
//                                     builder: (context) => PassnotMatchDialog());
//                               }
//                             }
//                           }
//                         },
//                         child: Text(
//                           'Continue',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       RaisedButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                             side: BorderSide(color: Colors.deepOrange)),
//                         color: Colors.white,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                         onPressed: () {
//                           OrderData.pmtype = "";
//                           OrderData.setSign = false;
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           'Cancel',
//                           style: TextStyle(color: Colors.deepOrange),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Positioned(
//         //   top: 0,
//         //   right: 16,
//         //   left: 16,
//         //   child: CircleAvatar(
//         //     backgroundColor: Colors.transparent,
//         //     radius: 100,
//         //     backgroundImage: AssetImage('assets/images/check2.gif'),
//         //   ),
//         // ),
//         Container(
//           padding: EdgeInsets.only(left: 10),
//           height: 60,
//           width: MediaQuery.of(context).size.width,
//           // color: Colors.deepOrange,
//           decoration: BoxDecoration(
//               color: Colors.deepOrange,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 'Change Password',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class PassnotMatchDialog extends StatefulWidget {
//   @override
//   _PassnotMatchDialogState createState() => _PassnotMatchDialogState();
// }

// class _PassnotMatchDialogState extends State<PassnotMatchDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: dialogContent(context),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   dialogContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           // color: Colors.grey,
//           padding: EdgeInsets.only(top: 70, bottom: 10, right: 5, left: 5),
//           // margin: EdgeInsets.only(top: 16),
//           decoration: BoxDecoration(
//               color: Colors.grey[50],
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: Offset(0.0, 10.0),
//                 ),
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Container(
//                 // height: 280,
//                 margin: EdgeInsets.only(bottom: 5),
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.white,
//                 // decoration: BoxDecoration(),
//                 child: Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             // color: Colors.grey,
//                             width: MediaQuery.of(context).size.width / 2,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Center(
//                               child: Text(
//                                 "Password doesn't match.",
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w500),
//                                 // overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 // color: Colors.grey,
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       RaisedButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         color: Colors.deepOrange,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                         onPressed: () => {
//                           Navigator.pop(context),
//                         },
//                         child: Text(
//                           'Okay',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Positioned(
//         //   top: 0,
//         //   right: 16,
//         //   left: 16,
//         //   child: CircleAvatar(
//         //     backgroundColor: Colors.transparent,
//         //     radius: 100,
//         //     backgroundImage: AssetImage('assets/images/check2.gif'),
//         //   ),
//         // ),
//         Container(
//           padding: EdgeInsets.only(left: 10),
//           height: 60,
//           width: MediaQuery.of(context).size.width,
//           // color: Colors.deepOrange,
//           decoration: BoxDecoration(
//               color: Colors.deepOrange,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 'Stop',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ConfirmDialog extends StatefulWidget {
//   @override
//   _ConfirmDialogState createState() => _ConfirmDialogState();
// }

// class _ConfirmDialogState extends State<ConfirmDialog> {
//   final db = DatabaseHelper();

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: dialogContent(context),
//     );
//   }

//   changePassword() async {
//     if (UserData.position == 'Salesman') {
//       var cPass =
//           await db.changeSalesmanPassword(UserData.id, UserData.newPassword);
//       if (cPass != 'failed') {
//         await db.updateSalesmanPassword(UserData.id, cPass);
//       }
//     }
//     if (UserData.position == 'Jefe de Viaje') {
//       var cPass =
//           await db.changeHepePassword(UserData.id, UserData.newPassword);
//       if (cPass != 'failed') {
//         await db.updateHepePassword(UserData.id, cPass);
//       }
//     }
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   dialogContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           // color: Colors.grey,
//           padding: EdgeInsets.only(top: 70, bottom: 10, right: 5, left: 5),
//           // margin: EdgeInsets.only(top: 16),
//           decoration: BoxDecoration(
//               color: Colors.grey[50],
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: Offset(0.0, 10.0),
//                 ),
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Container(
//                 // height: 280,
//                 margin: EdgeInsets.only(bottom: 5),
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.white,
//                 // decoration: BoxDecoration(),
//                 child: Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             // color: Colors.grey,
//                             width: MediaQuery.of(context).size.width / 2,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Center(
//                               child: Text(
//                                 "Are you sure you want to change password?",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                                 textAlign: TextAlign.center,
//                                 // overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 // color: Colors.grey,
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       RaisedButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         color: Colors.deepOrange,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                         onPressed: () {
//                           print('CHANGING PASSWORD');
//                           changePassword();
//                           Navigator.pop(context);
//                           showDialog(
//                               barrierDismissible: false,
//                               context: context,
//                               builder: (context) => SuccessDialog());
//                         },
//                         child: Text(
//                           'Change',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       RaisedButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         color: Colors.deepOrange,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                         onPressed: () => {
//                           Navigator.pop(context),
//                           Navigator.pop(context),
//                         },
//                         child: Text(
//                           'Cancel',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Positioned(
//         //   top: 0,
//         //   right: 16,
//         //   left: 16,
//         //   child: CircleAvatar(
//         //     backgroundColor: Colors.transparent,
//         //     radius: 100,
//         //     backgroundImage: AssetImage('assets/images/check2.gif'),
//         //   ),
//         // ),
//         Container(
//           padding: EdgeInsets.only(left: 10),
//           height: 60,
//           width: MediaQuery.of(context).size.width,
//           // color: Colors.deepOrange,
//           decoration: BoxDecoration(
//               color: Colors.deepOrange,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 'Stop',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class SuccessDialog extends StatefulWidget {
//   @override
//   _SuccessDialogState createState() => _SuccessDialogState();
// }

// class _SuccessDialogState extends State<SuccessDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: dialogContent(context),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   dialogContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           // color: Colors.grey,
//           padding: EdgeInsets.only(top: 70, bottom: 10, right: 5, left: 5),
//           // margin: EdgeInsets.only(top: 16),
//           decoration: BoxDecoration(
//               color: Colors.grey[50],
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: Offset(0.0, 10.0),
//                 ),
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Container(
//                 // height: 280,
//                 margin: EdgeInsets.only(bottom: 5),
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.white,
//                 // decoration: BoxDecoration(),
//                 child: Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             // color: Colors.grey,
//                             width: MediaQuery.of(context).size.width / 2,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Center(
//                               child: Text(
//                                 'Password changed successfully! You will be logged out to apply changes.',
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w500),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 // color: Colors.grey,
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       RaisedButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         color: Colors.deepOrange,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                         onPressed: () {
//                           GlobalVariables.menuKey = 0;
//                           GlobalVariables.viewPolicy = true;
//                           // Navigator.pushAndRemoveUntil(
//                           //     context,
//                           //     MaterialPageRoute(
//                           //         builder: (BuildContext context) =>
//                           //             MyOptionPage()),
//                           //     ModalRoute.withName('/option'));
//                           Navigator.of(context).pushNamedAndRemoveUntil(
//                               '/option', (route) => false);
//                         },
//                         child: Text(
//                           'Okay',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.only(left: 10),
//           height: 60,
//           width: MediaQuery.of(context).size.width,
//           // color: Colors.deepOrange,
//           decoration: BoxDecoration(
//               color: Colors.deepOrange,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 'Success',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class PassRestrictionDialog extends StatefulWidget {
//   @override
//   _PassRestrictionDialogState createState() => _PassRestrictionDialogState();
// }

// class _PassRestrictionDialogState extends State<PassRestrictionDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: dialogContent(context),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   dialogContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           // color: Colors.grey,
//           padding: EdgeInsets.only(top: 70, bottom: 10, right: 5, left: 5),
//           // margin: EdgeInsets.only(top: 16),
//           decoration: BoxDecoration(
//               color: Colors.grey[50],
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: Offset(0.0, 10.0),
//                 ),
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Container(
//                 // height: 280,
//                 margin: EdgeInsets.only(bottom: 5),
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.white,
//                 // decoration: BoxDecoration(),
//                 child: Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             // color: Colors.grey,
//                             width: MediaQuery.of(context).size.width / 2,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Center(
//                               child: Text(
//                                 "Passwords must be at least 8 characters in length.",
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w500),
//                                 textAlign: TextAlign.center,
//                                 // overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 // color: Colors.grey,
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       RaisedButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         color: Colors.deepOrange,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                         onPressed: () => {
//                           Navigator.pop(context),
//                         },
//                         child: Text(
//                           'Okay',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Positioned(
//         //   top: 0,
//         //   right: 16,
//         //   left: 16,
//         //   child: CircleAvatar(
//         //     backgroundColor: Colors.transparent,
//         //     radius: 100,
//         //     backgroundImage: AssetImage('assets/images/check2.gif'),
//         //   ),
//         // ),
//         Container(
//           padding: EdgeInsets.only(left: 10),
//           height: 60,
//           width: MediaQuery.of(context).size.width,
//           // color: Colors.deepOrange,
//           decoration: BoxDecoration(
//               color: Colors.deepOrange,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 'Stop',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class UnableDialog extends StatefulWidget {
//   final String title, description, buttonText;

//   UnableDialog({this.title, this.description, this.buttonText});

//   @override
//   _UnableDialogState createState() => _UnableDialogState();
// }

// class _UnableDialogState extends State<UnableDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: unableContent(context),
//     );
//   }

//   unableContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.only(top: 5, bottom: 16, right: 5, left: 5),
//           margin: EdgeInsets.only(top: 16),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: Offset(0.0, 10.0),
//                 ),
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Icon(
//                 Icons.error_outline,
//                 color: Colors.red,
//                 size: 72,
//               ),
//               Container(
//                 margin: EdgeInsets.only(bottom: 5),
//                 height: 70,
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.white,
//                 // decoration: BoxDecoration(),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Container(
//                       child: Text(
//                         widget.title,
//                         style: TextStyle(
//                             fontSize: 16, fontWeight: FontWeight.w500),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Container(
//                       child: Text(
//                         widget.description,
//                         style: TextStyle(fontSize: 12),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     RaisedButton(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20),
//                         // side: BorderSide(color: Colors.deepOrange)
//                       ),
//                       color: Colors.white,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         'Okay',
//                         style: TextStyle(color: Colors.deepOrange),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class LoadingSpinkit extends StatefulWidget {
//   final String description;

//   LoadingSpinkit({this.description});
//   @override
//   _LoadingSpinkitState createState() => _LoadingSpinkitState();
// }

// class _LoadingSpinkitState extends State<LoadingSpinkit> {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       // child: confirmContent(context),
//       child: loadingContent(context),
//     );
//   }

//   loadingContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//             // width: MediaQuery.of(context).size.width,
//             padding: EdgeInsets.only(top: 50, bottom: 16, right: 5, left: 5),
//             margin: EdgeInsets.only(top: 16),
//             decoration: BoxDecoration(
//                 color: Colors.transparent,
//                 shape: BoxShape.rectangle,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.transparent,
//                     // blurRadius: 10.0,
//                     // offset: Offset(0.0, 10.0),
//                   ),
//                 ]),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 Text(
//                   // 'Checking username...',
//                   widget.description,
//                   style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w300,
//                       color: Colors.white),
//                 ),
//                 SpinKitCircle(
//                   color: Colors.deepOrange,
//                 ),
//               ],
//             )),
//       ],
//     );
//   }
// }
