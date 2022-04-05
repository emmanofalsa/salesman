import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/profile/img_option.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/url/url.dart';
import 'package:http/http.dart' as http;
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/dialogs.dart';
import 'package:salesman/widgets/snackbar.dart';
import 'package:salesman/widgets/spinkit.dart';
// import 'package:salesman/widgets/snackbar.dart';

class ProfileInfo extends StatefulWidget {
  @override
  _ProfileInfoState createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  static final String uploadEndpoint = UrlAddress.url + '/uploaduserimg';
  Future<File>? file;
  String status = "";
  String? base64Image;
  File? tmpFile;
  String errMessage = 'Error Uploading Image';
  String? fileName;
  int? result;

  File? _image;
  final picker = ImagePicker();
  final txtController = TextEditingController();

  final db = DatabaseHelper();
  void initState() {
    super.initState();
    _image = null;
    print(uploadEndpoint);
  }

  // chooseImage() async {
  //   // setState(() {
  //   final ImagePicker _picker = ImagePicker();
  //   // file = ImagePicker.pickImage(source: ImageSource.camera);
  //   final file = await _picker.pickImage(source: ImageSource.gallery);
  //   // file = ImagePicker.getImage(source: ImageSource.camera);
  //   // });
  //   print(file);
  // }
  Future getImagefromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
      showImage();
      fileName = _image!.path.split('/').last;
      print(fileName);
    });
  }

  Future openCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile!.path);
      showImage();
      fileName = _image!.path.split('/').last;
      print(pickedFile.path);
      print(fileName);
    });
  }

  uploadImage() async {
    final uri = Uri.parse(uploadEndpoint);
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = fileName.toString();
    var pic = await http.MultipartFile.fromPath('image', _image!.path);
    request.files.add(pic);
    var response = await request.send();
    print(request.fields['name']);
    print('PATH: ' + _image!.path);
    print(_image);

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print('Image Upload');
      // ChequeData.imgName = fileName.toString();
      // OrderData.setChequeImg = true;
      UserData.img = fileName.toString();
      showGlobalSnackbar(
          'Information', 'Image Uploaded', Colors.white, ColorsTheme.mainColor);

      if (UserData.position == 'Salesman') {
        print(UserData.id);
        print(UserData.img);
        var changeImg = await db.updateSalesmanImg(UserData.id!, UserData.img!);
        print(changeImg);
        setState(() {
          result = changeImg;
        });
        if (result == 1) {
          Navigator.pop(context);
          final action = await WarningDialogs.openDialog(context, 'Information',
              'Changes Successfully Saved!', false, 'OK');
          if (action == DialogAction.yes) {
            GlobalVariables.processedPressed = true;
            GlobalVariables.menuKey = 3;
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) {
            //   return SalesmanMenu();
            // }));
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/smmenu', (Route<dynamic> route) => false);
          }
        }
      } else {
        var changeImg = await db.updateHepeImg(UserData.id!, UserData.img!);
        print(changeImg);
        setState(() {
          result = changeImg;
        });
        if (result == 1) {
          Navigator.pop(context);
          final action = await WarningDialogs.openDialog(context, 'Information',
              'Changes Successfully Saved!', false, 'OK');
          if (action == DialogAction.yes) {
            GlobalVariables.processedPressed = true;
            GlobalVariables.menuKey = 4;
            // Navigator.pushReplacement(context,
            //     MaterialPageRoute(builder: (context) {
            //   return Menu();
            // }));
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/hepemenu', (Route<dynamic> route) => false);
          }
        }
      }
    } else {
      print('Image not Upload');
    }
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          _image = snapshot.data;
          base64Image = base64Encode(snapshot.data!.readAsBytesSync());
          fileName = _image!.path.split('/').last;
          print('PRINT FILE NAME: ' + fileName!);
          return Flexible(
            child: Image.file(
              snapshot.data!,
              fit: BoxFit.fill,
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

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
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.width / 2 + 50,
          automaticallyImplyLeading: false,
          backgroundColor: ColorsTheme.mainColor,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Edit Profile",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold),
              ),
              // Visibility(visible: false, child: showImage()),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      // AvatarView(
                      //   radius: 80,
                      //   borderWidth: 5,
                      //   borderColor: Colors.white,
                      //   avatarType: AvatarType.CIRCLE,
                      //   backgroundColor: Colors.red,
                      //   imagePath: NetworkData.connected
                      //       ? UrlAddress.userImg + UserData.img
                      //       : UserData.imgPath,
                      //   placeHolder: Container(
                      //     child: Icon(
                      //       Icons.person,
                      //       size: 50,
                      //     ),
                      //   ),
                      //   errorWidget: Container(
                      //     child: Icon(
                      //       Icons.error,
                      //       size: 50,
                      //     ),
                      //   ),
                      // ),
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 75,
                          backgroundImage: (_image != null)
                              ? Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ).image
                              : NetworkImage(
                                  UrlAddress.userImg + UserData.img!),

                          // backgroundImage:
                          //     NetworkImage(UrlAddress.userImg + UserData.img),
                          backgroundColor: Colors.black,
                        ),
                      ),

                      SizedBox(
                        height: 5,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) => Option()).then((value) {
                            if (UserData.getImgfrom == 'Camera') {
                              openCamera();
                            } else {
                              getImagefromGallery();
                            }
                          });
                          // getImagefromGallery();
                        },
                        child: Row(
                          children: [
                            Text(
                              'Change Photo',
                              style: TextStyle(fontSize: 12),
                            ),
                            Icon(CupertinoIcons.camera_circle)
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        backgroundColor: ColorsTheme.mainColor,
        body: Column(
          children: [
            Expanded(
              child: Container(
                // padding: EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    )),
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    buildPersonalInfo(context),
                    SizedBox(
                      height: 20,
                    ),
                    buildContactInfo(context),
                    SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final action = await Dialogs.openDialog(
                                      context,
                                      'Confirmation',
                                      'Are you sure you want to save image?',
                                      true,
                                      'No',
                                      'Yes');
                                  if (action == DialogAction.yes) {
                                    Spinkit.label = 'Uploading Image...';
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (context) => LoadingSpinkit());
                                    uploadImage();
                                  }

                                  // final action = await Dialogs.openDialog(
                                  //     context,
                                  //     'Confirmation',
                                  //     'Are you sure you want to logout?',
                                  //     true,
                                  //     'No',
                                  //     'Yes');
                                  // if (action == DialogAction.yes) {
                                  //   GlobalVariables.menuKey = 0;
                                  //   Navigator.of(context).pushNamedAndRemoveUntil(
                                  //       '/splash',
                                  //       (Route<dynamic> route) => false);
                                  // }
                                },
                                child: Container(
                                  color: Colors.white,
                                  height: 50,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'SAVE CHANGES',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: ColorsTheme.mainColor,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildPersonalInfo(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text('Personal Information',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500)),
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(left: 15),
                color: Colors.white,
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      UserData.firstname! + " " + UserData.lastname!,
                      style: TextStyle(
                          color: Colors.grey[850],
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(left: 15),
                color: Colors.white,
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      UserData.position! +
                          '(' +
                          UserData.department! +
                          ' - ' +
                          UserData.division! +
                          ')',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ))
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(left: 15),
                color: Colors.white,
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      UserData.address! + ', ' + UserData.postal!,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }

  Container buildContactInfo(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text('Contact Information',
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500)),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 15),
                  color: Colors.white,
                  height: 50,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: Row(
                                children: [
                                  Text(
                                    'Mobile:',
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    UserData.contact!,
                                    style: TextStyle(
                                        color: Colors.grey[850],
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              showGlobalSnackbar(
                                  'Information',
                                  'This feature is currently unavailable.',
                                  Colors.white,
                                  ColorsTheme.mainColor);
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: ColorsTheme.mainColor,
                                      fontWeight: FontWeight.w500),
                                ),
                                Icon(
                                  CupertinoIcons.pencil,
                                  size: 20,
                                  color: ColorsTheme.mainColor,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(left: 15),
                color: Colors.white,
                height: 50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Row(
                              children: [
                                Text(
                                  'Email:',
                                  style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  UserData.email!,
                                  style: TextStyle(
                                      color: Colors.grey[850],
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showGlobalSnackbar(
                                'Information',
                                'This feature is currently unavailable.',
                                Colors.white,
                                ColorsTheme.mainColor);
                          },
                          child: Row(
                            children: [
                              Text(
                                'Edit',
                                style: TextStyle(
                                    fontSize: 10,
                                    color: ColorsTheme.mainColor,
                                    fontWeight: FontWeight.w500),
                              ),
                              Icon(
                                CupertinoIcons.pencil,
                                size: 20,
                                color: ColorsTheme.mainColor,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ))
            ],
          ),
        ],
      ),
    );
  }
}
