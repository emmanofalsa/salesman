// import 'dart:io';
// import 'dart:io';
// import 'dart:ui';
import 'package:avatar_view/avatar_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/profile/input_oldpass.dart';
import 'package:salesman/profile/message_inbox.dart';
import 'package:salesman/profile/notice.dart';
import 'package:salesman/profile/profile_info.dart';
import 'package:salesman/profile/settings.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/url/url.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/dialogs.dart';
import 'package:salesman/widgets/snackbar.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  List ver = [];
  bool checking = false;
  String? imgPath;
  String? imgName;
  bool loadingImg = true;

  // File _image;
  DatabaseHelper db = DatabaseHelper();

  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Colors.white,
    minimumSize: Size(40, 20),
    padding: EdgeInsets.symmetric(horizontal: 10),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  void initState() {
    super.initState();
    // getImagePath();
    checkVersion();
    GlobalVariables.dataPrivacyNoticeScrollBottom = false;
    print(UrlAddress.userImg + UserData.img!);
    // _initDir();
  }

  // getImagePath() async {
  //   var documentDirectory = await getApplicationDocumentsDirectory();
  //   var firstPath = documentDirectory.path + '/images/user/';
  //   // setState(() {
  //   imgPath = firstPath.toString();
  //   imgName = UserData.img.toString();
  //   loadingImg = false;
  //   print(imgPath + imgName);
  //   // });
  // }

  checkVersion() async {
    if (NetworkData.connected) {
      checking = true;
      var res = await db.checkAppversion(AppData.updesc);
      // print(res);
      // print(AppData.updesc);
      // print(AppData.appVersion);
      if (!mounted) return;
      setState(() {
        ver = res;
        // print(ver);
      });
      if (ver.isNotEmpty) {
        setState(() {
          checking = false;
          // print(ver[0]['tdesc']);
          if (ver[0]['tdesc'] == AppData.appVersion) {
            AppData.appUptodate = true;
          } else {
            AppData.appUptodate = false;
          }
        });
      }
    }
  }

  void _launchURL() async => await canLaunch(UrlAddress.appLink)
      ? await launch(UrlAddress.appLink)
      : throw 'Could not launch $UrlAddress.appLink';

  void handleUserInteraction([_]) {
    // _initializeTimer();

    SessionTimer sessionTimer = SessionTimer();
    sessionTimer.initializeTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        handleUserInteraction();
      },
      onPanDown: (details) {
        handleUserInteraction();
      },
      child: Scaffold(
        // appBar: AppBar(
        //   toolbarHeight: 120,
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.white,
        //   elevation: 0,
        //   title: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         "Profile",
        //         textAlign: TextAlign.right,
        //         style: TextStyle(
        //             color: ColorsTheme.mainColor,
        //             fontSize: 45,
        //             fontWeight: FontWeight.bold),
        //       ),
        //       SizedBox(height: 50),
        //     ],
        //   ),
        // ),
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.width / 2 - 20,
          automaticallyImplyLeading: false,
          backgroundColor: ColorsTheme.mainColor,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Profile",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 45,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                        child: Row(
                      children: [
                        // loadingImg
                        //     ? CircleAvatar(
                        //         backgroundColor: Colors.white,
                        //         radius: 45,
                        //         child: SpinKitFadingCircle(
                        //           color: ColorsTheme.mainColor,
                        //           size: 20,
                        //         ),
                        //       )
                        //     :
                        AvatarView(
                          radius: 45,
                          borderWidth: 5,
                          borderColor: Colors.white,
                          avatarType: AvatarType.CIRCLE,
                          backgroundColor: Colors.black,
                          imagePath: NetworkData.connected
                              ? UrlAddress.userImg + UserData.img!
                              : UserData.imgPath!,
                          placeHolder: Container(
                            child: Icon(
                              Icons.person,
                              size: 50,
                            ),
                          ),
                          errorWidget: Container(
                            child: Icon(
                              Icons.error,
                              size: 50,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UserData.firstname! + " " + UserData.lastname!,
                            ),
                            Text(
                              UserData.position!,
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        )
                      ],
                    )),
                  ),
                  InkWell(
                    onTap: () {
                      if (NetworkData.connected == true) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => ProfileInfo());
                      } else {
                        showGlobalSnackbar(
                            'Connectivity',
                            'Please connect to internet.',
                            Colors.red.shade900,
                            Colors.white);
                      }
                    },
                    child: Column(
                      children: [
                        Text(
                          'Edit',
                          style: TextStyle(fontSize: 10),
                        ),
                        Icon(
                          CupertinoIcons.pencil_circle, size: 24,
                          // color: Colors.deepOrange[800],
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        backgroundColor: ColorsTheme.mainColor,
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  // buildHeader(),
                  // buildInfo(context),
                  SizedBox(height: 20),
                  buildMessages(context),
                  SizedBox(height: 3),
                  buildChangePass(context),
                  SizedBox(height: 3),
                  buildPrivacyNot(context),
                  SizedBox(height: 3),
                  buildSettings(context),
                  SizedBox(height: 30),
                  buildLogout(context),
                  SizedBox(height: 30),
                  buildVersionUp(context),
                  Visibility(
                      visible: !AppData.appUptodate,
                      child: buildUpdateButton(context))
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'E-COMMERCE(MY NETGOSYO APP)'
                      ' COPYRIGHT 2020',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildSettings(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          if (NetworkData.connected == true) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => ViewSettings());
          } else {
            showGlobalSnackbar('Connectivity', 'Please connect to internet.',
                Colors.red.shade900, Colors.white);
          }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                CupertinoIcons.gear_alt_fill,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Container buildMessages(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          if (NetworkData.connected == true) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => MessageInbox());
          } else {
            showGlobalSnackbar('Connectivity', 'Please connect to internet.',
                Colors.red.shade900, Colors.white);
          }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                CupertinoIcons.bubble_left_bubble_right_fill,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                'Messages',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Container buildUpdateButton(BuildContext context) {
    return Container(
      // height: 60,
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.only(right: 15),
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: raisedButtonStyle,
            onPressed: () {
              _launchURL();
            },
            child: Text(
              'Update',
              style: TextStyle(fontSize: 12),
            ),
          )
        ],
      ),
    );
  }

  Container buildVersionUp(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      // color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                'Version: ' + AppData.appVersion!,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
              checking
                  ? Row(
                      children: [
                        Text(
                          'Checking for new updates ',
                          style: TextStyle(
                            color: ColorsTheme.mainColor,
                            fontSize: 12,
                          ),
                        ),
                        SpinKitCircle(
                          color: ColorsTheme.mainColor,
                          size: 18,
                        ),
                      ],
                    )
                  : AppData.appUptodate
                      ? Text(
                          'You are on latest version',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        )
                      : Text(
                          'A new update is available',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        )
            ],
          ),
        ],
      ),
    );
  }

  Container buildLogout(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          final action = await Dialogs.openDialog(context, 'Confirmation',
              'Are you sure you want to logout?', true, 'No', 'Yes');
          if (action == DialogAction.yes) {
            GlobalVariables.menuKey = 0;
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/splash', (Route<dynamic> route) => false);
          }
          // showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //         title: Text('Confirmation'),
          //         content: Text('Are you sure you want to logout?'),
          //         actions: <Widget>[
          //           TextButton(
          //               onPressed: () {
          //                 GlobalVariables.menuKey = 0;
          //                 // Navigator.pop(context);
          //                 // Navigator.push(context,
          //                 //     MaterialPageRoute(builder: (context) {
          //                 //   return MyOptionPage();
          //                 // }));

          //                 Navigator.of(context).pushNamedAndRemoveUntil(
          //                     '/splash', (Route<dynamic> route) => false);
          //               },
          //               child: Text('Confirm')),
          //           TextButton(
          //               onPressed: () {
          //                 Navigator.pop(context);
          //               },
          //               child: Text(
          //                 'Cancel',
          //                 style: TextStyle(color: Colors.grey),
          //               ))
          //         ],
          //       );
          //     });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'LOGOUT',
              style: TextStyle(
                  color: ColorsTheme.mainColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Container buildPrivacyNot(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ViewNotice();
          }));
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.description,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                'Privacy Notice',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Container buildChangePass(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () async {
          if (NetworkData.connected == true) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => InputPassDialog());
          } else {
            // final action = await WarningDialogs.openDialog(
            //   context,
            //   'Network',
            //   'Connection Problem.',
            //   false,
            //   'OK',
            // );
            // if (action == DialogAction.yes) {}
            showGlobalSnackbar('Connectivity', 'Please connect to internet.',
                Colors.red.shade900, Colors.white);
          }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.lock_open,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                'Change Password',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }

  Container buildInfo(BuildContext context) {
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 8,
      child: InkWell(
        onTap: () {
          if (NetworkData.connected == true) {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => ProfileInfo());
          } else {
            showGlobalSnackbar('Connectivity', 'Please connect to internet.',
                Colors.red.shade900, Colors.white);
          }
        },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                Icons.account_circle,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  UserData.firstname! + " " + UserData.lastname!,
                  style: TextStyle(
                    color: Colors.grey[850],
                    fontSize: 14,
                  ),
                ),
                Text(
                  UserData.position! +
                      '(' +
                      UserData.department! +
                      ' - ' +
                      UserData.division! +
                      ')',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                Text(
                  UserData.address! + ', ' + UserData.postal!,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
                Text(
                  UserData.contact!,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Container buildHeader() {
    return Container(
      padding: EdgeInsets.only(left: 16),
      alignment: Alignment.centerLeft,
      child: Text(
        "Profile",
        textAlign: TextAlign.right,
        style: TextStyle(
            color: ColorsTheme.mainColor,
            fontSize: 45,
            fontWeight: FontWeight.bold),
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
