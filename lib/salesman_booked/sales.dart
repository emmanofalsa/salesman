// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// // import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:intl/intl.dart';
// // import 'package:salesman/api.dart';

// import 'package:salesman/userdata.dart';

// class SalesmanSales extends StatefulWidget {
//   @override
//   _SalesmanSalesState createState() => _SalesmanSalesState();
// }

// class _SalesmanSalesState extends State<SalesmanSales> {
//   var colorCode = '';
//   String startDate = "";
//   String endDate = "";
//   String weekStart = "";
//   String weekEnd = "";

//   List _sList = [];
//   List _salesList = [];
//   List _wsalesList = [];
//   List _msalesList = [];
//   List _ysalesList = [];
//   // List _smList = [];
//   List _smsalelist = [];
//   List _tolist = [];
//   List _totlist = [];
//   List _toolist = [];
//   List _custsalelist = [];
//   List _custDsalesList = [];
//   List _custWsalesList = [];
//   List _custMsalesList = [];
//   List _custYsalesList = [];

//   bool viewSpinkit = true;

//   final formatCurrencyAmt =
//       new NumberFormat.currency(locale: "en_US", symbol: "₱");
//   final formatCurrencyTot =
//       new NumberFormat.currency(locale: "en_US", symbol: "Php ");

//   DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

//   final String today =
//       DateFormat("EEEE, MMM-dd-yyyy").format(new DateTime.now());
//   final date =
//       DateTime.parse(DateFormat("yyyy-mm-dd").format(new DateTime.now()));

//   final String month = DateFormat("MMMM yyyy").format(new DateTime.now());
//   final String year = DateFormat("yyyy").format(new DateTime.now());

//   void initState() {
//     super.initState();
//     SalesData.overallSalesType = 'Overall';
//     SalesData.custTotalCaption = 'Total Amount';
//     SalesData.salesmanSalesType = 'Today';
//     SalesData.customerSalesType = 'Today';
//     loadSalesType();
//   }

//   loadCustomerYearlysales() async {
//     _custYsalesList.clear();
//     // double totalSales = 0.00;

//     _sList.clear();

//     var getDsales = await getMyCustomerYearlySales(
//         UserData.id, SalesData.overallSalesType.toUpperCase());

//     _sList = getDsales;
//     _sList.forEach((element) {
//       if (element['sm_code'] != null) {
//         setState(() {
//           _custYsalesList.add(element);
//         });
//       }
//     });
//     viewSpinkit = false;
//   }

//   loadCustomerMonthlySales() async {
//     _custMsalesList.clear();
//     // double totalSales = 0.00;

//     _sList.clear();

//     var getDsales = await getMyCustomerMonthlySales(
//         UserData.id, SalesData.overallSalesType.toUpperCase());

//     _sList = getDsales;
//     _sList.forEach((element) {
//       if (element['sm_code'] != null) {
//         setState(() {
//           _custMsalesList.add(element);
//         });
//       }
//     });
//     // viewSpinkit = false;
//   }

//   loadCustomerWeeklySales() async {
//     _custWsalesList.clear();
//     // double totalSales = 0.00;
//     _sList.clear();

//     var getDsales = await getMyCustomerWeeklySales(
//         UserData.id, SalesData.overallSalesType.toUpperCase());

//     _sList = getDsales;
//     // print(_sList);
//     _sList.forEach((element) {
//       // print(element['sm_code']);
//       if (element['sm_code'] != null || element['sm_code'] == "") {
//         setState(() {
//           _custWsalesList.add(element);
//         });
//       }
//       if (_custWsalesList.isEmpty) {
//         weekStart = "";
//         weekEnd = "";
//       } else {
//         startDate = element['week_start'];
//         endDate = element['week_end'];
//         DateTime s = DateTime.parse(startDate);
//         DateTime e = DateTime.parse(endDate);
//         weekStart = DateFormat("MMM dd ").format(s);
//         weekEnd = DateFormat("MMM dd yyyy ").format(e);
//       }
//     });

//     // viewSpinkit = false;
//   }

//   loadCustomerDailySales() async {
//     _custDsalesList.clear();
//     // double totalSales = 0.00;
//     // print(_smList);
//     _sList.clear();

//     var getDsales = await getMyCustomerDailySales(
//         UserData.id, SalesData.overallSalesType.toUpperCase());

//     _sList = getDsales;
//     // print(_sList);
//     _sList.forEach((element) {
//       // if (element['sm_code'] != null) {
//       setState(() {
//         _custDsalesList.add(element);
//         // print(_custDsalesList);
//       });
//       // }
//     });
//     // SalesData.salesYearly = totalSales.toStringAsFixed(2);

//     customerSalesTypeChanged();
//     // viewSpinkit = false;
//   }

//   loadSalesmanYearlySales() async {
//     SalesData.salesYearly = '0.00';
//     _ysalesList.clear();
//     double totalSales = 0.00;
//     _sList.clear();

//     var getDsales = await getMyYearlySales(
//         UserData.id, SalesData.overallSalesType.toUpperCase());

//     _sList = getDsales;
//     // print(_sList);
//     _sList.forEach((element) {
//       if (element['sm_code'] != null) {
//         setState(() {
//           totalSales = totalSales + double.parse(element['total']);
//           _ysalesList.add(element);
//         });
//       }
//     });
//     SalesData.salesYearly = totalSales.toStringAsFixed(2);
//     // viewSpinkit = false;
//   }

//   loadSalesmanMonthlySales() async {
//     SalesData.salesMonthly = '0.00';
//     _msalesList.clear();
//     double totalSales = 0.00;
//     _sList.clear();

//     var getDsales = await getMyMonthlySales(
//         UserData.id, SalesData.overallSalesType.toUpperCase());

//     _sList = getDsales;
//     // print(_sList);
//     _sList.forEach((element) {
//       if (element['sm_code'] != null) {
//         setState(() {
//           totalSales = totalSales + double.parse(element['total']);
//           _msalesList.add(element);
//         });
//       }
//     });
//     // _smsalelist = _salesList;
//     SalesData.salesMonthly = totalSales.toStringAsFixed(2);
//     // viewSpinkit = false;
//   }

//   loadSalesmanWeeklySales() async {
//     SalesData.salesWeekly = '0.00';
//     _wsalesList.clear();
//     double totalSales = 0.00;
//     _sList.clear();

//     var getDsales = await getMyWeeklySales(
//         UserData.id, SalesData.overallSalesType.toUpperCase());

//     _sList = getDsales;
//     // print(_sList);
//     _sList.forEach((element) {
//       if (element['sm_code'] != null) {
//         setState(() {
//           totalSales = totalSales + double.parse(element['total']);
//           _wsalesList.add(element);
//         });
//       }
//     });
//     // _smsalelist = _wsalesList;
//     SalesData.salesWeekly = totalSales.toStringAsFixed(2);
//     // viewSpinkit = false;
//   }

//   loadSalesmanDailySales() async {
//     SalesData.salesToday = '0.00';
//     _salesList.clear();
//     double totalSales = 0.00;
//     _sList.clear();

//     var getDsales = await getMyDailySales(
//         UserData.id, SalesData.overallSalesType.toUpperCase());

//     _sList = getDsales;
//     // print(_sList);
//     _sList.forEach((element) {
//       if (element['sm_code'] != null) {
//         setState(() {
//           totalSales = totalSales + double.parse(element['total']);
//           _salesList.add(element);
//         });
//       }
//     });
//     // _smsalelist = _salesList;
//     SalesData.salesToday = totalSales.toStringAsFixed(2);
//     // viewSpinkit = false;
//     salesmanSalesTypeChanged();
//   }

//   loadSalesType() async {
//     _tolist.clear();
//     _toolist.clear();
//     _totlist.clear();

//     var getU = await getMySalesType();

//     _tolist = getU;
//     _toolist = getU;

//     loadMyTotalSalesType();
//     loadSalesmanDailySales();
//     loadSalesmanWeeklySales();
//     loadSalesmanMonthlySales();
//     loadSalesmanYearlySales();
//     loadCustomerDailySales();
//     loadCustomerWeeklySales();
//     loadCustomerMonthlySales();
//     loadCustomerYearlysales();
//   }

//   loadMyTotalSalesType() async {
//     var getT = await getMyTotalSalesType();
//     setState(() {
//       _totlist = getT;
//       SalesData.overallSalesType = 'Overall';
//     });
//   }

//   overAllSalesTypeChanged() {
//     if (SalesData.overallSalesType == 'Overall') {
//       setState(() {
//         SalesData.smTotalCaption = 'Sales';
//         SalesData.custTotalCaption = 'Total Amount';
//         SalesData.salesmanSalesType = 'Today';
//         SalesData.customerSalesType = 'Today';
//         loadSalesmanDailySales();
//         loadSalesmanWeeklySales();
//         loadSalesmanMonthlySales();
//         loadSalesmanYearlySales();
//         //CUSTOMER
//         loadCustomerDailySales();
//         loadCustomerWeeklySales();
//         loadCustomerMonthlySales();
//         loadCustomerYearlysales();
//       });
//     }
//     if (SalesData.overallSalesType == 'Cash') {
//       SalesData.smTotalCaption = 'Cash Sales';
//       SalesData.custTotalCaption = 'Cash Amount';
//       SalesData.salesmanSalesType = 'Today';
//       SalesData.customerSalesType = 'Today';
//       loadSalesmanDailySales();
//       loadSalesmanWeeklySales();
//       loadSalesmanMonthlySales();
//       loadSalesmanYearlySales();
//       //CUSTOMER
//       loadCustomerDailySales();
//       loadCustomerWeeklySales();
//       loadCustomerMonthlySales();
//       loadCustomerYearlysales();
//     }
//     if (SalesData.overallSalesType == 'Cheque') {
//       SalesData.smTotalCaption = 'Cheque Sales';
//       SalesData.custTotalCaption = 'Cheque Amount';
//       SalesData.salesmanSalesType = 'Today';
//       SalesData.customerSalesType = 'Today';
//       loadSalesmanDailySales();
//       loadSalesmanWeeklySales();
//       loadSalesmanMonthlySales();
//       loadSalesmanYearlySales();
//       //CUSTOMER
//       loadCustomerDailySales();
//       loadCustomerWeeklySales();
//       loadCustomerMonthlySales();
//       loadCustomerYearlysales();
//     }
//   }

//   customerSalesTypeChanged() {
//     if (SalesData.customerSalesType == 'Today') {
//       _custsalelist.clear();
//       List<double> nums = [];
//       _custDsalesList.forEach((element) {
//         setState(() {
//           nums.add(double.parse(element['total']));
//         });
//       });

//       nums.sort((b, a) => a.compareTo(b));
//       nums.forEach((element) {
//         setState(() {
//           double amt = element;
//           _custDsalesList.forEach((element) {
//             setState(() {
//               if (amt == double.parse(element['total'])) {
//                 _custsalelist.add(element);
//               }
//             });
//             // print(_custsalelist);
//           });
//         });
//       });
//     }
//     if (SalesData.customerSalesType == 'Week') {
//       _custsalelist.clear();
//       List<double> nums = [];
//       _custWsalesList.forEach((element) {
//         setState(() {
//           nums.add(double.parse(element['total']));
//         });
//       });
//       nums.sort((b, a) => a.compareTo(b));
//       // print(nums);
//       nums.forEach((element) {
//         setState(() {
//           double amt = element;
//           // print(amt);
//           _custWsalesList.forEach((element) {
//             setState(() {
//               if (amt == double.parse(element['total'])) {
//                 _custsalelist.add(element);
//               }
//             });
//           });
//         });
//       });
//     }
//     if (SalesData.customerSalesType == 'Month') {
//       _custsalelist.clear();
//       List<double> nums = [];
//       _custMsalesList.forEach((element) {
//         setState(() {
//           nums.add(double.parse(element['total']));
//         });
//       });
//       nums.sort((b, a) => a.compareTo(b));
//       // print(nums);
//       nums.forEach((element) {
//         setState(() {
//           double amt = element;
//           // print(amt);
//           _custMsalesList.forEach((element) {
//             setState(() {
//               if (amt == double.parse(element['total'])) {
//                 _custsalelist.add(element);
//               }
//             });
//           });
//         });
//       });
//     }
//     if (SalesData.customerSalesType == 'Year') {
//       _custsalelist.clear();
//       List<double> nums = [];
//       _custYsalesList.forEach((element) {
//         setState(() {
//           nums.add(double.parse(element['total']));
//         });
//       });
//       nums.sort((b, a) => a.compareTo(b));
//       // print(nums);
//       nums.forEach((element) {
//         setState(() {
//           double amt = element;
//           // print(amt);
//           _custYsalesList.forEach((element) {
//             setState(() {
//               if (amt == double.parse(element['total'])) {
//                 _custsalelist.add(element);
//               }
//             });
//           });
//         });
//       });
//     }
//   }

//   salesmanSalesTypeChanged() {
//     if (SalesData.salesmanSalesType == 'Today') {
//       _smsalelist.clear();
//       List<double> nums = [];
//       _salesList.forEach((element) {
//         setState(() {
//           nums.add(double.parse(element['total']));
//         });
//       });
//       nums.sort((b, a) => a.compareTo(b));
//       // print(nums);
//       nums.forEach((element) {
//         setState(() {
//           double amt = element;
//           // print(amt);
//           _salesList.forEach((element) {
//             setState(() {
//               if (amt == double.parse(element['total'])) {
//                 _smsalelist.add(element);
//               }
//             });
//           });
//         });
//       });
//     }
//     if (SalesData.salesmanSalesType == 'Week') {
//       _smsalelist.clear();
//       List<double> nums = [];
//       _wsalesList.forEach((element) {
//         setState(() {
//           nums.add(double.parse(element['total']));
//         });
//       });
//       nums.sort((b, a) => a.compareTo(b));
//       // print(nums);
//       nums.forEach((element) {
//         setState(() {
//           double amt = element;
//           // print(amt);
//           _wsalesList.forEach((element) {
//             setState(() {
//               if (amt == double.parse(element['total'])) {
//                 _smsalelist.add(element);
//               }
//             });
//           });
//         });
//       });
//     }
//     if (SalesData.salesmanSalesType == 'Month') {
//       _smsalelist.clear();
//       List<double> nums = [];
//       _msalesList.forEach((element) {
//         setState(() {
//           nums.add(double.parse(element['total']));
//         });
//       });
//       nums.sort((b, a) => a.compareTo(b));
//       // print(nums);
//       nums.forEach((element) {
//         setState(() {
//           double amt = element;
//           // print(amt);
//           _msalesList.forEach((element) {
//             setState(() {
//               if (amt == double.parse(element['total'])) {
//                 _smsalelist.add(element);
//               }
//             });
//           });
//         });
//       });
//     }
//     if (SalesData.salesmanSalesType == 'Year') {
//       _smsalelist.clear();
//       List<double> nums = [];
//       _ysalesList.forEach((element) {
//         setState(() {
//           nums.add(double.parse(element['total']));
//         });
//       });
//       nums.sort((b, a) => a.compareTo(b));
//       // print(nums);
//       nums.forEach((element) {
//         setState(() {
//           double amt = element;
//           // print(amt);
//           _ysalesList.forEach((element) {
//             setState(() {
//               if (amt == double.parse(element['total'])) {
//                 _smsalelist.add(element);
//               }
//             });
//           });
//         });
//       });
//       // setState(() {
//       //   _smsalelist = _ysalesList;
//       // });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (viewSpinkit == true) {
//       return Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         color: Colors.white,
//         child: Center(
//           child: SpinKitFadingCircle(
//             color: Colors.deepOrange,
//             size: 50,
//           ),
//         ),
//       );
//     }
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width,
//             child: SingleChildScrollView(
//               padding:
//                   EdgeInsets.only(left: 16, right: 16, top: 130, bottom: 0),
//               child: Column(
//                 children: [
//                   // buildOverallSalesCont(),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   buildSalesCont(),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   // buildSalesmanCont(),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   buildCustomerCont(),
//                 ],
//               ),
//             ),
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width,
//             height: 130,
//             color: Colors.white,
//             child: SingleChildScrollView(
//               padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(
//                     height: 15,
//                   ),
//                   buildHeader(),
//                   // SizedBox(
//                   //   height: 10,
//                   // ),
//                   // buildSearchField(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Container buildSearchField() {
//     return Container(
//       height: 50,
//       width: MediaQuery.of(context).size.width,
//       margin: EdgeInsets.only(top: 0, bottom: 0),
//       child: Form(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Row(
//               children: <Widget>[
//                 Container(
//                   // width: MediaQuery.of(context).size.width - 130,
//                   width: MediaQuery.of(context).size.width - 50,
//                   height: 40,
//                   child: TextFormField(
//                     // controller: searchController,
//                     onChanged: (String str) {
//                       setState(() {
//                         // _searchController = str;
//                         // searchCustomers();
//                       });
//                     },
//                     decoration: InputDecoration(
//                         contentPadding:
//                             EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.grey),
//                           borderRadius: BorderRadius.all(Radius.circular(16)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(color: Colors.black87),
//                           borderRadius: BorderRadius.all(Radius.circular(16)),
//                         ),
//                         hintText: 'Search Salesman'),
//                   ),
//                 ),
//                 SizedBox(
//                   width: 10,
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Container buildHeader() {
//     return Container(
//       alignment: Alignment.centerLeft,
//       child: Text(
//         "Sales",
//         textAlign: TextAlign.right,
//         style: TextStyle(
//             color: Colors.deepOrange,
//             fontSize: 45,
//             fontWeight: FontWeight.bold),
//       ),
//     );
//   }

//   Container buildOverallSalesCont() {
//     // if (viewSpinkit == true) {
//     //   return Container(
//     //     height: 620,
//     //     width: MediaQuery.of(context).size.width,
//     //     child: Center(
//     //       child: SpinKitFadingCircle(
//     //         color: Colors.deepOrange,
//     //         size: 50,
//     //       ),
//     //     ),
//     //   );
//     // }
//     return Container(
//       height: 220,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//           color: Colors.deepOrange,
//           border: Border.all(color: Colors.deepOrange),
//           borderRadius: BorderRadius.circular(0)),
//       child: SingleChildScrollView(
//         child: Stack(
//           children: <Widget>[
//             Column(
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Container(
//                       width: MediaQuery.of(context).size.width - 50,
//                       // color: Colors.grey,
//                       child: Stack(
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.only(left: 10, top: 5),
//                                 child: Container(
//                                   child: Text(
//                                     'Overall Sales',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w400,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: <Widget>[
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.only(right: 0, top: 5),
//                                 child: Container(
//                                   child: Row(
//                                     children: <Widget>[
//                                       Text(
//                                         'Month',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.w400,
//                                         ),
//                                       ),
//                                       Icon(
//                                         Icons.arrow_drop_down,
//                                         size: 24,
//                                         color: Colors.white,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 //SAMPLE LINE GRAPH
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: <Widget>[
//                     Container(
//                       height: 200,
//                       width: MediaQuery.of(context).size.width - 35,
//                       // color: Colors.grey,
//                       child: Icon(
//                         Icons.timeline,
//                         color: Colors.white,
//                         size: 100,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Container buildSalesCont() {
//     // if (viewSpinkit == true) {
//     //   return Container(
//     //     height: 220,
//     //     width: MediaQuery.of(context).size.width,
//     //     child: Center(
//     //       child: SpinKitFadingCircle(
//     //         color: Colors.deepOrange,
//     //         size: 50,
//     //       ),
//     //     ),
//     //   );
//     // }
//     return Container(
//       height: 250,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//           color: Colors.transparent,
//           border: Border.all(color: Colors.transparent),
//           borderRadius: BorderRadius.circular(10)),
//       child: SingleChildScrollView(
//         child: Stack(
//           children: <Widget>[
//             Column(
//               children: <Widget>[
//                 Row(
//                   // crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     Container(
//                       // width: MediaQuery.of(context).size.width - 40,
//                       height: 30,
//                       // color: Colors.grey,
//                       child: DropdownButtonHideUnderline(
//                         child: ButtonTheme(
//                           alignedDropdown: true,
//                           child: DropdownButton<String>(
//                             value: SalesData.overallSalesType,
//                             items: _totlist?.map((item) {
//                                   return new DropdownMenuItem(
//                                     child: new Text(
//                                       item['type'],
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                       ),
//                                     ),
//                                     value: item['type'].toString(),
//                                   );
//                                 })?.toList() ??
//                                 [],
//                             onChanged: (String newV) {
//                               setState(() {
//                                 SalesData.overallSalesType = newV;
//                                 overAllSalesTypeChanged();
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 30),
//               child: Column(
//                 children: <Widget>[
//                   Row(
//                     children: <Widget>[
//                       Container(
//                         width: MediaQuery.of(context).size.width - 40,
//                         // color: Colors.grey,
//                         child: Stack(
//                           children: <Widget>[
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Container(
//                                   margin: EdgeInsets.only(left: 5),
//                                   height: 100,
//                                   width: MediaQuery.of(context).size.width / 2 -
//                                       30,
//                                   decoration: BoxDecoration(
//                                       color: Colors.orange[300],
//                                       border:
//                                           Border.all(color: Colors.transparent),
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: Stack(
//                                     children: <Widget>[
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 5, top: 5),
//                                             child: Text(
//                                               'Today',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: <Widget>[
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                         .size
//                                                         .width /
//                                                     2 -
//                                                 30,
//                                             // color: Colors.grey,
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               children: <Widget>[
//                                                 Text(
//                                                   formatCurrencyAmt
//                                                       .format(double.parse(
//                                                           SalesData.salesToday))
//                                                       .toString(),
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontWeight: FontWeight.w500,
//                                                     fontSize: 24,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 5, top: 5),
//                                             child: Text(
//                                               today,
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w300,
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: <Widget>[
//                                 Container(
//                                   height: 100,
//                                   width: MediaQuery.of(context).size.width / 2 -
//                                       30,
//                                   decoration: BoxDecoration(
//                                       color: Colors.blue[300],
//                                       border:
//                                           Border.all(color: Colors.transparent),
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: Stack(
//                                     children: <Widget>[
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 5, top: 5),
//                                             child: Text(
//                                               'Week',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: <Widget>[
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                         .size
//                                                         .width /
//                                                     2 -
//                                                 30,
//                                             // color: Colors.grey,
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               children: <Widget>[
//                                                 Text(
//                                                   formatCurrencyAmt
//                                                       .format(double.parse(
//                                                           SalesData
//                                                               .salesWeekly))
//                                                       .toString(),
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontWeight: FontWeight.w500,
//                                                     fontSize: 24,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 5, top: 5),
//                                             child: Text(
//                                               weekStart + '-' + weekEnd,
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w300,
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     children: <Widget>[
//                       Container(
//                         width: MediaQuery.of(context).size.width - 40,
//                         // color: Colors.grey,
//                         child: Stack(
//                           children: <Widget>[
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: <Widget>[
//                                 Container(
//                                   margin: EdgeInsets.only(left: 5),
//                                   height: 100,
//                                   width: MediaQuery.of(context).size.width / 2 -
//                                       30,
//                                   decoration: BoxDecoration(
//                                       color: Colors.green[300],
//                                       border:
//                                           Border.all(color: Colors.transparent),
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: Stack(
//                                     children: <Widget>[
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 5, top: 5),
//                                             child: Text(
//                                               'Month',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: <Widget>[
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                         .size
//                                                         .width /
//                                                     2 -
//                                                 30,
//                                             // color: Colors.grey,
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               children: <Widget>[
//                                                 Text(
//                                                   formatCurrencyAmt
//                                                       .format(double.parse(
//                                                           SalesData
//                                                               .salesMonthly))
//                                                       .toString(),
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontWeight: FontWeight.w500,
//                                                     fontSize: 24,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 5, top: 5),
//                                             child: Text(
//                                               month,
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w300,
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               crossAxisAlignment: CrossAxisAlignment.end,
//                               children: <Widget>[
//                                 Container(
//                                   height: 100,
//                                   width: MediaQuery.of(context).size.width / 2 -
//                                       30,
//                                   decoration: BoxDecoration(
//                                       color: Colors.purple[300],
//                                       border:
//                                           Border.all(color: Colors.transparent),
//                                       borderRadius: BorderRadius.circular(10)),
//                                   child: Stack(
//                                     children: <Widget>[
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 5, top: 5),
//                                             child: Text(
//                                               'Year',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w400,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: <Widget>[
//                                           Container(
//                                             width: MediaQuery.of(context)
//                                                         .size
//                                                         .width /
//                                                     2 -
//                                                 30,
//                                             // color: Colors.grey,
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               children: <Widget>[
//                                                 Text(
//                                                   formatCurrencyAmt
//                                                       .format(double.parse(
//                                                           SalesData
//                                                               .salesYearly))
//                                                       .toString(),
//                                                   style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontWeight: FontWeight.w500,
//                                                     fontSize: 24,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.end,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.end,
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: const EdgeInsets.only(
//                                                 left: 5, top: 5),
//                                             child: Text(
//                                               year,
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w300,
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Container buildSalesmanCont() {
//     // if (viewSpinkit == true) {
//     //   return Container(
//     //     height: 220,
//     //     width: MediaQuery.of(context).size.width,
//     //     child: Center(
//     //       child: SpinKitFadingCircle(
//     //         color: Colors.deepOrange,
//     //         size: 50,
//     //       ),
//     //     ),
//     //   );
//     // }
//     return Container(
//       height: 220,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//           color: Colors.grey[100],
//           border: Border.all(color: Colors.transparent),
//           borderRadius: BorderRadius.circular(0)),
//       child: SingleChildScrollView(
//         child: Stack(
//           children: <Widget>[
//             Column(
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Container(
//                       width: MediaQuery.of(context).size.width - 40,
//                       // color: Colors.grey,
//                       child: Stack(
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.only(left: 10, top: 15),
//                                 child: Container(
//                                   child: Text(
//                                     'My Salesman',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: <Widget>[
//                               Container(
//                                 margin: EdgeInsets.only(left: 20, right: 0),
//                                 // width: MediaQuery.of(context).size.width / 2,
//                                 // color: Colors.grey,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     DropdownButtonHideUnderline(
//                                       child: ButtonTheme(
//                                         alignedDropdown: true,
//                                         child: DropdownButton<String>(
//                                           value: SalesData.salesmanSalesType,
//                                           items: _tolist?.map((item) {
//                                                 return new DropdownMenuItem(
//                                                   child: new Text(
//                                                     item['type'],
//                                                     style: TextStyle(
//                                                       fontSize: 14,
//                                                     ),
//                                                   ),
//                                                   value:
//                                                       item['type'].toString(),
//                                                 );
//                                               })?.toList() ??
//                                               [],
//                                           onChanged: (String newV) {
//                                             setState(() {
//                                               SalesData.salesmanSalesType =
//                                                   newV;
//                                               salesmanSalesTypeChanged();
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 //SALESMAN HEADER NAME ETC
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Container(
//                       width: MediaQuery.of(context).size.width - 35,
//                       height: 50,
//                       color: Colors.transparent,
//                       child: Stack(
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                 height: 50,
//                                 margin: EdgeInsets.only(left: 10),
//                                 // color: Colors.grey,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     Text(
//                                       'Name',
//                                       style: TextStyle(),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: <Widget>[
//                               Container(
//                                 height: 50,
//                                 margin: EdgeInsets.only(right: 10),
//                                 // color: Colors.grey,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     Text(
//                                       'Sales',
//                                       style: TextStyle(),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Container(
//                       width: MediaQuery.of(context).size.width - 35,
//                       height: 100,
//                       color: Colors.transparent,
//                       child: ListView.builder(
//                           padding: const EdgeInsets.only(top: 1),
//                           itemCount: _smsalelist.length,
//                           itemBuilder: (context, index) {
//                             return Container(
//                               child: Column(
//                                 children: <Widget>[
//                                   Container(
//                                     padding: EdgeInsets.all(10),
//                                     width:
//                                         MediaQuery.of(context).size.width - 35,
//                                     height: 40,
//                                     color: Colors.transparent,
//                                     child: Stack(
//                                       children: <Widget>[
//                                         Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: <Widget>[
//                                             Text(
//                                               _smsalelist[index]['first_name'] +
//                                                   ' ' +
//                                                   _smsalelist[index]
//                                                       ['last_name'],
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: <Widget>[
//                                             Text(
//                                               formatCurrencyAmt.format(
//                                                   double.parse(
//                                                       _smsalelist[index]
//                                                           ['total'])),
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Container buildCustomerCont() {
//     if (viewSpinkit == true) {
//       return Container(
//         height: 620,
//         width: MediaQuery.of(context).size.width,
//         child: Center(
//           child: SpinKitFadingCircle(
//             color: Colors.deepOrange,
//             size: 50,
//           ),
//         ),
//       );
//     }
//     return Container(
//       // height: 220,
//       height: 380,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//           color: Colors.deepOrange[50],
//           border: Border.all(color: Colors.deepOrange[50]),
//           borderRadius: BorderRadius.circular(0)),
//       child: SingleChildScrollView(
//         child: Stack(
//           children: <Widget>[
//             Column(
//               children: <Widget>[
//                 Row(
//                   children: <Widget>[
//                     Container(
//                       width: MediaQuery.of(context).size.width - 40,
//                       // color: Colors.grey,
//                       child: Stack(
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.only(left: 10, top: 15),
//                                 child: Container(
//                                   child: Text(
//                                     'Top Customer',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             crossAxisAlignment: CrossAxisAlignment.end,
//                             children: <Widget>[
//                               Container(
//                                 margin: EdgeInsets.only(left: 20, right: 0),
//                                 // width: MediaQuery.of(context).size.width / 2,
//                                 // color: Colors.grey,
//                                 child: Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     DropdownButtonHideUnderline(
//                                       child: ButtonTheme(
//                                         alignedDropdown: true,
//                                         child: DropdownButton<String>(
//                                           value: SalesData.customerSalesType,
//                                           items: _toolist?.map((item) {
//                                                 return new DropdownMenuItem(
//                                                   child: new Text(
//                                                     item['type'],
//                                                     style: TextStyle(
//                                                       fontSize: 14,
//                                                     ),
//                                                   ),
//                                                   value:
//                                                       item['type'].toString(),
//                                                 );
//                                               })?.toList() ??
//                                               [],
//                                           onChanged: (String newValue) {
//                                             setState(() {
//                                               SalesData.customerSalesType =
//                                                   newValue;
//                                               customerSalesTypeChanged();
//                                             });
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Container(
//                       width: MediaQuery.of(context).size.width - 35,
//                       height: 50,
//                       color: Colors.transparent,
//                       child: Stack(
//                         children: <Widget>[
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: <Widget>[
//                               Container(
//                                 height: 50,
//                                 margin: EdgeInsets.only(left: 10),
//                                 // color: Colors.grey,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     Text(
//                                       'Name',
//                                       style: TextStyle(),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             children: <Widget>[
//                               Container(
//                                 height: 50,
//                                 margin: EdgeInsets.only(right: 10),
//                                 // color: Colors.grey,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: <Widget>[
//                                     Text(
//                                       SalesData.custTotalCaption,
//                                       style: TextStyle(),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Container(
//                       width: MediaQuery.of(context).size.width - 35,
//                       // height: 120,
//                       height: 280,
//                       color: Colors.transparent,
//                       child: ListView.builder(
//                           padding: const EdgeInsets.only(top: 1),
//                           itemCount: _custsalelist.length,
//                           itemBuilder: (context, index) {
//                             return Container(
//                               child: Column(
//                                 children: <Widget>[
//                                   Container(
//                                     padding: EdgeInsets.all(10),
//                                     width:
//                                         MediaQuery.of(context).size.width - 35,
//                                     height: 50,
//                                     color: Colors.transparent,
//                                     child: Stack(
//                                       children: <Widget>[
//                                         Row(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.center,
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: <Widget>[
//                                             Container(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width -
//                                                   150,
//                                               child: Text(
//                                                 _custsalelist[index]
//                                                     ['account_name'],
//                                                 style: TextStyle(
//                                                   color: Colors.black,
//                                                   fontSize: 12,
//                                                 ),
//                                                 // overflow: TextOverflow.ellipsis,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: <Widget>[
//                                             Text(
//                                               formatCurrencyAmt.format(
//                                                   double.parse(
//                                                       _custsalelist[index]
//                                                           ['total'])),
//                                               style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 12,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           }),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
