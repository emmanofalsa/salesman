// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:intl/intl.dart';
// // import 'package:salesman/db/db_helper.dart';
// import 'userdata.dart';
// import './api.dart';
// import 'package:salesman/home/processed_listview.dart';

// class HepeHome extends StatefulWidget {
//   @override
//   _HepeHomeState createState() => _HepeHomeState();
// }

// class _HepeHomeState extends State<HepeHome> {
//   bool viewSpinkit = true;
//   bool processedPressed = true;
//   bool emptyApprovedTran = true;
//   bool emptyPendingTran = true;

//   final orangeColor = Colors.deepOrange;
//   final yellowColor = Colors.amber;
//   final blueColor = Colors.blue;

//   final formatCurrency =
//       new NumberFormat.currency(locale: "en_US", symbol: "P");

//   List _toList = [];
//   List _smList = [];
//   List _sList = [];

//   void initState() {
//     super.initState();
//     // loadSalesmanList();
//     loadProcessed();

//     CustomerData.discounted = false;
//   }

//   loadSalesmanList() async {
//     var getSM = await getSalesmanList(UserData.id);
//     _smList = getSM;
//     loadProcessed();
//   }

//   loadProcessed() async {
//     OrderData.visible = true;
//     _toList.clear();
//     _smList.forEach((element) async {
//       _sList.clear();
//       var getP = await getProcessed(element['salesman_code']);
//       _sList = getP;
//       // print(element['salesman_code']);
//       setState(() {
//         if (_sList.isNotEmpty) {
//           _sList.forEach((element) {
//             _toList.add((element));
//             viewSpinkit = false;
//           });
//         }

//         if (_toList.isNotEmpty) {
//           emptyApprovedTran = false;
//           viewSpinkit = false;
//         } else {
//           viewSpinkit = false;
//         }
//       });
//       GlobalVariables.processedPressed = true;
//     });

//     GlobalVariables.processedPressed = true;
//   }

//   checkifDiscounted() async {
//     var rsp = await checkDiscounted(CustomerData.accountCode);
//     if (rsp == "TRUE") {
//       // print(rsp);
//       CustomerData.discounted = true;
//     } else {
//       CustomerData.discounted = false;
//     }
//   }

//   loadPending() async {
//     OrderData.visible = false;
//     _toList.clear();
//     _smList.forEach((element) async {
//       _sList.clear();
//       var getPend = await getPending(element['salesman_code']);
//       _sList = getPend;
//       setState(() {
//         if (_sList.isNotEmpty) {
//           _sList.forEach((element) {
//             _toList.add((element));
//             viewSpinkit = false;
//           });
//         }

//         if (_toList.isNotEmpty) {
//           emptyPendingTran = false;
//           viewSpinkit = false;
//         } else {
//           viewSpinkit = false;
//         }
//         GlobalVariables.processedPressed = false;
//       });
//     });
//   }

//   Future<void> _getData() async {
//     setState(() {
//       if (processedPressed = true) {
//         OrderData.visible = true;
//         loadProcessed();
//       } else {
//         loadPending();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: SingleChildScrollView(
//               padding:
//                   EdgeInsets.only(left: 16, right: 16, top: 180, bottom: 5),
//               child: Column(
//                 children: [
//                   buildtranCont(),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: 178,
//             color: Colors.white,
//             child: SingleChildScrollView(
//               // physics: NeverScrollableScrollPhysics(),
//               padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(
//                     height: 15,
//                   ),
//                   buildHeader(),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   buildOrderOption(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Container buildtranCont() {
//     if (viewSpinkit == true) {
//       return Container(
//         height: 620,
//         width: MediaQuery.of(context).size.width,
//         child: Center(
//           child: SpinKitFadingCircle(
//             color: Colors.deepOrange,
//             size: 50,
//           ),
//         ),
//       );
//     }
//     if (emptyApprovedTran == true && processedPressed == true) {
//       return Container(
//         padding: EdgeInsets.all(50),
//         margin: EdgeInsets.only(top: 50),
//         height: MediaQuery.of(context).size.width,
//         width: MediaQuery.of(context).size.width,
//         // color: Colors.deepOrange,
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           // crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Icon(
//               Icons.not_interested,
//               size: 100,
//               color: Colors.grey[500],
//             ),
//             Text(
//               'No approved requests.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[500],
//               ),
//             )
//           ],
//         ),
//       );
//     }
//     if (emptyPendingTran == true && processedPressed == false) {
//       return Container(
//         padding: EdgeInsets.all(50),
//         margin: EdgeInsets.only(top: 50),
//         height: MediaQuery.of(context).size.width,
//         width: MediaQuery.of(context).size.width,
//         // color: Colors.deepOrange,
//         child: Column(
//           // mainAxisAlignment: MainAxisAlignment.center,
//           // crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Icon(
//               Icons.not_interested,
//               size: 100,
//               color: Colors.grey[500],
//             ),
//             Text(
//               'No pending requests.',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey[500],
//               ),
//             )
//           ],
//         ),
//       );
//     }
//     return Container(
//       height: 620,
//       width: MediaQuery.of(context).size.width,
//       // color: Colors.white,
//       child: RefreshIndicator(
//         child: ListView.builder(
//           padding: const EdgeInsets.all(0),
//           itemCount: _toList.length,
//           // scrollDirection: Axis.vertical,
//           itemBuilder: (context, index) {
//             return SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   GestureDetector(
//                     onTap: () async {
//                       // print(_toList);
//                       UserData.trans = _toList[index]['tran_no'];
//                       UserData.sname = _toList[index]['store_name'];
//                       OrderData.trans = _toList[index]['tran_no'];
//                       OrderData.name = _toList[index]['store_name'];
//                       OrderData.signature = '';
//                       CustomerData.accountCode = _toList[index]['account_code'];
//                       // OrderData.address = _toList[index]['address2'] +
//                       //     ', ' +
//                       //     _toList[index]['address3'] +
//                       //     ', ' +
//                       //     _toList[index]['address1'];
//                       // OrderData.contact = _toList[index]['cus_mobile_number'];
//                       OrderData.pmeth = _toList[index]['p_meth'];
//                       OrderData.itmno = _toList[index]['itm_count'];
//                       OrderData.grandTotal = _toList[index]['tot_amt'];
//                       OrderData.status = _toList[index]['tran_stat'];

//                       var getCi = await getCustInfo(CustomerData.accountCode);
//                       CustomerData.city = getCi[0]['address3'];
//                       CustomerData.district = getCi[0]['address2'];
//                       CustomerData.province = getCi[0]['address1'];
//                       CustomerData.contactNo = getCi[0]['cus_mobile_num'];

//                       checkifDiscounted();
//                       // print(getCi);
//                       Navigator.push(context,
//                           MaterialPageRoute(builder: (context) {
//                         return ProcessedListView();
//                       }));
//                     },
//                     child: Container(
//                       margin: EdgeInsets.only(bottom: 8),
//                       height: 80,
//                       width: MediaQuery.of(context).size.width,
//                       color: Colors.white,
//                       child: Stack(children: <Widget>[
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Container(
//                               // margin: EdgeInsets.all(0),
//                               width: 5,
//                               height: 80,
//                               color: Colors.deepOrange,
//                               // child: Image(
//                               //   image: AssetImage('assets/images/art.png'),
//                               // ),
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Container(
//                               width: MediaQuery.of(context).size.width / 2 + 60,
//                               // color: Colors.grey,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Text(
//                                     _toList[index]['store_name'],
//                                     // 'Store Name',
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         fontWeight: FontWeight.bold),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   Text(
//                                     _toList[index]['date_req'],
//                                     // 'Date',
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.normal),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: <Widget>[
//                             Container(
//                               // width: 138,
//                               // color: Colors.blueGrey,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: <Widget>[
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   Text(
//                                     'Total Amount',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.normal),
//                                   ),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   Text(
//                                     formatCurrency.format(double.parse(
//                                         _toList[index]['tot_amt'])),
//                                     // 'Tot amt',
//                                     textAlign: TextAlign.right,
//                                     style: TextStyle(
//                                         color: Colors.deepOrange,
//                                         fontSize: 16,
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   Text(
//                                     _toList[index]['tran_stat'],
//                                     // '',
//                                     textAlign: TextAlign.left,
//                                     style: TextStyle(
//                                         color: processedPressed
//                                             ? Colors.greenAccent
//                                             : Colors.redAccent,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.normal,
//                                         fontStyle: FontStyle.italic),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ]),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//         onRefresh: _getData,
//       ),
//     );
//   }

//   Container buildOrderOption() {
//     return Container(
//       height: 50,
//       width: 400,
//       margin: EdgeInsets.only(top: 0, bottom: 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           new SizedBox(
//             width: 170,
//             height: 35,
//             child: new RaisedButton(
//               color: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               elevation: 10,
//               onPressed: () {
//                 setState(() {
//                   viewSpinkit = true;
//                   loadProcessed();
//                   OrderData.visible = true;
//                   processedPressed = true;
//                 });
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   RichText(
//                     text: TextSpan(
//                       text: "Approved Orders",
//                       // recognizer: _tapGestureRecognizer,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: processedPressed
//                             ? FontWeight.bold
//                             : FontWeight.normal,
//                         decoration: TextDecoration.underline,
//                         color: processedPressed ? orangeColor : Colors.grey,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(
//             width: 2,
//           ),
//           new SizedBox(
//             width: 170,
//             height: 35,
//             child: new RaisedButton(
//               color: Colors.white,
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               elevation: 10,
//               onPressed: () {
//                 setState(() {
//                   viewSpinkit = true;
//                   loadPending();
//                   OrderData.visible = false;
//                   processedPressed = false;
//                 });
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   RichText(
//                       text: TextSpan(
//                     text: "Pending Orders",
//                     // recognizer: _tapGestureRecognizer,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: processedPressed
//                           ? FontWeight.normal
//                           : FontWeight.bold,
//                       decoration: TextDecoration.underline,
//                       color: processedPressed ? Colors.grey : orangeColor,
//                     ),
//                   ))
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Container buildHeader() {
//     return Container(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         "Home",
//         textAlign: TextAlign.right,
//         style: TextStyle(
//             color: Colors.deepOrange,
//             fontSize: 45,
//             fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
