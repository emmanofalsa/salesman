import 'dart:async';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/forget_pass/reset_password.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/widgets/elevated_button.dart';

class ForgetPass extends StatefulWidget {
  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  // List _userdata = [];
  List device = [];
  // List _deviceData = [];
  String response = '';
  String loginDialog = '';
  String err1 = 'No Internet Connection';
  String err2 = 'No Connection to Server';
  String err3 = 'API Error';
  final db = DatabaseHelper();
  final orangeColor = ColorsTheme.mainColor;
  final yellowColor = Colors.amber;
  final blueColor = Colors.blue;

  Timer? timer;

  // static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  // Map<String, dynamic> _deviceData = <String, dynamic>{};

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool viewSpinkit = true;
  // bool _obscureText = true;
  String? message = '';
  String? mobile;
  String? usercode;

  @override
  void initState() {
    super.initState();
    // initPlatformState();
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

  String generateString() {
    var list = List.generate(9, (index) => index + 1)..shuffle();
    return list.take(6).join('');
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    timer?.cancel();
    print('Timer Disposed');
    super.dispose();
  }

  // void _toggle() {
  //   setState(() {
  //     _obscureText = !_obscureText;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 20),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  // Container(
                  //   margin: EdgeInsets.only(top: 24),
                  //   width: 200,
                  //   height: 200,
                  //   child: Center(
                  //     child: Image(
                  //       image: AssetImage('assets/images/dtruck.png'),
                  //     ),
                  //   ),
                  // ),
                  Text(
                    "Forgot Password",
                    style: TextStyle(
                        color: ColorsTheme.mainColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    /*curve: Curves.easeInOutBack,*/
                    // height: 250,
                    width: MediaQuery.of(context).size.width,
                    // color: Colors.grey,
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: SingleChildScrollView(
                      child: buildSignInTextField(),
                    ),
                  ),
                  buildSignInButton(),
                  // buildForgetPass(),
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
                'E-COMMERCE(DISTRIBUTION APP) V1.' +
                    GlobalVariables.appVersion +
                    ' COPYRIGHT 2020',
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
      margin: EdgeInsets.only(top: 0),
      child: Column(
        children: [
          ElevatedButton(
            style: raisedButtonLoginStyle,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                var username = usernameController.text;

                if (!NetworkData.connected) {
                  if (NetworkData.errorNo == '1') {
                    showGlobalSnackbar(
                        'Connectivity',
                        'Please connect to internet.',
                        Colors.red.shade900,
                        Colors.white);
                  }
                  if (NetworkData.errorNo == '2') {
                    showGlobalSnackbar(
                        'Connectivity',
                        'API Problem. Please contact admin.',
                        Colors.red.shade900,
                        Colors.white);
                  }
                  if (NetworkData.errorNo == '3') {
                    showGlobalSnackbar(
                        'Connectivity',
                        'Cannot connect to server. Try again later.',
                        Colors.red.shade900,
                        Colors.white);
                  }
                } else {
                  showDialog(
                      context: context,
                      builder: (context) => LoadingSpinkit(
                            description: 'Checking username...',
                          ));

                  if (ForgetPassData.type == 'Salesman') {
                    var rsp = await db.checkSMusername(username);
                    if (rsp == null) {
                      print('NOT FOUND!');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.black,
                            content: Text("Username not found!")),
                      );
                      Navigator.pop(context);
                    } else {
                      print(rsp['mobile']);
                      print('FOUND!!!!!!!!!!!!!!');
                      mobile = rsp['mobile'];
                      usercode = rsp['user_code'];
                      var gstr = generateString();
                      print(gstr);
                      var resp = await db.addSmsCode(
                          username, gstr, mobile.toString());

                      if (resp != null) {
                        GlobalVariables.fpassUsername = username;
                        GlobalVariables.fpassmobile = mobile.toString();
                        GlobalVariables.fpassusercode = usercode.toString();
                        Navigator.pop(context);
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => InputSmsCode());
                      }
                    }
                  }

                  if (ForgetPassData.type == 'Hepe') {
                    var rsp = await db.checkHEPEusername(username);
                    if (rsp == null) {
                      print('NOT FOUND!');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("Username not found!")),
                      );
                      Navigator.pop(context);
                    } else {
                      print(rsp['mobile']);
                      print('FOUND!!!!!!!!!!!!!!');
                      mobile = rsp['mobile'];
                      usercode = rsp['user_code'];
                      var gstr = generateString();
                      print(gstr);
                      var resp = await db.addHepeSmsCode(
                          username, gstr, mobile.toString());

                      if (resp != null) {
                        GlobalVariables.fpassUsername = username;
                        GlobalVariables.fpassmobile = mobile.toString();
                        GlobalVariables.fpassusercode = usercode.toString();
                        Navigator.pop(context);
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => InputSmsCode());
                      }
                    }
                  }
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
          ),
          Text(message!),
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
                hintText: 'Enter username',
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Username cannot be empty';
                }
                return null;
              },
            ),
            SizedBox(
              height: 25,
            ),
          ]))
    ]);
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

class InputSmsCode extends StatefulWidget {
  @override
  _InputSmsCodeState createState() => _InputSmsCodeState();
}

class _InputSmsCodeState extends State<InputSmsCode> {
  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final db = DatabaseHelper();
  final smscodeController = TextEditingController();

  String generateString() {
    var list = List.generate(9, (index) => index + 1)..shuffle();
    return list.take(6).join('');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        // child: confirmContent(context),
        child: loadingContent(context),
      ),
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
                Container(
                  padding: EdgeInsets.all(20),
                  width: MediaQuery.of(context).size.width,
                  // height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                      color: Colors.white,
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Enter Code',
                        style: TextStyle(
                            fontSize: 26,
                            color: ColorsTheme.mainColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Enter the 6-digit code we sent to your number to finish setting up authentication.',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      buildSmsCodeField(),
                      SizedBox(
                        height: 10,
                      ),
                      buildButtons(),
                    ],
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Container buildSmsCodeField() {
    final node = FocusScope.of(context);
    return Container(
      child: Form(
        key: _formKey,
        child: TextFormField(
          style: TextStyle(
            fontSize: 24,
            color: ColorsTheme.mainColor,
            fontWeight: FontWeight.w500,
          ),
          textInputAction: TextInputAction.next,
          // onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          onEditingComplete: () => node.nextFocus(),
          controller: smscodeController,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black87),
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            // hintText: 'Username',
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'SMS Code cannot be empty';
            }
            if (value.length != 6) {
              return 'Invalid Code.';
            }
            return null;
          },
        ),
      ),
    );
  }

  Container buildButtons() {
    // final node = FocusScope.of(context);
    return Container(
        child: Column(
      children: [
        InkWell(
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              if (!NetworkData.connected) {
                if (NetworkData.errorNo == '1') {
                  showGlobalSnackbar(
                      'Connectivity',
                      'Please connect to internet.',
                      Colors.red.shade900,
                      Colors.white);
                }
                if (NetworkData.errorNo == '2') {
                  showGlobalSnackbar(
                      'Connectivity',
                      'API Problem. Please contact admin.',
                      Colors.red.shade900,
                      Colors.white);
                }
                if (NetworkData.errorNo == '3') {
                  showGlobalSnackbar(
                      'Connectivity',
                      'Cannot connect to server. Try again later.',
                      Colors.red.shade900,
                      Colors.white);
                }
              } else {
                showDialog(
                    context: context,
                    builder: (context) => LoadingSpinkit(
                          description: 'Checking code...',
                        ));
                if (ForgetPassData.type == 'Salesman') {
                  var scode = await db.checkSmsCode(
                      GlobalVariables.fpassUsername!, smscodeController.text);
                  if (scode == null) {
                    Navigator.pop(context);
                    print('NOT FOUND!');
                    showGlobalSnackbar('Information',
                        'Invalid Code. Try again.', Colors.blue, Colors.white);
                  } else {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ResetPass();
                    }));
                  }
                }
                if (ForgetPassData.type == 'Hepe') {
                  var scode = await db.checkHepeSmsCode(
                      GlobalVariables.fpassUsername!, smscodeController.text);
                  if (scode == null) {
                    Navigator.pop(context);
                    print('NOT FOUND!');
                    showGlobalSnackbar('Information',
                        'Invalid Code. Try again.', Colors.blue, Colors.white);
                  } else {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ResetPass();
                    }));
                  }
                }
              }
            }
            // ForgetPassData.type = 'Salesman';
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: ColorsTheme.mainColor,
            child: Center(
              child: Text(
                'CONFIRM',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 50,
                child: ElevatedButton(
                  style: raisedButtonStyleWhite,
                  onPressed: () async {
                    if (!NetworkData.connected) {
                      if (NetworkData.errorNo == '1') {
                        showGlobalSnackbar(
                            'Connectivity',
                            'Please connect to internet.',
                            Colors.red.shade900,
                            Colors.white);
                      }
                      if (NetworkData.errorNo == '2') {
                        showGlobalSnackbar(
                            'Connectivity',
                            'API Problem. Please contact admin.',
                            Colors.red.shade900,
                            Colors.white);
                      }
                      if (NetworkData.errorNo == '3') {
                        showGlobalSnackbar(
                            'Connectivity',
                            'Cannot connect to server. Try again later.',
                            Colors.red.shade900,
                            Colors.white);
                      }
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => LoadingSpinkit(
                                description: 'Resending code...',
                              ));
                      var gstr = generateString();
                      print(gstr);
                      var resp = await db.addSmsCode(
                          GlobalVariables.fpassUsername!,
                          gstr,
                          GlobalVariables.fpassmobile!);
                      if (resp != null) {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: Text(
                    'Resend Code',
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorsTheme.mainColor,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width / 3,
                height: 50,
                child: ElevatedButton(
                  style: raisedButtonStyleWhite,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 14,
                      color: ColorsTheme.mainColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
