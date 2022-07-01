import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesman/db/db_helper.dart';
// import 'package:salesman/url/url.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/assets.dart';
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
  String imgPath = "";
  double categHeight = 0.00;

  final db = DatabaseHelper();

  bool noImage = false;
  bool viewSpinkit = false;
  bool _expandedCustomer = false;
  bool _expandedItems = false;
  bool _expandedUnsItems = false;
  bool _expandedRetItems = false;
  List _sList = [];
  List _salesList = [];
  List _wsalesList = [];
  List _msalesList = [];
  List _ysalesList = [];
  List _imgpath = [];
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
    loadImagePath();
    loadSales();
  }

  loadImagePath() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + '/';
    imgPath = firstPath;
  }

  loadSales() async {
    loadSalesType();
    //SALESMAN
    loadJefeDailySales();
    loadJefeWeeklySales();
    loadJefeMonthlySales();
    loadJefeYearlySales();
    //CUSTOMER
    loadCustomerDailySales();
    loadCustomerWeeklySales();
    loadCustomerMonthlySales();
    loadCustomerYearlysales();
    //ITEMS
    loadItemDailySales();
    loadItemWeeklySales();
    loadItemMonthlySales();
    loadItemYearlySales();
  }

  loadItemYearlySales() async {
    _itmYsalesList.clear();
    _sList.clear();
    var getYsales = await db.getItemYearlySales();
    _sList = getYsales;
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _itmYsalesList.add(element);
      });
    });
    // print(_itmYsalesList);
    itemSalesTypeChanged();
    viewSpinkit = false;
  }

  loadItemMonthlySales() async {
    _itmMsalesList.clear();
    _sList.clear();
    var getMsales = await db.getItemMonthlySales();
    _sList = getMsales;
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _itmMsalesList.add(element);
      });
    });
    // print(_itmMsalesList);
    itemSalesTypeChanged();
    viewSpinkit = false;
  }

  loadItemWeeklySales() async {
    DateTime dateTime = DateTime.now();
    DateTime d1 = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    DateTime d2 =
        dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
    _itmWsalesList.clear();
    _sList.clear();
    var getWsales = await db.getItemWeeklySales(d1, d2);
    _sList = getWsales;
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _itmWsalesList.add(element);
      });
    });
    // print(_itmWsalesList);
    itemSalesTypeChanged();
    viewSpinkit = false;
  }

  loadItemDailySales() async {
    _itmDsalesList.clear();
    _sList.clear();
    var getDsales = await db.getItemDailySales();
    _sList = json.decode(json.encode(getDsales));
    // print(_sList);
    _sList.forEach((element) async {
      if (!mounted) return;
      setState(() {
        _itmDsalesList.add(element);
      });
    });
    itemSalesTypeChanged();
    viewSpinkit = false;
  }

  loadCustomerYearlysales() async {
    _custYsalesList.clear();
    _sList.clear();
    var getDsales = await db.getCustomerYearlySales(
        UserData.id, SalesData.overallSalesType.toString().toUpperCase());
    _sList = json.decode(json.encode(getDsales));
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _custYsalesList.add(element);
      });
    });
    // viewSpinkit = false;
  }

  loadCustomerMonthlySales() async {
    _custMsalesList.clear();
    _sList.clear();
    var getDsales = await db.getCustomerMonthlySales(
        UserData.id, SalesData.overallSalesType.toString().toUpperCase());
    _sList = json.decode(json.encode(getDsales));
    // print(_sList);
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _custMsalesList.add(element);
      });
    });
    // viewSpinkit = false;
  }

  loadCustomerWeeklySales() async {
    DateTime dateTime = DateTime.now();
    DateTime d1 = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    DateTime d2 =
        dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
    _custWsalesList.clear();
    _sList.clear();
    var getDsales = await db.getCustomerWeeklySales(UserData.id,
        SalesData.overallSalesType.toString().toUpperCase(), d1, d2);
    // _sList = getDsales;
    _sList = json.decode(json.encode(getDsales));

    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _custWsalesList.add(element);
      });

      // startdate = element['week_start'];
      // enddate = element['week_end'];
      // DateTime s = DateTime.parse(startdate);
      // DateTime e = DateTime.parse(enddate);
      // weekstart = DateFormat("MMM dd ").format(s);
      // weekend = DateFormat("MMM dd yyyy ").format(e);
    });

    // viewSpinkit = false;
  }

  loadCustomerDailySales() async {
    _custDsalesList.clear();
    _sList.clear();
    var getDsales = await db.getCustomerDailySales(
        UserData.id, SalesData.overallSalesType.toString().toUpperCase());
    // _sList = getDsales;
    _sList = json.decode(json.encode(getDsales));
    _sList.forEach((element) {
      if (!mounted) return;
      setState(() {
        _custDsalesList.add(element);
      });
    });
    customerSalesTypeChanged();
    // viewSpinkit = false;
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
      // print(element);
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

    // print(_sList);
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
      // print(element);
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

  itemSalesTypeChanged() {
    if (SalesData.itemSalesType == 'Today') {
      _itemsalelist.clear();
      List nums = [];
      _itmDsalesList.forEach((element) {
        setState(() {
          nums.add(element);
        });
      });

      nums.sort((b, a) => int.parse(a['total'].toString())
          .compareTo(int.parse(b['total'].toString())));
      nums.forEach((element) {
        setState(() {
          String desc = element['item_desc'];
          _itmDsalesList.forEach((element) {
            setState(() {
              if (desc == (element['item_desc'])) {
                _itemsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.itemSalesType == 'Week') {
      _itemsalelist.clear();
      List nums = [];
      _itmWsalesList.forEach((element) {
        setState(() {
          nums.add(element);
        });
      });
      // nums.sort((b, a) => a['total'].compareTo(b['total']));
      nums.sort((b, a) => int.parse(a['total'].toString())
          .compareTo(int.parse(b['total'].toString())));
      nums.forEach((element) {
        setState(() {
          String desc = element['item_desc'];
          _itmWsalesList.forEach((element) {
            setState(() {
              if (desc == (element['item_desc'])) {
                _itemsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.itemSalesType == 'Month') {
      _itemsalelist.clear();
      List nums = [];
      _itmMsalesList.forEach((element) {
        setState(() {
          nums.add(element);
        });
      });
      // nums.sort((b, a) => a['total'].compareTo(b['total']));
      nums.sort((b, a) => int.parse(a['total'].toString())
          .compareTo(int.parse(b['total'].toString())));
      nums.forEach((element) {
        setState(() {
          String desc = element['item_desc'];
          _itmMsalesList.forEach((element) {
            setState(() {
              if (desc == (element['item_desc'])) {
                _itemsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.itemSalesType == 'Year') {
      _itemsalelist.clear();
      List nums = [];
      _itmYsalesList.forEach((element) {
        setState(() {
          nums.add(element);
        });
      });
      // nums.sort((b, a) => a['total'].compareTo(b['total']));
      nums.sort((b, a) => int.parse(a['total'].toString())
          .compareTo(int.parse(b['total'].toString())));
      nums.forEach((element) {
        setState(() {
          String desc = element['item_desc'];
          _itmYsalesList.forEach((element) {
            setState(() {
              if (desc == (element['item_desc'])) {
                _itemsalelist.add(element);
              }
            });
          });
        });
      });
    }
  }

  customerSalesTypeChanged() {
    if (SalesData.customerSalesType == 'Today') {
      _custsalelist.clear();
      List<double> nums = [];
      _custDsalesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total'].toString()));
        });
      });

      nums.sort((b, a) => a.compareTo(b));
      nums.forEach((element) {
        setState(() {
          double amt = element;
          _custDsalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'].toString())) {
                _custsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.customerSalesType == 'Week') {
      _custsalelist.clear();
      List<double> nums = [];
      _custWsalesList.forEach((element) {
        setState(() {
          nums.add(double.parse(element['total'].toString()));
        });
      });
      nums.sort((b, a) => a.compareTo(b));
      nums.forEach((element) {
        setState(() {
          double amt = element;
          _custWsalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'].toString())) {
                _custsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.customerSalesType == 'Month') {
      _custsalelist.clear();
      List<double> nums = [];
      _custMsalesList.forEach((element) {
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
          _custMsalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'].toString())) {
                _custsalelist.add(element);
              }
            });
          });
        });
      });
    }
    if (SalesData.customerSalesType == 'Year') {
      _custsalelist.clear();
      List<double> nums = [];
      _custYsalesList.forEach((element) {
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
          _custYsalesList.forEach((element) {
            setState(() {
              if (amt == double.parse(element['total'].toString())) {
                _custsalelist.add(element);
              }
            });
          });
        });
      });
    }
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
      // print(_totlist);
      SalesData.overallSalesType = 'Overall';
    });
  }

  overAllSalesTypeChanged() {
    // print(SalesData.overallSalesType);
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
        loadCustomerDailySales();
        loadCustomerWeeklySales();
        loadCustomerMonthlySales();
        loadCustomerYearlysales();
        //     //ITEM
        loadItemDailySales();
        loadItemWeeklySales();
        loadItemMonthlySales();
        loadItemYearlySales();
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
      loadCustomerDailySales();
      loadCustomerWeeklySales();
      loadCustomerMonthlySales();
      loadCustomerYearlysales();
      // //ITEM
      loadItemDailySales();
      loadItemWeeklySales();
      loadItemMonthlySales();
      loadItemYearlySales();
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
        loadCustomerDailySales();
        loadCustomerWeeklySales();
        loadCustomerMonthlySales();
        loadCustomerYearlysales();
        //ITEM
        loadItemDailySales();
        loadItemWeeklySales();
        loadItemMonthlySales();
        loadItemYearlySales();
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ExpansionPanelList(
                    expandedHeaderPadding: EdgeInsets.all(1),
                    animationDuration: Duration(milliseconds: 300),
                    expansionCallback: (int i, bool isExpanded) {
                      _expandedCustomer = !_expandedCustomer;
                      setState(() {});
                    },
                    children: [
                      ExpansionPanel(
                        canTapOnHeader: true,
                        backgroundColor: Colors.deepOrange[100],
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Row(
                              children: [
                                Icon(Icons.groups),
                                SizedBox(width: 10),
                                Text(
                                  'Customer',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        body: Column(
                          children: [
                            buildCustomerCont(),
                          ],
                        ),
                        isExpanded: _expandedCustomer,
                      ),
                    ],
                  ),
                  ExpansionPanelList(
                    expandedHeaderPadding: EdgeInsets.all(1),
                    animationDuration: Duration(milliseconds: 300),
                    expansionCallback: (int i, bool isExpanded) {
                      _expandedItems = !_expandedItems;
                      setState(() {});
                    },
                    children: [
                      ExpansionPanel(
                        canTapOnHeader: true,
                        backgroundColor: Colors.blue[100],
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Row(
                              children: [
                                Icon(Icons.shopping_basket),
                                SizedBox(width: 10),
                                Text(
                                  'Items',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          );
                        },
                        body: Column(
                          children: [
                            buildItemCont(),
                          ],
                        ),
                        isExpanded: _expandedItems,
                      ),
                    ],
                  ),
                  ExpansionPanelList(
                    expandedHeaderPadding: EdgeInsets.all(1),
                    animationDuration: Duration(milliseconds: 300),
                    expansionCallback: (int i, bool isExpanded) {
                      _expandedUnsItems = !_expandedUnsItems;
                      setState(() {});
                    },
                    children: [
                      ExpansionPanel(
                        canTapOnHeader: true,
                        backgroundColor: Colors.yellowAccent[100],
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Row(
                              children: [
                                Icon(Icons.shopping_basket),
                                SizedBox(width: 10),
                                Text(
                                  'Unserved Items',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          );
                        },
                        body: Column(
                          children: [
                            // buildItemCont(),
                          ],
                        ),
                        isExpanded: _expandedUnsItems,
                      ),
                    ],
                  ),
                  ExpansionPanelList(
                    expandedHeaderPadding: EdgeInsets.all(1),
                    animationDuration: Duration(milliseconds: 300),
                    expansionCallback: (int i, bool isExpanded) {
                      _expandedRetItems = !_expandedRetItems;
                      setState(() {});
                    },
                    children: [
                      ExpansionPanel(
                        canTapOnHeader: true,
                        backgroundColor: Colors.black12,
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            title: Row(
                              children: [
                                Icon(Icons.shopping_basket),
                                SizedBox(width: 10),
                                Text(
                                  'Returned Items',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                          );
                        },
                        body: Column(
                          children: [
                            // buildItemCont(),
                          ],
                        ),
                        isExpanded: _expandedRetItems,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildItemCont() {
    if (viewSpinkit == true) {
      return Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: SpinKitFadingCircle(
            color: ColorsTheme.mainColor,
            size: 50,
          ),
        ),
      );
    }
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.blue[50],
          border: Border.all(color: Colors.blue.shade50),
          borderRadius: BorderRadius.circular(0)),
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 2,
                      // color: Colors.grey,
                      child: Stack(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 15),
                                child: Container(
                                  child: Text(
                                    'Top Items',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 0),
                                // width: MediaQuery.of(context).size.width / 2,
                                // color: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: SalesData.itemSalesType,
                                          items: _itmtypelist.map((item) {
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
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              SalesData.itemSalesType =
                                                  newValue;
                                              itemSalesTypeChanged();
                                            });
                                          },
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
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      width: MediaQuery.of(context).size.width - 2,
                      height: 30,
                      color: Colors.blue[200],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Item Description',
                              style: TextStyle(),
                            ),
                          ),
                          Text(
                            SalesData.itmTotalCaption.toString(),
                            style: TextStyle(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 2,
                      height: MediaQuery.of(context).size.height / 2 - 80,
                      padding: EdgeInsets.only(bottom: 5),
                      // color: Colors.transparent,
                      color: Colors.blue[50],
                      child: ListView.builder(
                          padding: const EdgeInsets.only(top: 1),
                          itemCount: _itemsalelist.length,
                          itemBuilder: (context, index) {
                            if (_itemsalelist[index]['image'] == '' ||
                                _itemsalelist[index]['image'] == null) {
                              noImage = true;
                            } else {
                              noImage = false;
                            }
                            return Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width:
                                        MediaQuery.of(context).size.width - 35,
                                    height: 80,
                                    color: Colors.transparent,
                                    child: Stack(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 5,
                                              height: 80,
                                              color: ColorsTheme.mainColor,
                                            ),
                                            if (GlobalVariables.viewImg)
                                              Container(
                                                height: 80,
                                                margin: EdgeInsets.only(
                                                    left: 3, top: 0),
                                                width: 75,
                                                color: Colors.white,
                                                child: noImage
                                                    ? Image(
                                                        image: AssetsValues
                                                            .noImageImg)
                                                    : Image.file(File(imgPath +
                                                        _itemsalelist[index]
                                                            ['image'])),
                                              ),
                                            if (!GlobalVariables.viewImg)
                                              Container(
                                                  margin: EdgeInsets.only(
                                                      left: 3, top: 3),
                                                  width: 75,
                                                  color: Colors.white,
                                                  child: Image(
                                                      image: AssetsValues
                                                          .noImageImg)),
                                            Container(
                                              color: Colors.white,
                                              height: 80,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  150,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _itemsalelist[index]
                                                        ['item_desc'],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    // overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              height: 80,
                                              width: 40,
                                              color: Colors.white,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    _itemsalelist[index]
                                                            ['total']
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
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
    );
  }

  Container buildCustomerCont() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
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
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 2,
                      // color: Colors.grey,
                      child: Stack(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 15),
                                child: Container(
                                  child: Text(
                                    'Top Customer',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(left: 20, right: 0),
                                // width: MediaQuery.of(context).size.width / 2,
                                // color: Colors.grey,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton<String>(
                                          value: SalesData.customerSalesType,
                                          items: _custtypelist.map((item) {
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
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              SalesData.customerSalesType =
                                                  newValue;
                                              customerSalesTypeChanged();
                                            });
                                          },
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
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      width: MediaQuery.of(context).size.width - 2,
                      height: 30,
                      color: Colors.deepOrange[200],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              'Name',
                              style: TextStyle(),
                            ),
                          ),
                          Container(
                            // width: 110,
                            child: Text(
                              SalesData.custTotalCaption.toString(),
                              style: TextStyle(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 2,
                      height: MediaQuery.of(context).size.height / 3 - 80,
                      color: Colors.transparent,
                      child: ListView.builder(
                          padding: const EdgeInsets.only(top: 1),
                          itemCount: _custsalelist.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    width:
                                        MediaQuery.of(context).size.width - 35,
                                    height: 50,
                                    color: Colors.transparent,
                                    child: Stack(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              // color: Colors.grey,
                                              // height: ,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  150,
                                              child: Text(
                                                _custsalelist[index]
                                                    ['store_name'],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                                // overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              formatCurrencyAmt.format(
                                                  double.parse(
                                                      _custsalelist[index]
                                                              ['total']
                                                          .toString())),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
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
