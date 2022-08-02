import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/history/chequedata.dart';
import 'package:salesman/history/signature.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/assets.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/elevated_button.dart';

class OrdersAndTracking extends StatefulWidget {
  @override
  _OrdersAndTrackingState createState() => _OrdersAndTrackingState();
}

class _OrdersAndTrackingState extends State<OrdersAndTracking> {
  String itemNo = "";
  String itemNo1 = "";
  String itemNo2 = "";
  String lineTotal = "0.00";
  String orderTotal = "0.00";
  String orderTotal2 = "0.00";
  String itmCat = "";
  String itmCat2 = "";
  String itemQty = "";
  String discount = "";
  String lineAmt = "0.00";
  String imgPath = "";

  bool categ = false;
  bool categ2 = false;
  bool notYetDelivered = true;
  bool viewDisc = false;
  bool viewSpinkit = true;
  bool viewRemSpinkit = true;

  int i = 0;
  final formatCurrencyAmt =
      new NumberFormat.currency(locale: "en_US", symbol: "₱");
  final formatCurrencyTot =
      new NumberFormat.currency(locale: "en_US", symbol: "Php ");

  bool reqPressed = true;
  bool remPressed = false;
  bool delPressed = false;
  bool unServed = false;
  bool returned = false;
  bool noImage = false;
  bool loadspinkit = true;

  final db = DatabaseHelper();

  List _list = [];
  // List _remlist = [];
  List _chequelist = [];
  List _templist = [];
  List _unservedList = [];
  List _returnedList = [];
  List _imgpath = [];
  // List _sampList = [];

  void initState() {
    super.initState();
    reqPressed = true;
    loadImagePath();
    loadOrders();
    // loadImage();
    if (OrderData.status == 'Delivered' || OrderData.status == 'Returned') {
      GlobalVariables.showSign = true;
      notYetDelivered = false;
    } else {
      GlobalVariables.showSign = false;
      notYetDelivered = true;
    }
    if (OrderData.pmtype == 'CHEQUE') {
      GlobalVariables.showCheque = true;
    } else {
      GlobalVariables.showCheque = false;
    }
  }

  loadImagePath() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + '/';
    imgPath = firstPath;
  }

  loadOrders() async {
    int x = 1;
    var getO = await db.getOrderedItems(UserData.trans);
    itemNo = '0';
    _list = json.decode(json.encode(getO));
    print(_list);
    if (!mounted) return;
    if (_list.isEmpty) {
      viewSpinkit = false;
    }
    setState(() {
      _list.forEach((element) async {
        var getImg = await db.getItemImg(element['itm_code'], element['uom']);
        _imgpath = json.decode(json.encode(getImg));

        setState(() {
          itmCat = "";
          categ = false;
          if (_imgpath.isEmpty) {
            element['image'] = '';
          } else {
            element['image'] = _imgpath[0]['image'];
          }

          itemNo =
              (int.parse(itemNo) + int.parse(element['req_qty'])).toString();
        });
        print(x);
        if (x == _list.length) {
          viewSpinkit = false;
        } else {
          x++;
        }
      });
    });
    OrderData.grandTotal = '0';
    OrderData.totalDisc = '0';
    OrderData.totamt = '0';
    getTotal();
    CustomerData.discounted = false;
    viewDisc = false;
  }

  getChequeData() async {
    // print(UserData.trans);
    var getC = await db.getChequeData(UserData.trans);
    if (!mounted) return;
    setState(() {
      _chequelist = getC;
      // print(_chequelist);
      _chequelist.forEach((element) {
        ChequeData.payeeName = element['payee_name'];
        ChequeData.payorName = element['payor_name'];
        ChequeData.bankName = element['bank_name'];
        ChequeData.chequeNum = element['cheque_no'];
        ChequeData.branchCode = element['branch_code'];
        ChequeData.bankAccNo = element['account_no'];
        ChequeData.chequeDate = element['cheque_date'];
        ChequeData.chequeAmt = element['amount'];
        ChequeData.imgName = element['image'];
      });
    });
    double num = double.parse(ChequeData.chequeAmt!);
    int peso = num.toInt();
    int cent = ((num - peso) * 100).toInt();
    if (cent <= 0) {
      ChequeData.numToWords = NumberToWord().convert('en-in', peso);
    } else {
      ChequeData.numToWords = NumberToWord().convert('en-in', peso) +
          "and " +
          NumberToWord().convert('en-in', cent) +
          "cents";
    }
    print(ChequeData.numToWords);
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return ChequePage();
    }));
  }

  loadRemovedOrders() async {
    int z = 1;
    // var smp = await db.getRemovedOrders();
    // _sampList = smp;
    // print(_sampList);
    OrderData.grandTotal = '0.00';
    OrderData.totalDisc = '0.00';
    OrderData.totamt = '0.00';
    itemNo1 = "0";
    itemNo2 = "0";
    itemNo = "0";
    orderTotal = "0";
    orderTotal2 = "0";
    // _unservedList.clear();
    // _returnedList.clear();
    var i = 0;
    var x = 0;
    var lineTot = 0.00;
    var lineTot2 = 0.00;
    // var getU = await getUnservedOrders(UserData.trans);
    var getU = await db.getUnservedOrders(UserData.trans);
    // _unservedList = getU;
    _unservedList = json.decode(json.encode(getU));
    if (!mounted) return;
    setState(() {
      if (_unservedList.isNotEmpty && _returnedList.isEmpty) {
        unServed = true;
        returned = false;
        _unservedList.forEach((element) async {
          var getImg = await db.getItemImg(element['itm_code'], element['uom']);
          _imgpath = json.decode(json.encode(getImg));
          setState(() {
            categ = false;
            categ = false;
            itmCat = "";
            itmCat2 = "";
            if (_imgpath.isEmpty) {
              element['image'] = '';
            } else {
              element['image'] = _imgpath[0]['image'];
            }
            i = int.parse(element['qty']);
            lineTot = i * double.parse(element['amt']);
            orderTotal = (double.parse(orderTotal) + lineTot).toString();
            itemNo = (int.parse(itemNo) + int.parse(element['qty'])).toString();
          });
          OrderData.totamt = orderTotal;
          OrderData.grandTotal = orderTotal;
          OrderData.totalDisc = '0.00';
          if (z == _unservedList.length) {
            viewRemSpinkit = false;
          } else {
            z++;
          }
        });
        // viewRemSpinkit = false;
      }
      categ = false;
      categ2 = false;
      itmCat = "";
      itmCat2 = "";
      viewDisc = false;
    });

    // var getR = await getReturnedOrders(UserData.trans);
    var getR = await db.getReturnedOrders(UserData.trans);
    // _returnedList = getR;
    _returnedList = json.decode(json.encode(getR));
    if (!mounted) return;
    setState(() {
      if (_returnedList.isNotEmpty && _unservedList.isEmpty) {
        returned = true;
        unServed = false;
        _returnedList.forEach((element) async {
          var getImg = await db.getItemImg(element['itm_code'], element['uom']);
          _imgpath = json.decode(json.encode(getImg));
          setState(() {
            categ = false;
            categ = false;
            itmCat = "";
            itmCat2 = "";
            if (_imgpath.isEmpty) {
              element['image'] = '';
            } else {
              element['image'] = _imgpath[0]['image'];
            }
            i = int.parse(element['qty']);
            lineTot = i * double.parse(element['amt']);
            orderTotal = (double.parse(orderTotal) + lineTot).toString();
            itemNo = (int.parse(itemNo) + int.parse(element['qty'])).toString();
          });
          // itemNo = _returnedList.length.toString();
          OrderData.totamt = orderTotal;
          OrderData.grandTotal = orderTotal;
          OrderData.totalDisc = '0.00';
          if (z == _returnedList.length) {
            viewRemSpinkit = false;
          } else {
            z++;
          }
        });
      }
    });
    setState(() {
      if (_returnedList.isNotEmpty && _unservedList.isNotEmpty) {
        _returnedList.forEach((element) async {
          var getImg = await db.getItemImg(element['itm_code'], element['uom']);
          _imgpath = json.decode(json.encode(getImg));
          if (!mounted) return;
          setState(() {
            categ = false;
            categ = false;
            itmCat = "";
            itmCat2 = "";
            if (_imgpath.isEmpty) {
              element['image'] = '';
            } else {
              element['image'] = _imgpath[0]['image'];
            }
            i = int.parse(element['qty']);
            lineTot = i * double.parse(element['amt']);
            orderTotal = (double.parse(orderTotal) + lineTot).toString();
            itemNo2 =
                (int.parse(itemNo2) + int.parse(element['qty'])).toString();
          });
        });
        _unservedList.forEach((element) async {
          var getImg = await db.getItemImg(element['itm_code'], element['uom']);
          _imgpath = json.decode(json.encode(getImg));
          if (!mounted) return;
          setState(() {
            categ = false;
            categ = false;
            itmCat = "";
            itmCat2 = "";
            if (_imgpath.isEmpty) {
              element['image'] = '';
            } else {
              element['image'] = _imgpath[0]['image'];
            }
            x = int.parse(element['qty']);
            lineTot2 = x * double.parse(element['amt']);
            orderTotal2 = (double.parse(orderTotal2) + lineTot2).toString();
            itemNo1 =
                (int.parse(itemNo1) + int.parse(element['qty'])).toString();
          });
        });
        // itemNo1 = _unservedList.length.toString();
        // itemNo2 = _returnedList.length.toString();
        itemNo = (int.parse(itemNo1) + int.parse(itemNo2)).toString();
        OrderData.totamt =
            (double.parse(orderTotal) + double.parse(orderTotal2)).toString();
        OrderData.grandTotal =
            (double.parse(orderTotal) + double.parse(orderTotal2)).toString();
        if (z == _unservedList.length) {
          viewRemSpinkit = false;
        } else {
          z++;
        }
      }
      categ = false;
      categ = false;
      itmCat = "";
      itmCat2 = "";
      viewDisc = false;
    });
    if (_returnedList.isEmpty && _unservedList.isEmpty) {
      setState(() {
        viewRemSpinkit = false;
        categ = false;
        categ = false;
        itmCat = "";
        itmCat2 = "";
        viewDisc = false;
      });
    }
  }

  getTotal() {
    orderTotal = "0";
    lineAmt = "0";
    _list.forEach((element) {
      lineAmt =
          (double.parse(element['amt']) * double.parse(element['req_qty']))
              .toString();
      orderTotal =
          (double.parse(orderTotal) + double.parse(lineAmt)).toString();
    });
    OrderData.totamt = orderTotal;
    OrderData.grandTotal = orderTotal;
  }

  loadDeliveredOrders() async {
    int x = 1;
    itemNo = '0';
    // var getO = await getDeliveredOrders(UserData.trans);
    var getO = await db.getDeliveredOrders(UserData.trans);
    if (!mounted) return;
    setState(() {
      _templist = json.decode(json.encode(getO));
      print(_templist);
      _list.clear();
      OrderData.grandTotal = '0';
      OrderData.totalDisc = '0';
      OrderData.totamt = '0';
      double discAmt = 0.00;
      double lineTot = 0.00;
      double orderTotal = 0.00;
      // itemNo = _list.length.toString();
      _templist.forEach((element) async {
        var getImg = await db.getItemImg(element['itm_code'], element['uom']);
        _imgpath = json.decode(json.encode(getImg));
        if (!mounted) return;
        setState(() {
          itmCat = "";
          categ = false;
          if (_imgpath.isEmpty) {
            element['image'] = '';
          } else {
            element['image'] = _imgpath[0]['image'];
          }
        });
        if (int.parse(element['del_qty']) > 0) {
          _list.add(element);
        }
        if (element['flag'] == "1") {
          lineAmt = '0.00';
          discAmt = 0.00;
          double a = double.parse(element['discount']);
          lineAmt =
              (double.parse(element['amt']) * double.parse(element['del_qty']))
                  .toString();
          discAmt = double.parse(lineAmt) * (a / 100);
        }
        print(_list);
        lineTot =
            double.parse(element['amt']) * double.parse(element['del_qty']);
        orderTotal = orderTotal + lineTot;
        itemNo = (int.parse(itemNo) + int.parse(element['del_qty'])).toString();
        // itemNo = _list.length.toString();
        OrderData.totalDisc =
            (double.parse(OrderData.totalDisc) + discAmt).toString();
        OrderData.totamt = orderTotal.toString();
        OrderData.grandTotal =
            (double.parse(OrderData.totamt) - double.parse(OrderData.totalDisc))
                .toString();
        if (x == _templist.length) {
          viewSpinkit = false;
        } else {
          x++;
        }
        print(OrderData.status);
      });
    });
    if (OrderData.status == 'Returned') {
      viewSpinkit = false;
    }
    categ = false;
    itmCat = "";
  }

  loadImage() async {}

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
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    // buildHeaderCont(),
                    SizedBox(
                      height: 5,
                    ),
                    buildListViewCont()!,
                  ],
                ),
              ),
            ),
            Container(
              height: 160,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    buildHeaderCont(),
                    buildOrderOption(),
                  ],
                ),
              ),
            ),
            // buildSummaryCont(context),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: CustomerData.discounted ? 200 : 150,
            // color: Colors.grey,
            child: Stack(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      // width: 200,
                      height: CustomerData.discounted ? 200 : 150,
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Order Summary',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Order No.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Payment Method',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Item(s)',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Visibility(
                            visible: CustomerData.discounted,
                            child: Text(
                              'Gross Amount',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ),
                          Visibility(
                            visible: CustomerData.discounted,
                            child: SizedBox(
                              height: 5,
                            ),
                          ),
                          Visibility(
                            visible: CustomerData.discounted,
                            child: Text(
                              'Discount',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ),
                          Visibility(
                            visible: CustomerData.discounted,
                            child: SizedBox(
                              height: 5,
                            ),
                          ),
                          Text(
                            'Net Amount',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 2 + 150,
                      margin: EdgeInsets.only(
                        right: 10,
                        bottom: 5,
                      ),
                      padding: EdgeInsets.only(left: 100),
                      height: CustomerData.discounted ? 200 : 150,
                      // color: Colors.grey,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width / 2 + 60,
                            // color: Colors.grey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(height: 32),
                                Text(
                                  OrderData.trans!,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  OrderData.pmeth!,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  itemNo,
                                  // '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Visibility(
                                  visible: CustomerData.discounted,
                                  child: Text(
                                    formatCurrencyAmt
                                        .format(double.parse(OrderData.totamt)),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        // decoration: TextDecoration.underline,
                                        color: Colors.grey),
                                  ),
                                ),
                                Visibility(
                                  visible: CustomerData.discounted,
                                  child: SizedBox(
                                    height: 5,
                                  ),
                                ),
                                Visibility(
                                  visible: CustomerData.discounted,
                                  child: Text(
                                    '- ' +
                                        formatCurrencyAmt.format(
                                            double.parse(OrderData.totalDisc)),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        // decoration: TextDecoration.underline,
                                        color: Colors.red),
                                  ),
                                ),
                                Visibility(
                                  visible: CustomerData.discounted,
                                  child: SizedBox(
                                    height: 5,
                                  ),
                                ),
                                Text(
                                  formatCurrencyTot.format(
                                      double.parse(OrderData.grandTotal)),
                                  // '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 + 80,
                                // color: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Visibility(
                                      visible: GlobalVariables.showCheque,
                                      child: Container(
                                        width: 80,
                                        height: 30,
                                        child: ElevatedButton(
                                          style: raisedButtonStyleBlack,
                                          // elevation: 10,
                                          onPressed: () => {
                                            getChequeData(),
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Cheque",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Visibility(
                                      visible: GlobalVariables.showSign,
                                      child: Container(
                                        // width: 80,
                                        height: 30,
                                        child: ElevatedButton(
                                          style: raisedButtonStyleBlackOut,
                                          onPressed: () => {
                                            if (OrderData.signature!.isNotEmpty)
                                              {
                                                Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        type: PageTransitionType
                                                            .rightToLeft,
                                                        child: Signature())),
                                                // Navigator.of(context).push(
                                                //   MaterialPageRoute(
                                                //     builder:
                                                //         (BuildContext context) {
                                                //       return Scaffold(
                                                //         appBar: AppBar(),
                                                //         body: Center(
                                                //             child: Container(
                                                //                 color: Colors
                                                //                     .grey[300],
                                                //                 child: Image.memory(
                                                //                     base64Decode(
                                                //                         OrderData
                                                //                             .signature!)))),
                                                //       );
                                                //     },
                                                //   ),
                                                // ),
                                              }
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Signature",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Container(
                                      // width: 80,
                                      height: 30,
                                      child: ElevatedButton(
                                        style: raisedButtonStyleBlack,
                                        // padding: EdgeInsets.symmetric(
                                        //     horizontal: 0, vertical: 0),
                                        // elevation: 10,
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  OrderTracking());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Tracking",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
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
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildOrderOption() {
    return Container(
      height: 30,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new SizedBox(
            // width: 170,
            // height: 35,
            child: new ElevatedButton(
              style: raisedButtonStyleWhite,
              onPressed: () {
                setState(() {
                  viewSpinkit = true;
                  itmCat = "";
                  orderTotal = '0';
                  loadOrders();
                  reqPressed = true;
                  remPressed = false;
                  delPressed = false;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Submitted Items",
                      // recognizer: _tapGestureRecognizer,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            reqPressed ? FontWeight.bold : FontWeight.normal,
                        decoration: TextDecoration.underline,
                        color: reqPressed ? ColorsTheme.mainColor : Colors.grey,
                      ),
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
            // width: 170,
            // height: 35,
            child: AbsorbPointer(
              absorbing: notYetDelivered,
              child: new ElevatedButton(
                style: raisedButtonStyleWhite,
                onPressed: () {
                  setState(() {
                    viewRemSpinkit = true;
                    itmCat = "";
                    itmCat2 = "";
                    categ = false;
                    categ2 = false;
                    orderTotal = '0';
                    loadRemovedOrders();
                    reqPressed = false;
                    remPressed = true;
                    delPressed = false;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                        text: TextSpan(
                      text: "Unserved/Returned",
                      // recognizer: _tapGestureRecognizer,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            remPressed ? FontWeight.bold : FontWeight.normal,
                        decoration: TextDecoration.underline,
                        color: remPressed ? ColorsTheme.mainColor : Colors.grey,
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 2,
          ),
          new SizedBox(
            // width: 170,
            // height: 35,
            child: AbsorbPointer(
              absorbing: notYetDelivered,
              child: new ElevatedButton(
                style: raisedButtonStyleWhite,
                onPressed: () {
                  setState(() {
                    viewSpinkit = true;
                    itmCat = "";
                    categ = false;
                    orderTotal = '0';
                    loadDeliveredOrders();
                    reqPressed = false;
                    remPressed = false;
                    delPressed = true;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RichText(
                        text: TextSpan(
                      text: "Delivered Items",
                      // recognizer: _tapGestureRecognizer,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            delPressed ? FontWeight.bold : FontWeight.normal,
                        decoration: TextDecoration.underline,
                        color: delPressed ? ColorsTheme.mainColor : Colors.grey,
                      ),
                    ))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container? buildListViewCont() {
    if (remPressed == true) {
      if (viewRemSpinkit == true) {
        return Container(
          // height: 620,
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width,
          color: Colors.white10,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 150,
                  // color: Colors.white10,
                  height: 150,
                  child: Image(
                    color: ColorsTheme.mainColor,
                    image: AssetsValues.cartImage,
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        if (_unservedList.isNotEmpty && _returnedList.isEmpty) {
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 110, bottom: 0),
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.grey,
                  child: Center(
                    child: Text(
                      'UNSERVED',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: ColorsTheme.mainColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0),
                  height: MediaQuery.of(context).size.height / 2 + 75,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 1),
                    itemCount: _unservedList.length,
                    itemBuilder: (context, index) {
                      if (!reqPressed && !delPressed) {
                        itemQty =
                            (int.parse(_unservedList[index]['qty'])).toString();
                      }
                      // if (itmCat != _unservedList[index]['itm_cat']) {
                      //   categ = false;
                      //   itmCat = _unservedList[index]['itm_cat'];
                      // } else {
                      //   categ = true;
                      // }
                      if (_unservedList[index]['itm_cat'] == null ||
                          _unservedList[index]['itm_cat'] == 'null' ||
                          _unservedList[index]['itm_cat'] == '') {
                        _unservedList[index]['itm_cat'] = '';
                      }
                      categ = true;
                      if (_unservedList[index]['image'] == '') {
                        noImage = true;
                      } else {
                        noImage = false;
                      }
                      lineTotal = (double.parse(_unservedList[index]['amt']) *
                              double.parse(itemQty))
                          .toString();

                      // _unservedList[index]['tot_amt'] = lineTotal;
                      getTotal();

                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            // if (!categ)
                            //   Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     height: 20,
                            //     color: Colors.deepOrange,
                            //     child: Stack(
                            //       children: <Widget>[
                            //         Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.start,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.center,
                            //           children: <Widget>[
                            //             Container(
                            //               // width: 260,
                            //               // width: MediaQuery.of(context).size.width / 2,
                            //               margin:
                            //                   EdgeInsets.only(left: 5, top: 3),
                            //               child: Text(
                            //                 _unservedList[index]['itm_cat'],
                            //                 textAlign: TextAlign.left,
                            //                 style: TextStyle(
                            //                     fontSize: 10,
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.end,
                            //           children: <Widget>[
                            //             Container(
                            //               // width: 50,
                            //               padding: EdgeInsets.only(right: 110),
                            //               margin:
                            //                   EdgeInsets.only(left: 5, top: 3),
                            //               child: Text(
                            //                 'Qty',
                            //                 textAlign: TextAlign.left,
                            //                 style: TextStyle(
                            //                     fontSize: 10,
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.end,
                            //           children: <Widget>[
                            //             Container(
                            //               // width: 50,
                            //               margin:
                            //                   EdgeInsets.only(left: 5, top: 3),
                            //               padding: EdgeInsets.only(right: 10),
                            //               child: Text(
                            //                 'Sub Total',
                            //                 textAlign: TextAlign.right,
                            //                 style: TextStyle(
                            //                     fontSize: 10,
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0, color: ColorsTheme.mainColor),
                                ),
                                color: Colors.white,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 5,
                                        height: 80,
                                        color: ColorsTheme.mainColor,
                                      ),
                                      if (GlobalVariables.viewImg)
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: 3, top: 3),
                                          width: 75,
                                          color: Colors.white,
                                          child: noImage
                                              ? Image(
                                                  image:
                                                      AssetsValues.noImageImg)
                                              : Image.file(File(imgPath +
                                                  _unservedList[index]
                                                      ['image'])),
                                        )
                                      else if (!GlobalVariables.viewImg)
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 3, top: 3),
                                            width: 75,
                                            color: Colors.white,
                                            child: Image(
                                                image: AssetsValues.noImageImg))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 85),
                                        margin: EdgeInsets.only(left: 3),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 +
                                                50,
                                        // color: Colors.grey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              _unservedList[index]['item_desc'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 50,
                                                    // color: Colors.grey,
                                                    child: Text(
                                                      _unservedList[index]
                                                          ['uom'],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  // SizedBox(
                                                  //   width: 5,
                                                  // ),
                                                  Container(
                                                    // width: 80,
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                6 -
                                                            10,
                                                    // color: Colors.grey,
                                                    child: Text(
                                                      formatCurrencyAmt.format(
                                                          double.parse(
                                                              _unservedList[
                                                                      index]
                                                                  ['amt'])),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 11,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
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
                                        margin: EdgeInsets.only(left: 0),
                                        // width: 105,
                                        // color: Colors.grey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            // SizedBox(
                                            //   height: 40,
                                            // ),
                                            Visibility(
                                              visible: viewDisc,
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 120,
                                                    height: 25,
                                                    // color: Colors.grey,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 75),
                                                      child: Container(
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Image(
                                                              image: AssetsValues
                                                                  .discountImg,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            3),
                                                                child: Text(
                                                                  discount,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: viewDisc,
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    // color: Colors.grey,
                                                    width: 100,
                                                    height: 15,
                                                    padding: EdgeInsets.only(
                                                        right: 0),
                                                    child: Text(
                                                      formatCurrencyTot.format(
                                                          double.parse(
                                                              lineAmt)),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        // fontStyle:
                                                        //     FontStyle.italic,
                                                        decoration: viewDisc
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : TextDecoration
                                                                .none,
                                                        decorationColor:
                                                            Colors.red,
                                                        decorationThickness: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: viewDisc ? 0 : 40,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    itemQty,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   width: 5,
                                                // ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  width: 100,
                                                  child: Text(
                                                    formatCurrencyTot.format(
                                                        double.parse(
                                                            lineTotal)),
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.italic),
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
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        if (_returnedList.isNotEmpty && _unservedList.isEmpty) {
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 110, bottom: 0),
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.grey,
                  child: Center(
                    child: Text(
                      'RETURNED',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: ColorsTheme.mainColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0),
                  height: MediaQuery.of(context).size.height / 2 + 75,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 1),
                    itemCount: _returnedList.length,
                    itemBuilder: (context, index) {
                      if (!reqPressed && !delPressed) {
                        itemQty =
                            (int.parse(_returnedList[index]['qty'])).toString();
                      }
                      // if (itmCat != _returnedList[index]['itm_cat']) {
                      //   categ = false;
                      //   itmCat = _returnedList[index]['itm_cat'];
                      // } else {
                      //   categ = true;
                      // }
                      if (_returnedList[index]['itm_cat'] == null ||
                          _returnedList[index]['itm_cat'] == 'null' ||
                          _returnedList[index]['itm_cat'] == '') {
                        _returnedList[index]['itm_cat'] = '';
                      }
                      categ = true;
                      if (_returnedList[index]['image'] == '') {
                        noImage = true;
                      } else {
                        noImage = false;
                      }
                      lineTotal = (double.parse(_returnedList[index]['amt']) *
                              double.parse(itemQty))
                          .toString();

                      _returnedList[index]['tot_amt'] = lineTotal;
                      // getTotal();

                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            // if (!categ)
                            //   Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     height: 20,
                            //     color: Colors.deepOrange,
                            //     child: Stack(
                            //       children: <Widget>[
                            //         Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.start,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.center,
                            //           children: <Widget>[
                            //             Container(
                            //               // width: 260,
                            //               // width: MediaQuery.of(context).size.width / 2,
                            //               margin:
                            //                   EdgeInsets.only(left: 5, top: 3),
                            //               child: Text(
                            //                 _returnedList[index]['itm_cat'],
                            //                 textAlign: TextAlign.left,
                            //                 style: TextStyle(
                            //                     fontSize: 10,
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.end,
                            //           children: <Widget>[
                            //             Container(
                            //               // width: 50,
                            //               padding: EdgeInsets.only(right: 110),
                            //               margin:
                            //                   EdgeInsets.only(left: 5, top: 3),
                            //               child: Text(
                            //                 'Qty',
                            //                 textAlign: TextAlign.left,
                            //                 style: TextStyle(
                            //                     fontSize: 10,
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.end,
                            //           children: <Widget>[
                            //             Container(
                            //               // width: 50,
                            //               margin:
                            //                   EdgeInsets.only(left: 5, top: 3),
                            //               padding: EdgeInsets.only(right: 10),
                            //               child: Text(
                            //                 'Sub Total',
                            //                 textAlign: TextAlign.right,
                            //                 style: TextStyle(
                            //                     fontSize: 10,
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0, color: ColorsTheme.mainColor),
                                ),
                                color: Colors.white,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 5,
                                        height: 80,
                                        color: ColorsTheme.mainColor,
                                      ),
                                      if (GlobalVariables.viewImg)
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: 3, top: 3),
                                          width: 75,
                                          color: Colors.white,
                                          child: noImage
                                              ? Image(
                                                  image:
                                                      AssetsValues.noImageImg)
                                              : Image.file(File(imgPath +
                                                  _returnedList[index]
                                                      ['image'])),
                                        )
                                      else if (!GlobalVariables.viewImg)
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 3, top: 3),
                                            width: 75,
                                            color: Colors.white,
                                            child: Image(
                                                image: AssetsValues.noImageImg))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 85),
                                        margin: EdgeInsets.only(left: 3),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 +
                                                50,
                                        // color: Colors.grey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              _returnedList[index]['item_desc'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 50,
                                                    child: Text(
                                                      _returnedList[index]
                                                          ['uom'],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  // SizedBox(
                                                  //   width: 5,
                                                  // ),
                                                  Container(
                                                    // width: 80,
                                                    width:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                6 -
                                                            10,
                                                    // color: Colors.grey,
                                                    child: Text(
                                                      formatCurrencyAmt.format(
                                                          double.parse(
                                                              _returnedList[
                                                                      index]
                                                                  ['amt'])),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 11,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
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
                                        margin: EdgeInsets.only(left: 0),
                                        // width: 105,
                                        // color: Colors.grey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            // SizedBox(
                                            //   height: 40,
                                            // ),
                                            Visibility(
                                              visible: viewDisc,
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 120,
                                                    height: 25,
                                                    // color: Colors.grey,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 75),
                                                      child: Container(
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Image(
                                                              image: AssetsValues
                                                                  .discountImg,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            3),
                                                                child: Text(
                                                                  discount,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: viewDisc,
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    // color: Colors.grey,
                                                    width: 100,
                                                    height: 15,
                                                    padding: EdgeInsets.only(
                                                        right: 0),
                                                    child: Text(
                                                      formatCurrencyTot.format(
                                                          double.parse(
                                                              lineAmt)),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        // fontStyle:
                                                        //     FontStyle.italic,
                                                        decoration: viewDisc
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : TextDecoration
                                                                .none,
                                                        decorationColor:
                                                            Colors.red,
                                                        decorationThickness: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: viewDisc ? 0 : 40,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    itemQty,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   width: 5,
                                                // ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  width: 100,
                                                  child: Text(
                                                    formatCurrencyTot.format(
                                                        double.parse(
                                                            lineTotal)),
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.italic),
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
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        if (_unservedList.isNotEmpty && _returnedList.isNotEmpty) {
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 110, bottom: 0),
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.grey,
                  child: Center(
                    child: Text(
                      'UNSERVED',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: ColorsTheme.mainColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0),
                  height: (MediaQuery.of(context).size.height / 2 + 40) / 2,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 1),
                    itemCount: _unservedList.length,
                    itemBuilder: (context, index) {
                      if (!reqPressed && !delPressed) {
                        itemQty =
                            (int.parse(_unservedList[index]['qty'])).toString();
                      }
                      // if (itmCat != _unservedList[index]['itm_cat']) {
                      //   categ = false;
                      //   itmCat = _unservedList[index]['itm_cat'];
                      // } else {
                      //   categ = true;
                      // }
                      if (_unservedList[index]['itm_cat'] == null ||
                          _unservedList[index]['itm_cat'] == 'null' ||
                          _unservedList[index]['itm_cat'] == '') {
                        _unservedList[index]['itm_cat'] = '';
                      }
                      categ = true;
                      if (_unservedList[index]['image'] == '') {
                        noImage = true;
                      } else {
                        noImage = false;
                      }
                      lineTotal = (double.parse(_unservedList[index]['amt']) *
                              double.parse(itemQty))
                          .toString();

                      _unservedList[index]['tot_amt'] = lineTotal;
                      // getTotal();

                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            // if (!categ)
                            //   Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     height: 20,
                            //     color: Colors.deepOrange,
                            //     child: Stack(
                            //       children: <Widget>[
                            //         Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.start,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.center,
                            //           children: <Widget>[
                            //             Container(
                            //               // width: 260,
                            //               // width: MediaQuery.of(context).size.width / 2,
                            //               margin:
                            //                   EdgeInsets.only(left: 5, top: 3),
                            //               child: Text(
                            //                 _unservedList[index]['itm_cat'],
                            //                 textAlign: TextAlign.left,
                            //                 style: TextStyle(
                            //                     fontSize: 10,
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.end,
                            //           children: <Widget>[
                            //             Container(
                            //               // width: 50,
                            //               padding: EdgeInsets.only(right: 110),
                            //               margin:
                            //                   EdgeInsets.only(left: 5, top: 3),
                            //               child: Text(
                            //                 'Qty',
                            //                 textAlign: TextAlign.left,
                            //                 style: TextStyle(
                            //                     fontSize: 10,
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.end,
                            //           children: <Widget>[
                            //             Container(
                            //               // width: 50,
                            //               margin:
                            //                   EdgeInsets.only(left: 5, top: 3),
                            //               padding: EdgeInsets.only(right: 10),
                            //               child: Text(
                            //                 'Sub Total',
                            //                 textAlign: TextAlign.right,
                            //                 style: TextStyle(
                            //                     fontSize: 10,
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0, color: ColorsTheme.mainColor),
                                ),
                                color: Colors.white,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 5,
                                        height: 80,
                                        color: ColorsTheme.mainColor,
                                      ),
                                      if (GlobalVariables.viewImg)
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: 3, top: 3),
                                          width: 75,
                                          color: Colors.white,
                                          child: noImage
                                              ? Image(
                                                  image:
                                                      AssetsValues.noImageImg)
                                              : Image.file(File(imgPath +
                                                  _unservedList[index]
                                                      ['image'])),
                                        )
                                      else if (!GlobalVariables.viewImg)
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 3, top: 3),
                                            width: 75,
                                            color: Colors.white,
                                            child: Image(
                                                image: AssetsValues.noImageImg))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 85),
                                        margin: EdgeInsets.only(left: 3),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 +
                                                50,
                                        // color: Colors.grey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              _unservedList[index]['item_desc'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 60,
                                                    child: Text(
                                                      _unservedList[index]
                                                          ['uom'],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  // SizedBox(
                                                  //   width: 5,
                                                  // ),
                                                  Container(
                                                    width: 80,
                                                    // color: Colors.grey,
                                                    child: Text(
                                                      formatCurrencyAmt.format(
                                                          double.parse(
                                                              _unservedList[
                                                                      index]
                                                                  ['amt'])),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 11,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
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
                                        margin: EdgeInsets.only(left: 0),
                                        // width: 105,
                                        // color: Colors.grey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            // SizedBox(
                                            //   height: 40,
                                            // ),
                                            Visibility(
                                              visible: viewDisc,
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 120,
                                                    height: 25,
                                                    // color: Colors.grey,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 75),
                                                      child: Container(
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Image(
                                                              image: AssetsValues
                                                                  .discountImg,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            3),
                                                                child: Text(
                                                                  discount,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: viewDisc,
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    // color: Colors.grey,
                                                    width: 100,
                                                    height: 15,
                                                    padding: EdgeInsets.only(
                                                        right: 0),
                                                    child: Text(
                                                      formatCurrencyTot.format(
                                                          double.parse(
                                                              lineAmt)),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        // fontStyle:
                                                        //     FontStyle.italic,
                                                        decoration: viewDisc
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : TextDecoration
                                                                .none,
                                                        decorationColor:
                                                            Colors.red,
                                                        decorationThickness: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: viewDisc ? 0 : 40,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    itemQty,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   width: 5,
                                                // ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  width: 100,
                                                  child: Text(
                                                    formatCurrencyTot.format(
                                                        double.parse(
                                                            lineTotal)),
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.italic),
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
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 0),
                  height: 25,
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.grey,
                  child: Center(
                    child: Text(
                      'RETURNED',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: ColorsTheme.mainColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0),
                  height: (MediaQuery.of(context).size.height / 2 + 40) / 2,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 1),
                    itemCount: _returnedList.length,
                    itemBuilder: (context, index) {
                      if (!reqPressed && !delPressed) {
                        itemQty =
                            (int.parse(_returnedList[index]['qty'])).toString();
                      }
                      // if (itmCat2 != _returnedList[index]['itm_cat']) {
                      //   categ2 = false;
                      //   itmCat = _returnedList[index]['itm_cat'];
                      // } else {
                      //   categ2 = true;
                      // }
                      if (_returnedList[index]['itm_cat'] == null ||
                          _returnedList[index]['itm_cat'] == 'null' ||
                          _returnedList[index]['itm_cat'] == '') {
                        _returnedList[index]['itm_cat'] = '';
                      }
                      categ2 = true;
                      if (_returnedList[index]['image'] == '') {
                        noImage = true;
                      } else {
                        noImage = false;
                      }
                      lineTotal = (double.parse(_returnedList[index]['amt']) *
                              double.parse(itemQty))
                          .toString();

                      _returnedList[index]['tot_amt'] = lineTotal;
                      // getTotal();

                      return SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            // if (!categ2)
                            //   Container(
                            //     width: MediaQuery.of(context).size.width,
                            //     height: 20,
                            //     color: Colors.deepOrange,
                            //     child: Stack(
                            //       children: <Widget>[
                            //         Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.start,
                            //           crossAxisAlignment:
                            //               CrossAxisAlignment.center,
                            //           children: <Widget>[
                            //             Container(
                            //               // width: 260,
                            //               // width: MediaQuery.of(context).size.width / 2,
                            //               margin:
                            //                   EdgeInsets.only(left: 5, top: 3),
                            //               child: Text(
                            //                 _returnedList[index]['itm_cat'],
                            //                 textAlign: TextAlign.left,
                            //                 style: TextStyle(
                            //                     fontSize: 10,
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.end,
                            //           children: <Widget>[
                            //             Container(
                            //               // width: 50,
                            //               padding: EdgeInsets.only(right: 110),
                            //               margin:
                            //                   EdgeInsets.only(left: 5, top: 3),
                            //               child: Text(
                            //                 'Qty',
                            //                 textAlign: TextAlign.left,
                            //                 style: TextStyle(
                            //                     fontSize: 10,
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //         Row(
                            //           mainAxisAlignment: MainAxisAlignment.end,
                            //           children: <Widget>[
                            //             Container(
                            //               // width: 50,
                            //               margin:
                            //                   EdgeInsets.only(left: 5, top: 3),
                            //               padding: EdgeInsets.only(right: 10),
                            //               child: Text(
                            //                 'Sub Total',
                            //                 textAlign: TextAlign.right,
                            //                 style: TextStyle(
                            //                     fontSize: 10,
                            //                     fontWeight: FontWeight.w400,
                            //                     color: Colors.white),
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            Container(
                              margin: EdgeInsets.only(bottom: 5),
                              height: 70,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      width: 1.0, color: ColorsTheme.mainColor),
                                ),
                                color: Colors.white,
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 5,
                                        height: 80,
                                        color: ColorsTheme.mainColor,
                                      ),
                                      if (GlobalVariables.viewImg)
                                        Container(
                                          margin:
                                              EdgeInsets.only(left: 3, top: 3),
                                          width: 75,
                                          color: Colors.white,
                                          child: noImage
                                              ? Image(
                                                  image:
                                                      AssetsValues.noImageImg)
                                              : Image.file(File(imgPath +
                                                  _returnedList[index]
                                                      ['image'])),
                                        )
                                      else if (!GlobalVariables.viewImg)
                                        Container(
                                            margin: EdgeInsets.only(
                                                left: 3, top: 3),
                                            width: 75,
                                            color: Colors.white,
                                            child: Image(
                                                image: AssetsValues.noImageImg))
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 85),
                                        margin: EdgeInsets.only(left: 3),
                                        width:
                                            MediaQuery.of(context).size.width /
                                                    2 +
                                                50,
                                        // color: Colors.grey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              _returnedList[index]['item_desc'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 60,
                                                    child: Text(
                                                      _returnedList[index]
                                                          ['uom'],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  // SizedBox(
                                                  //   width: 5,
                                                  // ),
                                                  Container(
                                                    width: 80,
                                                    // color: Colors.grey,
                                                    child: Text(
                                                      formatCurrencyAmt.format(
                                                          double.parse(
                                                              _returnedList[
                                                                      index]
                                                                  ['amt'])),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                          color: Colors.green,
                                                          fontSize: 11,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
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
                                        margin: EdgeInsets.only(left: 0),
                                        // width: 105,
                                        // color: Colors.grey,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            // SizedBox(
                                            //   height: 40,
                                            // ),
                                            Visibility(
                                              visible: viewDisc,
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    width: 120,
                                                    height: 25,
                                                    // color: Colors.grey,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 75),
                                                      child: Container(
                                                        child: Stack(
                                                          children: <Widget>[
                                                            Image(
                                                              image: AssetsValues
                                                                  .discountImg,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            3),
                                                                child: Text(
                                                                  discount,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Visibility(
                                              visible: viewDisc,
                                              child: Row(
                                                children: <Widget>[
                                                  Container(
                                                    // color: Colors.grey,
                                                    width: 100,
                                                    height: 15,
                                                    padding: EdgeInsets.only(
                                                        right: 0),
                                                    child: Text(
                                                      formatCurrencyTot.format(
                                                          double.parse(
                                                              lineAmt)),
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        // fontStyle:
                                                        //     FontStyle.italic,
                                                        decoration: viewDisc
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : TextDecoration
                                                                .none,
                                                        decorationColor:
                                                            Colors.red,
                                                        decorationThickness: 2,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                SizedBox(
                                                  height: viewDisc ? 0 : 40,
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  child: Text(
                                                    itemQty,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                // SizedBox(
                                                //   width: 5,
                                                // ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: 10),
                                                  width: 100,
                                                  child: Text(
                                                    formatCurrencyTot.format(
                                                        double.parse(
                                                            lineTotal)),
                                                    textAlign: TextAlign.right,
                                                    style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FontStyle.italic),
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
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
        if (_unservedList.isEmpty && _returnedList.isEmpty) {
          return Container(
            padding: EdgeInsets.all(50),
            // margin: EdgeInsets.only(top: 100),
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            // color: Colors.deepOrange,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.not_interested,
                  size: 100,
                  color: Colors.grey[500],
                ),
                Text(
                  'No unserved or returned items.',
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
      }
    } else {
      if (viewSpinkit == true) {
        return Container(
          // height: 620,
          height: MediaQuery.of(context).size.height - 100,
          width: MediaQuery.of(context).size.width,
          color: Colors.white10,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 150,
                  // color: Colors.white10,
                  height: 150,
                  child: Image(
                    color: ColorsTheme.mainColor,
                    image: AssetsValues.cartImage,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      if (_list.isEmpty) {
        return Container(
          padding: EdgeInsets.all(50),
          margin: EdgeInsets.only(top: 100),
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          // color: Colors.deepOrange,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.not_interested,
                size: 100,
                color: Colors.grey[500],
              ),
              Text(
                'No Delivered items.',
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
        margin: EdgeInsets.only(top: 110),
        height: MediaQuery.of(context).size.height / 2 + 100,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 1),
          itemCount: _list.length,
          itemBuilder: (context, index) {
            if (!delPressed && !remPressed) {
              itemQty = _list[index]['req_qty'];
            }
            if (!reqPressed && !delPressed) {
              itemQty = (int.parse(_list[index]['req_qty']) -
                      int.parse(_list[index]['del_qty']))
                  .toString();
            }
            if (!reqPressed && !remPressed) {
              itemQty = _list[index]['del_qty'];
            }
            // if (itmCat != _list[index]['itm_cat']) {
            //   categ = false;
            //   itmCat = _list[index]['itm_cat'];
            // } else {
            //   categ = true;
            // }
            if (_list[index]['itm_cat'] == null ||
                _list[index]['itm_cat'] == 'null' ||
                _list[index]['itm_cat'] == '') {
              _list[index]['itm_cat'] = '';
            }
            categ = true;
            // print(_list[index]['image']);
            if (_list[index]['image'] == '') {
              noImage = true;
            } else {
              noImage = false;
            }
            if (delPressed == true) {
              if (_list[index]['flag'] == '1') {
                viewDisc = true;
                int x = 0;
                double discAmt = 0.00;
                double a = double.parse(_list[index]['discount']);
                x = a.toInt();
                discount = x.toString();

                //DISCOUNT COMPUTATION
                lineAmt =
                    (double.parse(_list[index]['amt']) * double.parse(itemQty))
                        .toString();
                discAmt = double.parse(lineAmt) * (a / 100);
                lineTotal = (double.parse(lineAmt) - discAmt).toString();
              } else {
                viewDisc = false;
                lineTotal =
                    (double.parse(_list[index]['amt']) * double.parse(itemQty))
                        .toString();
              }
            } else {
              lineTotal =
                  (double.parse(_list[index]['amt']) * double.parse(itemQty))
                      .toString();
            }

            // _list[index]['tot_amt'] = lineTotal;
            getTotal();

            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  // if (!categ)
                  //   Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     height: 20,
                  //     color: Colors.deepOrange,
                  //     child: Stack(
                  //       children: <Widget>[
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           crossAxisAlignment: CrossAxisAlignment.center,
                  //           children: <Widget>[
                  //             Container(
                  //               // width: 260,
                  //               // width: MediaQuery.of(context).size.width / 2,
                  //               margin: EdgeInsets.only(left: 5, top: 3),
                  //               child: Text(
                  //                 _list[index]['itm_cat'],
                  //                 textAlign: TextAlign.left,
                  //                 style: TextStyle(
                  //                     fontSize: 10,
                  //                     fontWeight: FontWeight.w400,
                  //                     color: Colors.white),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.end,
                  //           children: <Widget>[
                  //             Container(
                  //               // width: 50,
                  //               padding: EdgeInsets.only(right: 110),
                  //               margin: EdgeInsets.only(left: 5, top: 3),
                  //               child: Text(
                  //                 'Qty',
                  //                 textAlign: TextAlign.left,
                  //                 style: TextStyle(
                  //                     fontSize: 10,
                  //                     fontWeight: FontWeight.w400,
                  //                     color: Colors.white),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.end,
                  //           children: <Widget>[
                  //             Container(
                  //               // width: 50,
                  //               margin: EdgeInsets.only(left: 5, top: 3),
                  //               padding: EdgeInsets.only(right: 10),
                  //               child: Text(
                  //                 'Sub Total',
                  //                 textAlign: TextAlign.right,
                  //                 style: TextStyle(
                  //                     fontSize: 10,
                  //                     fontWeight: FontWeight.w400,
                  //                     color: Colors.white),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  Container(
                    margin: EdgeInsets.only(bottom: 5),
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            width: 1.0, color: ColorsTheme.mainColor),
                      ),
                      color: Colors.white,
                    ),
                    child: Stack(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 5,
                              height: 80,
                              color: ColorsTheme.mainColor,
                            ),
                            if (GlobalVariables.viewImg)
                              Container(
                                margin: EdgeInsets.only(left: 3, top: 3),
                                width: 75,
                                color: Colors.white,
                                child: noImage
                                    ? Image(image: AssetsValues.noImageImg)
                                    : Image.file(
                                        File(imgPath + _list[index]['image'])),
                              )
                            else if (!GlobalVariables.viewImg)
                              Container(
                                  margin: EdgeInsets.only(left: 3, top: 3),
                                  width: 75,
                                  color: Colors.white,
                                  child: Image(image: AssetsValues.noImageImg))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 85),
                              margin: EdgeInsets.only(left: 3),
                              width: MediaQuery.of(context).size.width / 2 + 50,
                              // color: Colors.grey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    _list[index]['item_desc'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 50,
                                          // color: Colors.grey,
                                          child: Text(
                                            _list[index]['uom'],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 5,
                                        // ),
                                        Container(
                                          // width: 80,
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  6 -
                                              10,
                                          // color: Colors.grey,
                                          child: Text(
                                            formatCurrencyAmt.format(
                                                double.parse(
                                                    _list[index]['amt'])),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal),
                                          ),
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
                              margin: EdgeInsets.only(left: 0),
                              // width: 105,
                              // color: Colors.grey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // SizedBox(
                                  //   height: 40,
                                  // ),
                                  Visibility(
                                    visible: viewDisc,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 120,
                                          height: 25,
                                          // color: Colors.grey,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 75),
                                            child: Container(
                                              child: Stack(
                                                children: <Widget>[
                                                  Image(
                                                    image: AssetsValues
                                                        .discountImg,
                                                  ),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 3),
                                                      child: Text(
                                                        discount,
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: viewDisc,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          // color: Colors.grey,
                                          width: 100,
                                          height: 15,
                                          padding: EdgeInsets.only(right: 0),
                                          child: Text(
                                            formatCurrencyTot
                                                .format(double.parse(lineAmt)),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              // fontStyle:
                                              //     FontStyle.italic,
                                              decoration: viewDisc
                                                  ? TextDecoration.lineThrough
                                                  : TextDecoration.none,
                                              decorationColor: Colors.red,
                                              decorationThickness: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      SizedBox(
                                        height: viewDisc ? 0 : 40,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Text(
                                          itemQty,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   width: 5,
                                      // ),
                                      Container(
                                        margin: EdgeInsets.only(right: 10),
                                        width: 100,
                                        child: Text(
                                          formatCurrencyTot
                                              .format(double.parse(lineTotal)),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
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
                ],
              ),
            );
          },
        ),
      );
    }
  }

  Container buildHeaderCont() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      // color: Colors.grey,
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: 50,
              height: 80,
              child: Icon(
                Icons.arrow_back,
                color: ColorsTheme.mainColor,
                size: 36,
              ),
            ),
          ),
          SizedBox(
            width: 15,
            // height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 100,
            height: 80,
            alignment: Alignment.centerLeft,
            // color: Colors.lightGreen,
            child: Text(
              "Orders and Tracking",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderTracking extends StatefulWidget {
  @override
  _OrderTrackingState createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTracking> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      backgroundColor: Colors.grey[100],
      child: trackContent(context),
    );
  }

  trackContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Order # ' + OrderData.trans!,
            style: TextStyle(
              color: ColorsTheme.mainColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Date/Time',
                style: TextStyle(
                    color: Colors.grey[700], fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: 60,
              ),
              Text(
                'Status',
                style: TextStyle(
                    color: Colors.grey[700], fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        if (OrderData.status == 'Pending' || OrderData.status == 'On-Process')
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  OrderData.dateReq!,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Submitted',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
        if (OrderData.status == 'Approved')
          Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      OrderData.dateReq!,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Submitted',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      OrderData.dateApp!,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Approved',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        if (OrderData.status == 'Delivered' || OrderData.status == 'Returned')
          Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      OrderData.dateReq!,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Submitted',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      OrderData.dateApp!,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      'Approved',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      OrderData.dateDel!,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      OrderData.status!,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ],
          ),
        SizedBox(
          height: 20,
        )
      ],
    );
    // return Stack(
    //   children: <Widget>[
    //     Container(
    //       // color: Colors.grey,
    //       padding: EdgeInsets.only(top: 50, bottom: 10, right: 5, left: 5),
    //       // height: 300,
    //       decoration: BoxDecoration(
    //           color: Colors.grey[50],
    //           shape: BoxShape.rectangle,
    //           borderRadius: BorderRadius.circular(20),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.black26,
    //               blurRadius: 10.0,
    //               offset: Offset(0.0, 10.0),
    //             ),
    //           ]),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: <Widget>[
    //           Container(
    //             // height: 70,
    //             margin: EdgeInsets.only(bottom: 5, top: 20),
    //             width: MediaQuery.of(context).size.width,
    //             color: Colors.white,
    //             // decoration: BoxDecoration(),
    //             child: Column(
    //               children: <Widget>[
    //                 Container(
    //                   height: 60,
    //                   padding: EdgeInsets.only(bottom: 10),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: <Widget>[
    //                       Container(
    //                         padding: EdgeInsets.only(left: 35, right: 45),
    //                         child: Text(
    //                           'Date   /   Time',
    //                           style: TextStyle(
    //                               fontWeight: FontWeight.bold, fontSize: 14),
    //                         ),
    //                       ),
    //                       Container(
    //                         padding: EdgeInsets.only(
    //                           left: 35,
    //                         ),
    //                         child: Text(
    //                           'Status',
    //                           style: TextStyle(
    //                               fontWeight: FontWeight.bold, fontSize: 14),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 if (OrderData.status == 'Pending' ||
    //                     OrderData.status == 'On-Process')
    //                   Container(
    //                     color: Colors.grey[300],
    //                     height: 60,
    //                     padding: EdgeInsets.only(bottom: 10),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: <Widget>[
    //                         Container(
    //                           padding: EdgeInsets.only(left: 30, right: 45),
    //                           child: Text(
    //                             OrderData.dateReq,
    //                             style: TextStyle(
    //                                 fontWeight: FontWeight.w500, fontSize: 12),
    //                           ),
    //                         ),
    //                         Container(
    //                           padding: EdgeInsets.only(
    //                             left: 30,
    //                           ),
    //                           child: Text(
    //                             'Submitted',
    //                             style: TextStyle(
    //                                 fontWeight: FontWeight.w500, fontSize: 14),
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ),
    //                 if (OrderData.status == 'Approved')
    //                   Column(
    //                     children: <Widget>[
    //                       Container(
    //                         color: Colors.grey[300],
    //                         height: 60,
    //                         padding: EdgeInsets.only(bottom: 10),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: <Widget>[
    //                             Container(
    //                               padding: EdgeInsets.only(left: 30, right: 45),
    //                               child: Text(
    //                                 OrderData.dateReq,
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 12),
    //                               ),
    //                             ),
    //                             Container(
    //                               padding: EdgeInsets.only(left: 30),
    //                               child: Text(
    //                                 'Submitted',
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 14),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       Container(
    //                         height: 60,
    //                         padding: EdgeInsets.only(bottom: 10),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: <Widget>[
    //                             Container(
    //                               padding: EdgeInsets.only(left: 30, right: 45),
    //                               child: Text(
    //                                 OrderData.dateApp,
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 12),
    //                               ),
    //                             ),
    //                             Container(
    //                               padding: EdgeInsets.only(
    //                                 left: 30,
    //                               ),
    //                               child: Text(
    //                                 'Approved',
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 14),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 if (OrderData.status == 'Delivered')
    //                   Column(
    //                     children: <Widget>[
    //                       Container(
    //                         color: Colors.grey[300],
    //                         height: 60,
    //                         padding: EdgeInsets.only(bottom: 10),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: <Widget>[
    //                             Container(
    //                               padding: EdgeInsets.only(left: 30, right: 45),
    //                               child: Text(
    //                                 OrderData.dateReq,
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 12),
    //                               ),
    //                             ),
    //                             Container(
    //                               padding: EdgeInsets.only(
    //                                 left: 30,
    //                               ),
    //                               child: Text(
    //                                 'Submitted',
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 14),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       Container(
    //                         height: 60,
    //                         padding: EdgeInsets.only(bottom: 10),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: <Widget>[
    //                             Container(
    //                               padding: EdgeInsets.only(left: 30, right: 45),
    //                               child: Text(
    //                                 OrderData.dateApp,
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 12),
    //                               ),
    //                             ),
    //                             Container(
    //                               padding: EdgeInsets.only(
    //                                 left: 30,
    //                               ),
    //                               child: Text(
    //                                 'Approved',
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 14),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                       Container(
    //                         color: Colors.grey[300],
    //                         height: 60,
    //                         padding: EdgeInsets.only(bottom: 10),
    //                         child: Row(
    //                           mainAxisAlignment: MainAxisAlignment.center,
    //                           children: <Widget>[
    //                             Container(
    //                               padding: EdgeInsets.only(left: 30, right: 45),
    //                               child: Text(
    //                                 OrderData.dateDel,
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 12),
    //                               ),
    //                             ),
    //                             Container(
    //                               padding: EdgeInsets.only(
    //                                 left: 30,
    //                               ),
    //                               child: Text(
    //                                 'Delivered',
    //                                 style: TextStyle(
    //                                     fontWeight: FontWeight.w500,
    //                                     fontSize: 14),
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     // Positioned(
    //     //   top: 0,
    //     //   right: 16,
    //     //   left: 16,
    //     //   child: CircleAvatar(
    //     //     backgroundColor: Colors.transparent,
    //     //     radius: 100,
    //     //     backgroundImage: AssetImage('assets/images/check2.gif'),
    //     //   ),
    //     // ),
    //     Container(
    //       padding: EdgeInsets.only(left: 10),
    //       height: 60,
    //       width: MediaQuery.of(context).size.width,
    //       // color: Colors.deepOrange,
    //       decoration: BoxDecoration(
    //           color: Colors.deepOrange,
    //           shape: BoxShape.rectangle,
    //           borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           Text(
    //             'Order # ' + OrderData.trans,
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 16,
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
