import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
// import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' show Client, Request, get;
import 'package:retry/retry.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/login.dart';
import 'package:salesman/salesman_home/login.dart';
import 'package:salesman/url/url.dart';
import 'package:http/http.dart' as http;
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/assets.dart';
import 'package:salesman/variables/colors.dart';

class MyOptionPage extends StatefulWidget {
  @override
  _MyOptionPageState createState() => _MyOptionPageState();
}

class _MyOptionPageState extends State<MyOptionPage> {
  List rows = [];
  List salesmanList = [];
  List customerList = [];
  List discountList = [];
  List hepeList = [];
  List itemList = [];
  List itemImgList = [];
  List itemAllImgList = [];
  List itemwImgList = [];
  List categList = [];
  List salestypeList = [];
  List bankList = [];

  String imageData;

  bool dataLoaded = false;
  bool processing = false;

  final db = DatabaseHelper();

  bool loadSpinkit = true;
  bool imgLoad = true;

  // bool _downloading;
  String _dir;
  List<String> _images, _tempImages;
  String _zipPath = UrlAddress.itemImg + 'img.zip';
  String _localZipFileName = 'img.zip';

  // final date = DateTime.parse(DateFormat("y-M-d").format(new DateTime.now()));

  String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());

  // String date = '2021-12-31';

  Future createDatabase() async {
    await db.init();
    checkStatus();
    load();
    print(date);
    // itemImage();
  }

  @override
  void initState() {
    super.initState();
    createDatabase();
    _images = List();
    _tempImages = List();
    // _downloading = false;
    _initDir();
  }

  // viewSampleTable() async {
  //   var res = await db.ofFetchAll();
  //   rows = res;
  //   print(rows);
  // }

  _initDir() async {
    if (null == _dir) {
      _dir = (await getApplicationDocumentsDirectory()).path;
      print(_dir);
    }
  }

  load() {
    GlobalVariables.statusCaption = 'Creating/Updating Database...';
    GlobalVariables.spinProgress = 0;

    if (loadSpinkit == true) {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => LoadingSpinkit());
    }
    // GlobalVariables.viewPolicy = true;
  }

  unloadSpinkit() async {
    loadSpinkit = false;
    print('Unload Spinkit');
    setState(() {
      GlobalVariables.tableProcessing = 'Unloading Spinkit . . .';
    });

    Navigator.pop(context);
    // viewSampleTable();
    // updateItemImage();
  }

  checkStatus() async {
    var stat = await db.checkStat();
    if (!mounted) return;
    setState(() {
      if (stat == 'Connected') {
        // print('CONNECTED!');
        NetworkData.connected = true;

        NetworkData.errorMsgShow = false;
        // upload();
        NetworkData.errorMsg = '';
        // print('Connected to Internet!');
      } else {
        if (stat == 'ERROR1') {
          NetworkData.connected = false;
          NetworkData.errorMsgShow = true;
          NetworkData.errorNo = '1';
          // print('Network Error...');
        }
        if (stat == 'ERROR2') {
          NetworkData.connected = false;
          NetworkData.errorMsgShow = true;
          NetworkData.errorNo = '2';
          // print('Connection to API Error...');
        }
        if (stat == 'ERROR3') {
          NetworkData.connected = false;
          NetworkData.errorMsgShow = true;
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
      if (stat == '' || stat == null) {
        print('Checking Status');
      } else {
        itemImage();
      }
    });
  }

  itemImage() async {
    processing = true;
    //ITEM IMAGE (ONLY WITH IMAGE)
    var itmImg = await db.ofFetchItemImgList();
    itemImgList = itmImg;
    if (itemImgList.isEmpty) {
      var rsp = await db.getItemImgList();
      itemImgList = rsp;
      // _asyncmethod(); //PA SAVE SA IMAGE ONLINE TO FILE
      // _downloadZip(UrlAddress.itemImg + 'img.zip', 'img.zip');
      _downloadZip();
    } else {
      print('Image Already downloaded in phone.');
      processing = false;
      checkEmpty();
    }
  }

  // Future<void> _downloadZip(String _zipPath, String _localZipFileName) async {
  Future<void> _downloadZip() async {
    setState(() {
      // _downloading = true;
      print('Downloading Images');
      GlobalVariables.statusCaption = 'Downloading Images...';
    });

    _images.clear();
    _tempImages.clear();

    var zippedFile = await _downloadFile(_zipPath, _localZipFileName);
    await unarchiveAndSave(zippedFile);

    setState(() {
      _images.addAll(_tempImages);
      // _downloading = false;
      print('Download Completed!');
      GlobalVariables.statusCaption = 'Download Completed!';
      checkEmpty();
    });
  }

  Future<File> _downloadFile(String url, String fileName) async {
    var req = await retry(() => http.Client().get(Uri.parse(url)));
    var file = File('$_dir/$fileName');
    return file.writeAsBytes(req.bodyBytes);
  }

  unarchiveAndSave(var zippedFile) async {
    print('NAHUMAN NAG DOWNLOAD');
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
      var fileName = '$_dir/${file.name}';
      if (file.isFile) {
        var outFile = File(fileName);
        //print('File:: ' + outFile.path);
        _tempImages.add(outFile.path);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
  }

  downloadSalesmanImage() {
    int x = 1;
    // imgLoad = true;
    // print(
    //     'ITEM IMAGE LENGTH ------------->' + (salesmanList.length).toString());
    salesmanList.forEach((element) async {
      var url = Uri.parse(UrlAddress.userImg + element['img']); // <-- 1
      var response = await get(url); // <--2
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = documentDirectory.path + '/images/user/';
      var filePathAndName =
          documentDirectory.path + '/images/user/' + element['img'];
      // print(filePathAndName);
      //comment out the next three lines to prevent the image from being saved
      //to the device to show that it's coming from the internet
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName); // <-- 2
      file2.writeAsBytesSync(response.bodyBytes);
      // setState(() {
      //   imageData = filePathAndName;
      //   dataLoaded = true;
      // });
      if (x == salesmanList.length) {
        processing = false;
        print('Salesman Images Saved to File...');
        loadHepe();
      } else {
        // print(x);
        x++;
      }
    });
  }

  downloadHepeImage() {
    int x = 1;
    // imgLoad = true;
    // print(
    //     'ITEM IMAGE LENGTH ------------->' + (salesmanList.length).toString());
    hepeList.forEach((element) async {
      var url = Uri.parse(UrlAddress.userImg + element['img']); // <-- 1
      var response = await get(url); // <--2
      var documentDirectory = await getApplicationDocumentsDirectory();
      var firstPath = documentDirectory.path + '/images/user/';
      var filePathAndName =
          documentDirectory.path + '/images/user/' + element['img'];
      // print(filePathAndName);
      //comment out the next three lines to prevent the image from being saved
      //to the device to show that it's coming from the internet
      await Directory(firstPath).create(recursive: true); // <-- 1
      File file2 = new File(filePathAndName); // <-- 2
      file2.writeAsBytesSync(response.bodyBytes);
      // setState(() {
      //   imageData = filePathAndName;
      //   dataLoaded = true;
      // });
      if (x == hepeList.length) {
        processing = false;
        print('Hepe Images Saved to File...');
        loadCustomer();
      } else {
        // print(x);
        x++;
      }
    });
  }

  checkEmpty() async {
    //SALESMAN
    var sm = await db.ofFetchSalesmanList();
    salesmanList = sm;
    if (salesmanList.isEmpty) {
      var rsp = await db.getSalesmanList();
      salesmanList = rsp;
      // print(salesmanList);
      await db.insertSalesmanList(salesmanList);
      await db.addUpdateTable('salesman_lists ', 'SALESMAN', date.toString());
      print('Salesman List Created');

      setState(() {
        GlobalVariables.processList.add('Salesman List Created');
        GlobalVariables.statusCaption = 'SalesmanList Created';
      });
      loadHepe();
    } else {
      String updateType = 'Salesman';
      if (NetworkData.connected == true) {
        // print('NISUD SA CONNECTED!!');
        var resp = await db.getSalesmanList();
        if (!mounted) return;
        setState(() {
          salesmanList = resp;
          // print(salesmanList);
          int y = 1;
          salesmanList.forEach((element) async {
            if (y < salesmanList.length) {
              // print(salesmanList.length);
              y++;
              if (y == salesmanList.length) {
                await db.deleteTable('salesman_lists');
                await db.insertTable(salesmanList, 'salesman_lists');
                await db.updateTable('salesman_lists ', date.toString());
                await db.addUpdateTableLog(date.toString(),
                    'Salesman Masterfile', 'Completed', updateType);
                print('Salesman List Updated');
                GlobalVariables.updateSpinkit = true;
                downloadSalesmanImage();
                // loadHepe();
              }
            }
          });
        });
      } else {
        print('NIDERETSO!!');
        loadHepe();
      }
    }
  }

// //CATEGORY
//   loadCategory() async {
//     var ctg = await db.ofFetchCategList();
//     categList = ctg;
//     if (categList.isEmpty) {
//       var rsp = await db.getCategList();
//       categList = rsp;
//       int x = 1;
//       categList.forEach((element) async {
//         if (x < categList.length) {
//           final imgBase64Str = await networkImageToBase64(
//               UrlAddress.categImg + element['category_image']);
//           setState(() {
//             element['category_image'] = imgBase64Str;
//             // print('CONVERTING.....');
//           });
//           x++;
//           if (x == categList.length) {
//             // print(categList.length);
//             await db.insertCategList(categList);
//             await db.addUpdateTable(
//                 'tbl_category_masterfile', 'ITEM', date.toString());
//             await db.addUpdateTable(
//                 'tb_tran_head', 'TRANSACTIONS', date.toString());
//             await db.addUpdateTable(
//                 'tb_tran_line', 'TRANSACTIONS', date.toString());
//             await db.addUpdateTable(
//                 'tb_unserved_items', 'TRANSACTIONS', date.toString());
//             await db.addUpdateTable(
//                 'tb_returned_tran', 'TRANSACTIONS', date.toString());
//             print('Categ List Created');
//             GlobalVariables.tableProcessing = 'Categ List Created';
//             unloadSpinkit();
//           }
//         }
//       });
//     } else {
//       setState(() {
//         unloadSpinkit();
//       });
//     }
//   }

//CATEGORY
  loadCategory() async {
    var ctg = await db.ofFetchCategList();
    categList = ctg;
    if (categList.isEmpty) {
      var rsp = await db.getCategList();
      categList = rsp;
      int x = 1;
      categList.forEach((element) async {
        if (x < categList.length) {
          x++;
          if (x == categList.length) {
            // print(categList.length);
            await db.insertCategList(categList);
            await db.addUpdateTable(
                'tbl_category_masterfile', 'ITEM', date.toString());
            await db.addUpdateTable(
                'tb_tran_head', 'TRANSACTIONS', date.toString());
            await db.addUpdateTable(
                'tb_tran_line', 'TRANSACTIONS', date.toString());
            await db.addUpdateTable(
                'tb_unserved_items', 'TRANSACTIONS', date.toString());
            await db.addUpdateTable(
                'tb_returned_tran', 'TRANSACTIONS', date.toString());
            print('Categ List Created');
            setState(() {
              GlobalVariables.statusCaption = 'Category List Created';
            });

            unloadSpinkit();
          }
        }
      });
    } else {
      setState(() {
        unloadSpinkit();
      });
    }
  }

  //ITEM IMAGE (ALL IMAGE PATH)
  loadItemImgPath() async {
    var itmImg = await db.ofFetchItemImgList();
    itemAllImgList = itmImg;
    if (itemAllImgList.isEmpty) {
      var rsp = await db.getAllItemImgList();
      itemAllImgList = rsp;
      await db.insertItemImgList(itemAllImgList);
      await db.addUpdateTable('tbl_item_image   ', 'ITEM', date.toString());
      print('All Item Image List Created');
      GlobalVariables.tableProcessing = 'All Item Image List Created';
      setState(() {
        GlobalVariables.statusCaption = 'All Item Image List Created!';
      });
      loadCategory();
    } else {
      loadCategory();
    }
  }

//ITEM MASTERFILE
  loadItemMasterfile() async {
    var itm = await db.ofFetchItemList();
    itemList = itm;
    if (itemList.isEmpty) {
      var rsp = await db.getItemList();
      itemList = rsp;
      await db.insertItemList(itemList);
      await db.addUpdateTable('item_masterfiles ', 'ITEM', date.toString());
      print('Item Masterfile Created');
      GlobalVariables.tableProcessing = 'Item Masterfile Created';
      setState(() {
        GlobalVariables.statusCaption = 'Item Masterfile Created!';
      });
      loadItemImgPath();
    } else {
      loadItemImgPath();
    }
  }

//BANK LIST
  loadBankList() async {
    var blist = await db.ofFetchBankList();
    bankList = blist;
    // print(bankList);
    if (bankList.isEmpty) {
      var resp = await db.getBankListonLine();
      bankList = resp;
      int x = 1;
      bankList.forEach((element) async {
        if (x < bankList.length) {
          x++;
          if (x == bankList.length) {
            await db.insertBankList(bankList);
            await db.addUpdateTable(
                'tb_bank_list', 'CUSTOMER', date.toString());
            print('Bank List Created');
            GlobalVariables.tableProcessing = 'Bank List Created';
            setState(() {
              GlobalVariables.statusCaption = 'Bank List Created';
            });
            loadItemMasterfile();
          }
        }
      });
    } else {
      loadItemMasterfile();
    }
  }

  //SALES TYPE LIST
  loadSalesType() async {
    var stlist = await db.ofSalesTypeList();
    salestypeList = stlist;
    if (salestypeList.isEmpty) {
      var resp = await db.getSalesTypeListonLine();
      salestypeList = resp;
      int x = 1;
      salestypeList.forEach((element) async {
        if (x < salestypeList.length) {
          x++;
          if (x == salestypeList.length) {
            await db.insertSalesTypeList(salestypeList);
            await db.addUpdateTable(
                'tb_sales_type', 'CUSTOMER', date.toString());
            print('Sales Type List Created');
            GlobalVariables.tableProcessing = 'Sales Type List Created';
            setState(() {
              GlobalVariables.statusCaption = 'Sales Type List Created!';
            });
            loadBankList();
          }
        }
      });
    } else {
      loadBankList();
    }
  }

  //CUSTOMER_DISCOUNT
  loadCustomerDiscount() async {
    var disc = await db.ofFetchDiscountList();
    discountList = disc;
    if (discountList.isEmpty) {
      var resp = await db.getDiscountList();
      discountList = resp;
      int x = 1;
      discountList.forEach((element) async {
        if (x < discountList.length) {
          x++;
          if (x == discountList.length) {
            await db.insertDiscountList(discountList);
            await db.addUpdateTable(
                'tbl_discounts', 'CUSTOMER', date.toString());
            print('Discount List Created');
            GlobalVariables.tableProcessing = 'Discount List Created';
            setState(() {
              GlobalVariables.statusCaption = 'Discount List Created';
            });
            loadSalesType();
          }
        }
      });
    } else {
      loadSalesType();
    }
  }

  //CUSTOMER
  loadCustomer() async {
    var cust = await db.ofFetchCustomerList();
    customerList = cust;
    if (customerList.isEmpty) {
      var resp = await db.getCustomersList();
      customerList = resp;
      int x = 1;
      customerList.forEach((element) async {
        if (x < customerList.length) {
          x++;
          if (x == customerList.length) {
            await db.insertCustomersList(customerList);
            await db.addUpdateTable(
                'customer_master_files ', 'CUSTOMER', date.toString());
            print('Customer List Created');
            GlobalVariables.tableProcessing = 'Customer List Created';
            setState(() {
              GlobalVariables.statusCaption = 'Customer List Created!';
            });
            loadCustomerDiscount();
          }
        }
      });
    } else {
      loadCustomerDiscount();
    }
  }

  loadHepe() async {
    var hepe = await db.ofFetchHepeList();
    hepeList = hepe;
    if (hepeList.isEmpty) {
      var rsp = await db.getHepeList();
      hepeList = rsp;
      int x = 1;
      hepeList.forEach((element) async {
        if (x < hepeList.length) {
          x++;
          if (x == hepeList.length) {
            await db.insertHepeList(hepeList);
            await db.addUpdateTable(
                'tbl_hepe_de_viaje', 'SALESMAN', date.toString());
            print('Hepe List Created.');
            setState(() {
              GlobalVariables.processList.add('Salesman List Created');
              GlobalVariables.statusCaption = 'Hepe List Created';
            });
            GlobalVariables.tableProcessing = 'Hepe List Created';
            loadCustomer();
          }
        }
      });
    } else {
      // String updateType = 'Jefe';
      if (NetworkData.connected) {
        var rsp = await db.getHepeList();
        hepeList = rsp;
        int x = 1;
        hepeList.forEach((element) async {
          if (x < hepeList.length) {
            x++;
            if (x == hepeList.length) {
              await db.deleteTable('tbl_hepe_de_viaje');
              await db.insertTable(hepeList, 'tbl_hepe_de_viaje');
              await db.updateTable('tbl_hepe_de_viaje', date.toString());
              print('Hepe List Updated');
              downloadHepeImage();
            }
          }
        });
      } else {
        loadCustomer();
      }
      // loadCustomer();
    }
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    var imgUri = Uri.parse(imageUrl);
    http.Response response = await http.get(imgUri);
    final bytes = response?.bodyBytes;
    return (bytes != null ? base64Encode(bytes) : null);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetsValues.wallImg,
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2 - 50,
                  child: Card(
                      // elevation: 10,
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                'SELECT TO LOGIN AS',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SalesmanLoginPage();
                        }));
                        // sampleUpdate();
                        // viewSampleTable();
                        // print(itemImgList);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        height: 130,
                        // color: Colors.grey,
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    height: 80,
                                    child: Image(image: AssetsValues.smImg)),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width -
                                      20 / 2,
                                  child: Card(
                                      // elevation: 10,
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Salesman',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return MyLoginPage();
                        }));
                        // viewSampleTable();
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 50,
                        height: 130,
                        // height: MediaQuery.of(context).size.width / 2 - 50,
                        // color: Colors.grey,
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    height: 80,
                                    child: Image(image: AssetsValues.hepeImg)),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width -
                                      20 / 2,
                                  child: Card(
                                      // elevation: 10,
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text('Jefe de Viaje',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              )),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: MediaQuery.of(context).size.width,
              // height: 30,
              // color: Colors.grey,
              child: Text(
                AppData.appName + AppData.appYear,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      )),
    );
  }
}

class LoadingSpinkit extends StatefulWidget {
  @override
  _LoadingSpinkitState createState() => _LoadingSpinkitState();
}

class _LoadingSpinkitState extends State<LoadingSpinkit> {
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
                Text(
                  GlobalVariables.statusCaption,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                ),
                SpinKitCircle(
                  color: ColorsTheme.mainColor,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
      ],
    );
  }
}
