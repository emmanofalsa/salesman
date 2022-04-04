import 'package:flutter/material.dart';
import 'package:salesman/userdata.dart';
import 'dart:convert';

class Signature extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Container(
              color: Colors.grey[300],
              child: Image.memory(base64Decode(OrderData.signature!)))),
    );
  }
}
