import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salesman/userdata.dart';

class Option extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: Colors.grey[100],
        child: dialogContent(context),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Choose image from',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                UserData.getImgfrom = 'Camera';
                Navigator.pop(context);
              },
              child: Column(
                children: [
                  Icon(
                    CupertinoIcons.camera_circle,
                    size: 45,
                  ),
                  Text('Camera'),
                ],
              ),
            ),
            SizedBox(
              width: 50,
            ),
            InkWell(
              onTap: () {
                UserData.getImgfrom = 'Gallery';
                Navigator.pop(context);
              },
              child: Column(
                children: [
                  Icon(
                    CupertinoIcons.photo,
                    size: 45,
                  ),
                  Text('Gallery'),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
