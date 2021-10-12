import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesman/customer/customer_cart.dart';
import 'package:salesman/customer/favorites.dart';
import 'package:salesman/customer/product_per_categ.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/assets.dart';
import 'package:salesman/variables/colors.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final searchController = TextEditingController();
  List _categlist = [];
  String _searchController = "";
  String categPath = '';
  // List _flist = [];
  bool viewSpinkit = true;

  final db = DatabaseHelper();

  void initState() {
    super.initState();
    loadCateg();
  }

  loadCateg() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + '/category/';
    // var filePathAndName = documentDirectory.path + '/images/pic.jpg';
    categPath = firstPath;
    var ctg = await db.ofFetchCategList();
    setState(() {
      _categlist = ctg;
      // print()
      viewSpinkit = false;
    });
    loadFavorites();
  }

  searchCateg() async {
    var getC = await db.categSearch(_searchController);
    setState(() {
      _categlist = getC;
    });
  }

  loadFavorites() async {
    GlobalVariables.emptyFav = true;
    var getF = await db.getFav(CustomerData.accountCode);
    setState(() {
      GlobalVariables.favlist = getF;

      if (GlobalVariables.favlist.isNotEmpty) {
        GlobalVariables.emptyFav = false;
      }
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
        body: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 180, bottom: 5),
                child: Column(
                  children: [
                    buildCategCont(),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 178,
              color: Colors.white,
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    buildHeader(),
                    SizedBox(
                      height: 10,
                    ),
                    buildSearchField(),
                  ],
                ),
              ),
            ),
          ],
        ),
        // floatingActionButton: Align(
        //   alignment: Alignment.topRight,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: <Widget>[
        //       Container(
        //         padding: EdgeInsets.only(right: 30, top: 60),
        //         child: FloatingActionButton(
        //           onPressed: () {
        //             Navigator.push(context, MaterialPageRoute(builder: (context) {
        //               return CustomerCart();
        //             }));
        //           },
        //           child: Icon(
        //             Icons.shopping_cart,
        //             size: 26,
        //           ),
        //           // backgroundColor: ColorsTheme.mainColor,
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  Container buildSearchField() {
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
                        searchCateg();
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
                        hintText: 'Search Category'),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // Container(
                //   width: 80,
                //   height: 35,
                //   // color: ColorsTheme.mainColor,
                //   child: RaisedButton(
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(5)),
                //     color: ColorsTheme.mainColor,
                //     // padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                //     onPressed: () {},
                //     child: Text(
                //       'Search',
                //       style: TextStyle(color: Colors.white, fontSize: 12),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildCategCont() {
    if (viewSpinkit == true) {
      return Container(
        height: 620,
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
        margin: EdgeInsets.only(top: 0),
        // color: Colors.amber,
        // height: 510,
        height: MediaQuery.of(context).size.height - 180,
        width: MediaQuery.of(context).size.width,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.only(top: 1),
            itemCount: _categlist.length,
            itemBuilder: (BuildContext context, index) {
              return GestureDetector(
                onTap: () => {
                  CartData.setCateg = _categlist[index]['category_name'],
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProductperCategory();
                  })),
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 20 / 2,
                  // height: 80,
                  color: Colors.transparent,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 20 / 2,
                            child:
                                // Image.memory(base64Decode(
                                //     _categlist[index]['category_image'])),
                                // Image(image: AssetsValues.noImageImg)),
                                Image.file(File(categPath +
                                    _categlist[index]['category_image'])),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 20 / 2,
                            child: Card(
                                // elevation: 10,
                                color: Colors.black54,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child:
                                      Text(_categlist[index]['category_name'],
                                          style: TextStyle(
                                            color: Colors.white,
                                          )),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  Container buildHeader() {
    return Container(
      alignment: Alignment.centerLeft,
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  "Products",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      color: ColorsTheme.mainColor,
                      fontSize: 45,
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                child: Container(
                  // color: Colors.grey,
                  width: 50,
                  height: 50,
                  child: Stack(
                    children: <Widget>[
                      Icon(
                        Icons.favorite,
                        size: 50,
                        color: ColorsTheme.mainColor,
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: 12,
                          ),
                          child: Text(
                            'Favorites',
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return FavoritesPage();
                  })),
                },
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                child: Container(
                  // color: Colors.grey,
                  width: 50,
                  height: 50,
                  child: Stack(
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart,
                        size: 50,
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          // margin: EdgeInsets.only(top: 2),
                          padding: EdgeInsets.only(top: 3),
                          width: 25,
                          height: 20,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorsTheme.mainColor),
                          child: Text(
                            CartData.itmNo,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CustomerCart();
                  })),
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
