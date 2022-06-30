import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:salesman/db/db_helper.dart';
// import 'package:salesman/api.dart';
import 'package:salesman/url/url.dart';
// import 'package:carousel_pro/carousel_pro.dart';
import 'package:salesman/variables/colors.dart';
// import 'package:salesman/userdata.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool viewSpinkit = true;
  bool processedPressed = true;
  bool emptyApprovedTran = true;
  bool emptyPendingTran = true;

  final formatCurrencyAmt =
      new NumberFormat.currency(locale: "en_US", symbol: "₱");
  final formatCurrencyTot =
      new NumberFormat.currency(locale: "en_US", symbol: "Php ");

  final orangeColor = ColorsTheme.mainColor;
  final yellowColor = Colors.amber;
  final blueColor = Colors.blue;

  final formatCurrency =
      new NumberFormat.currency(locale: "en_US", symbol: "P");

  // List _toList = [];
  List _promolist = [];

  void initState() {
    super.initState();
    // processedPressed = true;
    // loadProcessed();
    // loadPromos();
  }

  // loadPromos() async {
  //   var getP = await getPromos();
  //   setState(() {
  //     _promolist = getP;
  //     // print(_promolist);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.only(left: 10, right: 10, top: 340, bottom: 5),
              child: Column(
                children: [
                  buildPromoCont(),
                  SizedBox(
                    height: 10,
                  ),
                  buildSaleCont(),
                ],
              ),
            ),
          ),
          Container(
            // height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[50],
            child: SingleChildScrollView(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 135, bottom: 5),
              child: Column(
                children: [
                  buildHeaderSlide(),

                  // buildPromoCont(),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 130,
            color: Colors.white,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  buildHeader(),
                  SizedBox(
                    height: 10,
                  ),
                  // buildHeaderSlider(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildPromoCont() {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[300],
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            height: 40,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
            child: Text(
              'Promos and Bundles',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: ColorsTheme.mainColor,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            height: 260,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 1),
                itemCount: _promolist.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width - 35,
                          height: 100,
                          color: Colors.white,
                          child: Stack(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: 100,
                                    color: Colors.white,
                                    child: Image.network(UrlAddress.itemImg +
                                        _promolist[index]['item_path']),
                                  ),
                                ],
                              ),
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,

                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              30,
                                          height: 60,
                                          // color: Colors.grey[200],
                                          child: Text(
                                            _promolist[index]['product_name'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2 -
                                              30,
                                          height: 20,
                                          // color: Colors.grey,
                                          child: Text(
                                            _promolist[index]['uom'],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 100,
                                    // color: Colors.grey,
                                    child: Center(
                                      child: Text(
                                        formatCurrencyAmt.format(double.parse(
                                            _promolist[index]
                                                ['list_price_wtax'])),
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
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
                  );
                }), //
          ),
        ],
      ),
    );
  }

  Container buildSaleCont() {
    return Container(
      height: 300,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[200],
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            height: 40,
            width: MediaQuery.of(context).size.width,
            color: ColorsTheme.mainColor,
            child: Text(
              'Items on Sale',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildHeaderSlide() {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      // width: 400,
      // color: ColorsTheme.mainColor,
      margin: EdgeInsets.only(top: 0, bottom: 0),
      child: Container(),
      // Carousel(
      //   boxFit: BoxFit.fill,
      //   autoplay: true,
      //   // autoplayDuration: Duration(seconds: 1),
      //   dotSize: 6.0,
      //   dotColor: Colors.white,
      //   dotIncreasedColor: ColorsTheme.mainColor,
      //   dotBgColor: Colors.transparent,
      //   // dotPosition: DotPosition.topRight,
      //   dotVerticalPadding: 10.0,
      //   showIndicator: true,
      //   indicatorBgPadding: 7.0,
      //   images: [
      //     // Image.network(UrlAddress.sliderImg + 'img1.jpg'),
      //     // Image.network(UrlAddress.sliderImg + 'img2.jpg'),
      //     // Image.network(UrlAddress.sliderImg + 'img3.jpg'),
      //     // Image.network(UrlAddress.sliderImg + 'img4.jpg'),
      //     // Image.network(UrlAddress.sliderImg + 'img5.jpg'),
      //   ],
      // ),
    );
  }

  Container buildHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        "Home",
        textAlign: TextAlign.right,
        style: TextStyle(
            color: ColorsTheme.mainColor,
            fontSize: 45,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
