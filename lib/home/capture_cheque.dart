import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:salesman/url/url.dart';
import 'package:salesman/userdata.dart';

class CaptureImage extends StatefulWidget {
  @override
  _CaptureImageState createState() => _CaptureImageState();
}

class _CaptureImageState extends State<CaptureImage> {
  static final String uploadEndpoint = UrlAddress.url + '/uploadchequeimg';
  Future<File>? file;
  String status = "";
  String? base64Image;
  File? tmpFile;
  String errMessage = 'Error Uploading Image';
  String? fileName;

  chooseImage() async {
    // setState(() {
    final ImagePicker _picker = ImagePicker();
    // file = ImagePicker.pickImage(source: ImageSource.camera);
    final file = await _picker.pickImage(source: ImageSource.gallery);
    // file = ImagePicker.getImage(source: ImageSource.camera);
    // });
    print(file);
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  uploadImage() async {
    final uri = Uri.parse(uploadEndpoint);
    var request = http.MultipartRequest('POST', uri);
    request.fields['name'] = fileName.toString();
    var pic = await http.MultipartFile.fromPath('image', tmpFile!.path);
    request.files.add(pic);
    var response = await request.send();
    print(fileName);
    print(tmpFile!.path);
    if (response.statusCode == 200) {
      print('Image Upload');
      ChequeData.imgName = fileName.toString();
      OrderData.setChequeImg = true;
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Successfully uploaded image.'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      if (!ChequeData.changeImg) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('OK'))
              ],
            );
          });
      print(ChequeData.imgName);
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
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data!.readAsBytesSync());
          fileName = tmpFile!.path.split('/').last;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cheque Image'),
      ),
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            OutlinedButton(
              onPressed: chooseImage(),
              child: Text('Choose Image'),
            ),
            SizedBox(
              height: 20,
            ),
            showImage(),
            SizedBox(
              height: 20,
            ),
            OutlinedButton(
              onPressed: uploadImage,
              child: Text('Upload Image'),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              status,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
