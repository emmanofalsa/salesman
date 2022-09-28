import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesman/customer/customer_signature.dart';
import 'package:salesman/customer/customer_signature_view.dart';
import 'package:salesman/customer/special_note.dart';
import 'package:salesman/customer/spinkit.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/widgets/dialogs.dart';
import 'package:salesman/widgets/elevated_button.dart';
import 'package:salesman/widgets/snackbar.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  String status = "Pending";
  String itmCat = "";
  String imgPath = "";
  bool categ = false;
  bool isDone = false;
  bool noImage = false;
  bool tranSaved = false;
  bool viewSpinkit = true;
  bool listSpinkit = true;

  List _templist = [];

  final db = DatabaseHelper();

  final formatCurrencyAmt =
      new NumberFormat.currency(locale: "en_US", symbol: "₱");
  final formatCurrencyTot =
      new NumberFormat.currency(locale: "en_US", symbol: "Php ");

  void initState() {
    super.initState();
    loadTemp();
    GlobalVariables.isDone = false;
    GlobalVariables.tranNo = '';
  }

  loadTemp() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + '/';
    imgPath = firstPath;
    // var getCart = await getTemp(UserData.id, CustomerData.accountCode);
    var rsp = await db.ofFetchCart(CustomerData.accountCode);
    _templist = json.decode(json.encode(rsp));
    // print(_templist);
    if (!mounted) return;
    setState(() {
      // print(UserData.trans);
      computeTotal();
      listSpinkit = false;
    });
    GlobalVariables.tranNo = "";
  }

  computeTotal() async {
    itmCat = "";
    categ = false;
    // CartData.itmNo = '';
    CartData.totalAmount = "";
    double sum = 0;

    _templist.forEach((element) {
      sum = sum + double.parse(element['item_total']);
      // itmno = itmno + int.parse(element['item_qty']);
    });
    CartData.totalAmount = sum.toStringAsFixed(2);
    // CartData.itmNo = _templist.length.toString();
  }

  addTransactionHead() async {
    final String date =
        DateFormat("yyyy-MM-dd HH:mm:ss").format(new DateTime.now());
    final String date2 = DateFormat("Mdy").format(new DateTime.now());
    final String tranNo = date2 + 'TEMP' + CustomerData.accountCode!;

    var getTranHead = await db.addTempTranHead(
        tranNo,
        date,
        CustomerData.accountCode.toString(),
        CustomerData.accountName.toString(),
        CustomerData.paymentType.toString(),
        CartData.itmNo.toString(),
        CartData.totalAmount.toString(),
        status,
        UserData.id.toString(),
        UserData.division.toString(),
        OrderData.signature.toString());
    print(getTranHead);
    GlobalVariables.tranNo = tranNo;

    addTransactionLine();

    db.deleteCart(CustomerData.accountCode);

    if (getTranHead != '') {
      viewSpinkit = false;
      Navigator.pop(context);
      tranSaved = true;
      viewSpinkit = false;
      if (tranSaved == true && viewSpinkit == false) {
        String msg = 'Your Order #' +
            GlobalVariables.tranNo! +
            ' is being processed right now.' +
            'View Transactions to check order status.';
        final action = await WarningDialogs.openDialog(
          context,
          'Information',
          msg,
          false,
          'OK',
        );
        if (action == DialogAction.yes) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/smmenu', (Route<dynamic> route) => false);
        } else {}
      }
    }
  }

  addTransactionLine() async {
    final String date =
        DateFormat("yyyy-MM-dd H:mm:ss").format(new DateTime.now());
    if (!mounted) return;
    setState(() {
      GlobalVariables.isDone = true;
      _templist.forEach((element) {
        double totamt = double.parse(element['item_amt']) *
            double.parse(element['item_qty']);
        db.addTempTranLine(
            GlobalVariables.tranNo,
            element['item_code'],
            element['item_desc'],
            element['item_qty'],
            element['item_uom'],
            element['item_amt'],
            totamt.toStringAsFixed(2),
            element['item_cat'],
            CustomerData.accountCode,
            UserData.division.toString(),
            date,
            element['image']);
      });
    });
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
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          title: Text(
            'Checkout',
            style:
                TextStyle(color: Colors.grey[800], fontWeight: FontWeight.bold),
          ),
          centerTitle: false,
          // elevation: 0,
          // toolbarHeight: 50,
        ),
        backgroundColor: Colors.grey[100],
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.grey[100],
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        buildDeliveryCont(context),
                        SizedBox(
                          height: 20,
                        ),
                        buildPaymentCont(),
                        SizedBox(
                          height: 30,
                        ),
                        buildSummaryCont(),
                        SizedBox(
                          height: 30,
                        ),
                        buildSignatureCont(),
                        SizedBox(
                          height: 30,
                        ),
                        buildNoteCont()
                      ],
                    ),
                  ),
                ),
              ),
              buildLogoutButton(context)
            ],
          ),
        ),
      ),
    );
  }

  Container buildLogoutButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(width: 0.2, color: Colors.black),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: 80,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                  style: raisedButtonStyleGreen,
                  onPressed: () async {
                    print('PRESSED');
                    if (OrderData.signature == "") {
                      {
                        showGlobalSnackbar(
                            'Information',
                            'Please input signature',
                            Colors.blue,
                            Colors.white);
                      }
                    } else {
                      final action = await Dialogs.openDialog(
                          context,
                          'Confirmation',
                          'You cannot cancel or modify after this. Are you sure you want to place this order?',
                          false,
                          'No',
                          'Yes');
                      if (action == DialogAction.yes) {
                        if (tranSaved == false) {
                          if (viewSpinkit == true) {
                            showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) => ProcessingBox());
                            addTransactionHead();
                          }
                        } else {
                          print('Already Processing');
                        }
                      } else {}
                    }
                  },
                  child: Text(
                    'CHECKOUT ORDER',
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Container buildNoteCont() {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return SpecialNote();
          }));
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add a note',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    OrderData.note
                        ? Text(OrderData.specialInstruction)
                        : Text(
                            'Place any special instruction here',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }

  Container buildSignatureCont() {
    return Container(
      child: GestureDetector(
        onTap: () {
          if (!OrderData.setSign) {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MyApp();
            }));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ViewSignature();
            }));
          }
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(15),
          child: Container(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Signature',
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildSummaryCont() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary',
            style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          Text(CartData.itmLineNo! + ' lines, ' + CartData.itmNo + ' items'),
          Row(
            children: [
              Expanded(child: Text('Goods')),
              Text(
                formatCurrencyAmt.format(double.parse(CartData.totalAmount)),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(child: Text('Delivery Fee')),
              Text('0.00'),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total',
                  style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 20,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                formatCurrencyTot.format(double.parse(CartData.totalAmount)),
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildPaymentCont() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Payment Method',
              style: TextStyle(
                  color: Colors.grey[800],
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            'Cash',
            style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.chevron_right,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  Container buildDeliveryCont(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(left: 15),
                child: Icon(
                  Icons.local_shipping,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Delivery',
                style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Row(
            children: [
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height / 8,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Icon(
                        Icons.room,
                        color: Colors.red,
                        size: 24,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          CustomerData.accountName!,
                          style: TextStyle(
                              color: Colors.grey[850],
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          CustomerData.district! +
                              ', ' +
                              CustomerData.city! +
                              ', ' +
                              CustomerData.province!,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          'Mobile: ' + '0' + CustomerData.contactNo!,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
