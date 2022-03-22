import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/dialogs/confirmupload.dart';
import 'package:salesman/dialogs/syncloading.dart';
import 'package:salesman/dialogs/syncsuccess.dart';
import 'package:salesman/dialogs/uploadloading.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/url/url.dart';
import 'package:http/http.dart' as http;
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/elevated_button.dart';
import 'package:salesman/widgets/snackbar.dart';

class SyncHepe extends StatefulWidget {
  @override
  _SyncHepeState createState() => _SyncHepeState();
}

class _SyncHepeState extends State<SyncHepe> {
  bool viewSpinkit = true;
  bool uploadPressed = true;
  bool downloadPressed = false;
  bool errorMsgShow = true;
  bool uploading = false;

  bool upTrans = false;
  bool upItem = false;
  bool upCust = false;
  bool upSm = false;

  String transLastUp = '';
  String itemLastUp = '';
  String custLastUp = '';
  String smLastUp = '';

  String amount = "";

  String err1 = 'No Internet Connection';
  String err2 = 'No Connection to Server';
  String err3 = 'API Error';
  String errorMsg = '';

  final db = DatabaseHelper();

  // final String today =
  //     DateFormat("y-M-d 00:00:00.000").format(new DateTime.now());

  final String today = DateFormat("yyyy-MM-dd").format(new DateTime.now());

  Timer? timer;

  final formatCurrencyTot =
      new NumberFormat.currency(locale: "en_US", symbol: "Php ");

  List _toList = [];
  // List _smList = [];
  // List _sList = [];
  List _upList = [];

  List _updateLog = [];

  void initState() {
    GlobalVariables.updateSpinkit = false;
    GlobalVariables.uploadSpinkit = false;
    GlobalVariables.upload = false;
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => checkStatus());
    super.initState();
    checkStatus();
  }

  checkUpdates() async {
    String dtime = '';
    var rsp = await db.ofFetchUpdatesTables();
    _upList = rsp;
    // print(_upList);
    _upList.forEach((element) {
      DateTime a = DateTime.parse(element['date']);
      dtime = DateFormat("yyyy-MM-dd").format(a);

      if (element['tb_categ'] == 'TRANSACTIONS') {
        if (dtime == today) {
          upTrans = true;
        } else {
          upTrans = false;
        }
        DateTime x = DateTime.parse(element['date']);
        transLastUp = DateFormat.yMMMd().format(x);
      }
      if (element['tb_categ'] == 'ITEM') {
        if (dtime == today) {
          upItem = true;
        } else {
          upItem = false;
        }
        DateTime x = DateTime.parse(element['date'].toString());
        itemLastUp = DateFormat("MMM. d, y").format(x);
      }
      if (element['tb_categ'] == 'CUSTOMER') {
        if (dtime == today) {
          upCust = true;
        } else {
          upCust = false;
        }
        DateTime x = DateTime.parse(element['date'].toString());
        custLastUp = DateFormat("MMM. d, y").format(x);
      }
      if (element['tb_categ'] == 'SALESMAN') {
        if (dtime == today) {
          upSm = true;
        } else {
          upSm = false;
        }
        DateTime x = DateTime.parse(element['date'].toString());
        smLastUp = DateFormat("MMM. d, y").format(x);
      }
    });
  }

  upload() async {
    GlobalVariables.upload = false;
    // String tmpTranNo = '';
    // String tranNo = '';
    // String pmeth = '';
    // String lineRsp = '';
    List _chequeList = [];
    // List _retList = [];
    // List _unsrvdList = [];
    // List _tempList = [];
    int z = 0;
    int listLength = 0;
    if (NetworkData.errorMsgShow == false &&
        uploading == false &&
        !GlobalVariables.uploaded) {
      listLength = _toList.length;
      _toList.forEach((element) async {
        uploading = true;
        //KUNG NA DELIVER
        print(element['tran_no']);
        var tmpTranLine = await db.getTransactionLine(element['tran_no']);
        //pagkuha sa list sa unserved sa sqflite
        var tmpretLine = await db.getReturnedLine(element['tran_no']);

        //KUNG CHEQUE IYANG MODE OF PAYMENT
        if (element['pmeth_type'] == 'CHEQUE') {
          var tmpchq = await db.getChequeData(element['tran_no']);
          _chequeList = tmpchq;
          if (_chequeList.isNotEmpty) {
            _chequeList.forEach((element) async {
              //PA SAVE SA CHEQUE DATA SA SERVER
              await db.setChequeData(
                  element['tran_no'],
                  element['account_code'],
                  element['sm_code'],
                  element['hepe_code'],
                  element['datetime'],
                  element['payee_name'],
                  element['payor_name'],
                  element['bank_name'],
                  element['cheque_no'],
                  element['branch_code'],
                  element['account_no'],
                  element['cheque_date'],
                  element['amount'],
                  element['status'],
                  element['image']);
              // print(lrsp);
            });
          }
        }

        if (element['tran_stat'] == 'Delivered' &&
            element['hepe_upload'] != 'TRUE') {
          print('NISUD SA DELIVERED');
          var rsp = await db.updateDeliveredTranStat(
              element['tran_no'],
              element['tran_stat'],
              element['itm_del_count'],
              element['tot_del_amt'],
              element['date_del'],
              element['hepe_code'],
              element['pmeth_type'],
              element['signature'],
              tmpTranLine,
              tmpretLine);
          print('PRINT UPDATE TRAN SA SERVER RSP: ' + rsp.toString());

          if (rsp != 0) {
            var changestatrsp = await db.updateTranUploadStatHEPE(rsp);
            print('CHANGESTAT RETURN: ' + changestatrsp.toString());
            setState(() {
              if (changestatrsp == 1) {
                z++;
                print('STATUS CHANGED!!!');
                print('LIST LENGTH VALUE: ' + listLength.toString());
                print('Z VALUE:' + z.toString());
                if (z == listLength) {
                  setState(() {
                    uploading = false;
                    GlobalVariables.uploaded = true;
                    Navigator.pop(context);
                  });
                }
              }
            });
          }
        }
        //KUNG NA RETURN TBOOK TRANSACTION
        if (element['tran_stat'] == 'Returned' &&
            element['hepe_upload'] != 'TRUE') {
          // print(_tempList);
          print('NISUD SA RETURNED TANAN!');
          print(element['tran_no']);
          print(element['tran_stat']);

          var retTran = await db.getReturnedTran(element['tran_no']);
          var retLine = await db.getReturnedLine(element['tran_no']);

          var smp = await db.updateReturnedTranStat(
              element['tran_no'],
              element['tran_stat'],
              element['tot_del_amt'],
              element['date_del'],
              element['hepe_code'],
              element['signature'],
              retTran,
              retLine);
          print('PRINT UPDATE TRAN SA SERVER RETURNED RSP: ' + smp.toString());

          if (smp != 0) {
            var changestatrsp = await db.updateTranUploadStatHEPE(smp);
            print('CHANGESTAT RETURN: ' + changestatrsp.toString());
            setState(() {
              if (changestatrsp == 1) {
                z++;
                print('STATUS CHANGED!!!');
                print('LIST LENGTH VALUE: ' + listLength.toString());
                print('Z VALUE:' + z.toString());
                if (z == listLength) {
                  setState(() {
                    uploading = false;
                    GlobalVariables.uploaded = true;
                    Navigator.pop(context);
                  });
                }
              }
            });
          } else {
            print("FAILED");
          }

          // print(element['signature']);
          // var smp = await db.oldupdateTranStat(
          //     element['tran_no'],
          //     element['tran_stat'],
          //     " ",
          //     element['tot_del_amt'],
          //     element['date_del'],
          //     element['hepe_code'],
          //     " ",
          //     element['signature']);
          // print('UPDATING STATUS RETURN-------> ' + smp);
          // // tranNo = element['tran_no'];
          // z++;
          // //PARA SA RETURNED TRAN SA SERVER
          // var retTran = await db.getReturnedTran(element['tran_no']);
          // _retList = retTran;

          // if (_retList.isNotEmpty) {
          //   _retList.forEach((element) {
          //     db.setReturnStatus(
          //         element['tran_no'],
          //         element['date'],
          //         element['signature'],
          //         element['account_code'],
          //         element['store_name'],
          //         element['itm_count'],
          //         element['tot_amt'],
          //         element['hepe_code'],
          //         element['reason']);
          //   });
          // }
          // ////
          // ///
          // await db.updateTranUploadStatHEPE(element['tran_no']);
          // //pagkuha sa list sa unserved sa sqflite
          // var tmp = await db.getReturnedLine(element['tran_no']);
          // // _unsrvdList = tmp;
          // print('UNSERVED LIST:');
          // print(_unsrvdList);
          // if (_unsrvdList.isNotEmpty) {
          //   _unsrvdList.forEach((element) async {
          //     //PA SAVE SA UNSERVED SA SERVER
          //     var lrsp = await db.setReturnLineStatus(
          //         element['tran_no'],
          //         element['itm_code'],
          //         element['item_desc'],
          //         element['uom'],
          //         element['amt'],
          //         element['qty'],
          //         element['tot_amt'],
          //         element['itm_cat']);
          //     print(lrsp);
          //     if (lrsp != 'ERROR') {
          //       setState(() {
          //         uploading = false;
          //         if (z == _toList.length) {
          //           setState(() {
          //             GlobalVariables.uploaded = true;
          //           });
          //         }
          //       });
          //     }
          //   });
          // }
        }
      });
    }
  }

  loadForUpload() async {
    var getP = await db.ofFetchForUploadHepe(UserData.id);
    if (!mounted) return;
    setState(() {
      _toList = getP;
      // print(_toList);
      if (_toList.isEmpty) {
        uploading = false;
      } else {
        GlobalVariables.uploaded = false;
        GlobalVariables.uploadLength = _toList.length.toString();
      }
    });
  }

  checkSpinkit() {
    if (GlobalVariables.updateSpinkit == true) {
      Navigator.pop(context);
      GlobalVariables.updateSpinkit = false;

      print('SUCCESSFULLY UPDATED!');
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => UpdatedSuccessfully());
    }
  }

  loadUpdateLog() async {
    String updateType = 'Jefe';
    var rsp = await db.ofFetchUpdateLog(updateType);
    _updateLog = rsp;
  }

  checkStatus() async {
    loadForUpload();
    checkUpdates();
    checkSpinkit();
    loadUpdateLog();
    if (!mounted) return;
    // setState(() {
    //   if (NetworkData.connected == true) {
    //     upload();
    //   }
    // });

    // if (GlobalVariables.upload == true) {
    //   showDialog(
    //       barrierDismissible: false,
    //       context: context,
    //       builder: (context) => UploadingSpinkit());
    //   GlobalVariables.uploadSpinkit = true;
    //   await upload();
    // }

    if (GlobalVariables.upload == true) {
      if (NetworkData.uploaded == false && uploading == false) {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => UploadingSpinkit());
        GlobalVariables.uploadSpinkit = true;
        await upload();
      }
    }
  }

  uploadButtonclicked() async {
    if (NetworkData.connected == true) {
      if (NetworkData.uploaded == false) {
        showDialog(
            context: context,
            builder: (context) => ConfirmUpload(
                  // iconn: 59137,
                  title: 'Confirmation!',
                  description1: 'Are you sure you want to upload transactions?',
                  description2: 'Please secure stable internet connection.',
                ));
      }
    } else {
      // showDialog(
      //     context: context,
      //     builder: (context) => ErrorDialog(
      //           // iconn: 59137,
      //           title: 'Connection Problem!',
      //           description: 'Connection Problem.' + ' Try Again.',
      //           buttonText: 'Okay',
      //         ));
      showGlobalSnackbar('Connectivity', 'Please connect to internet.',
          Colors.red.shade900, Colors.white);
    }
  }

  void handleUserInteraction([_]) {
    // _initializeTimer();

    SessionTimer sessionTimer = SessionTimer();
    sessionTimer.initializeTimer(context);
  }

  @override
  void dispose() {
    timer?.cancel();
    print('Timer Disposed');
    super.dispose();
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
          toolbarHeight: ScreenData.scrHeight * .14,
          // toolbarHeight: 120,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Sync",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: ColorsTheme.mainColor,
                    fontSize: 45,
                    fontWeight: FontWeight.bold),
              ),
              // SizedBox(
              //   height: 10,
              // ),
              Visibility(
                  visible: NetworkData.errorMsgShow, child: buildStatusCont()),
              buildOrderOption(),
            ],
          ),
        ),
        body: uploadPressed ? buildUploadCont() : buildDownloadCont(),
        floatingActionButton: Visibility(
          visible: uploadPressed,
          child: Container(
            padding: EdgeInsets.only(left: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                onPressed: () {
                  if (_toList.isNotEmpty) {
                    uploadButtonclicked();
                  }
                },
                tooltip: 'Upload',
                child: Icon(Icons.file_upload),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildDownloadCont() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              // height: 250,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          // color: Colors.grey,
                          child: Stack(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      if (!NetworkData.errorMsgShow) {
                                        print('TRANSACTIONS CLICKED!');
                                        GlobalVariables.updateType =
                                            'Transactions';
                                        showDialog(
                                            context: context,
                                            builder: (context) => ConfirmDialog(
                                                  title: 'Confirmation',
                                                  description:
                                                      'Are you sure you want to update transactions?',
                                                  buttonText: 'Confirm',
                                                ));
                                      } else {
                                        // showDialog(
                                        //     context: context,
                                        //     builder: (context) =>
                                        //         ErrorDialog(
                                        //           // iconn: 59137,
                                        //           title:
                                        //               'Connection Problem!',
                                        //           description:
                                        //               'Connection Problem.' +
                                        //                   ' Try Again.',
                                        //           buttonText: 'Okay',
                                        //         ));
                                        showGlobalSnackbar(
                                            'Connectivity',
                                            'Please connect to internet.',
                                            Colors.red.shade900,
                                            Colors.white);
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      height: 100,
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          30,
                                      decoration: BoxDecoration(
                                          color: Colors.orange[300],
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Stack(
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 5),
                                                child: !upTrans
                                                    ? Container(
                                                        child: Text(
                                                          'Click to Update',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            30,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .check_circle,
                                                              size: 25,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    30,
                                                // color: Colors.grey,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.shopping_cart,
                                                      size: 50,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'Transaction',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 5),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      'Last Updated: ',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Text(
                                                      transLastUp,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      if (!NetworkData.errorMsgShow) {
                                        print('ITEM MASTERFILE CLICKED');
                                        GlobalVariables.updateType =
                                            'Item Masterfile';
                                        showDialog(
                                            context: context,
                                            builder: (context) => ConfirmDialog(
                                                  title: 'Confirmation',
                                                  description:
                                                      'Are you sure you want to update item masterfile?',
                                                  buttonText: 'Confirm',
                                                ));
                                      } else {
                                        showGlobalSnackbar(
                                            'Connectivity',
                                            'Please connect to internet.',
                                            Colors.red.shade900,
                                            Colors.white);
                                      }
                                    },
                                    child: Container(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          30,
                                      decoration: BoxDecoration(
                                          color: Colors.blue[300],
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Stack(
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 5),
                                                child: !upItem
                                                    ? Container(
                                                        child: Text(
                                                          'Click to Update',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            30,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .check_circle,
                                                              size: 25,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    30,
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                // color: Colors.grey,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.local_offer,
                                                      size: 50,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'Item',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 5),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      'Last Updated: ',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Text(
                                                      itemLastUp,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 40,
                          // color: Colors.grey,
                          child: Stack(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      if (!NetworkData.errorMsgShow) {
                                        print('CUSTOMER MASTERFILE CLICKED!');
                                        GlobalVariables.updateType =
                                            'Customer Masterfile';
                                        showDialog(
                                            context: context,
                                            builder: (context) => ConfirmDialog(
                                                  title: 'Confirmation',
                                                  description:
                                                      'Are you sure you want to update customer masterfile?',
                                                  buttonText: 'Confirm',
                                                ));
                                      } else {
                                        showGlobalSnackbar(
                                            'Connectivity',
                                            'Please connect to internet.',
                                            Colors.red.shade900,
                                            Colors.white);
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5),
                                      height: 100,
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          30,
                                      decoration: BoxDecoration(
                                          color: Colors.green[300],
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Stack(
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 5),
                                                child: !upCust
                                                    ? Container(
                                                        child: Text(
                                                          'Click to Update',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            30,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .check_circle,
                                                              size: 25,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    30,
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                // color: Colors.grey,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.account_circle,
                                                      size: 50,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'Customer',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 5),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      'Last Updated: ',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Text(
                                                      custLastUp,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      if (!NetworkData.errorMsgShow) {
                                        print('SALESMAN MASTERFILE CLICKED!');
                                        GlobalVariables.updateType =
                                            'Salesman Masterfile';
                                        showDialog(
                                            context: context,
                                            builder: (context) => ConfirmDialog(
                                                  title: 'Confirmation',
                                                  description:
                                                      'Are you sure you want to update salesman masterfile?',
                                                  buttonText: 'Confirm',
                                                ));
                                      } else {
                                        showGlobalSnackbar(
                                            'Connectivity',
                                            'Please connect to internet.',
                                            Colors.red.shade900,
                                            Colors.white);
                                      }
                                    },
                                    child: Container(
                                      height: 100,
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          30,
                                      decoration: BoxDecoration(
                                          color: Colors.purple[300],
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Stack(
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 5),
                                                child: !upSm
                                                    ? Container(
                                                        child: Text(
                                                          'Click to Update',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2 -
                                                            30,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons
                                                                  .check_circle,
                                                              size: 25,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                width: MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        2 -
                                                    30,
                                                margin: EdgeInsets.only(
                                                    left: 5, right: 5),
                                                // color: Colors.grey,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.local_shipping,
                                                      size: 50,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(width: 10),
                                                    Text(
                                                      'Salesman',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 5),
                                                child: Row(
                                                  children: <Widget>[
                                                    Text(
                                                      'Last Updated: ',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                    Text(
                                                      smLastUp,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            // height: 220,
            // height: 380,
            padding: EdgeInsets.only(left: 15, right: 15),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.deepOrange[50],
                border: Border.all(color: Colors.deepOrange.shade50),
                borderRadius: BorderRadius.circular(0)),
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            width: MediaQuery.of(context).size.width - 35,
                            height: 20,
                            color: ColorsTheme.mainColor,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  margin: EdgeInsets.only(left: 10),
                                  // color: ColorsTheme.mainColor,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'Download Log',
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic,
                                            fontSize: 10,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            // margin: EdgeInsets.only(left: 10, right: 10),
                            width: MediaQuery.of(context).size.width - 35,
                            height: 30,
                            color: Colors.transparent,
                            child: Stack(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      margin: EdgeInsets.only(left: 10),
                                      // color: Colors.grey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Date',
                                            style: TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      margin: EdgeInsets.only(right: 10),
                                      // color: Colors.grey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Type',
                                            style: TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      height: 50,
                                      margin: EdgeInsets.only(right: 10),
                                      // color: Colors.grey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Status',
                                            style: TextStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 35,
                            // height: 120,

                            height:
                                MediaQuery.of(context).size.height / 2 - 100,
                            color: Colors.transparent,
                            child: ListView.builder(
                                padding: const EdgeInsets.only(top: 1),
                                itemCount: _updateLog.length,
                                itemBuilder: (context, index) {
                                  Color contColor = Colors.transparent;
                                  Color fontColor = Colors.white;
                                  String conDate = '';
                                  DateTime x = DateTime.parse(
                                      _updateLog[index]['date'].toString());
                                  // conDate = DateFormat("MMM. d, y ").format(x);
                                  conDate =
                                      DateFormat.yMMMd().add_jm().format(x);
                                  if (_updateLog[index]['tb_categ'] ==
                                      'Transactions') {
                                    contColor = Colors.orange.shade300;
                                  }
                                  if (_updateLog[index]['tb_categ'] ==
                                      'Item Masterfile') {
                                    contColor = Colors.blue.shade300;
                                  }
                                  if (_updateLog[index]['tb_categ'] ==
                                      'Customer Masterfile') {
                                    contColor = Colors.green.shade300;
                                  }
                                  if (_updateLog[index]['tb_categ'] ==
                                      'Salesman Masterfile') {
                                    contColor = Colors.purple.shade300;
                                  }
                                  return Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(bottom: 5),
                                          padding: EdgeInsets.all(10),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              35,
                                          // height: 50,
                                          color: contColor,
                                          child: Stack(
                                            children: <Widget>[
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            150,
                                                    child: Text(
                                                      conDate,
                                                      style: TextStyle(
                                                        color: fontColor,
                                                        fontSize: 11,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                      // overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3 +
                                                            20),
                                                    child: Text(
                                                      _updateLog[index]
                                                          ['tb_categ'],
                                                      style: TextStyle(
                                                        color: fontColor,
                                                        fontSize: 12,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    _updateLog[index]['status'],
                                                    style: TextStyle(
                                                      color: fontColor,
                                                      fontSize: 12,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildUploadCont() {
    if (_toList.isEmpty) {
      return Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        width: MediaQuery.of(context).size.width,
        // color: ColorsTheme.mainColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.file_upload,
              size: 100,
              color: Colors.grey[500],
            ),
            Text(
              'You have no transaction for upload.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            )
          ],
        ),
      );
    }

    return Container(
      // height: 600,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15, right: 15),

      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: _toList.length,
        // scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          bool uploaded = false;
          // print('STATUS PER TRANSACTION:---------- ' +
          //     _toList[index]['uploaded'].toString());
          if (_toList[index]['uploaded'] == 'FALSE') {
            uploaded = false;
          } else {
            uploaded = true;
          }
          amount = _toList[index]['tot_amt'];
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 8),
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Stack(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          // margin: EdgeInsets.all(0),
                          width: 5,
                          height: 80,
                          color: ColorsTheme.mainColor,
                          // child: Image(
                          //   image: AssetImage('assets/images/art.png'),
                          // ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3 + 30,
                          // color: Colors.grey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Order # ' + _toList[index]['tran_no'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                _toList[index]['store_name'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _toList[index]['date_req'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 60),
                                width: MediaQuery.of(context).size.width / 4,
                                // color: Colors.blueGrey,
                                padding: EdgeInsets.only(left: 5, right: 5),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'Total Amount',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      formatCurrencyTot
                                          .format(double.parse(amount)),
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          // color: ColorsTheme.mainColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 105,
                          // color: Colors.grey,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 5,
                              ),
                              !uploading
                                  ? Text(
                                      !uploaded
                                          ? 'Uploaded'
                                          : 'Ready to Upload',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          color: !uploaded
                                              ? Colors.greenAccent
                                              : ColorsTheme.mainColor,
                                          fontSize: !uploaded ? 14 : 16,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Container(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            'Uploading...',
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SpinKitFadingCircle(
                                            color: Colors.green,
                                            size: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Container buildOrderOption() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 40,
      margin: EdgeInsets.only(top: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new SizedBox(
            width: (MediaQuery.of(context).size.width - 45) / 2,
            height: 35,
            child: new ElevatedButton(
              style: raisedButtonStyleWhite,
              onPressed: () {
                setState(() {
                  viewSpinkit = true;
                  // loadProcessed();
                  OrderData.visible = true;
                  uploadPressed = true;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Upload Data",
                      // recognizer: _tapGestureRecognizer,
                      style: TextStyle(
                        fontSize: ScreenData.scrWidth * .038,
                        fontWeight:
                            uploadPressed ? FontWeight.bold : FontWeight.normal,
                        decoration: TextDecoration.underline,
                        color:
                            uploadPressed ? ColorsTheme.mainColor : Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.file_upload,
                      color: Colors.green,
                      size: ScreenData.scrWidth * .06,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          new SizedBox(
            width: (MediaQuery.of(context).size.width - 45) / 2,
            height: 35,
            child: new ElevatedButton(
              style: raisedButtonStyleWhite,
              onPressed: () {
                setState(() {
                  viewSpinkit = true;
                  // loadPending();
                  // loadConsolidated();
                  // dispose();
                  OrderData.visible = false;
                  uploadPressed = false;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                      text: TextSpan(
                    text: "Download Data",
                    // recognizer: _tapGestureRecognizer,
                    style: TextStyle(
                      fontSize: ScreenData.scrWidth * .038,
                      fontWeight:
                          uploadPressed ? FontWeight.normal : FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color:
                          uploadPressed ? Colors.grey : ColorsTheme.mainColor,
                    ),
                  )),
                  Container(
                    // padding: EdgeInsets.all(5),
                    child: Icon(
                      Icons.file_download,
                      color: Colors.yellowAccent,
                      size: ScreenData.scrWidth * .06,
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

  Container buildStatusCont() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 20,
      color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                NetworkData.errorMsg!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 10,
              ),
              SpinKitFadingCircle(
                color: Colors.white,
                size: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        "Sync",
        textAlign: TextAlign.right,
        style: TextStyle(
            color: ColorsTheme.mainColor,
            fontSize: 45,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ConfirmDialog extends StatefulWidget {
  final String? title, description, buttonText;

  ConfirmDialog({this.title, this.description, this.buttonText});

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  bool loadSpinkit = false;
  List itemList = [];
  List categList = [];
  List itemImgList = [];
  List customerList = [];
  List discountList = [];
  List bankList = [];
  List salesmanList = [];
  List tranHeadList = [];
  List linelist = [];
  List returnList = [];
  List unsrvlist = [];
  List chequeList = [];
  List hepeList = [];

  String updateType = 'Jefe';

  final date = DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
  final db = DatabaseHelper();

  updateTransactions() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => LoadingSpinkit());
    //UNSERVED UPDATE
    // var rsp = await db.getHepeList();
    // linelist = rsp;
    // int x = 1;
    // linelist.forEach((element) async {
    //   if (x < linelist.length) {
    //     x++;
    //     if (x == linelist.length) {
    //       await db.deleteTable('tb_tran_line');
    //       await db.insertTable(linelist, 'tb_tran_line');
    //       await db.updateTable('tb_tran_line', date.toString());
    //       print('Transaction Line Created');
    //     }
    //   }
    // });
    //RETURNED TRAN LIST
    var retlist = await db.getReturnedTranList();
    returnList = retlist;
    int v = 1;
    returnList.forEach((element) async {
      if (v < returnList.length) {
        v++;
        if (v == returnList.length) {
          await db.deleteTable('tb_returned_tran');
          await db.insertTable(returnList, 'tb_returned_tran');
          await db.updateTable('tb_returned_tran', date.toString());
          print('RETURNED TRAN Updated');
        }
      }
    });

    //RETURNED/UNSERVED LIST
    var uslist = await db.getUnservedList();
    unsrvlist = uslist;
    int w = 1;
    unsrvlist.forEach((element) async {
      if (w < unsrvlist.length) {
        w++;
        if (w == unsrvlist.length) {
          await db.deleteTable('tb_unserved_items');
          await db.insertTable(unsrvlist, 'tb_unserved_items');
          await db.updateTable('tb_unserved_items', date.toString());
          print('Unserved List Updated');
        }
      }
    });

    //CHEQUE DATA UPDATE
    var chqdata = await db.getChequeList();
    chequeList = chqdata;
    int x = 1;
    chequeList.forEach((element) async {
      if (x < chequeList.length) {
        x++;
        if (x == chequeList.length) {
          await db.deleteTable('tb_cheque_data');
          await db.insertTable(chequeList, 'tb_cheque_data');
          await db.updateTable('tb_cheque_data', date.toString());
          print('Cheque Data List Updated');
        }
      }
    });

    //LINE UPDATE
    var linersp = await db.getTranLine();
    linelist = linersp;
    int y = 1;
    linelist.forEach((element) async {
      if (y < linelist.length) {
        y++;
        if (y == linelist.length) {
          await db.deleteTable('tb_tran_line');
          await db.insertTable(linelist, 'tb_tran_line');
          await db.updateTable('tb_tran_line', date.toString());
          print('Transaction Line Updated');
        }
      }
    });
    //TRAN UPDATE
    var thead = await db.getTranHead();
    tranHeadList = thead;
    int z = 0;
    tranHeadList.forEach((element) async {
      if (z < tranHeadList.length) {
        z++;
        if (z == tranHeadList.length) {
          print(tranHeadList.length);
          await db.deleteTable('tb_tran_head');
          await db.insertTable(tranHeadList, 'tb_tran_head');
          await db.updateTable('tb_tran_head ', date.toString());
          await db.addUpdateTableLog(
              date.toString(), 'Transactions', 'Completed', updateType);
          print('Transaction Head Updated');
          GlobalVariables.updateSpinkit = true;
        }
      }
    });
  }

  updateItemMasterfile() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => LoadingSpinkit());

    var rsp = await db.getItemImgList();
    itemImgList = rsp;
    int x = 0;
    itemImgList.forEach((element) async {
      if (x < itemImgList.length) {
        x++;
        if (x == itemImgList.length) {
          await db.insertItemImgList(itemImgList);
          await db.updateTable('tbl_item_image', date.toString());
          print('Item Image List Updated');
        }
      }
    });

    // //CATEGORY

    var rsp1 = await db.getCategList();
    categList = rsp1;
    int y = 0;
    categList.forEach((element) async {
      if (y < categList.length) {
        final imgBase64Str = await networkImageToBase64(
            UrlAddress.categImg + element['category_image']);
        // setState(() {
        element['category_image'] = imgBase64Str;
        // });
        y++;
        if (y == categList.length) {
          await db.deleteTable('tbl_category_masterfile');
          await db.updateCategList(categList);
          await db.updateTable('tbl_category_masterfile', date.toString());
          print('Categ List Updated');
        }
      }
    });

    var resp = await db.getItemList();
    itemList = resp;
    int z = 0;
    itemList.forEach((element) async {
      if (z < itemList.length) {
        z++;
        if (z == itemList.length) {
          await db.deleteTable('item_masterfiles');
          await db.insertItemList(itemList);
          await db.updateTable('item_masterfiles', date.toString());
          await db.addUpdateTableLog(
              date.toString(), 'Item Masterfile', 'Completed', updateType);
          print('Item Masterfile Updated');
          GlobalVariables.updateSpinkit = true;
        }
      }
    });
  }

  Future<String> networkImageToBase64(String imageUrl) async {
    var imgUri = Uri.parse(imageUrl);
    http.Response response = await http.get(imgUri);
    final bytes = response.bodyBytes;
    // return (bytes != null ? base64Encode(bytes) : null);
    return (base64Encode(bytes));
  }

  updateCustomer() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => LoadingSpinkit());

    var rsp = await db.getDiscountList();
    discountList = rsp;
    int x = 1;
    discountList.forEach((element) async {
      if (x < discountList.length) {
        x++;
        if (x == discountList.length) {
          await db.deleteTable('tbl_discounts');
          await db.insertTable(discountList, 'tbl_discounts');
          await db.updateTable('tbl_discounts ', date.toString());
          print('Discount List Updated');
        }
      }
    });

    var rsp1 = await db.getBankListonLine();
    bankList = rsp1;
    int y = 1;
    bankList.forEach((element) async {
      if (y < bankList.length) {
        y++;
        if (y == bankList.length) {
          await db.deleteTable('tb_bank_list');
          await db.insertTable(bankList, 'tb_bank_list');
          await db.updateTable('tb_bank_list', date.toString());
          print('Bank List Updated');
        }
      }
    });

    var resp = await db.getCustomersList();
    customerList = resp;
    int z = 1;
    customerList.forEach((element) async {
      if (z < customerList.length) {
        z++;
        if (z == customerList.length) {
          await db.deleteTable('customer_master_files');
          await db.insertTable(customerList, 'customer_master_files');
          await db.updateTable('customer_master_files ', date.toString());
          await db.addUpdateTableLog(
              date.toString(), 'Customer Masterfile', 'Completed', updateType);
          print('Customer List Updated');
          GlobalVariables.updateSpinkit = true;
        }
      }
    });
  }

  updateSalesman() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => LoadingSpinkit());

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
        }
      }
    });

    var resp = await db.getSalesmanList();
    salesmanList = resp;
    int y = 1;
    salesmanList.forEach((element) async {
      if (y < salesmanList.length) {
        y++;
        if (y == salesmanList.length) {
          await db.deleteTable('salesman_lists');
          await db.insertTable(salesmanList, 'salesman_lists');
          await db.updateTable('salesman_lists ', date.toString());
          await db.addUpdateTableLog(
              date.toString(), 'Salesman Masterfile', 'Completed', updateType);
          print('Salesman List Updated');
          GlobalVariables.updateSpinkit = true;
        }
      }
    });
  }

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
                        loadSpinkit = true;
                        if (GlobalVariables.updateType == 'Transactions') {
                          Navigator.pop(context);
                          updateTransactions();
                        }
                        if (GlobalVariables.updateType == 'Item Masterfile') {
                          Navigator.pop(context);
                          updateItemMasterfile();
                        }
                        if (GlobalVariables.updateType ==
                            'Customer Masterfile') {
                          Navigator.pop(context);
                          updateCustomer();
                        }
                        if (GlobalVariables.updateType ==
                            'Salesman Masterfile') {
                          Navigator.pop(context);
                          updateSalesman();
                        }
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
