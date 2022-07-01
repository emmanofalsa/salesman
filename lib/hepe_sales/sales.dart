import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';

class HepeSalesPage extends StatefulWidget {
  const HepeSalesPage({Key? key}) : super(key: key);

  @override
  State<HepeSalesPage> createState() => _HepeSalesPageState();
}

class _HepeSalesPageState extends State<HepeSalesPage> {
  var colorCode = '';
  String startdate = "";
  String enddate = "";
  String weekstart = "";
  String weekend = "";
  double categHeight = 0.00;

  final db = DatabaseHelper();

  bool _expandedSalesman = false;
  bool _expandedCustomer = false;
  bool _expandedItems = false;
  List _sList = [];
  List _salesList = [];
  List _wsalesList = [];
  List _msalesList = [];
  List _ysalesList = [];
  // List _smList = [];
  List _smsalelist = [];
  List _totlist = [];
  List _smtypelist = [];
  List _custtypelist = [];
  List _itmtypelist = [];
  List _custsalelist = [];
  List _itemsalelist = [];
  List _custDsalesList = [];
  List _custWsalesList = [];
  List _custMsalesList = [];
  List _custYsalesList = [];
  List _itmDsalesList = [];
  List _itmWsalesList = [];
  List _itmMsalesList = [];
  List _itmYsalesList = [];

  final formatCurrencyAmt =
      new NumberFormat.currency(locale: "en_US", symbol: "P");
  final formatCurrencyTot =
      new NumberFormat.currency(locale: "en_US", symbol: "Php ");

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  final String today =
      DateFormat("EEEE, MMM-dd-yyyy").format(new DateTime.now());
  final date =
      DateTime.parse(DateFormat("yyyy-mm-dd").format(new DateTime.now()));

  final String month = DateFormat("MMMM yyyy").format(new DateTime.now());
  final String year = DateFormat("yyyy").format(new DateTime.now());

  void initState() {
    super.initState();
    loadSales();
  }

  loadSales() async {
    loadSalesType();
    //SALESMAN
    loadJefeDailySales();
    loadJefeWeeklySales();
    loadJefeMonthlySales();
    loadJefeYearlySales();
    //CUSTOMER
    // loadCustomerDailySales();
    // loadCustomerWeeklySales();
    // loadCustomerMonthlySales();
    // loadCustomerYearlysales();
    //ITEMS
    // loadItemDailySales();
    // loadItemWeeklySales();
    // loadItemMonthlySales();
    // loadItemYearlySales();
  }

  loadJefeYearlySales() async {
    SalesData.salesYearly = '0.00';
    _ysalesList.clear();
    double totalSales = 0.00;
    _sList.clear();
    var getDsales = await db.getYearlySales(
        UserData.id, SalesData.overallSalesType.toString().toUpperCase());
    // _sList = getDsales;
    _sList = json.decode(json.encode(getDsales));
    _sList.forEach((element) {
      if (element['total'] == null) {
        element['total'] = "0.00";
      }
      setState(() {
        totalSales = totalSales + double.parse(element['total'].toString());
        _ysalesList.add(element);
      });
    });
    SalesData.salesYearly = totalSales.toStringAsFixed(2);
    // viewSpinkit = false;
  }

  loadJefeMonthlySales() async {
    SalesData.salesMonthly = '0.00';
    _msalesList.clear();
    double totalSales = 0.00;
    _sList.clear();
    var getDsales = await db.getMonthlySales(
        UserData.id, SalesData.overallSalesType.toString().toUpperCase());
    // _sList = getDsales;
    _sList = json.decode(json.encode(getDsales));
    _sList.forEach((element) {
      if (element['total'] == null) {
        element['total'] = "0.00";
      }
      print(element);
      setState(() {
        totalSales = totalSales + double.parse(element['total'].toString());
        _msalesList.add(element);
      });
    });
    SalesData.salesMonthly = totalSales.toStringAsFixed(2);

    // viewSpinkit = false;
  }

  loadJefeWeeklySales() async {
    DateTime dateTime = DateTime.now();
    DateTime d1 = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    DateTime d2 =
        dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
    weekstart = DateFormat("MMM dd ").format(d1);
    weekend = DateFormat("MMM dd yyyy ").format(d2);

    SalesData.salesWeekly = '0.00';
    _wsalesList.clear();
    double totalSales = 0.00;
    _sList.clear();
    var getDsales = await db.getWeeklySales(UserData.id,
        SalesData.overallSalesType.toString().toUpperCase(), d1, d2);
    // _sList = getDsales;
    _sList = json.decode(json.encode(getDsales));

    print(_sList);
    _sList.forEach((element) {
      if (element['total'] == null) {
        element['total'] = "0.00";
      }
      if (!mounted) return;
      // setState(() {
      totalSales = totalSales + double.parse(element['total'].toString());
      _wsalesList.add(element);
      // });
    });
    SalesData.salesWeekly = totalSales.toStringAsFixed(2);
    // viewSpinkit = false;
  }

  loadJefeDailySales() async {
    SalesData.salesToday = '0.00';
    double totalSales = 0.00;
    _salesList.clear();
    _sList.clear();
    var getDsales = await db.getDailySales(
        UserData.id, SalesData.overallSalesType.toString().toUpperCase());
    // _sList = getDsales;
    _sList = json.decode(json.encode(getDsales));
    _sList.forEach((element) {
      print(element);
      if (element['total'] == null) {
        element['total'] = "0.00";
      }
      if (!mounted) return;
      setState(() {
        totalSales = totalSales + double.parse(element['total'].toString());
        _salesList.add(element);
      });
    });
    SalesData.salesToday = totalSales.toStringAsFixed(2);
    // viewSpinkit = false;
    jefeSalesTypeChanged();
  }

  jefeSalesTypeChanged() {
    if (SalesData.salesmanSalesType == 'Today') {
      _smsalelist.clear();
      List<double> nums = [];
      _salesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total'].toString()));
        });
      });
      nums.sort((b, a) => a.compareTo(b));
      // print(nums);
      nums.forEach((element) {
        setState(() {
          double amt = element;
          // print(amt);
          _salesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'].toString())) {
                _smsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.salesmanSalesType == 'Week') {
      _smsalelist.clear();
      List<double> nums = [];
      _wsalesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total']));
        });
      });
      nums.sort((b, a) => a.compareTo(b));
      // print(nums);
      nums.forEach((element) {
        setState(() {
          double amt = element;
          // print(amt);
          _wsalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'])) {
                _smsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.salesmanSalesType == 'Month') {
      _smsalelist.clear();
      List<double> nums = [];
      _msalesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total']));
        });
      });
      nums.sort((b, a) => a.compareTo(b));
      // print(nums);
      nums.forEach((element) {
        setState(() {
          double amt = element;
          // print(amt);
          _msalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'])) {
                _smsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.salesmanSalesType == 'Year') {
      _smsalelist.clear();
      List<double> nums = [];
      _ysalesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total']));
        });
      });
      nums.sort((b, a) => a.compareTo(b));
      // print(nums);
      nums.forEach((element) {
        setState(() {
          double amt = element;
          // print(amt);
          _ysalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'])) {
                _smsalelist.add(element);
              }
            });
          });
        });
      });
    }
  }

  loadSalesType() async {
    SalesData.overallSalesType = 'Overall';
    SalesData.smTotalCaption = 'Sales';
    SalesData.custTotalCaption = 'Total Amount';
    SalesData.itmTotalCaption = 'Total Qty';
    _smtypelist.clear();
    _custtypelist.clear();
    _itmtypelist.clear();
    _totlist.clear();
    var getU = await db.getSalesType();
    if (!mounted) return;
    setState(() {
      _smtypelist = getU;
      _custtypelist = getU;
      _itmtypelist = getU;
      SalesData.salesmanSalesType = 'Today';
      SalesData.customerSalesType = 'Today';
      SalesData.itemSalesType = 'Today';
    });
    var getT = await db.getTotalSalesType();
    if (!mounted) return;
    setState(() {
      _totlist = getT;
      print(_totlist);
      SalesData.overallSalesType = 'Overall';
    });
  }

  overAllSalesTypeChanged() {
    print(SalesData.overallSalesType);
    if (SalesData.overallSalesType == 'Overall') {
      setState(() {
        _smsalelist.clear();
        _custsalelist.clear();
        _itemsalelist.clear();
        SalesData.smTotalCaption = 'Sales';
        SalesData.custTotalCaption = 'Total Amount';
        SalesData.salesmanSalesType = 'Today';
        SalesData.customerSalesType = 'Today';
        SalesData.itemSalesType = 'Today';
        loadJefeDailySales();
        loadJefeWeeklySales();
        loadJefeMonthlySales();
        loadJefeYearlySales();
        //     //CUSTOMER
        //     loadCustomerDailySales();
        //     loadCustomerWeeklySales();
        //     loadCustomerMonthlySales();
        //     loadCustomerYearlysales();
        //     //ITEM
        //     loadItemDailySales();
        //     loadItemWeeklySales();
        //     loadItemMonthlySales();
        //     loadItemYearlySales();
      });
    }
    if (SalesData.overallSalesType == 'Cash') {
      // setState(() {
      _smsalelist.clear();
      _custsalelist.clear();
      _itemsalelist.clear();
      SalesData.smTotalCaption = 'Cash Total';
      SalesData.custTotalCaption = 'Cash Total';
      SalesData.salesmanSalesType = 'Today';
      SalesData.customerSalesType = 'Today';
      SalesData.itemSalesType = 'Today';
      loadJefeDailySales();
      loadJefeWeeklySales();
      loadJefeMonthlySales();
      loadJefeYearlySales();
      // //FOR CUSTOMER
      // loadCustomerDailySales();
      // loadCustomerWeeklySales();
      // loadCustomerMonthlySales();
      // loadCustomerYearlysales();
      // //ITEM
      // loadItemDailySales();
      // loadItemWeeklySales();
      // loadItemMonthlySales();
      // loadItemYearlySales();
      // });
    }
    if (SalesData.overallSalesType == 'Cheque') {
      setState(() {
        _smsalelist.clear();
        _custsalelist.clear();
        _itemsalelist.clear();
        SalesData.smTotalCaption = 'Cheque Total';
        SalesData.custTotalCaption = 'Cheque Total';
        SalesData.salesmanSalesType = 'Today';
        SalesData.customerSalesType = 'Today';
        SalesData.itemSalesType = 'Today';
        loadJefeDailySales();
        loadJefeWeeklySales();
        loadJefeMonthlySales();
        loadJefeYearlySales();
        //FOR CUSTOMER
        // loadCustomerDailySales();
        // loadCustomerWeeklySales();
        // loadCustomerMonthlySales();
        // loadCustomerYearlysales();
        //ITEM
        // loadItemDailySales();
        // loadItemWeeklySales();
        // loadItemMonthlySales();
        // loadItemYearlySales();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: ScreenData.scrHeight * .085,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Column(
          children: [
            Text(
              "Sales",
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: ColorsTheme.mainColor,
                  fontSize: 45,
                  fontWeight: FontWeight.bold),
            ),
            // SizedBox(height: 50),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildSalesCont(),
        ],
      ),
    );
  }

  Container buildSalesCont() {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10)),
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      // width: MediaQuery.of(context).size.width - 40,
                      height: 30,
                      // color: Colors.grey,
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            value: SalesData.overallSalesType,
                            items: _totlist.map((item) {
                              return new DropdownMenuItem(
                                child: new Text(
                                  item['type'],
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                value: item['type'].toString(),
                              );
                            }).toList(),
                            onChanged: (String? newV) {
                              SalesData.overallSalesType = newV;
                              overAllSalesTypeChanged();
                              // setState(() {
                              //   SalesData.overallSalesType = newV;
                              //   overAllSalesTypeChanged();
                              // });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        // color: Colors.grey,
                        child: Stack(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  height: 100,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      30,
                                  decoration: BoxDecoration(
                                      color: Colors.orange[300],
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10)),
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
                                            child: Text(
                                              'Today',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
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
                                            // color: Colors.grey,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  formatCurrencyAmt
                                                      .format(double.parse(
                                                          SalesData.salesToday
                                                              .toString()))
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
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
                                            child: Text(
                                              today,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
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
                              width: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      30,
                                  decoration: BoxDecoration(
                                      color: Colors.blue[300],
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10)),
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
                                            child: Text(
                                              'Week',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
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
                                            // color: Colors.grey,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  formatCurrencyAmt
                                                      .format(double.parse(
                                                          SalesData.salesWeekly
                                                              .toString()))
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
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
                                            child: Text(
                                              weekstart + '-' + weekend,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        // color: Colors.grey,
                        child: Stack(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 5),
                                  height: 100,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      30,
                                  decoration: BoxDecoration(
                                      color: Colors.green[300],
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10)),
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
                                            child: Text(
                                              'Month',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
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
                                            // color: Colors.grey,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  formatCurrencyAmt
                                                      .format(double.parse(
                                                          SalesData.salesMonthly
                                                              .toString()))
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
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
                                            child: Text(
                                              month,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  height: 100,
                                  width: MediaQuery.of(context).size.width / 2 -
                                      30,
                                  decoration: BoxDecoration(
                                      color: Colors.purple[300],
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10)),
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
                                            child: Text(
                                              'Year',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w400,
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
                                            // color: Colors.grey,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: <Widget>[
                                                Text(
                                                  formatCurrencyAmt
                                                      .format(double.parse(
                                                          SalesData.salesYearly
                                                              .toString()))
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 24,
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
                                            child: Text(
                                              year,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
