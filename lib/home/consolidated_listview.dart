import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesman/db/db_helper.dart';
// import 'package:salesman/home.dart';
import 'package:salesman/home/receivecons_dialog.dart';
// import 'package:salesman/menu.dart';
import 'package:salesman/userdata.dart';
import 'package:intl/intl.dart';
import 'package:salesman/variables/assets.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/elevated_button.dart';
import 'package:salesman/widgets/snackbar.dart';

class ConsolidatedListView extends StatefulWidget {
  @override
  _ConsolidatedListViewState createState() => _ConsolidatedListViewState();
}

class _ConsolidatedListViewState extends State<ConsolidatedListView> {
  String itmNo = "";
  String itmQty = "";
  String itmCat = "";
  String discount = "";

  bool unabletoEdit = true;
  bool qtyVisible = false;
  bool emptyCart = false;
  bool categ = false;
  bool appBool = false;
  bool viewDisc = false;
  bool viewSpinkit = true;
  bool tmpRet = true;
  bool noImage = false;

  var changeStat = 'Delivered';
  var tempRetAmt = 0.00;

  double sumHeight = 0;

  List _remlist = [];
  List _list = [];
  List _tranList = [];
  List _tranNoList = [];
  List _tempList = [];
  List _imgpath = [];

  String lineTotal = "0";
  String orderTotal = "0";
  String totalAmt = "0";
  String lineAmt = "0";
  String returnAmt = "0";
  String imgPath = "";

  final db = DatabaseHelper();

  final formatCurrencyAmt =
      new NumberFormat.currency(locale: "en_US", symbol: "₱");
  final formatCurrencyTot =
      new NumberFormat.currency(locale: "en_US", symbol: "Php ");

  void initState() {
    super.initState();
    if (!CustomerData.discounted) {
      sumHeight = 180;
    } else {
      sumHeight = 210;
    }
    CustomerData.tranNoList.clear();
    loadOrders();
    // loadImage();
  }

  loadOrders() async {
    itmNo = '0';
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + '/';
    imgPath = firstPath;
    if (OrderData.status == 'Approved') {
      lineTotal = "0";
      orderTotal = '0';
      var lineTot = 0.00;
      // print(CustomerData.accountCode);
      // print(OrderData.dateReq);
      var getT = await db.getTransactionNoList(
          CustomerData.accountCode, OrderData.dateReq);
      // _tranNoList = getT;
      _tranNoList = json.decode(json.encode(getT));
      CustomerData.tranNoList = json.decode(json.encode(_tranNoList));
      // print(CustomerData.tranNoList);
      var getO = await db.getConsolidatedApprovedRequestLine(
          CustomerData.accountCode, OrderData.dateReq);
      OrderData.itmno = '0';
      double discAmt = 0.00;
      OrderData.grandTotal = '0';
      OrderData.totalDisc = '0';
      OrderData.totamt = '0';
      OrderData.retAmt = '0';
      _remlist = json.decode(json.encode(getO));
      // print(_remlist);
      _list.clear();
      setState(() {
        _remlist.forEach((element) async {
          var getImg = await db.getItemImg(element['itm_code'], element['uom']);
          _imgpath = json.decode(json.encode(getImg));
          // print(element['itm_code']);
          element['image'] = _imgpath[0]['image'];
          setState(() {
            // print(_imgpath[0]['image']);
            itmCat = "";
            categ = false;
            lineAmt = '0';
            discAmt = 0.00;
            if (double.parse(element['total_qty'].toString()) != 0) {
              _list.add(json.decode(json.encode(element)));
              // print(element);
            }
            if (element['flag'] == "1") {
              lineAmt = '0';
              discAmt = 0.00;
              double a = double.parse(element['discount']);
              lineAmt = (double.parse(element['amt']) *
                      double.parse(element['total_qty'].toString()))
                  .toString();
              discAmt = double.parse(lineAmt) * (a / 100);
            }

            lineTot = double.parse(element['amt']) *
                double.parse(element['total_qty'].toString());
            orderTotal = (double.parse(orderTotal) + lineTot).toString();
            itmNo = _list.length.toString();
            // print(orderTotal);
            // print(orderTotal);
            // print(lineTot);

            // itmNo =
            //     (int.parse(itmNo) + int.parse(element['total_qty'])).toString();
            OrderData.itmno = itmNo;
            OrderData.totalDisc =
                (double.parse(OrderData.totalDisc) + discAmt).toString();
            OrderData.totamt = orderTotal;
            OrderData.grandTotal = (double.parse(OrderData.totamt) -
                    double.parse(OrderData.totalDisc))
                .toString();
          });
        });
      });

      tempRetAmt = double.parse(OrderData.grandTotal);
      OrderData.retAmt =
          (double.parse(OrderData.grandTotal) - tempRetAmt).toString();
    } else {
      var getO = await db.getOrders(UserData.trans);
      setState(() {
        _list = getO;
        // print(_list);
        orderTotal = OrderData.grandTotal;
        itmNo = _list.length.toString();
        // print(_list);
      });
    }

    viewSpinkit = false;
  }

  getTranNo() {
    _tranList.clear();
    _tempList.clear();
    _list.forEach((element) async {
      var getT = await db.getTranperLine(
          element['itm_code'], CustomerData.accountCode, OrderData.dateReq);
      _tempList = getT;
      _tempList.forEach((a) {
        if (_tranList.isEmpty) {
          _tranList.add(a['tran_no']);
          // print(a['tran_no']);
        } else {
          _tranList.forEach((a) {
            // print('YAWA');
            // print(a['tran_no']);
            //     print(b['tran_no'].toString());
            //     print(a['tran_no'].toString());
            //     // if (element['tran_no'].toString() != val['tran_no'].toString()) {
            //     //   _tranList.add(val['tran_no']);
            //     // }
          });
        }

        // print(_tranList);
      });
    });
  }

  computeTotal() {
    itmCat = "";
    categ = false;
    lineTotal = "0";
    itmNo = "0";
    orderTotal = '0';
    var lineTot = 0.00;

    double discAmt = 0.00;
    OrderData.grandTotal = '0';
    OrderData.totalDisc = '0';
    OrderData.totamt = '0';
    OrderData.retAmt = '0';
    // print(_list);
    _list.forEach((element) {
      setState(() {
        lineAmt = '0';
        discAmt = 0.00;
        if (element['flag'] == "1") {
          double a = double.parse(element['discount']);
          lineAmt = (double.parse(element['amt']) *
                  double.parse(element['total_qty'].toString()))
              .toString();
          discAmt = double.parse(lineAmt) * (a / 100);
          lineTot = double.parse(lineAmt) - discAmt;
          print(lineTot);
        }

        lineTot = double.parse(element['amt']) *
            double.parse(element['total_qty'].toString());
        orderTotal = (double.parse(orderTotal) + lineTot).toString();
        itmNo = _list.length.toString();
        // itmNo = (int.parse(itmNo) + int.parse(element['total_qty'])).toString();
        OrderData.itmno = itmNo;
        OrderData.totalDisc =
            (double.parse(OrderData.totalDisc) + discAmt).toString();
        OrderData.totamt = orderTotal;
        OrderData.grandTotal =
            (double.parse(OrderData.totamt) - double.parse(OrderData.totalDisc))
                .toString();
      });
    });

    OrderData.retAmt =
        (double.parse(OrderData.grandTotal) - tempRetAmt).toString();
  }

  showSnackBar(context, tran, itmCode, itmDesc, itmUom, itmAmt, itmQty,
      itmTotal, setCateg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
            '1 Item Deleted',
          ),
          action: SnackBarAction(
              label: "UNDO",
              onPressed: () {
                setState(() {
                  unDoDelete(tran, itmCode, itmDesc, itmUom, itmAmt, itmQty,
                      itmTotal, setCateg);
                });
              })),
    );
  }

  unDoDelete(
      tran, itmCode, itmDesc, itmUom, itmAmt, itmQty, itmTotal, setCateg) {
    setState(() {
      db.addQtytoLine(
          tran, itmCode, itmDesc, itmUom, itmAmt, itmQty, itmTotal, setCateg);
      db.deleteQtytoLog(tran, itmCode, itmUom, itmQty);
      refreshList();
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    itmCat = "";
    categ = false;
    loadOrders();
    // computeTotal();
    // return null;
  }

  // loadTemp() async {
  //   var getCart = await getTemp(UserData.id, CustomerData.accountCode);
  //   setState(() {
  //     _list = getCart;
  //     if (_list.isNotEmpty) {
  //       emptyCart = false;
  //     }
  //     // print(UserData.trans);
  //     computeTotal();
  //   });
  // }

  // loadImage() async {}

  @override
  Widget build(BuildContext context) {
    if (viewSpinkit == true) {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Center(
          child: SpinKitFadingCircle(
            color: Colors.deepOrange,
            size: 50,
          ),
        ),
      );
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              // physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  // buildHeaderCont(),
                  SizedBox(
                    height: 5,
                  ),
                  buildListViewCont(),
                ],
              ),
            ),
          ),
          Container(
            height: 160,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  buildHeaderCont(),
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
          height: sumHeight,
          // color: Colors.grey,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Container(
                // width: 200,
                height: sumHeight,
                // color: Colors.grey,
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
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                    Text(
                      'Gross Amount',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: qtyVisible,
                      child: Text(
                        'Return Amount',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                    ),
                    Visibility(
                      visible: qtyVisible,
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 5),
                width: MediaQuery.of(context).size.width / 2 + 40,
                height: sumHeight,
                // color: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      width: 200,
                      height: 15,
                      // color: Colors.grey,
                      child: ListView.builder(
                          itemCount: CustomerData.tranNoList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    CustomerData.tranNoList[index]['tran_no'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          }),
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
                      itmNo,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      formatCurrencyAmt.format(double.parse(OrderData.totamt)),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          // decoration: TextDecoration.underline,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Visibility(
                      visible: qtyVisible,
                      child: Text(
                        formatCurrencyAmt
                            .format(double.parse(OrderData.retAmt)),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            // decoration: TextDecoration.underline,
                            color: Colors.red),
                      ),
                    ),
                    Visibility(
                      visible: qtyVisible,
                      child: SizedBox(
                        height: 5,
                      ),
                    ),
                    Visibility(
                      visible: CustomerData.discounted,
                      child: Text(
                        '- ' +
                            formatCurrencyAmt
                                .format(double.parse(OrderData.totalDisc)),
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
                      formatCurrencyTot
                          .format(double.parse(OrderData.grandTotal)),
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Visibility(
                          visible: OrderData.visible,
                          child: Container(
                            height: 30,
                            child: ElevatedButton(
                              style: raisedButtonStyleBlack,
                              onPressed: () => {
                                if (unabletoEdit)
                                  {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Confirmation'),
                                            content: Text(
                                                'Are you sure you want to edit this transaction?'),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      sumHeight =
                                                          sumHeight + 20;
                                                      qtyVisible = true;
                                                      unabletoEdit = false;
                                                      itmCat = "";
                                                      categ = false;
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: Text('OK')),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Cancel')),
                                            ],
                                          );
                                        }),
                                  }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Edit Order",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 30,
                          child: ElevatedButton(
                            style: raisedButtonStyleGreen,
                            onPressed: () async {
                              if (_list.isEmpty) {
                                showGlobalSnackbar(
                                    'Information',
                                    'Unable to receive empty order.',
                                    Colors.blue,
                                    Colors.white);
                              } else {
                                ChequeData.payeeName = "";
                                ChequeData.payorName = "";
                                ChequeData.bankName = "";
                                ChequeData.chequeNum = "";
                                ChequeData.branchCode = "";
                                ChequeData.bankAccNo = "";
                                ChequeData.imgName = "";
                                ChequeData.changeImg = false;
                                OrderData.pmtype = "";
                                OrderData.signature = "";
                                OrderData.setPmType = false;
                                OrderData.setChequeImg = false;
                                showDialog(
                                    context: context,
                                    builder: (context) =>
                                        ReceivedConsolidatedDialog());
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Receive Order",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
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
        ),
      ),
    );
  }

  // Column buildSummaryCont(BuildContext context) {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       Container(
  //         width: MediaQuery.of(context).size.width,
  //         height: 150,
  //         color: Colors.white,
  //         child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             SizedBox(
  //               width: 5,
  //             ),
  //             Container(
  //               width: 200,
  //               height: 150,
  //               // color: Colors.grey,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 5,
  //                   ),
  //                   Text(
  //                     'Order Summary',
  //                     textAlign: TextAlign.left,
  //                     style:
  //                         TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  //                   ),
  //                   SizedBox(
  //                     height: 10,
  //                   ),
  //                   Text(
  //                     'Order No.',
  //                     textAlign: TextAlign.left,
  //                     style: TextStyle(
  //                         fontSize: 12, fontWeight: FontWeight.normal),
  //                   ),
  //                   SizedBox(
  //                     height: 5,
  //                   ),
  //                   Text(
  //                     'Payment Method',
  //                     textAlign: TextAlign.left,
  //                     style: TextStyle(
  //                         fontSize: 12, fontWeight: FontWeight.normal),
  //                   ),
  //                   SizedBox(
  //                     height: 5,
  //                   ),
  //                   Text(
  //                     'Item(s)',
  //                     textAlign: TextAlign.left,
  //                     style: TextStyle(
  //                         fontSize: 12, fontWeight: FontWeight.normal),
  //                   ),
  //                   SizedBox(
  //                     height: 5,
  //                   ),
  //                   Text(
  //                     'Grand Total',
  //                     textAlign: TextAlign.left,
  //                     style:
  //                         TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             Container(
  //               margin: EdgeInsets.only(right: 5),
  //               width: 200,
  //               height: 150,
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.end,
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 32,
  //                   ),
  //                   Text(
  //                     OrderData.trans,
  //                     textAlign: TextAlign.left,
  //                     style:
  //                         TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
  //                   ),
  //                   SizedBox(
  //                     height: 5,
  //                   ),
  //                   Text(
  //                     OrderData.pmeth,
  //                     textAlign: TextAlign.left,
  //                     style: TextStyle(
  //                         fontSize: 12,
  //                         color: Colors.green,
  //                         fontWeight: FontWeight.w500,
  //                         fontStyle: FontStyle.italic),
  //                   ),
  //                   SizedBox(
  //                     height: 5,
  //                   ),
  //                   Text(
  //                     itmNo,
  //                     textAlign: TextAlign.left,
  //                     style: TextStyle(
  //                       fontSize: 12,
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   SizedBox(
  //                     height: 5,
  //                   ),
  //                   Text(
  //                     formatCurrencyTot.format(double.parse(orderTotal)),
  //                     textAlign: TextAlign.left,
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w500,
  //                       decoration: TextDecoration.underline,
  //                     ),
  //                   ),
  //                   Container(
  //                     height: 30,
  //                     child: RaisedButton(
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(20)),
  //                       color: Colors.green,
  //                       // padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                       elevation: 10,
  //                       onPressed: () {},
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Text(
  //                             "Receive Order",
  //                             style: TextStyle(
  //                               fontSize: 16,
  //                               color: Colors.white,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Container buildListViewCont() {
    return Container(
      margin: EdgeInsets.only(top: 110),
      // color: Colors.amber,
      // height: 510,
      height: MediaQuery.of(context).size.height - (sumHeight * 2) + 20,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 1),
        itemCount: _list.length,
        itemBuilder: (context, index) {
          if (OrderData.status == 'Approved') {
            itmQty = _list[index]['total_qty'].toString();
            appBool = true;
            // print(itmQty);
          } else {
            itmQty = _list[index]['req_qty'];
            appBool = false;
          }
          // itmQty = _list[index]['req_qty'];
          if (itmCat != _list[index]['itm_cat']) {
            categ = false;
            itmCat = _list[index]['itm_cat'];
          } else {
            categ = true;
          }
          if (_list[index]['image'] == '') {
            // print(_list[index]['image']);
            noImage = true;
          } else {
            noImage = false;
          }

          if (_list[index]['flag'] == '1') {
            viewDisc = true;
            int x = 0;
            double discAmt = 0.00;
            double a = double.parse(_list[index]['discount']);
            x = a.toInt();
            discount = x.toString();

            //DISCOUNT COMPUTATION
            lineAmt = (double.parse(_list[index]['amt']) * double.parse(itmQty))
                .toString();
            discAmt = double.parse(lineAmt) * (a / 100);
            lineTotal = (double.parse(lineAmt) - discAmt).toString();
          } else {
            viewDisc = false;
            lineTotal =
                (double.parse(_list[index]['amt']) * double.parse(itmQty))
                    .toString();
          }

          _list[index]['tot_amt'] = lineTotal;

          final item = _list[index].toString();

          return InkWell(
            onTap: () async {
              var getT = await db.getTranperLine(_list[index]['itm_code'],
                  CustomerData.accountCode, OrderData.dateReq);
              OrderData.tranLine = getT;
              OrderData.pmtype = "";
              // print(OrderData.tranLine.length);
              showDialog(
                  context: context, builder: (context) => PopupTranperLine());
            },
            child: AbsorbPointer(
              absorbing: unabletoEdit,
              child: Dismissible(
                background: Container(
                  alignment: AlignmentDirectional.centerEnd,
                  color: Colors.deepOrange,
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                direction: DismissDirection.endToStart,
                key: Key(item),
                onDismissed: (direction) {
                  var tran = OrderData.trans;
                  var itmcode = _list[index]['itm_code'].toString();
                  var itmdesc = _list[index]['item_desc'].toString();
                  var itmuom = _list[index]['uom'].toString();
                  var itmamt = _list[index]['amt'].toString();
                  var itmqty = _list[index]['total_qty'].toString();
                  var itmtot = _list[index]['tot_amt'].toString();
                  var itmcat = _list[index]['itm_cat'].toString();
                  showSnackBar(
                    context,
                    tran,
                    itmcode,
                    itmdesc,
                    itmuom,
                    itmamt,
                    itmqty,
                    itmtot,
                    itmcat,
                  );

                  setState(() {
                    db.addtoUnserved(
                        OrderData.trans,
                        _list[index]['itm_code'].toString(),
                        _list[index]['item_desc'].toString(),
                        _list[index]['uom'].toString(),
                        _list[index]['amt'].toString(),
                        _list[index]['total_qty'].toString(),
                        _list[index]['tot_amt'].toString(),
                        _list[index]['itm_cat'].toString());
                    db.minusQtytoLine(
                        OrderData.trans,
                        _list[index]['itm_code'].toString(),
                        _list[index]['uom'].toString(),
                        "0");
                    _list.removeAt(index);

                    computeTotal();
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Column(
                    children: <Widget>[
                      if (!categ)
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 20,
                          color: Colors.deepOrange,
                          child: Stack(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    // width: 260,
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.only(left: 5),
                                    child: Text(
                                      _list[index]['itm_cat'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    // width: 50,
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.only(right: 10),
                                    child: Text(
                                      'Sub Total',
                                      textAlign: TextAlign.right,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    // width: 50,
                                    padding: EdgeInsets.all(3),
                                    margin: EdgeInsets.only(right: 110),
                                    child: Text(
                                      'Qty',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      Container(
                        margin: EdgeInsets.only(bottom: 5),
                        height: 70,
                        // color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: Stack(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 5,
                                  height: 80,
                                  color: Colors.deepOrange,
                                ),
                                if (GlobalVariables.viewImg)
                                  Container(
                                    margin: EdgeInsets.only(left: 3, top: 3),
                                    width: 75,
                                    child: noImage
                                        ? Image(image: AssetsValues.noImageImg)
                                        : Image.file(File(
                                            imgPath + _list[index]['image'])),
                                  )
                                else if (!GlobalVariables.viewImg)
                                  Container(
                                      margin: EdgeInsets.only(left: 3, top: 3),
                                      width: 75,
                                      color: Colors.white,
                                      child:
                                          Image(image: AssetsValues.noImageImg))
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 85),
                                  margin: EdgeInsets.only(left: 3),
                                  // width: 180,
                                  // color: Colors.green,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width: 200,
                                        child: Text(
                                          _list[index]['item_desc'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                          // overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              // color: Colors.grey,
                                              width: 60,
                                              child: Text(
                                                _list[index]['uom'],
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
                                              width: 60,
                                              // color: Colors.grey,
                                              child: Text(
                                                formatCurrencyAmt.format(
                                                    double.parse(
                                                        _list[index]['amt'])),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.normal),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(right: 0),
                                  // width: 105,
                                  // color: Colors.grey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      // SizedBox(
                                      //   height: 40,
                                      // ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Visibility(
                                                    visible: qtyVisible,
                                                    child: Container(
                                                      width: 50,
                                                      height: 10,
                                                      // color: Colors.grey,
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: viewDisc,
                                                    child: Container(
                                                      width: 120,
                                                      height: 25,
                                                      // color: Colors.black,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 75),
                                                        child: Container(
                                                          // width: 10,
                                                          // height: 25,
                                                          // color: Colors.black,
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
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left: 3),
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
                                                  ),
                                                ],
                                              ),
                                              Visibility(
                                                visible: viewDisc,
                                                child: Row(
                                                  children: <Widget>[
                                                    Visibility(
                                                      visible: qtyVisible,
                                                      child: Container(
                                                        width: 50,
                                                        height: 10,
                                                        // color: Colors.grey,
                                                      ),
                                                    ),
                                                    Container(
                                                      // color: Colors.grey,
                                                      width: 125,
                                                      height: 15,
                                                      padding: EdgeInsets.only(
                                                          right: 5),
                                                      child: Text(
                                                        formatCurrencyTot
                                                            .format(
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
                                                          decorationThickness:
                                                              2,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  SizedBox(
                                                    height: viewDisc ? 0 : 30,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Visibility(
                                            visible: qtyVisible,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (int.parse(_list[index]
                                                              ['total_qty']
                                                          .toString()) ==
                                                      1) {
                                                    print(
                                                        'Swipe left to Remove item!');
                                                    itmCat = "";
                                                    categ = false;
                                                    showGlobalSnackbar(
                                                        'Information',
                                                        'Swipe left to remove item.',
                                                        Colors.blue,
                                                        Colors.white);
                                                  } else {
                                                    if (int.parse(_list[index]
                                                                ['total_qty']
                                                            .toString()) >
                                                        1) {
                                                      var i = int.parse(_list[
                                                                      index]
                                                                  ['total_qty']
                                                              .toString()) -
                                                          1;
                                                      _list[index]
                                                              ['total_qty'] =
                                                          i.toString();
                                                      db.addtoUnserved(
                                                          OrderData.trans,
                                                          _list[index]
                                                                  ['itm_code']
                                                              .toString(),
                                                          _list[index]
                                                                  ['item_desc']
                                                              .toString(),
                                                          _list[index]['uom']
                                                              .toString(),
                                                          _list[index]['amt']
                                                              .toString(),
                                                          "1",
                                                          _list[index]['amt']
                                                              .toString(),
                                                          _list[index]
                                                                  ['itm_cat']
                                                              .toString());
                                                      db.minusQtytoLine(
                                                          OrderData.trans,
                                                          _list[index]
                                                                  ['itm_code']
                                                              .toString(),
                                                          _list[index]['uom']
                                                              .toString(),
                                                          _list[index]
                                                                  ['total_qty']
                                                              .toString());

                                                      computeTotal();
                                                    } else {
                                                      setState(() {
                                                        db.addtoUnserved(
                                                            OrderData.trans,
                                                            _list[index]
                                                                    ['itm_code']
                                                                .toString(),
                                                            _list[index][
                                                                    'item_desc']
                                                                .toString(),
                                                            _list[index]['uom']
                                                                .toString(),
                                                            _list[index]['amt']
                                                                .toString(),
                                                            "1",
                                                            _list[index]['amt']
                                                                .toString(),
                                                            _list[index]
                                                                    ['itm_cat']
                                                                .toString());
                                                        db.minusQtytoLine(
                                                            OrderData.trans,
                                                            _list[index]
                                                                    ['itm_code']
                                                                .toString(),
                                                            _list[index]['uom']
                                                                .toString(),
                                                            "0");

                                                        _list.removeAt(index);
                                                        computeTotal();
                                                      });
                                                    }
                                                  }
                                                });
                                              },
                                              child: Container(
                                                child: Icon(
                                                  Icons.indeterminate_check_box,
                                                  color: ColorsTheme.mainColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: 25,
                                            // color: Colors.grey,
                                            // padding: EdgeInsets.only(right: 20),
                                            child: Text(
                                              appBool
                                                  ? _list[index]['total_qty']
                                                      .toString()
                                                  : _list[index]['req_qty'],
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          Visibility(
                                            visible: qtyVisible,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (int.parse(_list[index]
                                                              ['total_qty']
                                                          .toString()) >=
                                                      int.parse(_list[index]
                                                          ['temp_qty'])) {
                                                    itmCat = "";
                                                    categ = false;
                                                  } else {
                                                    setState(() {
                                                      var i = int.parse(_list[
                                                                      index]
                                                                  ['total_qty']
                                                              .toString()) +
                                                          1;
                                                      _list[index]
                                                              ['total_qty'] =
                                                          i.toString();
                                                      // print(_list[index]
                                                      //     ['temp_qty']);
                                                      db.addQtytoLine(
                                                          OrderData.trans,
                                                          _list[index]
                                                                  ['itm_code']
                                                              .toString(),
                                                          _list[index]
                                                                  ['item_desc']
                                                              .toString(),
                                                          _list[index]['uom']
                                                              .toString(),
                                                          _list[index]['amt']
                                                              .toString(),
                                                          "1",
                                                          _list[index]['amt']
                                                              .toString(),
                                                          _list[index]
                                                                  ['itm_cat']
                                                              .toString());
                                                      db.deleteQtytoLog(
                                                          OrderData.trans,
                                                          _list[index]
                                                                  ['itm_code']
                                                              .toString(),
                                                          _list[index]['uom']
                                                              .toString(),
                                                          "1");
                                                      computeTotal();
                                                    });
                                                  }
                                                });
                                              },
                                              child: Container(
                                                child: Icon(
                                                  Icons.add_box,
                                                  color: ColorsTheme.mainColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   width: 5,
                                          // ),
                                          Container(
                                            // color: Colors.grey,
                                            width: 100,
                                            padding: EdgeInsets.only(right: 5),
                                            child: Text(
                                              formatCurrencyTot.format(
                                                  double.parse(lineTotal)),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
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
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Container buildHeaderCont() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      // color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              GlobalVariables.menuKey = 0;
              GlobalVariables.viewPolicy = false;
              // print('CLICKED!');
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return Menu();
              // }));
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //     '/hepemenu', (Route<dynamic> route) => false);
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
          ),
          Container(
            width: MediaQuery.of(context).size.width - 100,
            height: 80,
            alignment: Alignment.center,
            // color: Colors.lightGreen,
            child: Text(
              UserData.sname! + "'S ORDER",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class ConfirmBox extends StatefulWidget {
//   final String title, description, buttonText;

//   ConfirmBox({this.title, this.description, this.buttonText});

//   @override
//   _ConfirmBoxState createState() => _ConfirmBoxState();
// }

// class _ConfirmBoxState extends State<ConfirmBox> {
//   final db = DatabaseHelper();
//   final String changeStat = 'Delivered';

//   final formatCurrencyTot =
//       new NumberFormat.currency(locale: "en_US", symbol: "Php ");

//   final String date =
//       DateFormat("yyyy-MM-dd H:mm:ss").format(new DateTime.now());

//   setStatus() {
//     if (CustomerData.discounted == true) {
//       CustomerData.tranNoList.forEach((element) {
//         if (element['disc_total'] == '0.00') {
//           var result = db.getStatus(
//               element['tran_no'],
//               changeStat,
//               element['total'],
//               OrderData.itmno,
//               date,
//               OrderData.pmtype,
//               OrderData.signature);
//           print(result);
//         } else {
//           var result = db.getStatus(
//               element['tran_no'],
//               changeStat,
//               element['disc_total'],
//               OrderData.itmno,
//               date,
//               OrderData.pmtype,
//               OrderData.signature);
//           print(result);
//         }

//         ChequeData.status = "Pending";
//         if (OrderData.pmtype == "CHEQUE") {
//           db.addCheque(
//               element['tran_no'],
//               CustomerData.accountCode,
//               OrderData.smcode,
//               UserData.id,
//               date,
//               ChequeData.payeeName,
//               ChequeData.payorName,
//               ChequeData.bankName,
//               ChequeData.chequeNum,
//               ChequeData.branchCode,
//               ChequeData.bankAccNo,
//               ChequeData.chequeDate,
//               element['disc_total'],
//               ChequeData.status,
//               ChequeData.imgName);
//         }
//       });
//     } else {
//       CustomerData.tranNoList.forEach((element) {
//         var result = db.getStatus(
//             element['tran_no'],
//             changeStat,
//             element['total'],
//             OrderData.itmno,
//             date,
//             OrderData.pmtype,
//             OrderData.signature);
//         print(result);
//         ChequeData.status = "Pending";
//         if (OrderData.pmtype == "CHEQUE") {
//           db.addCheque(
//               element['tran_no'],
//               CustomerData.accountCode,
//               OrderData.smcode,
//               UserData.id,
//               date,
//               ChequeData.payeeName,
//               ChequeData.payorName,
//               ChequeData.bankName,
//               ChequeData.chequeNum,
//               ChequeData.branchCode,
//               ChequeData.bankAccNo,
//               ChequeData.chequeDate,
//               element['total'],
//               ChequeData.status,
//               ChequeData.imgName);
//         }
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: confirmContent(context),
//     );
//   }

//   confirmContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           padding: EdgeInsets.only(top: 50, bottom: 16, right: 5, left: 5),
//           margin: EdgeInsets.only(top: 16),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: Offset(0.0, 10.0),
//                 ),
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 margin: EdgeInsets.only(bottom: 5),
//                 height: 70,
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.white,
//                 // decoration: BoxDecoration(),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Container(
//                       child: Text(
//                         widget.description,
//                         style: TextStyle(
//                             fontSize: 12, fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     RaisedButton(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                       color: Colors.deepOrange,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                       onPressed: () => {
//                         setStatus(),
//                         showDialog(
//                             context: context,
//                             builder: (context) => SuccessBox(
//                                   title: 'Success!',
//                                   description:
//                                       'Transaction has been saved successfully.',
//                                   buttonText: 'Ok',
//                                 )),
//                       },
//                       child: Text(
//                         widget.buttonText,
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     RaisedButton(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           side: BorderSide(color: Colors.deepOrange)),
//                       color: Colors.white,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(color: Colors.deepOrange),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.only(left: 10),
//           height: 40,
//           width: MediaQuery.of(context).size.width,
//           // color: Colors.deepOrange,
//           decoration: BoxDecoration(
//               color: Colors.deepOrange,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 widget.title,
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   successContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           height: MediaQuery.of(context).size.height,
//           padding: EdgeInsets.only(top: 50, bottom: 16, right: 5, left: 5),
//           margin: EdgeInsets.only(top: 16),
//           decoration: BoxDecoration(
//               color: Colors.grey[50],
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: Offset(0.0, 10.0),
//                 ),
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Container(
//                 height: 70,
//                 margin: EdgeInsets.only(bottom: 5),
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.white,
//                 // decoration: BoxDecoration(),
//                 child: Row(
//                   children: <Widget>[
//                     Container(
//                       width: 3,
//                       height: MediaQuery.of(context).size.height,
//                       color: Colors.deepOrange,
//                     ),
//                     Container(
//                       margin: EdgeInsets.all(10),
//                       width: 40,
//                       height: 40,
//                       child: Image(
//                         image: AssetImage('assets/images/wpf_name.png'),
//                       ),
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           OrderData.name,
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                         Text(
//                           OrderData.address,
//                           style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(bottom: 5),
//                 height: 70,
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.white,
//                 // decoration: BoxDecoration(),
//                 child: Row(
//                   children: <Widget>[
//                     Container(
//                       width: 3,
//                       height: MediaQuery.of(context).size.height,
//                       color: Colors.deepOrange,
//                     ),
//                     Container(
//                       margin: EdgeInsets.all(10),
//                       width: 40,
//                       height: 40,
//                       child: Image(
//                         image: AssetImage('assets/images/peso.png'),
//                       ),
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           'Amount',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                         Text(
//                           formatCurrencyTot
//                               .format(double.parse(OrderData.grandTotal)),
//                           style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(bottom: 5),
//                 height: 70,
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.white,
//                 // decoration: BoxDecoration(),
//                 child: Row(
//                   children: <Widget>[
//                     Container(
//                       width: 3,
//                       height: MediaQuery.of(context).size.height,
//                       color: Colors.deepOrange,
//                     ),
//                     Container(
//                       margin: EdgeInsets.all(10),
//                       width: 40,
//                       height: 40,
//                       child: Image(
//                         image: AssetImage('assets/images/payment.png'),
//                       ),
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           'Payment Method',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                         Text(
//                           OrderData.pmeth,
//                           style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color: Colors.grey),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(bottom: 5),
//                 height: 70,
//                 width: MediaQuery.of(context).size.width,
//                 color: Colors.grey,
//                 // decoration: BoxDecoration(),
//                 child: Row(
//                   children: <Widget>[
//                     Container(
//                       width: 3,
//                       height: MediaQuery.of(context).size.height,
//                       color: Colors.deepOrange,
//                     ),
//                     Container(
//                       margin: EdgeInsets.all(10),
//                       width: 40,
//                       height: 40,
//                       child: Image(
//                         image: AssetImage('assets/images/sign.png'),
//                       ),
//                     ),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           'Signature',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     RaisedButton(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20)),
//                       color: Colors.deepOrange,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                       onPressed: () => {
//                         showDialog(
//                             context: context,
//                             builder: (context) => ConfirmBox(
//                                   title: 'Confirmation',
//                                   description:
//                                       'Are you sure you want to save this transaction?',
//                                   buttonText: 'Confirm',
//                                 )),
//                       },
//                       child: Text(
//                         'Receive',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 5,
//                     ),
//                     RaisedButton(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                           side: BorderSide(color: Colors.deepOrange)),
//                       color: Colors.white,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text(
//                         'Cancel',
//                         style: TextStyle(color: Colors.deepOrange),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.only(left: 10),
//           height: 60,
//           width: MediaQuery.of(context).size.width,
//           // color: Colors.deepOrange,
//           decoration: BoxDecoration(
//               color: Colors.deepOrange,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 'Receiving & Payment',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class SuccessBox extends StatelessWidget {
//   final String title, description, buttonText;

//   final db = Home();

//   SuccessBox({this.title, this.description, this.buttonText});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       // child: confirmContent(context),
//       child: successContent(context),
//     );
//   }

//   successContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           width: MediaQuery.of(context).size.width,
//           padding: EdgeInsets.only(top: 50, bottom: 16, right: 5, left: 5),
//           margin: EdgeInsets.only(top: 16),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: Offset(0.0, 10.0),
//                 ),
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Container(
//                 margin: EdgeInsets.only(top: 40),
//                 child: Text(
//                   title,
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Container(
//                 margin: EdgeInsets.only(top: 40),
//                 child: Text(
//                   description,
//                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               RaisedButton(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20)),
//                 color: Colors.deepOrange,
//                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                 onPressed: () => {
//                   // Navigator.pop(context),
//                   GlobalVariables.processedPressed = true,
//                   GlobalVariables.menuKey = 0,
//                   GlobalVariables.viewPolicy = false,

//                   // Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   //   return Menu();
//                   // })),
//                   Navigator.pushAndRemoveUntil(
//                       context,
//                       MaterialPageRoute(
//                           builder: (BuildContext context) => Menu()),
//                       ModalRoute.withName('/hepemenu')),
//                   // Navigator.pop(context),
//                 },
//                 child: Text(
//                   'OK',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Positioned(
//           top: 0,
//           right: 16,
//           left: 16,
//           child: CircleAvatar(
//             backgroundColor: Colors.transparent,
//             radius: 50,
//             backgroundImage: AssetImage('assets/images/gif1.gif'),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ChequeDialog extends StatefulWidget {
//   @override
//   _ChequeDialogState createState() => _ChequeDialogState();
// }

// class _ChequeDialogState extends State<ChequeDialog> {
//   DateTime pickedDate;
//   bool emptyStat = true;
//   List _banklist = [];

//   final db = DatabaseHelper();

//   final formatCurrencyTot =
//       new NumberFormat.currency(locale: "en_US", symbol: "Php ");

//   @override
//   void initState() {
//     super.initState();
//     _banklist.clear();
//     pickedDate = DateTime.now();
//     loadBankList();
//   }

//   loadBankList() async {
//     var blist = await db.getBankList();
//     setState(() {
//       _banklist = blist;
//       print(_banklist);
//       ChequeData.bankName = "Allied Bank";
//     });
//     ChequeData.chequeDate = pickedDate.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: chequeContent(context),
//     );
//   }

//   chequeContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           // height: MediaQuery.of(context).size.height - 50,
//           padding: EdgeInsets.only(top: 65, bottom: 10, right: 5, left: 5),
//           // margin: EdgeInsets.only(top: 16),
//           decoration: BoxDecoration(
//               color: Colors.grey[50],
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: Offset(0.0, 10.0),
//                 ),
//               ]),
//           child: Stack(
//             children: <Widget>[
//               SingleChildScrollView(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: <Widget>[
//                     //PAYEE NAME
//                     Container(
//                       height: 65,
//                       margin: EdgeInsets.only(bottom: 5),
//                       width: MediaQuery.of(context).size.width,
//                       color: Colors.white,
//                       // decoration: BoxDecoration(),
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: 3,
//                             height: MediaQuery.of(context).size.height,
//                             color: Colors.deepOrange,
//                           ),
//                           Container(
//                             margin: EdgeInsets.all(10),
//                             width: 40,
//                             height: 40,
//                             child: Image(
//                               image: AssetImage('assets/images/wpf_name.png'),
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                 // color: Colors.grey,
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Text(
//                                   'Payee Name',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Container(
//                                 width:
//                                     MediaQuery.of(context).size.width / 2 + 50,
//                                 height: 30,
//                                 child: TextFormField(
//                                   initialValue: ChequeData.payeeName,
//                                   // textCapitalization:
//                                   //     TextCapitalization.characters,
//                                   inputFormatters: [
//                                     // new WhitelistingTextInputFormatter(
//                                     //     RegExp("[a-zA-Z ]")),
//                                     FilteringTextInputFormatter.allow(
//                                         RegExp("[a-zA-Z ]"))
//                                   ],
//                                   onChanged: (String str) {
//                                     ChequeData.payeeName = str.toUpperCase();
//                                   },
//                                   decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.fromLTRB(
//                                           5.0, 0.0, 5.0, 0.0),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide:
//                                             BorderSide(color: Colors.grey),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(0)),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide:
//                                             BorderSide(color: Colors.black87),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(0)),
//                                       ),
//                                       hintText: 'Enter Payee Name'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     //PAYOR NAME
//                     Container(
//                       height: 65,
//                       margin: EdgeInsets.only(bottom: 5),
//                       width: MediaQuery.of(context).size.width,
//                       color: Colors.white,
//                       // decoration: BoxDecoration(),
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: 3,
//                             height: MediaQuery.of(context).size.height,
//                             color: Colors.deepOrange,
//                           ),
//                           Container(
//                             margin: EdgeInsets.all(10),
//                             width: 40,
//                             height: 40,
//                             child: Image(
//                               image: AssetImage('assets/images/wpf_name.png'),
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                 // color: Colors.grey,
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Text(
//                                   'Payor Name',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Container(
//                                 width:
//                                     MediaQuery.of(context).size.width / 2 + 50,
//                                 height: 30,
//                                 child: TextFormField(
//                                   initialValue: ChequeData.payorName,
//                                   inputFormatters: [
//                                     // new WhitelistingTextInputFormatter(
//                                     //     RegExp("[a-zA-Z ]"))
//                                     FilteringTextInputFormatter.allow(
//                                         RegExp("[a-zA-Z ]"))
//                                   ],
//                                   onChanged: (String str) {
//                                     ChequeData.payorName = str.toUpperCase();
//                                   },
//                                   decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.fromLTRB(
//                                           5.0, 0.0, 5.0, 0.0),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide:
//                                             BorderSide(color: Colors.grey),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(0)),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide:
//                                             BorderSide(color: Colors.black87),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(0)),
//                                       ),
//                                       hintText: 'Enter Payor Name'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     //BANK NAME
//                     Container(
//                       height: 65,
//                       margin: EdgeInsets.only(bottom: 5),
//                       width: MediaQuery.of(context).size.width,
//                       color: Colors.white,
//                       // decoration: BoxDecoration(),
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: 3,
//                             height: MediaQuery.of(context).size.height,
//                             color: Colors.deepOrange,
//                           ),
//                           Container(
//                             margin: EdgeInsets.all(10),
//                             width: 40,
//                             height: 40,
//                             child: Image(
//                               image: AssetImage('assets/images/bank.png'),
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                 // color: Colors.grey,
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Text(
//                                   'Bank Name',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Container(
//                                 // color: Colors.grey,
//                                 width:
//                                     MediaQuery.of(context).size.width / 2 + 50,
//                                 height: 30,
//                                 child: DropdownButtonHideUnderline(
//                                   child: ButtonTheme(
//                                     alignedDropdown: true,
//                                     child: DropdownButton<String>(
//                                       value: ChequeData.bankName,
//                                       items: _banklist?.map((item) {
//                                             return new DropdownMenuItem(
//                                               child: new Text(
//                                                 item['bank_name'],
//                                                 style: TextStyle(
//                                                   fontSize: 11,
//                                                   fontWeight: FontWeight.w500,
//                                                 ),
//                                                 // overflow: TextOverflow.ellipsis,
//                                               ),
//                                               value:
//                                                   item['bank_name'].toString(),
//                                             );
//                                           })?.toList() ??
//                                           [],
//                                       onChanged: (String newV) {
//                                         setState(() {
//                                           ChequeData.bankName = newV;
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 // TextFormField(
//                                 //   initialValue: ChequeData.bankName,
//                                 //   inputFormatters: [
//                                 //     new WhitelistingTextInputFormatter(
//                                 //         RegExp("[a-zA-Z ]"))
//                                 //   ],
//                                 //   onChanged: (String str) {
//                                 //     ChequeData.bankName = str.toUpperCase();
//                                 //   },
//                                 //   decoration: InputDecoration(
//                                 //       contentPadding: EdgeInsets.fromLTRB(
//                                 //           5.0, 0.0, 5.0, 0.0),
//                                 //       enabledBorder: OutlineInputBorder(
//                                 //         borderSide:
//                                 //             BorderSide(color: Colors.grey),
//                                 //         borderRadius: BorderRadius.all(
//                                 //             Radius.circular(0)),
//                                 //       ),
//                                 //       focusedBorder: OutlineInputBorder(
//                                 //         borderSide:
//                                 //             BorderSide(color: Colors.black87),
//                                 //         borderRadius: BorderRadius.all(
//                                 //             Radius.circular(0)),
//                                 //       ),
//                                 //       hintText: 'Enter Bank Name'),
//                                 // ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     //CHEQUE NO.
//                     Container(
//                       height: 65,
//                       margin: EdgeInsets.only(bottom: 5),
//                       width: MediaQuery.of(context).size.width,
//                       color: Colors.white,
//                       // decoration: BoxDecoration(),
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: 3,
//                             height: MediaQuery.of(context).size.height,
//                             color: Colors.deepOrange,
//                           ),
//                           Container(
//                             margin: EdgeInsets.all(10),
//                             width: 40,
//                             height: 40,
//                             child: Image(
//                               image: AssetImage('assets/images/cheque.png'),
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                 // color: Colors.grey,
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Text(
//                                   'Cheque No.',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Container(
//                                 width:
//                                     MediaQuery.of(context).size.width / 2 + 50,
//                                 height: 30,
//                                 child: TextFormField(
//                                   initialValue: ChequeData.chequeNum,
//                                   inputFormatters: <TextInputFormatter>[
//                                     FilteringTextInputFormatter.digitsOnly
//                                   ],
//                                   onChanged: (String str) {
//                                     ChequeData.chequeNum = str;
//                                   },
//                                   decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.fromLTRB(
//                                           5.0, 0.0, 5.0, 0.0),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide:
//                                             BorderSide(color: Colors.grey),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(0)),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide:
//                                             BorderSide(color: Colors.black87),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(0)),
//                                       ),
//                                       hintText: 'Enter Cheque No.'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     //BRANCH SORT CODE
//                     // Container(
//                     //   height: 65,
//                     //   margin: EdgeInsets.only(bottom: 5),
//                     //   width: MediaQuery.of(context).size.width,
//                     //   color: Colors.white,
//                     //   // decoration: BoxDecoration(),
//                     //   child: Row(
//                     //     children: <Widget>[
//                     //       Container(
//                     //         width: 3,
//                     //         height: MediaQuery.of(context).size.height,
//                     //         color: Colors.deepOrange,
//                     //       ),
//                     //       Container(
//                     //         margin: EdgeInsets.all(10),
//                     //         width: 40,
//                     //         height: 40,
//                     //         child: Image(
//                     //           image: AssetImage('assets/images/cheque.png'),
//                     //         ),
//                     //       ),
//                     //       Column(
//                     //         mainAxisAlignment: MainAxisAlignment.center,
//                     //         crossAxisAlignment: CrossAxisAlignment.start,
//                     //         children: <Widget>[
//                     //           Container(
//                     //             // color: Colors.grey,
//                     //             width: MediaQuery.of(context).size.width / 2,
//                     //             child: Text(
//                     //               'MICR(branch) Code',
//                     //               style: TextStyle(
//                     //                   fontSize: 16,
//                     //                   fontWeight: FontWeight.w500),
//                     //               overflow: TextOverflow.ellipsis,
//                     //             ),
//                     //           ),
//                     //           Container(
//                     //             width:
//                     //                 MediaQuery.of(context).size.width / 2 + 50,
//                     //             height: 30,
//                     //             child: TextFormField(
//                     //               initialValue: ChequeData.branchCode,
//                     //               inputFormatters: <TextInputFormatter>[
//                     //                 WhitelistingTextInputFormatter.digitsOnly
//                     //               ],
//                     //               onChanged: (String str) {
//                     //                 ChequeData.branchCode = str;
//                     //               },
//                     //               decoration: InputDecoration(
//                     //                   contentPadding: EdgeInsets.fromLTRB(
//                     //                       5.0, 0.0, 5.0, 0.0),
//                     //                   enabledBorder: OutlineInputBorder(
//                     //                     borderSide:
//                     //                         BorderSide(color: Colors.grey),
//                     //                     borderRadius: BorderRadius.all(
//                     //                         Radius.circular(0)),
//                     //                   ),
//                     //                   focusedBorder: OutlineInputBorder(
//                     //                     borderSide:
//                     //                         BorderSide(color: Colors.black87),
//                     //                     borderRadius: BorderRadius.all(
//                     //                         Radius.circular(0)),
//                     //                   ),
//                     //                   hintText: 'Enter MICR Code'),
//                     //             ),
//                     //           ),
//                     //         ],
//                     //       ),
//                     //     ],
//                     //   ),
//                     // ),
//                     //Account CODE
//                     Container(
//                       height: 65,
//                       margin: EdgeInsets.only(bottom: 5),
//                       width: MediaQuery.of(context).size.width,
//                       color: Colors.white,
//                       // decoration: BoxDecoration(),
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: 3,
//                             height: MediaQuery.of(context).size.height,
//                             color: Colors.deepOrange,
//                           ),
//                           Container(
//                             margin: EdgeInsets.all(10),
//                             width: 40,
//                             height: 40,
//                             child: Image(
//                               image: AssetImage('assets/images/cheque.png'),
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                 // color: Colors.grey,
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Text(
//                                   'Bank Account No.',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Container(
//                                 width:
//                                     MediaQuery.of(context).size.width / 2 + 50,
//                                 height: 30,
//                                 child: TextFormField(
//                                   initialValue: ChequeData.bankAccNo,
//                                   inputFormatters: <TextInputFormatter>[
//                                     // WhitelistingTextInputFormatter.digitsOnly
//                                     FilteringTextInputFormatter.digitsOnly
//                                   ],
//                                   onChanged: (String str) {
//                                     ChequeData.bankAccNo = str;
//                                   },
//                                   decoration: InputDecoration(
//                                       contentPadding: EdgeInsets.fromLTRB(
//                                           5.0, 0.0, 5.0, 0.0),
//                                       enabledBorder: OutlineInputBorder(
//                                         borderSide:
//                                             BorderSide(color: Colors.grey),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(0)),
//                                       ),
//                                       focusedBorder: OutlineInputBorder(
//                                         borderSide:
//                                             BorderSide(color: Colors.black87),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(0)),
//                                       ),
//                                       hintText: 'Enter Bank Account No.'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     //DATE
//                     Container(
//                       height: 65,
//                       margin: EdgeInsets.only(bottom: 5),
//                       width: MediaQuery.of(context).size.width,
//                       color: Colors.white,
//                       // decoration: BoxDecoration(),
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: 3,
//                             height: MediaQuery.of(context).size.height,
//                             color: Colors.deepOrange,
//                           ),
//                           Container(
//                             margin: EdgeInsets.all(10),
//                             width: 40,
//                             height: 40,
//                             // child: Image(
//                             //   image: AssetImage('assets/images/wpf_name.png'),
//                             // ),
//                             child: Icon(
//                               Icons.date_range,
//                               size: 36,
//                               color: Colors.deepOrange,
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                 // color: Colors.grey,
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 child: Text(
//                                   'Cheque Date',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500),
//                                   // overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Container(
//                                 height: 40,
//                                 // color: Colors.grey,
//                                 width:
//                                     MediaQuery.of(context).size.width / 2 + 50,
//                                 child: ListTile(
//                                   title: Text(
//                                     "Date: ${pickedDate.year}, ${pickedDate.month}, ${pickedDate.day}",
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   trailing: Icon(Icons.keyboard_arrow_down),
//                                   onTap: _pickDate,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     //AMOUNT
//                     Container(
//                       margin: EdgeInsets.only(bottom: 5),
//                       height: 65,
//                       width: MediaQuery.of(context).size.width,
//                       color: Colors.white,
//                       // decoration: BoxDecoration(),
//                       child: Row(
//                         children: <Widget>[
//                           Container(
//                             width: 3,
//                             height: MediaQuery.of(context).size.height,
//                             color: Colors.deepOrange,
//                           ),
//                           Container(
//                             margin: EdgeInsets.all(10),
//                             width: 40,
//                             height: 40,
//                             child: Image(
//                               image: AssetImage('assets/images/peso.png'),
//                             ),
//                           ),
//                           Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(
//                                 'Amount',
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w500),
//                               ),
//                               Text(
//                                 formatCurrencyTot
//                                     .format(double.parse(OrderData.grandTotal)),
//                                 style: TextStyle(
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         if (ChequeData.imgName.isEmpty) {
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (context) {
//                             return CaptureImage();
//                           }));
//                         } else {
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (context) {
//                             return ViewChequeImg();
//                           }));
//                         }
//                       },
//                       child: Container(
//                         height: 65,
//                         margin: EdgeInsets.only(bottom: 5),
//                         width: MediaQuery.of(context).size.width,
//                         color: Colors.white,
//                         // decoration: BoxDecoration(),
//                         child: Row(
//                           children: <Widget>[
//                             Container(
//                               width: 3,
//                               height: MediaQuery.of(context).size.height,
//                               color: Colors.deepOrange,
//                             ),
//                             Container(
//                               margin: EdgeInsets.all(10),
//                               width: 40,
//                               height: 40,
//                               // child: Image(
//                               //   image: AssetImage('assets/images/wpf_name.png'),
//                               // ),
//                               child: Icon(
//                                 Icons.camera_alt,
//                                 size: 36,
//                                 color: Colors.deepOrange,
//                               ),
//                             ),
//                             Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Container(
//                                   // color: Colors.grey,
//                                   width: MediaQuery.of(context).size.width / 2,
//                                   child: Row(
//                                     children: <Widget>[
//                                       Text(
//                                         'Capture Image',
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.w500),
//                                         // overflow: TextOverflow.ellipsis,
//                                       ),
//                                       SizedBox(
//                                         width: 10,
//                                       ),
//                                       Visibility(
//                                         visible: OrderData.setChequeImg,
//                                         child: Icon(
//                                           Icons.check_circle,
//                                           size: 24,
//                                           color: Colors.green,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     Container(
//                       // color: Colors.grey,
//                       child: Align(
//                         alignment: Alignment.bottomCenter,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             RaisedButton(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20)),
//                               color: Colors.deepOrange,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 40, vertical: 12),
//                               onPressed: () => {
//                                 OrderData.pmtype = "CHEQUE",
//                                 if (ChequeData.payeeName == "" ||
//                                     ChequeData.payorName == "" ||
//                                     ChequeData.bankName == "" ||
//                                     ChequeData.chequeNum == "" ||
//                                     // ChequeData.branchCode == "" ||
//                                     ChequeData.bankAccNo == "" ||
//                                     ChequeData.chequeDate == "" ||
//                                     ChequeData.imgName == "")
//                                   {
//                                     showDialog(
//                                         barrierDismissible: false,
//                                         context: context,
//                                         builder: (context) {
//                                           return AlertDialog(
//                                             title: Text('Error'),
//                                             content: Text(
//                                                 'Unable to save. Check empty fields.'),
//                                             actions: <Widget>[
//                                               TextButton(
//                                                   onPressed: () {
//                                                     Navigator.pop(context);
//                                                   },
//                                                   child: Text('OK'))
//                                             ],
//                                           );
//                                         }),
//                                   }
//                                 else
//                                   {
//                                     showDialog(
//                                         barrierDismissible: false,
//                                         context: context,
//                                         builder: (context) {
//                                           return AlertDialog(
//                                             title: Text('Confirmation'),
//                                             content: Text(
//                                                 'Are you sure you want to save cheque as payment type?'),
//                                             actions: <Widget>[
//                                               TextButton(
//                                                   onPressed: () => {
//                                                         OrderData.pmtype =
//                                                             'CHEQUE',
//                                                         showDialog(
//                                                             barrierDismissible:
//                                                                 false,
//                                                             context: context,
//                                                             builder: (context) {
//                                                               return AlertDialog(
//                                                                 title: Text(
//                                                                     'Success'),
//                                                                 content: Text(
//                                                                     'Successfully added Cheque as payment type.'),
//                                                                 actions: <
//                                                                     Widget>[
//                                                                   TextButton(
//                                                                       onPressed:
//                                                                           () {
//                                                                         // Navigator.pop(context);
//                                                                         // Navigator.pop(context);

//                                                                         Navigator.push(
//                                                                             context,
//                                                                             MaterialPageRoute(builder:
//                                                                                 (context) {
//                                                                           return ConsolidatedListView();
//                                                                         }));
//                                                                         showDialog(
//                                                                             context:
//                                                                                 context,
//                                                                             builder: (context) =>
//                                                                                 ReceivedConsDialog());
//                                                                       },
//                                                                       child: Text(
//                                                                           'OK'))
//                                                                 ],
//                                                               );
//                                                             }),
//                                                       },
//                                                   child: Text('OK')),
//                                               TextButton(
//                                                   onPressed: () {
//                                                     setState(() {
//                                                       ChequeData.payeeName = "";
//                                                       ChequeData.payorName = "";
//                                                       ChequeData.bankName = "";
//                                                       ChequeData.chequeNum = "";
//                                                       ChequeData.branchCode =
//                                                           "";
//                                                       ChequeData.bankAccNo = "";
//                                                       OrderData.pmtype = "";

//                                                       OrderData.setPmType =
//                                                           false;
//                                                       Navigator.pop(context);
//                                                     });

//                                                     // Navigator.pop(context);
//                                                   },
//                                                   child: Text('Cancel'))
//                                             ],
//                                           );
//                                         }),
//                                   }
//                               },
//                               child: Text(
//                                 'Confirm',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             RaisedButton(
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20),
//                                   side: BorderSide(color: Colors.deepOrange)),
//                               color: Colors.white,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 40, vertical: 12),
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text(
//                                 'Cancel',
//                                 style: TextStyle(color: Colors.deepOrange),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.only(left: 10),
//           height: 60,
//           width: MediaQuery.of(context).size.width,
//           // color: Colors.deepOrange,
//           decoration: BoxDecoration(
//               color: Colors.deepOrange,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 'Cheque',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   _pickDate() async {
//     DateTime date = await showDatePicker(
//       context: context,
//       initialDate: pickedDate,
//       firstDate: DateTime(DateTime.now().year - 5),
//       lastDate: DateTime(DateTime.now().year + 5),
//     );
//     if (date != null)
//       setState(() {
//         pickedDate = date;
//         ChequeData.chequeDate = date.toString();
//       });
//   }
// }

// class UnabletoRemoveDialog extends StatefulWidget {
//   @override
//   _UnabletoRemoveDialogState createState() => _UnabletoRemoveDialogState();
// }

// class _UnabletoRemoveDialogState extends State<UnabletoRemoveDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: dialogContent(context),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   dialogContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           // color: Colors.grey,
//           padding: EdgeInsets.only(top: 70, bottom: 10, right: 5, left: 5),
//           // margin: EdgeInsets.only(top: 16),
//           decoration: BoxDecoration(
//               color: Colors.grey[50],
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: Offset(0.0, 10.0),
//                 ),
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Container(
//                 // height: 280,
//                 margin: EdgeInsets.only(bottom: 5),
//                 width: MediaQuery.of(context).size.width,
//                 // color: Colors.white,
//                 // decoration: BoxDecoration(),
//                 child: Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             // color: Colors.grey,
//                             width: MediaQuery.of(context).size.width / 2,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Center(
//                               child: Text(
//                                 'Swipe left to remove this item.',
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w400),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 // color: Colors.grey,
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       RaisedButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         color: Colors.deepOrange,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           'Okay',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.only(left: 10),
//           height: 60,
//           width: MediaQuery.of(context).size.width,
//           // color: Colors.deepOrange,
//           decoration: BoxDecoration(
//               color: Colors.deepOrange,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 'Stop',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ConfirmEditDialog extends StatefulWidget {
//   @override
//   _ConfirmEditDialogState createState() => _ConfirmEditDialogState();
// }

// class _ConfirmEditDialogState extends State<ConfirmEditDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//       elevation: 0,
//       backgroundColor: Colors.transparent,
//       child: dialogContent(context),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   dialogContent(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Container(
//           // color: Colors.grey,
//           padding: EdgeInsets.only(top: 70, bottom: 10, right: 5, left: 5),
//           // margin: EdgeInsets.only(top: 16),
//           decoration: BoxDecoration(
//               color: Colors.grey[50],
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   blurRadius: 10.0,
//                   offset: Offset(0.0, 10.0),
//                 ),
//               ]),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Container(
//                 // height: 280,
//                 margin: EdgeInsets.only(bottom: 5),
//                 width: MediaQuery.of(context).size.width,
//                 // color: Colors.white,
//                 // decoration: BoxDecoration(),
//                 child: Column(
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Container(
//                             // color: Colors.grey,
//                             width: MediaQuery.of(context).size.width / 2,
//                             margin: EdgeInsets.only(left: 10),
//                             child: Center(
//                               child: Text(
//                                 'Are you sure you want to edit this transaction?',
//                                 style: TextStyle(
//                                     fontSize: 16, fontWeight: FontWeight.w400),
//                                 textAlign: TextAlign.center,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 // color: Colors.grey,
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       RaisedButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         color: Colors.deepOrange,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           'Okay',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                       SizedBox(
//                         width: 5,
//                       ),
//                       RaisedButton(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20)),
//                         color: Colors.deepOrange,
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text(
//                           'Cancel',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.only(left: 10),
//           height: 60,
//           width: MediaQuery.of(context).size.width,
//           // color: Colors.deepOrange,
//           decoration: BoxDecoration(
//               color: Colors.deepOrange,
//               shape: BoxShape.rectangle,
//               borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(20), topRight: Radius.circular(20))),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(
//                 'Confirmation',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

class PopupTranperLine extends StatefulWidget {
  @override
  _PopupTranperLineState createState() => _PopupTranperLineState();
}

class _PopupTranperLineState extends State<PopupTranperLine> {
  double height = double.parse((OrderData.tranLine.length).toString());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: content(context),
    );
  }

  content(BuildContext context) {
    return Stack(
      // mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 0, bottom: 10, right: 5, left: 5),
          decoration: BoxDecoration(
              color: Colors.grey[50],
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
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80 * height,
                color: Colors.transparent,
                child: ListView.builder(
                    itemCount: OrderData.tranLine.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 30,
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey[200],
                              child: Center(
                                child: Text(
                                  OrderData.tranLine[index]['tran_no'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: 30,
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    'Requested quantity:',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    OrderData.tranLine[index]['req_qty'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Served quantity:',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    OrderData.tranLine[index]['del_qty'],
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.deepOrange,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
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
          // child: ListView.builder(
          //   itemCount: OrderData.tranLine.length,
          //   itemBuilder: (context, index) {
          //     return Padding(
          //       padding: const EdgeInsets.all(1.0),
          //       child: Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: <Widget>[
          //           SizedBox(
          //             height: 15,
          //           ),
          //           Container(
          //             margin: EdgeInsets.only(bottom: 5),
          //             height: 70,
          //             width: MediaQuery.of(context).size.width,
          //             color: Colors.white,
          //             // decoration: BoxDecoration(),
          //             child: Row(
          //               children: <Widget>[
          //                 Container(
          //                   width: 3,
          //                   height: MediaQuery.of(context).size.height,
          //                   color: Colors.deepOrange,
          //                 ),
          //                 Container(
          //                   margin: EdgeInsets.all(10),
          //                   width: 40,
          //                   height: 40,
          //                   child: Image(
          //                     image: AssetImage('assets/images/cash.png'),
          //                   ),
          //                 ),
          //                 SizedBox(
          //                   width: 10,
          //                 ),
          //                 Column(
          //                   mainAxisAlignment: MainAxisAlignment.center,
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: <Widget>[
          //                     Text(
          //                       'CASH',
          //                       style: TextStyle(
          //                           fontSize: 16, fontWeight: FontWeight.w500),
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ],
          //       ),
          //     );
          //   },
          // ),
        ),
      ],
    );
  }
}
