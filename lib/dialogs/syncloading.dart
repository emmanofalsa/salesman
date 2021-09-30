import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salesman/userdata.dart';

class LoadingSpinkit extends StatefulWidget {
  @override
  _LoadingSpinkitState createState() => _LoadingSpinkitState();
}

class _LoadingSpinkitState extends State<LoadingSpinkit>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    // onWillPop: () => Future.value(false),
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      // child: confirmContent(context),
      child: loadingContent(context),
    );
  }

  loadingContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            // width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 50, bottom: 16, right: 5, left: 5),
            margin: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                    // blurRadius: 10.0,
                    // offset: Offset(0.0, 10.0),
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Updating ' + GlobalVariables.updateType + ' . . .',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                // SpinKitCircle(
                //   color: Colors.yellowAccent,
                //   // size: 100.0,
                //   controller: AnimationController(
                //       vsync: this, duration: const Duration(seconds: 1)),
                // ),
                SpinKitCircle(
                  controller: animationController,
                  color: Colors.yellowAccent,
                ),
              ],
            )),
      ],
    );
  }
}
