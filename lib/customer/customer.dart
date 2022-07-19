import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:salesman/customer/customer_cart.dart';
import 'package:salesman/customer/customer_profile.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/elevated_button.dart';

class Customer extends StatefulWidget {
  @override
  _CustomerState createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  final db = DatabaseHelper();
  String _searchController = "";
  var colorCode = '';
  List _custList = [];
  List accessList = [];

  bool viewSpinkit = true;
  bool incInfo = false;

  void initState() {
    super.initState();
    // loadUserAccess();
    loadCustomers();
    _getColor();
  }

  loadCustomers() async {
    print(UserAccess.multiSalesman);
    if (UserAccess.multiSalesman == false) {
      if (_custList.isEmpty) {
        var getC = await db.viewAllCustomers();
        _custList = getC;

        setState(() {
          if (_custList.isEmpty) {
            viewSpinkit = true;
            print('No Customer Found!');
          }
          viewSpinkit = false;
        });
      }
    } else {
      _custList.clear();
      UserAccess.customerList.forEach((element) async {
        print(element);

        if (_custList.isEmpty) {
          var getC = await db.viewMultiCustomersList(element);
          // _custList.add(getC);
          _custList.addAll(getC);
          // print(getC);

          setState(() {
            if (_custList.isEmpty) {
              viewSpinkit = true;
              print('No Customer Found!');
            }
            viewSpinkit = false;
          });
        }
      });
    }
  }

  loadUserAccess() async {
    var ulist = await db.ofFetchUserAccess();
    accessList = ulist;
    assignAccess();
    // print(accessList);
    loadCustomers();
  }

  assignAccess() {
    UserAccess.multiSalesman = false;
    UserAccess.noMinOrder = false;
    accessList.forEach((element) {
      print(element['ua_action']);
      //PARA SA MULTIPLE SALESMAN PER CUSTOMER
      if (element['ua_userid'] == UserData.id &&
          element['ua_code'] == 'MULTI_SALESMAN' &&
          element['ua_action'] == '1') {
        setState(() {
          UserAccess.multiSalesman = true;
        });

        //SPLITTING CUSTOMER LIST
        if (element['ua_cust'] != '' || element['ua_cust'] != null) {
          UserAccess.customerList.clear();
          final cust = element['ua_cust'];
          final t = cust.split(',');
          for (int i = 0; i < t.length; i++) UserAccess.customerList.add(t[i]);
        }
      }
      if (element['ua_userid'] == UserData.id &&
          element['ua_code'] == 'NO_MIN_ORDER' &&
          element['ua_action'] == '1') {
        setState(() {
          UserAccess.noMinOrder = true;
        });
      }
    });
  }

  checkCustInfo() {
    incInfo = false;
    if (CustomerData.accountCode == '') {
      incInfo = true;
    }
    if (CustomerData.accountName == '') {
      incInfo = true;
    }
    if (CustomerData.accountDescription == '') {
      incInfo = true;
    }
    if (CustomerData.province == '') {
      incInfo = true;
    }
    if (CustomerData.city == '') {
      incInfo = true;
    }
    if (CustomerData.district == '') {
      incInfo = true;
    }
    if (CustomerData.groupCode == '') {
      incInfo = true;
    }
    if (CustomerData.paymentType == '') {
      incInfo = true;
    }
    if (CustomerData.status == '') {
      incInfo = true;
    }
    if (CustomerData.colorCode == '') {
      incInfo = true;
    }
    // if (CustomerData.contactNo == '' || CustomerData.contactNo == null) {
    //   incInfo = true;
    // }
  }

  searchCustomers() async {
    var getC = await db.customerSearch(_searchController);
    setState(() {
      _custList = getC;
    });
  }

  Future<void> _getData() async {
    setState(() {
      loadCustomers();
      _getColor();
    });
  }

  void _getColor() {
    var cCode = CustomerData.colorCode;
    CustomerData.placeOrder = true;
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
          CustomerData.placeOrder = false;
        }
        break;
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
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              floating: true,
              snap: true,
              toolbarHeight: 120,
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
                  buildSearchCont(context),
                ],
              ),
            ),
          ],
          body: Column(
            children: [
              Expanded(child: buildCustCont()),
            ],
          ),
        ),
      ),
    );
  }

  Container buildSearchCont(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 0, bottom: 0),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  // width: MediaQuery.of(context).size.width - 130,
                  width: MediaQuery.of(context).size.width - 50,
                  height: 40,
                  child: TextFormField(
                    // controller: searchController,
                    onChanged: (String str) {
                      setState(() {
                        _searchController = str;
                        searchCustomers();
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black87),
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        hintText: 'Search Customer'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildCustCont() {
    if (viewSpinkit == true) {
      return Container(
          padding: EdgeInsets.only(left: 15, right: 15, top: 0),
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Expanded(
          //       child: ListView.separated(
          //           // shrinkWrap: true,
          //           itemBuilder: (context, index) => const CardSkeleton(),
          //           separatorBuilder: (context, index) => const SizedBox(
          //                 height: 8,
          //               ),
          //           itemCount: 7),
          //     ),
          //   ],
          // ));
          child: Column(
            children: [
              CardSkeleton(),
              SizedBox(height: 8),
              CardSkeleton(),
              SizedBox(height: 8),
              CardSkeleton(),
              SizedBox(height: 8),
              CardSkeleton(),
              SizedBox(
                height: 8,
              ),
              CardSkeleton(),
              SizedBox(height: 8),
              CardSkeleton(),
              SizedBox(height: 8),
              CardSkeleton(),
            ],
          ));
    }
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      // height: 620,
      width: MediaQuery.of(context).size.width,
      // color: Colors.white,
      child: RefreshIndicator(
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          itemCount: _custList.length,
          // scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            CustomerData.colorCode =
                _custList[index]['account_classification_id'];
            _getColor();
            if (_custList[index]['account_classification_id'] == 'N/A') {
              _custList[index]['account_description'] = 'N/A';
            }
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      CustomerData.accountCode =
                          _custList[index]['account_code'];
                      CustomerData.accountName =
                          _custList[index]['account_name'];
                      CustomerData.accountDescription =
                          _custList[index]['account_description'];
                      CustomerData.province = _custList[index]['address1'];
                      CustomerData.city = _custList[index]['address3'];
                      CustomerData.district = _custList[index]['address2'];
                      CustomerData.groupCode =
                          _custList[index]['account_group_code'];
                      CustomerData.paymentType =
                          _custList[index]['payment_type'];
                      CustomerData.status = _custList[index]['status'];
                      CustomerData.colorCode =
                          _custList[index]['account_classification_id'];
                      CustomerData.contactNo =
                          _custList[index]['cus_mobile_number'];
                      CustomerData.creditLimit = '0.00';

                      if (CustomerData.creditLimit == null ||
                          CustomerData.creditLimit == 'NA') {
                        CustomerData.creditLimit = "0.00";
                      }
                      if (CustomerData.groupCode == null ||
                          CustomerData.groupCode == 'NA' ||
                          CustomerData.groupCode == '') {
                        CustomerData.groupCode = 'N/A';
                      }

                      checkCustInfo();

                      if (!incInfo) {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: CustomerProfile()));
                      }
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
                              color: CustomerData.custColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 200,
                                    child: Text(
                                      _custList[index]['account_name'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    _custList[index]['address2'] +
                                        ', ' +
                                        _custList[index]['address3'] +
                                        ', ' +
                                        _custList[index]['address1'],
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.normal),
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
                            Column(
                              children: <Widget>[
                                Container(
                                  height: 30,
                                  width: 150,
                                  margin: EdgeInsets.only(top: 10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: CustomerData.custColor,
                                      minimumSize: Size(88, 36),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                      ),
                                    ),
                                    onPressed: () => {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          _custList[index]
                                              ['account_description'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: CustomerData.placeOrder,
                                  child: Container(
                                    height: 30,
                                    width: 150,
                                    margin: EdgeInsets.only(top: 5),
                                    child: ElevatedButton(
                                      style: raisedButtonStyleWhite,
                                      onPressed: () => {
                                        CustomerData.accountCode =
                                            _custList[index]['account_code'],
                                        CustomerData.accountName =
                                            _custList[index]['account_name'],
                                        CustomerData.accountDescription =
                                            _custList[index]
                                                ['account_description'],
                                        CustomerData.province =
                                            _custList[index]['address1'],
                                        CustomerData.city =
                                            _custList[index]['address3'],
                                        CustomerData.district =
                                            _custList[index]['address2'],
                                        CustomerData.groupCode =
                                            _custList[index]
                                                ['account_group_code'],
                                        CustomerData.paymentType =
                                            _custList[index]['payment_type'],
                                        CustomerData.status =
                                            _custList[index]['status'],
                                        CustomerData.colorCode =
                                            _custList[index]
                                                ['account_classification_id'],
                                        CustomerData.contactNo =
                                            _custList[index]
                                                ['cus_mobile_number'],
                                        CustomerData.creditLimit = '0.00',
                                        if (CustomerData.creditLimit == null ||
                                            CustomerData.creditLimit == 'NA')
                                          {
                                            CustomerData.creditLimit = "0.00",
                                          },
                                        if (CustomerData.paymentType == '')
                                          {
                                            CustomerData.paymentType =
                                                'Cash on Delivery',
                                          },
                                        // Navigator.push(context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) {
                                        //   return CustomerCart();
                                        // })),
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: CustomerCart())),
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            'Place an Order',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: ColorsTheme.mainColor,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: Icon(
                                              Icons.add_circle_outline,
                                              color: ColorsTheme.mainColor,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
        onRefresh: _getData,
      ),
    );
  }
}

class CardSkeleton extends StatelessWidget {
  const CardSkeleton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(
            height: 80,
            width: 5,
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 10,
                ),
                Skeleton(
                  width: 130,
                  height: 25,
                ),
                SizedBox(
                  height: 5,
                ),
                Skeleton(
                  width: 150,
                  height: 20,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 50,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Skeleton(
                width: 150,
                height: 35,
              ),
              SizedBox(
                height: 2,
              ),
              Skeleton(
                width: 150,
                height: 35,
              ),
            ],
          ))
        ],
      ),
    );
  }
}

class Skeleton extends StatelessWidget {
  const Skeleton({
    Key? key,
    this.height,
    this.width,
  }) : super(key: key);

  final double? height, width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      // padding: EdgeInsets.all(8),

      decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.04),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
    );
  }
}
