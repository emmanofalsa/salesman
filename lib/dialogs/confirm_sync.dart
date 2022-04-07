import 'package:flutter/material.dart';
import 'package:salesman/dialogs/syncloading.dart';
// import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/elevated_button.dart';

class ConfirmDialog extends StatefulWidget {
  final String? title, description, buttonText;

  ConfirmDialog({this.title, this.description, this.buttonText});

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  // String updateType = 'Salesman';

  // final date = DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
  // final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: confirmContent(context),
    );
  }

  confirmContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 5, bottom: 16, right: 5, left: 5),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0),
                ),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.help_outline,
                color: ColorsTheme.mainColor,
                size: 72,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                height: 70,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                // decoration: BoxDecoration(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Text(
                        widget.title.toString(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      child: Text(
                        widget.description.toString(),
                        style: TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: raisedButtonDialogStyle,
                      onPressed: () {
                        // loadSpinkit = true;
                        Navigator.pop(context);
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => SyncLoadingSpinkit());
                      },
                      child: Text(
                        widget.buttonText.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      style: raisedButtonStyleWhite,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: ColorsTheme.mainColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
