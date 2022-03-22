import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/home/consolidated_listview.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/elevated_button.dart';
import 'userdata.dart';
// import './api.dart';
import 'package:salesman/home/processed_listview.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool viewSpinkit = true;
  bool processedPressed = true;
  bool emptyApprovedTran = true;
  bool emptyPendingTran = true;

  final db = DatabaseHelper();

  final orangeColor = ColorsTheme.mainColor;
  final yellowColor = Colors.amber;
  final blueColor = Colors.blue;
  final formatCurrency =
      new NumberFormat.currency(locale: "en_US", symbol: "P");

  String reqDate = "";
  String nreqDate = "";

  List _toList = [];
  List _sList = [];
  List samplist = [];

  @override
  void initState() {
    super.initState();
    // loadSalesmanList();
    loadProcessed();
    CustomerData.discounted = false;
    GlobalVariables.consolidatedOrder = false;
  }

  // viewTranStatus() async {
  //   var smp = await db.viewStatus();
  //   samplist = smp;
  //   print(samplist);
  // }

  // loadSalesmanList() async {
  //   var getSM = await getSalesmanList(UserData.id);
  //   _smList = getSM;
  //   // loadProcessed();
  //   _getData();
  // }

  loadProcessed() async {
    //OLD CODE
    // OrderData.visible = true;
    // _toList.clear();
    // _smList.forEach((element) async {
    //   _sList.clear();
    //   var getP = await getProcessed(element['salesman_code']);
    //   _sList = getP;
    //   // print(element['salesman_code']);
    //   setState(() {
    //     if (_sList.isNotEmpty) {
    //       _sList.forEach((element) {
    //         req_date = element['date_req'];
    //         // print(req_date);
    //         DateTime e = DateTime.parse(req_date);
    //         nreq_date = DateFormat("MMM dd yyyy").format(e);
    //         element['date_req'] = nreq_date;
    //         _toList.add((element));
    //         viewSpinkit = false;
    //       });
    //     }

    //     if (_toList.isNotEmpty) {
    //       emptyApprovedTran = false;
    //       viewSpinkit = false;
    //     } else {
    //       viewSpinkit = false;
    //     }
    //   });
    //   GlobalVariables.processedPressed = true;
    // });
    OrderData.visible = true;
    var getP = await db.getApprovedOrders();
    setState(() {
      // _toList = getP;
      _toList = json.decode(json.encode(getP));
      // print(_toList);
      if (_toList.isNotEmpty) {
        emptyApprovedTran = false;
        viewSpinkit = false;
      } else {
        viewSpinkit = false;
      }
    });
    GlobalVariables.processedPressed = true;
  }

  checkifDiscounted() async {
    // print(CustomerData.id);
    var rsp = await db.checkDiscounted(CustomerData.id);
    // print(rsp);
    if (rsp == "TRUE") {
      // print(rsp);
      CustomerData.discounted = true;
    } else {
      CustomerData.discounted = false;
    }
  }

  /////DILI NA NI MAGAMIT
  loadPending() async {
    OrderData.visible = false;
    _toList.clear();
    // _smList.forEach((element) async {
    // _sList.clear();
    // var getPend = await getPending(element['salesman_code']);
    var getPend = await db.getPendingOrders();
    setState(() {
      // _sList = json.decode(json.encode(getPend));
      _toList = json.decode(json.encode(getPend));
      // if (_sList.isNotEmpty) {
      //   _sList.forEach((element) {
      //     _toList.add((json.decode(json.encode(element))));
      //     viewSpinkit = false;
      //   });
      // }

      if (_toList.isNotEmpty) {
        emptyPendingTran = false;
        viewSpinkit = false;
      } else {
        viewSpinkit = false;
      }
      GlobalVariables.processedPressed = false;
    });
    // });
  }

  loadConsolidated() async {
    OrderData.visible = true;
    _toList.clear();
    // _smList.forEach((element) async {
    _sList.clear();
    // var getPend =
    //     await getConsolidatedApprovedRequestHead(element['salesman_code']);
    var getCons = await db.getConsolidatedApprovedRequestHead();
    // print(getCons);
    // _sList = getCons;

    // print(_sList);
    setState(() {
      _sList = json.decode(json.encode(getCons));
      if (_sList.isNotEmpty) {
        _sList.forEach((element) {
          reqDate = element['date_req'];
          DateTime e = DateTime.parse(reqDate);
          nreqDate = DateFormat("MMM dd yyyy").format(e);
          // element['date_req'] = nreq_date;
          _toList.add((element));
          viewSpinkit = false;
        });
      }

      if (_toList.isNotEmpty) {
        emptyPendingTran = false;
        viewSpinkit = false;
      } else {
        viewSpinkit = false;
      }
      GlobalVariables.processedPressed = false;
    });
    // });
  }

  Future<void> _getData() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      if (GlobalVariables.processedPressed == true) {
        OrderData.visible = true;
        loadProcessed();
      } else {
        if (processedPressed = true) {
          OrderData.visible = true;
          loadProcessed();
        } else {
          // loadPending();
          loadConsolidated();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            floating: true,
            snap: true,
            toolbarHeight: ScreenData.scrHeight * .14,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Home",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: ColorsTheme.mainColor,
                      fontSize: 45,
                      fontWeight: FontWeight.bold),
                ),
                buildOrderOption(),
              ],
            ),
          ),
        ],
        body: Column(
          children: [
            Expanded(child: buildtranCont()),
          ],
        ),
      ),
    );
  }

  Container buildtranCont() {
    if (viewSpinkit == true) {
      return Container(
        // height: 620,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: SpinKitFadingCircle(
            color: ColorsTheme.mainColor,
            size: 50,
          ),
        ),
      );
    }
    if (emptyApprovedTran == true && processedPressed == true) {
      return Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        // margin: EdgeInsets.only(top: 50),
        // height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: ColorsTheme.mainColor,
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
              'No approved requests.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
            Text(
              'Sync Transactions to update data.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
      );
    }
    if (emptyPendingTran == true && processedPressed == false) {
      return Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        // height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        // color: ColorsTheme.mainColor,
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
              'No approved requests.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
            Text(
              'Sync Transactions to update data.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
      );
    }
    return Container(
      // color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 15, right: 15, top: 0),
      // margin: EdgeInsets.only(top: 0),
      child: RefreshIndicator(
        child: ListView.builder(
          itemCount: _toList.length,
          itemBuilder: (context, index) {
            if (!processedPressed) {
              reqDate = _toList[index]['date_req'];
              DateTime e = DateTime.parse(reqDate);
              nreqDate = DateFormat("MMM dd yyyy").format(e);
            }
            return SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.end,
                // crossAxisAlignment: CrossAxisAlignment.end,
                // mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      // print(_toList);
                      UserData.trans = _toList[index]['tran_no'];
                      UserData.sname = _toList[index]['store_name'];
                      OrderData.trans = _toList[index]['tran_no'];
                      OrderData.name = _toList[index]['store_name'];
                      OrderData.signature = '';

                      CustomerData.accountCode = _toList[index]['account_code'];
                      OrderData.pmeth = _toList[index]['p_meth'];
                      OrderData.itmno = _toList[index]['itm_count'];
                      OrderData.grandTotal = _toList[index]['tot_amt'];
                      OrderData.status = _toList[index]['tran_stat'];
                      OrderData.smcode = _toList[index]['sm_code'];
                      OrderData.setSign = false;
                      // print(_toList[index]['date_req']);
                      var getCi =
                          await db.getCustInfo(CustomerData.accountCode);
                      CustomerData.city = getCi[0]['address3'];
                      CustomerData.district = getCi[0]['address2'];
                      CustomerData.province = getCi[0]['address1'];
                      CustomerData.contactNo = getCi[0]['cus_mobile_num'];
                      CustomerData.id = getCi[0]['customer_id'];
                      // print(getCi);
                      checkifDiscounted();

                      if (processedPressed == true) {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProcessedListView();
                        }));
                      } else {
                        reqDate = _toList[index]['date_req'];
                        DateTime e = DateTime.parse(_toList[index]['date_req']);
                        OrderData.dateReq = DateFormat("yyyy-MM-dd").format(e);
                        // print(OrderData.dateReq);

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ConsolidatedListView();
                        }));
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8),
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 5,
                                  height: 80,
                                  color: ColorsTheme.mainColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  // // width: MediaQuery.of(context).size.width / 2 +
                                  // //     60,
                                  // color: Colors.grey,
                                  width: ScreenData.scrWidth * .56,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        _toList[index]['store_name'],
                                        // 'Store Name',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        processedPressed
                                            ? _toList[index]['date_req']
                                            : nreqDate,
                                        // 'Date',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            // width: 138,
                            // color: Colors.blueGrey,
                            margin: EdgeInsets.only(right: 5),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Total Amount',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  processedPressed
                                      ? formatCurrency.format(double.parse(
                                          _toList[index]['tot_amt']))
                                      : formatCurrency.format(double.parse(
                                          _toList[index]['total'].toString())),
                                  // 'Tot amt',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: ColorsTheme.mainColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _toList[index]['tran_stat'],
                                  // '',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      // color: processedPressed
                                      //     ? Colors.greenAccent
                                      //     : Colors.redAccent,
                                      color: Colors.greenAccent,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        onRefresh: _getData,
      ),
    );
  }

  Container buildOrderOption() {
    return Container(
      height: 50,
      width: ScreenData.scrWidth * .87,
      // margin: EdgeInsets.only(top: 0, bottom: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new SizedBox(
            width: ScreenData.scrWidth * .43,
            // height: 35,
            child: new ElevatedButton(
              style: raisedButtonStyleWhite,
              onPressed: () {
                setState(() {
                  viewSpinkit = true;
                  loadProcessed();
                  OrderData.visible = true;
                  processedPressed = true;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    // overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: "On-Processed Orders",
                      // recognizer: _tapGestureRecognizer,

                      style: TextStyle(
                        fontSize: ScreenData.scrWidth * .032,
                        fontWeight: processedPressed
                            ? FontWeight.bold
                            : FontWeight.normal,
                        decoration: TextDecoration.underline,
                        color: processedPressed ? orangeColor : Colors.grey,
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
            width: ScreenData.scrWidth * .43,
            // height: 35,
            child: new ElevatedButton(
              style: raisedButtonStyleWhite,
              onPressed: () {
                setState(() {
                  // viewSpinkit = true;
                  // loadPending();
                  loadConsolidated();
                  // print('CLICKED!');
                  OrderData.visible = false;
                  processedPressed = false;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                      // overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                    text: "Consolidated Orders",
                    // recognizer: _tapGestureRecognizer,
                    style: TextStyle(
                      fontSize: ScreenData.scrWidth * .032,
                      fontWeight: processedPressed
                          ? FontWeight.normal
                          : FontWeight.bold,
                      decoration: TextDecoration.underline,
                      color: processedPressed ? Colors.grey : orangeColor,
                    ),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
