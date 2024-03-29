import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
// import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
// import 'package:http/http.dart' show Client, Request, get;
import 'package:retry/retry.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/login.dart';
import 'package:salesman/providers/caption_provider.dart';
import 'package:salesman/salesman_home/login.dart';
import 'package:salesman/url/url.dart';
import 'package:http/http.dart' as http;
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/assets.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/custom_modals.dart';
import 'package:salesman/widgets/dialogs.dart';
import 'package:salesman/widgets/size_config.dart';
// import 'package:salesman/widgets/snackbar.dart';

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
  List orderLimitList = [];
  List accessList = [];

  String? imageData;

  bool dataLoaded = false;
  bool processing = false;

  final db = DatabaseHelper();

  bool loadSpinkit = true;
  bool imgLoad = true;

  String? _dir;
  List<String>? _images, _tempImages;
  String _zipPath = UrlAddress.itemImg + 'img.zip';
  String _localZipFileName = 'img.zip';

  // final date = DateTime.parse(DateFormat("y-M-d").format(new DateTime.now()));

  String date = DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());

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
    // _images = List();
    _images = [];
    // _tempImages = List();
    _tempImages = [];
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
    // GlobalVariables.statusCaption = 'Creating/Updating Database...';
    // context.read().changeCap('Creating/Updating Database...');
    Provider.of<Caption>(context, listen: false)
        .changeCap('Creating/Updating Database...');
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
    Provider.of<Caption>(context, listen: false)
        .changeCap('Checking Connection...');
    var stat = await db.checkStat();
    if (!mounted) return;
    setState(() {
      print(stat);
      if (stat == 'Connected') {
        NetworkData.connected = true;
        NetworkData.errorMsgShow = false;
        NetworkData.errorMsg = '';
      } else {
        NetworkData.connected = false;
      }
      if (stat == '' || stat == null) {
        print('Checking Status');
        unloadSpinkit();
      } else {
        // itemImage(); // OLD PROCESS
        setState(() {
          checkEmpty();
        });
      }
    });
  }

  itemImage() async {
    processing = true;
    //ITEM IMAGE (ONLY WITH IMAGE)
    var itmImg = await db.ofFetchItemImgList();
    itemImgList = itmImg;
    if (itemImgList.isEmpty) {
      var rsp = await db.getItemImgList(context);
      itemImgList = rsp;
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
      Provider.of<Caption>(context, listen: false)
          .changeCap('Downloading Images...');
    });

    _images!.clear();
    _tempImages!.clear();

    var zippedFile = await _downloadFile(_zipPath, _localZipFileName);
    await unarchiveAndSave(zippedFile);

    setState(() {
      _images!.addAll(_tempImages!);
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
        _tempImages!.add(outFile.path);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
  }

  downloadSalesmanImage() {
    Provider.of<Caption>(context, listen: false)
        .changeCap('Downloading Salesman Images...');
    int x = 1;
    salesmanList.forEach((element) async {
      try {
        var url = Uri.parse(UrlAddress.userImg + element['img']); // <-- 1
        var response = await get(url); // <--2
        if (response.statusCode == 200) {
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
          if (x == salesmanList.length) {
            processing = false;
            print('Salesman Images Saved to File...');
            loadHepe();
          } else {
            x++;
          }
        } else if (response.statusCode >= 400 || response.statusCode <= 499) {
          customModal(
              context,
              Icon(CupertinoIcons.exclamationmark_circle,
                  size: 50, color: Colors.red),
              Text(
                  "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                  textAlign: TextAlign.center),
              true,
              Icon(
                CupertinoIcons.checkmark_alt,
                size: 25,
                color: Colors.greenAccent,
              ),
              '',
              () {});
        } else if (response.statusCode >= 500 || response.statusCode <= 599) {
          customModal(
              context,
              Icon(CupertinoIcons.exclamationmark_circle,
                  size: 50, color: Colors.red),
              Text("Error: ${response.statusCode}. Internal server error.",
                  textAlign: TextAlign.center),
              true,
              Icon(
                CupertinoIcons.checkmark_alt,
                size: 25,
                color: Colors.greenAccent,
              ),
              '',
              () {});
        }
      } on TimeoutException {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Connection timed out. Please check internet connection or proxy server configurations.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            'Okay',
            () {});
      } on SocketException {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Connection timed out. Please check internet connection or proxy server configurations.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            'Okay',
            () {});
      } on HttpException {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("An HTTP error eccured. Please try again later.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            'Okay',
            () {});
      } on FormatException {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Format exception error occured. Please try again later.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            'Okay',
            () {});
      }
    });
  }

  downloadHepeImage() {
    Provider.of<Caption>(context, listen: false)
        .changeCap('Downloading Hepe Images...');
    int x = 1;
    hepeList.forEach((element) async {
      try {
        var url = Uri.parse(UrlAddress.userImg + element['img']); // <-- 1
        var response = await get(url); // <--2
        if (response.statusCode == 200) {
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
          if (x == hepeList.length) {
            processing = false;
            print('Hepe Images Saved to File...');
            loadCustomer();
          } else {
            x++;
          }
        } else if (response.statusCode >= 400 || response.statusCode <= 499) {
          customModal(
              context,
              Icon(CupertinoIcons.exclamationmark_circle,
                  size: 50, color: Colors.red),
              Text(
                  "Error: ${response.statusCode}. Your client has issued a malformed or illegal request.",
                  textAlign: TextAlign.center),
              true,
              Icon(
                CupertinoIcons.checkmark_alt,
                size: 25,
                color: Colors.greenAccent,
              ),
              '',
              () {});
        } else if (response.statusCode >= 500 || response.statusCode <= 599) {
          customModal(
              context,
              Icon(CupertinoIcons.exclamationmark_circle,
                  size: 50, color: Colors.red),
              Text("Error: ${response.statusCode}. Internal server error.",
                  textAlign: TextAlign.center),
              true,
              Icon(
                CupertinoIcons.checkmark_alt,
                size: 25,
                color: Colors.greenAccent,
              ),
              '',
              () {});
        }
      } on TimeoutException {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Connection timed out. Please check internet connection or proxy server configurations.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            'Okay',
            () {});
      } on SocketException {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text(
                "Connection timed out. Please check internet connection or proxy server configurations.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            'Okay',
            () {});
      } on HttpException {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("An HTTP error eccured. Please try again later.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            'Okay',
            () {});
      } on FormatException {
        customModal(
            context,
            Icon(CupertinoIcons.exclamationmark_circle,
                size: 50, color: Colors.red),
            Text("Format exception error occured. Please try again later.",
                textAlign: TextAlign.center),
            true,
            Icon(
              CupertinoIcons.checkmark_alt,
              size: 25,
              color: Colors.greenAccent,
            ),
            'Okay',
            () {});
      }
    });
  }

  checkEmpty() async {
    //SALESMAN
    var sm = await db.ofFetchSalesmanList();
    salesmanList = sm;
    // salesmanList = json.decode(json.encode(sm));
    if (salesmanList.isEmpty) {
      // context.read().changeCap('Creating Salesman List...');
      Provider.of<Caption>(context, listen: false)
          .changeCap('Creating Salesman List...');
      var rsp = await db.getSalesmanList(context);
      salesmanList = rsp;
      print(salesmanList);
      await db.insertSalesmanList(salesmanList);
      await db.addUpdateTable('salesman_lists ', 'SALESMAN', date.toString());
      print('Salesman List Created');
      loadHepe();
    } else {
      if (NetworkData.connected == true) {
        final action = await Dialogs.openDialog(
            context,
            'Confirmation',
            'Update data? It may take a while please secure a stable connection.',
            false,
            'No',
            'Yes');
        if (action == DialogAction.yes) {
          // context.read().changeCap('Updating Salesman List...');
          Provider.of<Caption>(context, listen: false)
              .changeCap('Updating Order Limit...');
          String updateType = 'Salesman';
          // if (NetworkData.connected == true) {
          // print('NISUD SA CONNECTED!!');
          var resp = await db.getOrderLimitonLine(context);
          if (!mounted) return;
          setState(() {
            orderLimitList = resp;
            // print(salesmanList);
            int y = 1;
            orderLimitList.forEach((element) async {
              if (y < orderLimitList.length) {
                // print(salesmanList.length);
                y++;
                if (y == orderLimitList.length) {
                  await db.deleteTable('tbl_order_limit');
                  await db.insertTable(orderLimitList, 'tbl_order_limit');
                  await db.updateTable('tbl_order_limit ', date.toString());
                  await db.addUpdateTableLog(date.toString(),
                      'Salesman Masterfile', 'Completed', updateType);
                  print('Oder Limit Updated');
                  GlobalVariables.updateSpinkit = true;
                  loadSalesman();
                  // loadHepe();
                }
              }
            });
          });
        } else {
          Provider.of<Caption>(context, listen: false)
              .changeCap('Updated Successfuly!');
          unloadSpinkit();
        }
      } else {
        unloadSpinkit();
      }
    }
  }

  loadSalesman() async {
    Provider.of<Caption>(context, listen: false)
        .changeCap('Updating Salesman List...');
    String updateType = 'Salesman';
    var resp = await db.getSalesmanList(context);
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
            await db.addUpdateTableLog(date.toString(), 'Salesman Masterfile',
                'Completed', updateType);
            print('Salesman List Updated');
            GlobalVariables.updateSpinkit = true;
            downloadSalesmanImage();
            // loadHepe();
          }
        }
      });
    });
  }

//CATEGORY
  loadCategory() async {
    var ctg = await db.ofFetchCategList();
    categList = ctg;
    if (categList.isEmpty) {
      // context.read().changeCap('Creating Category...');
      Provider.of<Caption>(context, listen: false)
          .changeCap('Creating Categories...');
      var rsp = await db.getCategList(context);
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
            Provider.of<Caption>(context, listen: false)
                .changeCap('All Database Created Successfuly!');
            unloadSpinkit();
          }
        }
      });
    } else {
      Provider.of<Caption>(context, listen: false)
          .changeCap('All Database Created Successfuly!');
      setState(() {
        unloadSpinkit();
      });
    }
  }

  //ITEM IMAGE (ALL IMAGE PATH)
  loadItemImgPath() async {
    // context.read().changeCap('Creating Image Path...');
    Provider.of<Caption>(context, listen: false)
        .changeCap('Creating Image Path...');
    var itmImg = await db.ofFetchItemImgList();
    itemAllImgList = itmImg;
    if (itemAllImgList.isEmpty) {
      var rsp = await db.getAllItemImgList(context);
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
    // context.read().changeCap('Creating Item Masterfile...');
    Provider.of<Caption>(context, listen: false)
        .changeCap('Creating Item Masterfile...');
    var itm = await db.ofFetchItemList();
    itemList = itm;
    if (itemList.isEmpty) {
      var rsp = await db.getItemList(context);
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
    // context.read().changeCap('Creating Bank List...');
    Provider.of<Caption>(context, listen: false)
        .changeCap('Creating Bank List...');
    var blist = await db.ofFetchBankList();
    bankList = blist;
    // print(bankList);
    if (bankList.isEmpty) {
      var resp = await db.getBankListonLine(context);
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
            loadOrderLimit();
            // loadItemMasterfile();
          }
        }
      });
    } else {
      loadOrderLimit();
      // loadItemMasterfile();

    }
  }

  //BANK LIST
  loadOrderLimit() async {
    // context.read().changeCap('Creating Bank List...');
    Provider.of<Caption>(context, listen: false)
        .changeCap('Creating Oder Limit...');
    var ollist = await db.ofFetchOrderLimit();
    orderLimitList = ollist;
    // print(bankList);
    if (orderLimitList.isEmpty) {
      var resp = await db.getOrderLimitonLine(context);
      orderLimitList = resp;
      int x = 1;
      orderLimitList.forEach((element) async {
        if (x < orderLimitList.length) {
          x++;
          if (x == orderLimitList.length) {
            await db.insertOrderLimitList(orderLimitList);
            await db.addUpdateTable(
                'tbl_order_limit', 'SALESMAN', date.toString());
            print('Order Limit Created');
            GlobalVariables.tableProcessing = 'Order Limit Created';
            setState(() {
              GlobalVariables.statusCaption = 'Order Limit Created';
            });
            // loadUserAccess();
            loadItemMasterfile();
          }
        }
      });
    } else {
      loadItemMasterfile();
      // loadUserAccess();
    }
  }

  loadUserAccess() async {
    // context.read().changeCap('Creating Bank List...');
    Provider.of<Caption>(context, listen: false)
        .changeCap('Creating User Access...');
    var ulist = await db.ofFetchUserAccess();
    accessList = ulist;
    // print(bankList);
    if (accessList.isEmpty) {
      var resp = await db.getUserAccessonLine(context);
      accessList = resp;
      int x = 1;
      accessList.forEach((element) async {
        if (x < accessList.length) {
          x++;
          if (x == accessList.length) {
            await db.insertAccessList(accessList);
            await db.addUpdateTable('user_access', 'CUSTOMER', date.toString());
            print('User Access Created');
            GlobalVariables.tableProcessing = 'User Access Created';
            setState(() {
              GlobalVariables.statusCaption = 'User Access Created';
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
    // context.read().changeCap('Creating Sales Type...');
    Provider.of<Caption>(context, listen: false)
        .changeCap('Creating Sales Type...');
    var stlist = await db.ofSalesTypeList();
    salestypeList = stlist;
    if (salestypeList.isEmpty) {
      var resp = await db.getSalesTypeListonLine(context);
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
    Provider.of<Caption>(context, listen: false)
        .changeCap('Creating Customer Discount...');
    var disc = await db.ofFetchDiscountList();
    discountList = disc;
    if (discountList.isEmpty) {
      var resp = await db.getDiscountList(context);
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
    Provider.of<Caption>(context, listen: false)
        .changeCap('Creating Customer List...');
    var cust = await db.ofFetchCustomerList();
    customerList = cust;
    if (customerList.isEmpty) {
      var resp = await db.getCustomersList(context);
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
      Provider.of<Caption>(context, listen: false)
          .changeCap('Creating Hepe List...');
      var rsp = await db.getHepeList(context);
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
        Provider.of<Caption>(context, listen: false)
            .changeCap('Updating Hepe List...');
        var rsp = await db.getHepeList(context);
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
    }
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    var imgUri = Uri.parse(imageUrl);
    http.Response response = await http.get(imgUri);
    final bytes = response.bodyBytes;
    return (base64Encode(bytes));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    ScreenData.scrWidth = screenWidth;
    ScreenData.scrHeight = screenHeight;
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
                  width: 40 * SizeConfig.imageSizeMultiplier,
                  child: Card(
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
                      },
                      child: Container(
                        width: ScreenData.scrWidth * .3,
                        height: ScreenData.scrHeight * .19,
                        // color: Colors.grey,
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                    width: ScreenData.scrWidth * .3,
                                    height: ScreenData.scrHeight * .09,
                                    child: Image(image: AssetsValues.smImg)),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  width: ScreenData.scrWidth * .3,
                                  // height: ScreenData.scrHeight * .09,
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
                                                  fontSize: 10,
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
                      },
                      child: Container(
                        width: ScreenData.scrWidth * .3,
                        height: ScreenData.scrHeight * .19,
                        decoration: BoxDecoration(
                            border: Border.all(width: 3, color: Colors.white),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                    width: ScreenData.scrWidth * .3,
                                    height: ScreenData.scrHeight * .09,
                                    child: Image(image: AssetsValues.hepeImg)),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: ScreenData.scrWidth * .3,
                                  child: Card(
                                      color: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text('Jefe de Viaje',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
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
        child: loadingContent(context),
      ),
    );
  }

  loadingContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(top: 50, bottom: 16, right: 5, left: 5),
            margin: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                  ),
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  // Provider.of<Caption>(context).cap,
                  context.watch<Caption>().cap,
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
