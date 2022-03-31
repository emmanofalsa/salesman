import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:salesman/customer/customer_cart.dart';
import 'package:salesman/customer/customer_inbox.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/history/ordersandtracking.dart';
import 'package:salesman/salesman_home/menu.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/variables/assets.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/elevated_button.dart';

class CustomerProfile extends StatefulWidget {
  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  bool viewSpinkit = true;
  bool emptyTranHistory = true;
  bool msg = false;
  List _hList = [];
  List msgList = [];

  String? tranStatus;
  String activeMsg = '0';

  final db = DatabaseHelper();

  final formatCurrencyAmt =
      new NumberFormat.currency(locale: "en_US", symbol: "₱");
  final formatCurrencyTot =
      new NumberFormat.currency(locale: "en_US", symbol: "Php ");

  bool status = true;
  void initState() {
    super.initState();
    loadHistory();
    _getColor();
  }

  loadHistory() async {
    var getH = await db.ofFetchCustomerHistory(CustomerData.accountCode);
    if (!mounted) return;
    setState(() {
      _hList = getH;
      // print(_hList);
      viewSpinkit = false;
      if (_hList.isNotEmpty) {
        emptyTranHistory = false;
      }
    });
    CustomerData.discounted = false;
    // print(CustomerData.accountCode);
    // _getColor();
    if (NetworkData.connected) {
      var getM = await db.checkCustomerMessages(CustomerData.accountCode);
      if (!mounted) return;
      setState(() {
        msgList = getM;
        print(msgList.length);
        if (msgList.isEmpty) {
          msg = false;
          activeMsg = '0';
        } else {
          msg = true;
          activeMsg = msgList.length.toString();
        }
      });
    }
  }

  _callNumber(String phone) async {
    // const number = '08592119XXXX'; //set the number here
    print(phone);
    bool? res = await FlutterPhoneDirectCaller.callNumber(phone);
    print(res);
  }

  void _getColor() {
    var cCode = CustomerData.colorCode;
    switch (cCode) {
      case "488":
        {
          CustomerData.custColor = Colors.black;
        }
        break;
      case "489":
        {
          CustomerData.custColor = Colors.purpleAccent;
        }
        break;
      case "490":
        {
          CustomerData.custColor = Colors.pinkAccent;
        }
        break;
      case "491":
        {
          CustomerData.custColor = Colors.green;
        }
        break;
      case "492":
        {
          CustomerData.custColor = Colors.redAccent;
        }
        break;
      case "493":
        {
          CustomerData.custColor = Colors.blue.shade300;
        }
        break;
      case "495":
        {
          CustomerData.custColor = Colors.deepOrange;
        }
        break;
      default:
        {
          CustomerData.custColor = Colors.grey.shade200;
        }
        break;
    }
  }

  checkifDiscounted() async {
    var rsp = await db.checkDiscounted(CustomerData.accountCode);
    if (rsp == "TRUE") {
      // print(rsp);
      CustomerData.discounted = true;
    } else {
      CustomerData.discounted = false;
    }
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
          automaticallyImplyLeading: true,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.deepOrange),
          elevation: 0,
          title: Text(
            'Customer Profile',
            style: TextStyle(fontSize: 14, color: Colors.deepOrange),
          ),
          leading: GestureDetector(
            child: Icon(CupertinoIcons.arrow_left),
            onTap: () {
              GlobalVariables.menuKey = 0;
              GlobalVariables.viewPolicy = false;
              Navigator.pop(context);
              // Navigator.push(
              //     context,
              //     PageTransition(
              //         type: PageTransitionType.leftToRight,
              //         child: SalesmanMenu()));
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 15),
          child: Column(
            children: [
              buildCustomerInfo(),
              Expanded(child: buildTransHistory()),
            ],
          ),
        ),
      ),
    );
  }

  Container buildTransHistory() {
    if (emptyTranHistory == true) {
      return Container(
        padding: EdgeInsets.all(40),
        margin: EdgeInsets.only(top: 50),
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        // color: ColorsTheme.mainColor,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.event_busy,
              size: 100,
              color: Colors.grey[500],
            ),
            Text(
              'This customer has no transaction history.',
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
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(
        left: 0,
      ),
      // color: Colors.grey,
      child: ListView.builder(
        padding: const EdgeInsets.all(0),
        itemCount: _hList.length,
        // scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          if (_hList[index]['tran_stat'] == "Pending") {
            tranStatus = 'Submitted';
          } else {
            tranStatus = _hList[index]['tran_stat'].toString();
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    UserData.trans = _hList[index]['tran_no'];
                    UserData.sname = _hList[index]['store_name'];
                    OrderData.trans = _hList[index]['tran_no'];
                    OrderData.name = _hList[index]['cust_name'];
                    OrderData.pmeth = _hList[index]['p_meth'];
                    OrderData.itmno = _hList[index]['itm_count'];
                    OrderData.totamt = _hList[index]['tot_amt'];
                    OrderData.status = _hList[index]['tran_stat'];
                    OrderData.signature = _hList[index]['signature'];
                    OrderData.dateReq = _hList[index]['date_req'];
                    OrderData.dateApp = _hList[index]['date_app'];
                    OrderData.dateDel = _hList[index]['date_del'];
                    checkifDiscounted();
                    //   Navigator.push(context,
                    //       MaterialPageRoute(builder: (context) {
                    //     return OrdersAndTracking();
                    //   }));
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
                            width: MediaQuery.of(context).size.width / 2 - 50,
                            // color: Colors.grey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'Order # ' + _hList[index]['tran_no'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  _hList[index]['store_name'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  _hList[index]['date_req'],
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
                            margin: EdgeInsets.only(left: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: 105,
                                  // color: Colors.blueGrey,
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        formatCurrencyTot.format(double.parse(
                                            _hList[index]['tot_amt'])),
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
                                // if (_hList[index]['tran_stat'] ==
                                //     "Pending")
                                //   {
                                //     static String stat = _hList[index]['date_req'];
                                //   },
                                Text(
                                  'Last Updated: ' + _hList[index]['date_req'],
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
    );
  }

  // Container buildHeaderCont() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     height: 80,
  //     // color: Colors.grey,
  //     alignment: Alignment.centerLeft,
  //     child: Column(
  //       children: <Widget>[
  //         Row(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: <Widget>[
  //             GestureDetector(
  //               onTap: () {
  //                 GlobalVariables.menuKey = 0;
  //                 GlobalVariables.viewPolicy = false;
  //                 Navigator.push(context, MaterialPageRoute(builder: (context) {
  //                   return SalesmanMenu();
  //                 }));
  //               },
  //               child: Container(
  //                 width: 50,
  //                 height: 80,
  //                 child: Image(
  //                   image: AssetsValues.backImg,
  //                 ),
  //               ),
  //             ),
  //             SizedBox(height: 50),
  //             Container(
  //               // padding: EdgeInsets.only(top: 50),
  //               width: MediaQuery.of(context).size.width - 100,
  //               height: 60,
  //               // color: Colors.grey[350],
  //               alignment: Alignment.center,
  //               // color: Colors.lightGreen,
  //               child: Text(
  //                 '',
  //                 style: TextStyle(
  //                   // color: Colors.grey,
  //                   fontSize: 26,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Container buildCustomerInfo() {
    return Container(
      // height: 215,
      // color: Colors.grey[300],
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 0, bottom: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 200,
                    // height: 150,
                    height: ScreenData.scrHeight * .20,
                    // color: Colors.grey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          CustomerData.accountName!,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          CustomerData.district! +
                              ', ' +
                              CustomerData.city! +
                              ', ' +
                              CustomerData.province!,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        Text(
                          '+63' + CustomerData.contactNo!,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: 180,
                          // color: Colors.grey[200],
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Status: ',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              if (CustomerData.status == "0")
                                Text(
                                  'Inactive',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic),
                                ),
                              if (CustomerData.status == "1")
                                Text(
                                  'Active',
                                  style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Text(
                                'Credit Limit:',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                formatCurrencyAmt.format(
                                    double.parse(CustomerData.creditLimit!)),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
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
              SizedBox(
                width: 10,
              ),
              Container(
                padding: EdgeInsets.only(top: 0),
                // width: 100,
                // height: 150,
                // color: Colors.grey,
                width: ScreenData.scrWidth * .25,
                height: ScreenData.scrHeight * .20,
                child: Image(
                  image: AssetsValues.personImg,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: 40,
                    // color: Colors.black,
                    width: MediaQuery.of(context).size.width - 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 20,
                          // width: 150,
                          margin: EdgeInsets.only(top: 0),
                          child: ElevatedButton(
                            style: raisedButtonStyleGreen,
                            onPressed: () {
                              String _phone = '0' + CustomerData.contactNo!;
                              print(_phone);
                              // FlutterPhoneDirectCaller.callNumber(_phone);
                              _callNumber(_phone);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Call',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 5 + 30,
                          // color: Colors.grey,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  height: 20,
                                  // width: 150,
                                  margin: EdgeInsets.only(top: 0),
                                  child: ElevatedButton(
                                    style: raisedButtonStyleBlue,
                                    onPressed: () => {
                                      if (msg)
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CustomerInbox();
                                        })),
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Message',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Icon(
                                          Icons.mail,
                                          color: Colors.white,
                                          // size: 15,
                                          size: ScreenData.scrWidth * .035,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: msg,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    // margin: EdgeInsets.only(top: 2),
                                    padding: EdgeInsets.only(top: 3),
                                    width: 25,
                                    height: 20,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.red),
                                    child: Text(
                                      activeMsg,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width / 5 + 30,
                          margin: EdgeInsets.only(top: 0),
                          child: ElevatedButton(
                            style: raisedButtonStyleWhite,
                            onPressed: () {
                              // Navigator.push(context,
                              //     MaterialPageRoute(builder: (context) {
                              //   return CustomerCart();
                              // }));
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: CustomerCart()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Add Order',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: ColorsTheme.mainColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                // SizedBox(
                                //   width: 5,
                                // ),
                                Container(
                                  width: 15,
                                  height: 15,
                                  child: Icon(
                                    Icons.add_circle_outline,
                                    color: ColorsTheme.mainColor,
                                    size: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 25,
                    color: ColorsTheme.mainColor,
                    width: MediaQuery.of(context).size.width - 40,
                    padding: EdgeInsets.only(left: 10),
                    // margin: EdgeInsets.only(left: 5, top: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Transaction History',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
