// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:salesman/url/url.dart';
import 'package:salesman/userdata.dart';

class ChequePage extends StatefulWidget {
  @override
  _ChequePageState createState() => _ChequePageState();
}

class _ChequePageState extends State<ChequePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Cheque Information')),
      ),
      body: Center(
          child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[100],
            child: Image.network(UrlAddress.chequeImg + ChequeData.imgName!),
            // child: Container(
            //   margin: EdgeInsets.all(10),
            //   height: MediaQuery.of(context).size.height / 2 - 20,
            //   width: MediaQuery.of(context).size.width - 20,
            //   // color: Colors.grey[100],
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.deepOrange[100], width: 5),
            //     color: Colors.grey[100],
            //   ),
            //   child: SingleChildScrollView(
            //     child: Column(
            //       children: <Widget>[
            //         Container(
            //           margin: EdgeInsets.only(left: 10),
            //           height: 60,
            //           width: MediaQuery.of(context).size.width - 20,
            //           color: Colors.grey[100],
            //           child: Stack(
            //             children: <Widget>[
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 children: <Widget>[
            //                   Container(
            //                     child: Center(
            //                       child: Icon(
            //                         Icons.account_box,
            //                         size: 36,
            //                         color: Colors.grey,
            //                       ),
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     width: 10,
            //                   ),
            //                   Container(
            //                     height: 60,
            //                     width: MediaQuery.of(context).size.width / 2,
            //                     // color: Colors.white,
            //                     child: Column(
            //                       crossAxisAlignment: CrossAxisAlignment.start,
            //                       mainAxisAlignment: MainAxisAlignment.center,
            //                       children: <Widget>[
            //                         Text(
            //                           ChequeData.payeeName,
            //                           textAlign: TextAlign.left,
            //                           style: TextStyle(
            //                             fontSize: 12,
            //                             fontWeight: FontWeight.w500,
            //                             color: Colors.grey[500],
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.end,
            //                 children: <Widget>[
            //                   Container(
            //                     child: Text(
            //                       ChequeData.chequeNum,
            //                       style: TextStyle(
            //                         fontSize: 12,
            //                         fontWeight: FontWeight.w500,
            //                         color: Colors.grey[500],
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //         Container(
            //           height: 60,
            //           width: MediaQuery.of(context).size.width - 20,
            //           color: Colors.grey[100],
            //           child: Stack(
            //             children: <Widget>[
            //               Row(
            //                 children: <Widget>[
            //                   Container(
            //                     height: 50,
            //                     width: 60,
            //                     child: Align(
            //                       alignment: Alignment.bottomLeft,
            //                       child: Text(
            //                         'PAY TO THE ORDER OF',
            //                         style: TextStyle(
            //                           fontSize: 10,
            //                           color: Colors.grey[500],
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                   Container(
            //                     height: 50,
            //                     width:
            //                         MediaQuery.of(context).size.width / 2 + 40,
            //                     decoration: BoxDecoration(
            //                         border: Border(
            //                             bottom: BorderSide(
            //                                 color: Colors.deepOrange[100]))),
            //                     child: Align(
            //                       alignment: Alignment.bottomCenter,
            //                       child: Text(
            //                         ChequeData.payorName,
            //                         textAlign: TextAlign.start,
            //                         style: TextStyle(
            //                           fontSize: 12,
            //                           fontWeight: FontWeight.w500,
            //                           color: Colors.grey[500],
            //                           fontStyle: FontStyle.italic,
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                   Container(
            //                     height: 50,
            //                     width: 20,
            //                     child: Align(
            //                       alignment: Alignment.bottomCenter,
            //                       child: Image(
            //                         image: AssetImage(
            //                             'assets/images/pesologo.png'),
            //                       ),
            //                     ),
            //                   ),
            //                   Container(
            //                     height: 50,
            //                     child: Column(
            //                       mainAxisAlignment: MainAxisAlignment.end,
            //                       children: <Widget>[
            //                         Container(
            //                           color: Colors.white,
            //                           height: 25,
            //                           child: Align(
            //                               alignment: Alignment.bottomCenter,
            //                               child: Text(
            //                                 ChequeData.chequeAmt,
            //                                 style: TextStyle(
            //                                   fontSize: 10,
            //                                 ),
            //                               )),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //         Container(
            //           height: 60,
            //           width: MediaQuery.of(context).size.width - 20,
            //           color: Colors.grey[100],
            //           child: Stack(
            //             children: <Widget>[
            //               Row(
            //                 children: <Widget>[
            //                   Container(
            //                     height: 30,
            //                     width:
            //                         MediaQuery.of(context).size.width / 2 + 120,
            //                     decoration: BoxDecoration(
            //                         border: Border(
            //                             bottom: BorderSide(
            //                                 color: Colors.deepOrange[100]))),
            //                     child: Align(
            //                       alignment: Alignment.bottomCenter,
            //                       child: Text(
            //                         ChequeData.numToWords,
            //                         style: TextStyle(
            //                           fontSize: 12,
            //                           fontWeight: FontWeight.w500,
            //                           color: Colors.grey[500],
            //                           fontStyle: FontStyle.italic,
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                   Container(
            //                     height: 30,
            //                     width: 50,
            //                     child: Align(
            //                       alignment: Alignment.bottomCenter,
            //                       child: Text(
            //                         'PESOS',
            //                         style: TextStyle(
            //                           fontSize: 12,
            //                           fontWeight: FontWeight.w500,
            //                           color: Colors.grey[500],
            //                           fontStyle: FontStyle.italic,
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //         Container(
            //           margin: EdgeInsets.only(left: 10),
            //           height: 60,
            //           width: MediaQuery.of(context).size.width - 20,
            //           color: Colors.grey[100],
            //           child: Row(
            //             children: <Widget>[
            //               Icon(
            //                 Icons.account_balance,
            //                 size: 36,
            //                 color: Colors.grey,
            //               ),
            //               SizedBox(
            //                 width: 10,
            //               ),
            //               Text(
            //                 ChequeData.bankName,
            //                 style: TextStyle(
            //                   fontSize: 14,
            //                   fontWeight: FontWeight.w500,
            //                   color: Colors.grey[500],
            //                 ),
            //               )
            //             ],
            //           ),
            //         ),
            //         Container(
            //           margin: EdgeInsets.only(left: 10),
            //           height: 80,
            //           width: MediaQuery.of(context).size.width - 20,
            //           color: Colors.grey[100],
            //           child: Stack(
            //             children: <Widget>[
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 children: <Widget>[
            //                   Container(
            //                     width: 100,
            //                     height: 100,
            //                     // color: Colors.white,
            //                     child: Image.memory(
            //                       base64Decode(OrderData.signature),
            //                       // color: Colors.transparent,
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //         Container(
            //           margin: EdgeInsets.only(left: 10),
            //           height: 20,
            //           width: MediaQuery.of(context).size.width - 20,
            //           // color: Colors.grey[100],
            //           // color: Colors.white,
            //           child: Stack(
            //             children: <Widget>[
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.start,
            //                 children: <Widget>[
            //                   Text(
            //                     'Authorized Signature',
            //                     style: TextStyle(
            //                       fontSize: 12,
            //                       color: Colors.grey[500],
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.end,
            //                 children: <Widget>[
            //                   Container(
            //                     child: Text(
            //                       'DATE: ',
            //                       style: TextStyle(
            //                         fontSize: 12,
            //                         color: Colors.grey[500],
            //                       ),
            //                     ),
            //                   ),
            //                   Container(
            //                     child: Text(
            //                       ChequeData.chequeDate,
            //                       style: TextStyle(
            //                         fontSize: 12,
            //                         color: Colors.grey[500],
            //                         fontWeight: FontWeight.w500,
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ],
            //           ),
            //         ),
            //         SizedBox(
            //           height: 10,
            //         ),
            //         Container(
            //           margin: EdgeInsets.only(left: 10),
            //           height: 20,
            //           width: MediaQuery.of(context).size.width - 20,
            //           // color: Colors.white,
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.start,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: <Widget>[
            //               Container(
            //                 width: 80,
            //                 child: Center(
            //                   child: Text(
            //                     ChequeData.chequeNum,
            //                     style: TextStyle(
            //                       color: Colors.black54,
            //                       fontSize: 12,
            //                       fontWeight: FontWeight.bold,
            //                       fontFeatures: [FontFeature.oldstyleFigures()],
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               Container(
            //                 child: Text(
            //                   '-',
            //                   style: TextStyle(
            //                     fontSize: 12,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //               ),
            //               Container(
            //                 width: 80,
            //                 child: Center(
            //                   child: Text(
            //                     ChequeData.branchCode,
            //                     style: TextStyle(
            //                       color: Colors.black54,
            //                       fontSize: 12,
            //                       fontWeight: FontWeight.bold,
            //                       fontFeatures: [FontFeature.oldstyleFigures()],
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //               Container(
            //                 child: Text(
            //                   '-',
            //                   style: TextStyle(
            //                     fontSize: 12,
            //                     fontWeight: FontWeight.bold,
            //                   ),
            //                 ),
            //               ),
            //               Container(
            //                 width: 100,
            //                 child: Center(
            //                   child: Text(
            //                     ChequeData.bankAccNo,
            //                     style: TextStyle(
            //                       color: Colors.black54,
            //                       fontSize: 12,
            //                       fontWeight: FontWeight.bold,
            //                       fontFeatures: [FontFeature.oldstyleFigures()],
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ),
        ],
      )),
    );
  }
}
