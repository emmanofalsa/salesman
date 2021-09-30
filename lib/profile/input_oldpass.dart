import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/forget_pass/change_password.dart';
// import 'package:salesman/profile/profile.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/dialogs.dart';
import 'package:salesman/widgets/elevated_button.dart';

class InputPassDialog extends StatefulWidget {
  @override
  _InputPassDialogState createState() => _InputPassDialogState();
}

class _InputPassDialogState extends State<InputPassDialog> {
  final _formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: dialogContent(context),
    );
  }

  final oldPassController = TextEditingController();

  @override
  void dispose() {
    oldPassController.dispose();
    super.dispose();
  }

  dialogContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            // height: 280,
            // margin: EdgeInsets.only(bottom: 5),
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: EdgeInsets.all(10),
            // decoration: BoxDecoration(),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        // color: Colors.grey,
                        width: MediaQuery.of(context).size.width / 2,
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          'Old Password',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                          // overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          height: 40,
                          child: TextFormField(
                            obscureText: true,
                            controller: oldPassController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                  left: 20, top: 10, bottom: 10),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              // hintText: 'Password',
                            ),
                            // maxLines: 5,
                            // minLines: 3,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password cannot be empty';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            // color: Colors.grey,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: raisedButtonDialogStyle,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var pass = oldPassController.text;
                        if (!NetworkData.connected) {
                          print('CLICKED!');
                          if (NetworkData.errorNo == '1') {
                            final action = await WarningDialogs.openDialog(
                              context,
                              'Network',
                              'Please check the internet connection.',
                              false,
                              'OK',
                            );
                            if (action == DialogAction.yes) {}
                          }
                          if (NetworkData.errorNo == '2') {
                            final action = await WarningDialogs.openDialog(
                              context,
                              'Network',
                              'API Problem. Please contact admin.',
                              false,
                              'OK',
                            );
                            if (action == DialogAction.yes) {}
                          }
                          if (NetworkData.errorNo == '3') {
                            final action = await WarningDialogs.openDialog(
                              context,
                              'Network',
                              'Cannot connect to server. Try again later.',
                              false,
                              'OK',
                            );
                            if (action == DialogAction.yes) {}
                          }
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) => LoadingSpinkit(
                                    description: 'Checking Password...',
                                  ));
                          if (UserData.position == 'Salesman') {
                            var rsp =
                                await db.loginUser(UserData.username!, pass);
                            if (rsp == 'failed password') {
                              Navigator.pop(context);
                              print("Wrong Password!");

                              final action = await WarningDialogs.openDialog(
                                context,
                                'Validation',
                                'Wrong Password!',
                                false,
                                'OK',
                              );
                              if (action == DialogAction.yes) {}
                            } else {
                              print("Correct Password!");
                              UserData.newPassword = '';
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChangePass();
                              }));
                            }
                          }
                          if (UserData.position == 'Jefe de Viaje') {
                            var rsp =
                                await db.loginHepe(UserData.username!, pass);
                            if (rsp == 'failed password') {
                              Navigator.pop(context);
                              print("Wrong Password!");
                              final action = await WarningDialogs.openDialog(
                                context,
                                'Validation',
                                'Wrong Password!',
                                false,
                                'OK',
                              );
                              if (action == DialogAction.yes) {}
                            } else {
                              print("Correct Password!");
                              UserData.newPassword = '';
                              Navigator.pop(context);
                              Navigator.pop(context);

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ChangePass();
                              }));
                            }
                          }
                        }
                      }
                    },
                    child: Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                    style: raisedButtonStyleWhite,
                    onPressed: () {
                      OrderData.pmtype = "";
                      OrderData.setSign = false;
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
          ),
        ],
      ),
    );
  }
}

class LoadingSpinkit extends StatefulWidget {
  final String? description;

  LoadingSpinkit({this.description});
  @override
  _LoadingSpinkitState createState() => _LoadingSpinkitState();
}

class _LoadingSpinkitState extends State<LoadingSpinkit> {
  @override
  Widget build(BuildContext context) {
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
                  // 'Checking username...',
                  widget.description.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
                SpinKitCircle(
                  color: ColorsTheme.mainColor,
                ),
              ],
            )),
      ],
    );
  }
}
