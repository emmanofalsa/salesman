import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

  bool viewSpinkit = true;
  bool incInfo = false;

  void initState() {
    super.initState();
    loadCustomers();
    _getColor();
  }

  loadCustomers() async {
    if (_custList.isEmpty) {
      var getC = await db.viewCustomersList(UserData.id);
      _custList = getC;

      setState(() {
        if (_custList.isEmpty) {
          viewSpinkit = true;
          print('No Customer Found!');
        }
        viewSpinkit = false;
      });
    }
  }

  checkCustInfo() {
    incInfo = false;
    if (CustomerData.accountCode == '' || CustomerData.accountCode == null) {
      incInfo = true;
    }
    if (CustomerData.accountName == '' || CustomerData.accountName == null) {
      incInfo = true;
    }
    if (CustomerData.accountDescription == '' ||
        CustomerData.accountDescription == null) {
      incInfo = true;
    }
    if (CustomerData.province == '' || CustomerData.province == null) {
      incInfo = true;
    }
    if (CustomerData.city == '' || CustomerData.city == null) {
      incInfo = true;
    }
    if (CustomerData.district == '' || CustomerData.district == null) {
      incInfo = true;
    }
    if (CustomerData.groupCode == '' || CustomerData.groupCode == null) {
      incInfo = true;
    }
    if (CustomerData.paymentType == '' || CustomerData.paymentType == null) {
      incInfo = true;
    }
    if (CustomerData.status == '' || CustomerData.status == null) {
      incInfo = true;
    }
    if (CustomerData.colorCode == '' || CustomerData.colorCode == null) {
      incInfo = true;
    }
    // if (CustomerData.contactNo == '' || CustomerData.contactNo == null) {
    //   incInfo = true;
    // }
  }

  searchCustomers() async {
    var getC = await db.customerSearch(UserData.id, _searchController);
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
          CustomerData.custColor = Colors.blue[300];
        }
        break;
      case "495":
        {
          CustomerData.custColor = Colors.deepOrange;
        }
        break;
      default:
        {
          CustomerData.custColor = Colors.grey[200];
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
              buildCustCont(),
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
        child: Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: SpinKitFadingCircle(
                color: ColorsTheme.mainColor,
                size: 50,
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      child: Expanded(
        child: Container(
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CustomerProfile();
                            }));
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                200,
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16),
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
                                                _custList[index]
                                                    ['account_code'],
                                            CustomerData.accountName =
                                                _custList[index]
                                                    ['account_name'],
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
                                                _custList[index]
                                                    ['payment_type'],
                                            CustomerData.status =
                                                _custList[index]['status'],
                                            CustomerData.colorCode = _custList[
                                                    index]
                                                ['account_classification_id'],
                                            CustomerData.contactNo =
                                                _custList[index]
                                                    ['cus_mobile_number'],
                                            CustomerData.creditLimit = '0.00',
                                            if (CustomerData.creditLimit ==
                                                    null ||
                                                CustomerData.creditLimit ==
                                                    'NA')
                                              {
                                                CustomerData.creditLimit =
                                                    "0.00",
                                              },
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return CustomerCart();
                                            })),
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
        ),
      ),
    );
  }
}
