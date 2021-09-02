// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:salesman/home/capture_cheque.dart';
import 'package:salesman/url/url.dart';
import 'package:salesman/userdata.dart';

class ViewChequeImg extends StatefulWidget {
  @override
  _ViewChequeImgState createState() => _ViewChequeImgState();
}

class _ViewChequeImgState extends State<ViewChequeImg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Cheque Image Captured')),
      ),
      body: Center(
          child: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[100],
            child: Image.network(UrlAddress.chequeImg + ChequeData.imgName),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 250),
              width: MediaQuery.of(context).size.width / 2,
              height: 40,
              // color: Colors.grey,
              child: OutlinedButton(
                onPressed: () {
                  ChequeData.changeImg = true;
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CaptureImage();
                  }));
                },
                child: Text('Change Image'),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
