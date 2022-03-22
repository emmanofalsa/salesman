import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesman/db/db_helper.dart';
// import 'package:salesman/dialogs/account_lock.dart';
import 'package:salesman/forget_pass/forget_password.dart';
import 'package:salesman/menu.dart';
import 'package:salesman/variables/assets.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/elevated_button.dart';
import 'forget_pass/change_password.dart';
import 'userdata.dart';
import 'package:salesman/widgets/snackbar.dart';

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  String err1 = 'No Internet Connection';
  String err2 = 'API Error';
  String err3 = 'No Connection to Server';
  List _userdata = [];
  List _userAttempt = [];
  String loginDialog = '';
  final db = DatabaseHelper();
  final orangeColor = ColorsTheme.mainColor;
  final yellowColor = Colors.amber;
  final blueColor = Colors.blue;

  // static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool viewSpinkit = true;
  bool _obscureText = true;
  String message = '';
  String? imgPath;

  Timer? timer;

  void initState() {
    // if (mounted) {
    //   timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkStatus());
    // }
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkStatus());
    super.initState();
    getImagePath();
    checkStatus();
    // initPlatformState();
  }

  getImagePath() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + '/images/user/';
    // setState(() {
    imgPath = firstPath.toString();
    // imgName = UserData.img.toString();
    // loadingImg = false;
    // UserData
    // print(imgPath + imgName);
    // });
  }

  checkFailureAttempts() async {
    _userAttempt.forEach((element) {
      if (element['username'] == usernameController.text &&
          int.parse(element['attempt'].toString()) >= 3) {
        print('ACCOUNT WILL BE LOCKED OUT');
        // showDialog(
        //     barrierDismissible: false,
        //     context: context,
        //     builder: (context) => LockAccount(
        //           title: 'Account Locked',
        //           description:
        //               'This account will be locked due to excessive login failures. Please contact your administrator.',
        //           buttonText: 'Okay',
        //         ));
        showGlobalSnackbar(
            'Information',
            'This account has been locked due to excessive login failures. Please contact your administrator.',
            Colors.blue,
            Colors.white);
        db.updateHepeStatus(usernameController.text);
        if (NetworkData.connected) {
          db.updateHepeStatusOnline(usernameController.text);
        }
      }
    });
  }

  checkStatus() async {
    GlobalVariables.viewImg = false;
    var stat = await db.checkStat();
    // setState(() {
    if (stat == 'Connected') {
      NetworkData.connected = true;
      NetworkData.errorMsgShow = false;
      // upload();

    } else {
      if (stat == 'ERROR1') {
        NetworkData.connected = false;
        NetworkData.errorMsgShow = true;
        NetworkData.errorMsg = err1;
        NetworkData.errorNo = '1';
        // print('Network Error...');
      }
      if (stat == 'ERROR2') {
        NetworkData.connected = false;
        NetworkData.errorMsgShow = true;
        NetworkData.errorMsg = err2;
        NetworkData.errorNo = '2';
        // print('Connection to API Error...');
      }
      if (stat == 'ERROR3') {
        NetworkData.connected = false;
        NetworkData.errorMsgShow = true;
        NetworkData.errorMsg = err3;
        NetworkData.errorNo = '3';
        // print('Cannot connect to the Server...');
      }
      if (stat == 'Updating') {
        NetworkData.connected = false;
        NetworkData.errorMsgShow = true;
        NetworkData.errorMsg = 'Updating Server';
        NetworkData.errorNo = '4';
        // print('Updating Server...');
      }
    }
    // });
  }

  // Future<void> initPlatformState() async {
  //   Map<String, dynamic> deviceData;

  //   try {
  //     if (Platform.isAndroid) {
  //       deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
  //     }
  //   } on PlatformException {
  //     deviceData = <String, dynamic>{
  //       'Error:': 'Failed to get platform version.'
  //     };
  //   }

  //   if (!mounted) return;

  //   setState(() {
  //     _deviceData = deviceData;
  //   });
  // }

  // Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  //   return <String, dynamic>{
  //     'version.securityPatch': build.version.securityPatch,
  //     'version.sdkInt': build.version.sdkInt,
  //     'version.release': build.version.release,
  //     'version.previewSdkInt': build.version.previewSdkInt,
  //     'version.incremental': build.version.incremental,
  //     'version.codename': build.version.codename,
  //     'version.baseOS': build.version.baseOS,
  //     'board': build.board,
  //     'bootloader': build.bootloader,
  //     'brand': build.brand,
  //     'device': build.device,
  //     'display': build.display,
  //     'fingerprint': build.fingerprint,
  //     'hardware': build.hardware,
  //     'host': build.host,
  //     'id': build.id,
  //     'manufacturer': build.manufacturer,
  //     'model': build.model,
  //     'product': build.product,
  //     'supported32BitAbis': build.supported32BitAbis,
  //     'supported64BitAbis': build.supported64BitAbis,
  //     'supportedAbis': build.supportedAbis,
  //     'tags': build.tags,
  //     'type': build.type,
  //     'isPhysicalDevice': build.isPhysicalDevice,
  //     'androidId': build.androidId,
  //     'systemFeatures': build.systemFeatures,
  //   };
  // }

  @override
  void dispose() {
    timer?.cancel();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: ScreenData.scrWidth * .55,
                    height: ScreenData.scrWidth * .4,
                    child: Center(
                      child: Image(
                        image: AssetsValues.loginLogo,
                      ),
                    ),
                  ),
                  Text(
                    "Jefe de Viaje Login",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: ScreenData.scrHeight * .030,
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    /*curve: Curves.easeInOutBack,*/
                    // height: 130,
                    // width: 270,
                    height: ScreenData.scrHeight * .27,
                    width: ScreenData.scrWidth * .84,
                    child: SingleChildScrollView(
                      child: buildSignInTextField(),
                    ),
                  ),
                  SizedBox(
                    height: ScreenData.scrHeight * .030,
                  ),
                  buildSignInButton(),
                  buildForgetPass(),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: 30,
              // color: Colors.grey,
              child: Text(
                'E-COMMERCE(My NETgosyo App)' + ' COPYRIGHT 2020',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildSignInButton() {
    return Container(
      // margin: EdgeInsets.only(top: 0),
      child: Column(
        children: [
          ElevatedButton(
            style: raisedButtonLoginStyle,
            onPressed: () async {
              if (viewSpinkit == true) {
                if (_formKey.currentState!.validate()) {
                  checkFailureAttempts();
                  var username = usernameController.text;
                  var password = passwordController.text;

                  var rsp = await db.hepeLogin(username, password);

                  if (rsp == '') {
                    loginDialog = 'Account not Found!';
                  } else {
                    //Username found but incorrect password
                    if (rsp[0]['username'].toString() == username &&
                        rsp[0]['success'].toString() == '0') {
                      if (_userAttempt.isEmpty) {
                        // _userAttempt = rsp;
                        _userAttempt = json.decode(json.encode(rsp));
                        // print(_userAttempt);
                      } else {
                        int x = 0;
                        bool found = false;
                        _userAttempt.forEach((element) {
                          x++;
                          if (username.toString() ==
                              element['username'].toString()) {
                            element['attempt'] =
                                (int.parse(element['attempt'].toString()) + 1)
                                    .toString();
                            found = true;
                          } else {
                            if (_userAttempt.length == x && !found) {
                              _userAttempt
                                  .addAll(json.decode(json.encode(rsp)));
                            }
                          }
                          print(_userAttempt);
                        });
                      }
                      loginDialog = 'Account not Found!';
                    } else {
                      _userdata = rsp;
                      loginDialog = 'Found!';
                    }
                  }

                  if (loginDialog == 'Account not Found!') {
                    print("Invalid username or Password");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Invalid username or Password")),
                    );
                  } else {
                    if (_userdata[0]['status'] == '0') {
                      showGlobalSnackbar(
                          'Information',
                          'This account has been locked due to excessive login failures. Please contact your administrator.',
                          Colors.blue,
                          Colors.white);
                    } else {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => LoggingInBox());
                      UserData.id = _userdata[0]['user_code'];
                      UserData.firstname = _userdata[0]['first_name'];
                      UserData.lastname = _userdata[0]['last_name'];
                      UserData.department = _userdata[0]['department'];
                      UserData.division = _userdata[0]['division'];
                      UserData.district = _userdata[0]['district'];
                      UserData.position = _userdata[0]['title'];
                      UserData.contact = _userdata[0]['mobile'];
                      UserData.postal = _userdata[0]['postal_code'];
                      UserData.email = _userdata[0]['email'];
                      UserData.address = _userdata[0]['address'];
                      UserData.routes = _userdata[0]['area'];
                      UserData.passwordAge = _userdata[0]['password_date'];
                      UserData.img = _userdata[0]['img'];
                      UserData.imgPath = imgPath! + _userdata[0]['img'];
                      UserData.username = username;

                      //CHECK FOR DEVICE LOGIN
                      GlobalVariables.deviceData =
                          _deviceData['brand'].toString() +
                              '_' +
                              _deviceData['device'].toString() +
                              '-' +
                              _deviceData['androidId'].toString();
                      if (NetworkData.connected) {
                        var setDev = await db.setLoginDevice(
                            UserData.id!, GlobalVariables.deviceData!);
                        print(setDev);
                      }

                      print("Login Successful!");
                      viewSpinkit = false;
                      if (viewSpinkit == false) {
                        dispose();
                        DateTime a = DateTime.parse(UserData.passwordAge!);
                        final date1 = DateTime(a.year, a.month, a.day);

                        final date2 = DateTime.now();
                        final difference = date2.difference(date1).inDays;
                        if (difference >= 90) {
                          GlobalVariables.passExp = true;
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChangePass();
                          }));
                        } else {
                          GlobalVariables.passExp = false;
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Menu();
                          }));
                        }
                      }
                    }
                  }
                }
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: ScreenData.scrHeight * .070,
          ),
          // Text(message),
        ],
      ),
    );
  }

  Column buildSignInTextField() {
    final node = FocusScope.of(context);
    return Column(children: [
      Form(
          key: _formKey,
          child: Column(children: <Widget>[
            TextFormField(
              textInputAction: TextInputAction.next,
              // onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
              onEditingComplete: () => node.nextFocus(),
              controller: usernameController,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black87),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  hintText: 'Username'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Username cannot be empty';
                }
                return null;
              },
            ),
            SizedBox(
              height: ScreenData.scrHeight * .020,
            ),
            TextFormField(
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => node.unfocus(),
              obscureText: _obscureText,
              controller: passwordController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                hintText: 'Password',
                suffixIcon: GestureDetector(
                  onLongPressStart: (_) async {
                    _toggle();
                  },
                  onLongPressEnd: (_) {
                    setState(() {
                      _toggle();
                    });
                  },
                  child: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                      size: 30,
                    ),
                    onPressed: () {
                      // _toggle();
                    },
                  ),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password cannot be empty';
                }
                return null;
              },
            ),
          ]))
    ]);
  }

  Container buildForgetPass() {
    return Container(
      margin: EdgeInsets.only(top: 0),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (NetworkData.connected == true) {
                ForgetPassData.type = 'Hepe';
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ForgetPass();
                }));
                // print('Forget Password Form');
              } else {
                // showDialog(
                //     context: context,
                //     builder: (context) => UnableDialog(
                //           title: 'Connection Problem!',
                //           description: 'Check Internet Connection' +
                //               ' to use this feature.',
                //           buttonText: 'Okay',
                //         ));
                showGlobalSnackbar(
                    'Connectivity',
                    'Please connect to internet.',
                    Colors.red.shade900,
                    Colors.white);
              }
              // ForgetPassData.type = 'Hepe';
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return ForgetPass();
              // }));
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 12,
                color: ColorsTheme.mainColor,
              ),
            ),
          ),
          // Text(message),
        ],
      ),
    );
  }
}

// void initSignIn() {}
class LoggingInBox extends StatefulWidget {
  @override
  _LoggingInBoxState createState() => _LoggingInBoxState();
}

class _LoggingInBoxState extends State<LoggingInBox> {
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
                  'Logging in as Jefe de Viaje...',
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
