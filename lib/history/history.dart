import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/history/ordersandtracking.dart';
import 'package:salesman/variables/colors.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final searchController = TextEditingController();
  String _searchController = "";
  String? tranStatus;
  bool viewSpinkit = true;
  bool emptyTranHistory = true;
  bool emptyTranSearch = false;
  String amount = "";

  final formatCurrencyTot =
      new NumberFormat.currency(locale: "en_US", symbol: "Php ");

  List _toList = [];
  List _completedList = [];
  List _cancelList = [];
  List _sList = [];

  final db = DatabaseHelper();

  void initState() {
    super.initState();
    if (UserData.position == 'Salesman') {
      // loadSalesmanHistory();
      loadSalesmanOngoingHistory();
      loadSalesmanCompletedHistory();
      loadSalesmanCancelHistory();
      GlobalVariables.showSign = false;
    }
    if (UserData.position == 'Jefe de Viaje') {
      // loadSalesmanList();
      loadHepeOngoingHistory();
      loadHepeCompletedHistory();
      loadHepeCancelHistory();
      GlobalVariables.showSign = false;
      // print('TRUE');
    }
    CustomerData.discounted = false;
  }

  // loadHepeHistory() async {
  //   var getP = await db.ofFetchHepeHistory(UserData.id);
  //   _sList = json.decode(json.encode(getP));
  //   // print(_sList);
  //   setState(() {
  //     if (_sList.isNotEmpty) {
  //       _sList.forEach((element) {
  //         _toList.add((element));
  //         viewSpinkit = false;
  //       });
  //     }
  //     viewSpinkit = false;
  //     if (_toList.isNotEmpty) {
  //       emptyTranHistory = false;
  //     }
  //   });
  // }

  loadHepeOngoingHistory() async {
    var getP = await db.ofFetchHepeOngoingHistory(UserData.id);
    _sList = json.decode(json.encode(getP));
    // print(_sList);
    if (!mounted) return;
    setState(() {
      if (_sList.isNotEmpty) {
        _sList.forEach((element) {
          _toList.add((element));
          viewSpinkit = false;
        });
      }
      viewSpinkit = false;
      if (_toList.isNotEmpty) {
        emptyTranHistory = false;
      }
    });
  }

  loadHepeCompletedHistory() async {
    var getP = await db.ofFetchHepeCompletedHistory(UserData.id);
    _sList = json.decode(json.encode(getP));
    if (!mounted) return;
    setState(() {
      if (_sList.isNotEmpty) {
        _sList.forEach((element) {
          _completedList.add((element));
          viewSpinkit = false;
        });
      }
      viewSpinkit = false;
      if (_completedList.isNotEmpty) {
        emptyTranHistory = false;
      }
    });
  }

  loadHepeCancelHistory() async {
    var getP = await db.ofFetchHepeCancelHistory(UserData.id);
    _sList = json.decode(json.encode(getP));
    if (!mounted) return;
    setState(() {
      if (_sList.isNotEmpty) {
        _sList.forEach((element) {
          _cancelList.add((element));
          viewSpinkit = false;
        });
      }
      viewSpinkit = false;
      if (_cancelList.isNotEmpty) {
        emptyTranHistory = false;
      }
    });
  }

  // loadSalesmanHistory() async {
  //   var getP = await db.ofFetchSalesmanHistory(UserData.id);
  //   if (!mounted) return;
  //   setState(() {
  //     _toList = json.decode(json.encode(getP));
  //     viewSpinkit = false;
  //     if (_toList.isNotEmpty) {
  //       emptyTranHistory = false;
  //     }
  //   });
  //   // print(_toList);
  // }

  loadSalesmanOngoingHistory() async {
    // print(UserData.id);
    var getP = await db.ofFetchSalesmanOngoingHistory(UserData.id);
    if (!mounted) return;
    setState(() {
      _toList = json.decode(json.encode(getP));
      // print(_toList);
      viewSpinkit = false;
      if (_toList.isNotEmpty) {
        emptyTranHistory = false;
      }
    });
    // print(_toList);
  }

  loadSalesmanCompletedHistory() async {
    var getC = await db.ofFetchSalesmanCompletedHistory(UserData.id);
    if (!mounted) return;

    setState(() {
      _completedList = json.decode(json.encode(getC));
      viewSpinkit = false;
      if (_completedList.isNotEmpty) {
        emptyTranHistory = false;
      }
    });
  }

  loadSalesmanCancelHistory() async {
    var getC = await db.ofFetchSalesmanCancelHistory(UserData.id);
    if (!mounted) return;
    setState(() {
      _cancelList = json.decode(json.encode(getC));
      viewSpinkit = false;
      if (_cancelList.isNotEmpty) {
        emptyTranHistory = false;
      }
    });
  }

  searchHistory() async {
    var getC = await db.salesmanHistorySearch(_searchController);
    if (!mounted) return;
    setState(() {
      _toList = getC;
    });
    if (_toList.isEmpty) {
      emptyTranSearch = true;
    } else {
      emptyTranSearch = false;
    }
  }

  checkifDiscounted() async {
    var rsp = await db.checkDiscounted(CustomerData.accountCode);
    if (rsp == "TRUE") {
      print(rsp);
      CustomerData.discounted = true;
    } else {
      CustomerData.discounted = false;
    }
  }

  clearChequeData() {
    ChequeData.bankAccNo = '';
    ChequeData.bankName = '';
    ChequeData.branchCode = '';
    ChequeData.chequeAmt = '';
    ChequeData.chequeDate = '';
    ChequeData.chequeNum = '';
    ChequeData.imgName = '';
    ChequeData.numToWords = '';
    ChequeData.payeeName = '';
    ChequeData.payorName = '';
    ChequeData.status = '';
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
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                toolbarHeight: ScreenData.scrHeight * .08,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                title: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "History",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: ColorsTheme.mainColor,
                          fontSize: 45,
                          fontWeight: FontWeight.bold),
                    ),
                    // buildSearchCont(context),
                    // buildSearchField(),
                  ],
                ),
                bottom: TabBar(
                  indicatorColor: ColorsTheme.mainColor,
                  labelColor: ColorsTheme.mainColor,
                  indicatorWeight: 5,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.shopping_basket,
                          color: ColorsTheme.mainColor),
                      text: 'Ongoing',
                    ),
                    Tab(
                      icon: Icon(Icons.done_outline,
                          color: ColorsTheme.mainColor),
                      text: 'Completed',
                    ),
                    Tab(
                      icon: Icon(Icons.warning, color: ColorsTheme.mainColor),
                      text: 'Cancelled',
                    ),
                  ],
                ),
              ),
            ],
            // body: Column(
            //   children: [
            //     buildtranCont(),
            //   ],
            // ),
            body: TabBarView(children: [
              buildOngoingCont(),
              buildCompletedCont(),
              buildCancelledCont(),
            ]),
          ),
        ),
      ),
    );
  }

  Container buildOngoingCont() {
    if (viewSpinkit == true) {
      return Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                // height: 620,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: SpinKitFadingCircle(
                    color: ColorsTheme.mainColor,
                    size: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (_toList.isEmpty) {
      return Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.event_busy,
                      size: 100,
                      color: Colors.grey[500],
                    ),
                    Text(
                      'You have no transaction history.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              // color: Colors.white,
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: _toList.length,
                // scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  String newDate = "";
                  String date = "";

                  // if (_toList[index]['tran_stat'] == "Delivered") {
                  //   date = _toList[index]['date_del'].toString();
                  //   DateTime s = DateTime.parse(date);
                  //   newDate = DateFormat("MMM dd, yyyy").format(s) +
                  //       ' at ' +
                  //       DateFormat("hh:mm aaa").format(s);
                  //   _toList[index]['newdate'] = newDate.toString();
                  //   amount = _toList[index]['tot_del_amt'];
                  // } else {
                  //   amount = _toList[index]['tot_amt'];
                  // }
                  amount = _toList[index]['tot_amt'];
                  if (_toList[index]['tran_stat'] == "Pending" ||
                      _toList[index]['tran_stat'] == "On-Process") {
                    date = _toList[index]['date_req'].toString();
                    DateTime s = DateTime.parse(date);
                    newDate = DateFormat("MMM dd, yyyy").format(s) +
                        ' at ' +
                        DateFormat("hh:mm aaa").format(s);
                    _toList[index]['newdate'] = newDate.toString();
                    tranStatus = 'Submitted';
                  } else {
                    tranStatus = _toList[index]['tran_stat'].toString();
                  }
                  if (_toList[index]['tran_stat'] == "Approved") {
                    date = _toList[index]['date_app'].toString();
                    DateTime s = DateTime.parse(date);
                    newDate = DateFormat("MMM dd, yyyy").format(s) +
                        ' at ' +
                        DateFormat("hh:mm aaa").format(s);
                    _toList[index]['newdate'] = newDate.toString();
                  }
                  // if (_toList[index]['tran_stat'] == "Returned") {
                  //   date = _toList[index]['date_del'].toString();
                  //   DateTime s = DateTime.parse(date);
                  //   newDate = DateFormat("MMM dd, yyyy").format(s) +
                  //       ' at ' +
                  //       DateFormat("hh:mm aaa").format(s);
                  //   _toList[index]['newdate'] = newDate.toString();
                  // }
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            UserData.trans = _toList[index]['tran_no'];
                            UserData.sname = _toList[index]['store_name'];
                            OrderData.trans = _toList[index]['tran_no'];
                            OrderData.name = _toList[index]['cust_name'];
                            OrderData.pmeth = _toList[index]['p_meth'];
                            OrderData.itmno = _toList[index]['itm_count'];
                            OrderData.totamt = _toList[index]['tot_amt'];
                            OrderData.status = _toList[index]['tran_stat'];
                            OrderData.signature = _toList[index]['signature'];
                            OrderData.dateReq = _toList[index]['date_req'];
                            OrderData.dateApp = _toList[index]['date_app'];
                            OrderData.dateDel = _toList[index]['date_del'];
                            OrderData.pmtype = _toList[index]['pmeth_type'];
                            CustomerData.accountCode =
                                _toList[index]['account_code'];
                            clearChequeData();
                            checkifDiscounted();
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return OrdersAndTracking();
                            // }));
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: OrdersAndTracking()));
                          },
                          child: Container(
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
                                    width:
                                        MediaQuery.of(context).size.width / 3 +
                                            30,
                                    // color: Colors.grey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Order # ' +
                                              _toList[index]['tran_no'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
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
                                          margin: EdgeInsets.only(left: 50),
                                          width: 105,
                                          // color: Colors.blueGrey,
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Total Amount',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                formatCurrencyTot.format(
                                                    double.parse(amount)),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    // color: ColorsTheme.mainColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
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
                                    padding:
                                        EdgeInsets.only(left: 5, right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          tranStatus.toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: ColorsTheme.mainColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        if ((_toList[index]['tran_stat'])
                                                    .toString() ==
                                                "Pending" ||
                                            (_toList[index]['tran_stat'])
                                                    .toString() ==
                                                "On-Process")
                                          Text(
                                            _toList[index]['newdate'],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                // color: ColorsTheme.mainColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        if ((_toList[index]['tran_stat'])
                                                .toString() ==
                                            "Approved")
                                          Text(
                                            _toList[index]['newdate'],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                // color: ColorsTheme.mainColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        if ((_toList[index]['tran_stat'])
                                                    .toString() ==
                                                "Delivered" ||
                                            (_toList[index]['tran_stat'])
                                                    .toString() ==
                                                "Returned")
                                          Text(
                                            _toList[index]['newdate']
                                                .toString(),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                // color: ColorsTheme.mainColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildCompletedCont() {
    if (viewSpinkit == true) {
      return Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                // height: 620,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: SpinKitFadingCircle(
                    color: ColorsTheme.mainColor,
                    size: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (_completedList.isEmpty) {
      return Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.event_busy,
                      size: 100,
                      color: Colors.grey[500],
                    ),
                    Text(
                      'You have no transaction history.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              // color: Colors.white,
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: _completedList.length,
                // scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  String newDate = "";
                  String date = "";

                  if (_completedList[index]['tran_stat'] == "Delivered") {
                    date = _completedList[index]['date_del'].toString();
                    DateTime s = DateTime.parse(date);
                    newDate = DateFormat("MMM dd, yyyy").format(s) +
                        ' at ' +
                        DateFormat("hh:mm aaa").format(s);
                    _completedList[index]['newdate'] = newDate.toString();
                    amount = _completedList[index]['tot_del_amt'];
                  } else {
                    amount = _completedList[index]['tot_amt'];
                  }
                  if (_completedList[index]['tran_stat'] == "Pending" ||
                      _completedList[index]['tran_stat'] == "On-Process") {
                    date = _completedList[index]['date_req'].toString();
                    DateTime s = DateTime.parse(date);
                    newDate = DateFormat("MMM dd, yyyy").format(s) +
                        ' at ' +
                        DateFormat("hh:mm aaa").format(s);
                    _completedList[index]['newdate'] = newDate.toString();
                    tranStatus = 'Submitted';
                  } else {
                    tranStatus = _completedList[index]['tran_stat'].toString();
                  }
                  if (_completedList[index]['tran_stat'] == "Approved") {
                    date = _completedList[index]['date_app'].toString();
                    DateTime s = DateTime.parse(date);
                    newDate = DateFormat("MMM dd, yyyy").format(s) +
                        ' at ' +
                        DateFormat("hh:mm aaa").format(s);
                    _completedList[index]['newdate'] = newDate.toString();
                  }
                  if (_completedList[index]['tran_stat'] == "Returned") {
                    date = _completedList[index]['date_del'].toString();
                    DateTime s = DateTime.parse(date);
                    newDate = DateFormat("MMM dd, yyyy").format(s) +
                        ' at ' +
                        DateFormat("hh:mm aaa").format(s);
                    _completedList[index]['newdate'] = newDate.toString();
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            UserData.trans = _completedList[index]['tran_no'];
                            UserData.sname =
                                _completedList[index]['store_name'];
                            OrderData.trans = _completedList[index]['tran_no'];
                            OrderData.name = _completedList[index]['cust_name'];
                            OrderData.pmeth = _completedList[index]['p_meth'];
                            OrderData.itmno =
                                _completedList[index]['itm_count'];
                            OrderData.totamt = _completedList[index]['tot_amt'];
                            OrderData.status =
                                _completedList[index]['tran_stat'];
                            OrderData.signature =
                                _completedList[index]['signature'];
                            OrderData.dateReq =
                                _completedList[index]['date_req'];
                            OrderData.dateApp =
                                _completedList[index]['date_app'];
                            OrderData.dateDel =
                                _completedList[index]['date_del'];
                            OrderData.pmtype =
                                _completedList[index]['pmeth_type'];
                            CustomerData.accountCode =
                                _completedList[index]['account_code'];
                            clearChequeData();
                            checkifDiscounted();
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return OrdersAndTracking();
                            // }));
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: OrdersAndTracking()));
                          },
                          child: Container(
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
                                    width:
                                        MediaQuery.of(context).size.width / 3 +
                                            30,
                                    // color: Colors.grey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Order # ' +
                                              _completedList[index]['tran_no'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _completedList[index]['store_name'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          _completedList[index]['date_req'],
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
                                          margin: EdgeInsets.only(left: 50),
                                          width: 105,
                                          // color: Colors.blueGrey,
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Total Amount',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                formatCurrencyTot.format(
                                                    double.parse(amount)),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    // color: ColorsTheme.mainColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
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
                                    padding:
                                        EdgeInsets.only(left: 5, right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          tranStatus.toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: ColorsTheme.mainColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        if ((_completedList[index]['tran_stat'])
                                                    .toString() ==
                                                "Pending" ||
                                            (_completedList[index]['tran_stat'])
                                                    .toString() ==
                                                "On-Process")
                                          Text(
                                            _completedList[index]['newdate'],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                // color: ColorsTheme.mainColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        if ((_completedList[index]['tran_stat'])
                                                .toString() ==
                                            "Approved")
                                          Text(
                                            _completedList[index]['newdate'],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                // color: ColorsTheme.mainColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        if ((_completedList[index]['tran_stat'])
                                                    .toString() ==
                                                "Delivered" ||
                                            (_completedList[index]['tran_stat'])
                                                    .toString() ==
                                                "Returned")
                                          Text(
                                            _completedList[index]['newdate']
                                                .toString(),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                // color: ColorsTheme.mainColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildCancelledCont() {
    if (viewSpinkit == true) {
      return Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                // height: 620,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: SpinKitFadingCircle(
                    color: ColorsTheme.mainColor,
                    size: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (_cancelList.isEmpty) {
      return Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.event_busy,
                      size: 100,
                      color: Colors.grey[500],
                    ),
                    Text(
                      'You have no cancelled transaction.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[500],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 15, right: 15, top: 5),
              // color: Colors.white,
              child: ListView.builder(
                padding: const EdgeInsets.all(0),
                itemCount: _cancelList.length,
                // scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  String newDate = "";
                  String date = "";

                  if (_cancelList[index]['tran_stat'] == "Delivered") {
                    date = _cancelList[index]['date_del'].toString();
                    DateTime s = DateTime.parse(date);
                    newDate = DateFormat("MMM dd, yyyy").format(s) +
                        ' at ' +
                        DateFormat("hh:mm aaa").format(s);
                    _cancelList[index]['newdate'] = newDate.toString();
                    amount = _cancelList[index]['tot_del_amt'];
                  } else {
                    amount = _cancelList[index]['tot_amt'];
                  }
                  if (_cancelList[index]['tran_stat'] == "Pending" ||
                      _cancelList[index]['tran_stat'] == "On-Process") {
                    date = _cancelList[index]['date_req'].toString();
                    DateTime s = DateTime.parse(date);
                    newDate = DateFormat("MMM dd, yyyy").format(s) +
                        ' at ' +
                        DateFormat("hh:mm aaa").format(s);
                    _cancelList[index]['newdate'] = newDate.toString();
                    tranStatus = 'Submitted';
                  } else {
                    tranStatus = _cancelList[index]['tran_stat'].toString();
                  }
                  if (_cancelList[index]['tran_stat'] == "Approved") {
                    date = _cancelList[index]['date_app'].toString();
                    DateTime s = DateTime.parse(date);
                    newDate = DateFormat("MMM dd, yyyy").format(s) +
                        ' at ' +
                        DateFormat("hh:mm aaa").format(s);
                    _cancelList[index]['newdate'] = newDate.toString();
                  }
                  if (_cancelList[index]['tran_stat'] == "Returned") {
                    date = _cancelList[index]['date_del'].toString();
                    DateTime s = DateTime.parse(date);
                    newDate = DateFormat("MMM dd, yyyy").format(s) +
                        ' at ' +
                        DateFormat("hh:mm aaa").format(s);
                    _cancelList[index]['newdate'] = newDate.toString();
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            UserData.trans = _cancelList[index]['tran_no'];
                            UserData.sname = _cancelList[index]['store_name'];
                            OrderData.trans = _cancelList[index]['tran_no'];
                            OrderData.name = _cancelList[index]['cust_name'];
                            OrderData.pmeth = _cancelList[index]['p_meth'];
                            OrderData.itmno = _cancelList[index]['itm_count'];
                            OrderData.totamt = _cancelList[index]['tot_amt'];
                            OrderData.status = _cancelList[index]['tran_stat'];
                            OrderData.signature =
                                _cancelList[index]['signature'];
                            OrderData.dateReq = _cancelList[index]['date_req'];
                            OrderData.dateApp = _cancelList[index]['date_app'];
                            OrderData.dateDel = _cancelList[index]['date_del'];
                            OrderData.pmtype = _cancelList[index]['pmeth_type'];
                            CustomerData.accountCode =
                                _cancelList[index]['account_code'];
                            clearChequeData();
                            checkifDiscounted();
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return OrdersAndTracking();
                            // }));
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: OrdersAndTracking()));
                          },
                          child: Container(
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
                                    width: 5,
                                    height: 80,
                                    color: ColorsTheme.mainColor,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 3 +
                                            30,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Order # ' +
                                              _cancelList[index]['tran_no'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _cancelList[index]['store_name'],
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          _cancelList[index]['date_req'],
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
                                          margin: EdgeInsets.only(left: 50),
                                          width: 105,
                                          // color: Colors.blueGrey,
                                          padding: EdgeInsets.only(
                                              left: 5, right: 5),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                'Total Amount',
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                formatCurrencyTot.format(
                                                    double.parse(amount)),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    // color: ColorsTheme.mainColor,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
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
                                    padding:
                                        EdgeInsets.only(left: 5, right: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          tranStatus.toString(),
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: ColorsTheme.mainColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        if ((_cancelList[index]['tran_stat'])
                                                    .toString() ==
                                                "Pending" ||
                                            (_cancelList[index]['tran_stat'])
                                                    .toString() ==
                                                "On-Process")
                                          Text(
                                            _cancelList[index]['newdate'],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                // color: ColorsTheme.mainColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        if ((_cancelList[index]['tran_stat'])
                                                .toString() ==
                                            "Approved")
                                          Text(
                                            _cancelList[index]['newdate'],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                // color: ColorsTheme.mainColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        if ((_cancelList[index]['tran_stat'])
                                                    .toString() ==
                                                "Delivered" ||
                                            (_cancelList[index]['tran_stat'])
                                                    .toString() ==
                                                "Returned")
                                          Text(
                                            _cancelList[index]['newdate']
                                                .toString(),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                // color: ColorsTheme.mainColor,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
