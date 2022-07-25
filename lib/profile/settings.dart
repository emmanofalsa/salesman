import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:archive/archive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:salesman/providers/img_download.dart';
// import 'package:salesman/dialogs/downloadingimage.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/url/url.dart';
import 'package:salesman/userdata.dart';
// import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/dialogs.dart';
import 'package:switcher/core/switcher_size.dart';
import 'package:switcher/switcher.dart';

class ViewSettings extends StatefulWidget {
  @override
  _ViewSettingsState createState() => _ViewSettingsState();
}

class _ViewSettingsState extends State<ViewSettings> {
  // List<String>? _images, _tempImages;
  List<String> _images = [];
  List<String> _tempImages = [];
  String? _dir;
  // 'img.zip'
  String _zipPath = UrlAddress.itemImg + 'img10k.zip';
  String _localZipFileName = 'img10k.zip';
  bool downloading = false;

  void initState() {
    super.initState();
    _initDir();
  }

  _initDir() async {
    if (null == _dir) {
      _dir = (await getApplicationDocumentsDirectory()).path;
      print('DIRECTORY: ' + _dir.toString());
    }
    _images = [];
    // _tempImages = List();
    _tempImages = [];
  }

  void handleUserInteraction([_]) {
    // _initializeTimer();

    SessionTimer sessionTimer = SessionTimer();
    sessionTimer.initializeTimer(context);
  }

  checkImage() async {
    if (!GlobalVariables.viewImg) {
      var file = '$_dir/' + 'no_image_item.jpg';

      if (await File(file).exists()) {
        print("File exists");
        // String imgFile = '$_dir/' + 'no_image_item.jpg';
        // if (await File(imgFile).exists()) {
        //   print('FOUND!');
        //   print(imgFile);
        // } else {
        //   print('IMAGE NOT FOUND!');
        // }
      } else {
        final action = await Dialogs.openDialog(context, 'Confirmation',
            'Are you sure you want to download images?', true, 'No', 'Yes');
        if (action == DialogAction.yes) {
          print('Downloading');
          setState(() {
            downloading = true;
            GlobalVariables.progressString = "Preparing Download...";
          });
          Provider.of<DownloadStat>(context, listen: false)
              .changeCap('Preparing Download...');
          // showDialog(
          //     barrierDismissible: false,
          //     context: context,
          //     builder: (context) => LoadingImageSpinkit());
          downloadingImage();
        } else {
          // Navigator.pop(context);
          // setState(() {
          GlobalVariables.viewImg = false;
          Navigator.pop(context);
          // });
        }
      }
    }
  }

  Future<void> downloadingImage() async {
    Dio dio = Dio();
    GlobalVariables.progressString = '';
    _images.clear();
    _tempImages.clear();
    try {
      await dio.download(_zipPath, "$_dir/$_localZipFileName",
          onReceiveProgress: (int rec, int total) {
        // setState(() {
        //   print("Rec: $rec, Total: $total");
        //   GlobalVariables.progressString =
        //       "Downloading " + ((rec / total) * 100).toStringAsFixed(0) + "%";
        //   print(GlobalVariables.progressString);
        // });

        //
        Provider.of<DownloadStat>(context, listen: false).changeCap(
            'Downloading...' + ((rec / total) * 100).toStringAsFixed(0) + "%");
        // print(GlobalVariables.progressString);
      });
      await unarchiveAndSave();
      setState(() {
        _images.addAll(_tempImages);
        downloading = false;
        // GlobalVariables.progressString = 'Completed';
      });
      Provider.of<DownloadStat>(context, listen: false).changeCap('Completed');
    } catch (e) {
      print(e);
      // setState(() {
      //   GlobalVariables.progressString = 'Error when Downloading';
      //   downloading = false;
      // });
      Provider.of<DownloadStat>(context, listen: false)
          .changeCap('Error when downloading...');
    }
    setState(() {
      //   _images.addAll(_tempImages);
      //   downloading = false;
      // GlobalVariables.progressString = 'Extracting Zipped File...';
    });

    // print('Download Complete');
  }

  unarchiveAndSave() async {
    print('NAHUMAN NAG DOWNLOAD');
    var file = '$_dir/$_localZipFileName';

    // GlobalVariables.progressString = 'Extracting Zipped File...';
    Provider.of<DownloadStat>(context, listen: false)
        .changeCap('Extracting Zipped File...');
    var bytes = File(file).readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
      var fileName = '$_dir/${file.name}';
      print(fileName);
      if (file.isFile) {
        var outFile = File(fileName);
        // print('File: ' + outFile.path);
        _tempImages.add(outFile.path);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
        // print(_tempImages);
      }
    }
  }

  // _toggle() {
  //   setState(() {
  //     GlobalVariables.viewImg = !GlobalVariables.viewImg;
  //     print(GlobalVariables.viewImg);
  //   });
  // }

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
      child: WillPopScope(
        onWillPop: () => Future.value(!downloading),
        child: Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Settings',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            // centerTitle: true,
            elevation: 0,
            // toolbarHeight: 50,
          ),
          backgroundColor: ColorsTheme.mainColor,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          )),
                      child: Column(
                        children: [
                          SizedBox(height: 15),
                          buildImageOption(context),
                          SizedBox(height: 25),
                          Visibility(
                              visible: downloading,
                              child: buildDownloadProgress(context)),
                        ],
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildImageOption(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      color: Colors.white,
      child: InkWell(
        onTap: () async {},
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                CupertinoIcons.photo_fill,
                color: Colors.grey[700],
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                'View Item Images',
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 14,
                ),
              ),
            ),
            Switcher(
              switcherRadius: 50,
              value: GlobalVariables.viewImg,
              colorOff: Colors.grey,
              colorOn: Colors.greenAccent,
              iconOff: CupertinoIcons.xmark,
              onChanged: (bool val) {
                if (val) {
                  checkImage();
                }
                print('VALUE OF VAL   : $val');
                GlobalVariables.viewImg = val;
              },
              size: SwitcherSize.small,
            ),
          ],
        ),
      ),
    );
  }

  Container buildDownloadProgress(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(right: 15),
      // color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SpinKitCircle(
            // controller: animationController,
            size: 24,
            color: Colors.greenAccent,
          ),
          Text(
            // GlobalVariables.progressString,
            Provider.of<DownloadStat>(context).cap,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.greenAccent.shade700),
          ),
        ],
      ),
    );
  }
}
