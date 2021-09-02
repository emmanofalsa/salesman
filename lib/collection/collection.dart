import 'package:flutter/material.dart';
import 'package:salesman/variables/colors.dart';

class Collection extends StatefulWidget {
  @override
  _CollectionState createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Collections",
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: ColorsTheme.mainColor,
                  fontSize: 45,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              // color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  buildtranCont(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildtranCont() {
    return Container(
      padding: EdgeInsets.all(50),
      margin: EdgeInsets.only(top: 0),
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // color: Colors.transparent,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/wip.png',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 2,
          ),

          // Text(
          //   'You have no transaction history.',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.w500,
          //     color: Colors.grey[500],
          //   ),
          // )
        ],
      ),
    );
  }

  // Container buildHeader() {
  //   return Container(
  //     alignment: Alignment.centerLeft,
  //     child: Text(
  //       "Collections",
  //       textAlign: TextAlign.right,
  //       style: TextStyle(
  //           color: Colors.deepOrange,
  //           fontSize: 45,
  //           fontWeight: FontWeight.bold),
  //     ),
  //   );
  // }
}
