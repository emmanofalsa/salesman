import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:salesman/customer/add_dialog.dart';
import 'package:salesman/customer/customer_cart.dart';
// import 'package:salesman/customer/product_page.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/assets.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/dialogs.dart';
import 'package:salesman/widgets/elevated_button.dart';
import 'package:salesman/widgets/snackbar.dart';

class ProductperCategory extends StatefulWidget {
  @override
  _ProductperCategoryState createState() => _ProductperCategoryState();
}

class _ProductperCategoryState extends State<ProductperCategory> {
  bool addedAlready = false;
  bool favorite = false;
  bool viewSpinkit = true;
  bool outofStock = false;
  bool noImage = true;

  String? imgPath;
  String _searchController = "";
  String uom = CartData.itmUom!;

  // final db = AddDialog();

  final db = DatabaseHelper();

  List _itemlist = [];
  List _flist = [];
  List _tmpitm = [];

  final formatCurrencyAmt =
      new NumberFormat.currency(locale: "en_US", symbol: "₱");
  final formatCurrencyTot =
      new NumberFormat.currency(locale: "en_US", symbol: "Php ");

  void initState() {
    super.initState();
    refreshList();
    loadProducts();

    // addImage();
  }

  // addImage() async {
  //   _itemlist.forEach((element) async {
  //     var getImg = await db.getItemImg(element['itemcode'], element['uom']);
  //     List img = [];
  //     img = getImg;
  //     _itemlist.add(element['image'] == img);
  //   });
  // }

  loadProducts() async {
    // int x = 1;
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + '/';
    // var filePathAndName = documentDirectory.path + '/images/pic.jpg';
    imgPath = firstPath;
    if (CartData.setCateg == 'ALL PRODUCTS') {
      CartData.allProd = true;
      if (_itemlist.isEmpty) {
        var getO = await db.getAllProducts();

        if (!mounted) return;
        setState(() {
          _itemlist = json.decode(json.encode(getO));
          print(_itemlist);
          // print(_itemlist);
          // _itemlist.forEach((element) async {
          //   var getImg =
          //       await db.getItemImginTable(element['itemcode'], element['uom']);
          //   element['image'] = json.decode(json.encode(getImg.toString()));
          //   // element['image'] = getImg;
          // });
          viewSpinkit = false;
          _flist = GlobalVariables.favlist;
          GlobalVariables.itemlist = _itemlist;
        });
      } else {
        _itemlist = GlobalVariables.itemlist;
      }
    } else {
      CartData.allProd = false;
      var getO = await db.getProducts(CartData.setCateg);
      print(getO);
      if (!mounted) return;
      setState(() {
        _itemlist = json.decode(json.encode(getO));
        // _itemlist.forEach((element) async {
        //   var getImg =
        //       await db.getItemImginTable(element['itemcode'], element['uom']);
        //   element['image'] = json.decode(json.encode(getImg.toString()));
        //   // element['image'] = getImg;
        // });
        viewSpinkit = false;
        _flist = GlobalVariables.favlist;
      });
    }
    GlobalVariables.outofStock = false;
  }

  searchItems() async {
    if (CartData.setCateg == 'ALL PRODUCTS') {
      var getI = await db.searchAllItems(_searchController);
      if (!mounted) return;
      setState(() {
        _itemlist = getI;
      });
    } else {
      var getI = await db.searchItems(CartData.setCateg, _searchController);
      if (!mounted) return;
      setState(() {
        _itemlist = getI;
      });
    }
  }

  loadFavorites() async {
    var getF = await db.getFav(CustomerData.accountCode);
    GlobalVariables.favlist = getF;
    print('FAVORITES:' + GlobalVariables.favlist.toString());
    // });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    loadProducts();
    // return null;
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
                    EdgeInsets.only(left: 16, right: 16, top: 50, bottom: 5),
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    // buildHeaderCont(),
                    SizedBox(
                      height: 5,
                    ),
                    buildItemListCont(),
                  ],
                ),
              ),
            ),
            Container(
              height: 180,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: SingleChildScrollView(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    buildHeaderCont(),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    buildSearchField(),
                  ],
                ),
              ),
            ),
            // buildSummaryCont(context),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            width: MediaQuery.of(context).size.width,
            // height: 80,
            height: 50,
            // color: Colors.grey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 5,
                ),
                Container(
                  margin: EdgeInsets.only(right: 5),
                  width: MediaQuery.of(context).size.width - 20,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                          // color: Colors.grey,
                          width: MediaQuery.of(context).size.width - 150,
                          child: RichText(
                            text: TextSpan(
                                text: 'Note: Minimum order amount is ',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                                children: [
                                  TextSpan(
                                      text: formatCurrencyAmt.format(
                                          double.parse(
                                              GlobalVariables.minOrder!)),
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: ColorsTheme.mainColor)),
                                  TextSpan(
                                      text: '.',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                  TextSpan(
                                      text: ' Currently, you reached ',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black)),
                                  TextSpan(
                                      text: formatCurrencyAmt.format(
                                          double.parse(CartData.totalAmount)),
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          color: ColorsTheme.mainColor)),
                                ]),
                          )),
                      SizedBox(width: 10),
                      // Text(
                      //   formatCurrencyTot
                      //       .format(double.parse(CartData.totalAmount)),
                      //   textAlign: TextAlign.left,
                      //   style: TextStyle(
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.w500,
                      //     decoration: TextDecoration.underline,
                      //   ),
                      // ),
                      Container(
                        height: 30,
                        child: ElevatedButton(
                          style: raisedButtonStyleGreen,
                          onPressed: () => {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CustomerCart();
                            })),
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Go to Cart",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildItemListCont() {
    if (viewSpinkit == true) {
      return Container(
        // height: 620,
        height: MediaQuery.of(context).size.height - 100,
        width: MediaQuery.of(context).size.width,
        color: Colors.white10,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 150,
                // color: Colors.white10,
                height: 150,
                child: Image(
                  color: ColorsTheme.mainColor,
                  image: AssetsValues.cartImage,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.only(top: 110),
      // color: Colors.amber,
      // height: 510,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 1),
        itemCount: _itemlist.length,
        itemBuilder: (context, index) {
          favorite = false;

          _flist.forEach((element) {
            if (_itemlist[index]['itemcode'] == element['item_code']) {
              favorite = true;
            }
            // else {
            //   favorite = false;
            // }
          });
          if (_itemlist[index]['status'] == '0') {
            outofStock = true;
          } else {
            outofStock = false;
          }
          if (_itemlist[index]['image'] == '') {
            noImage = true;
          } else {
            noImage = false;
          }
          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    var tmp = await db.searchCart(CustomerData.accountCode,
                        _itemlist[index]['itemcode'], _itemlist[index]['uom']);
                    _tmpitm = tmp;
                    setState(() {
                      CartData.itmCode = _itemlist[index]['itemcode'];
                      CartData.itmDesc = _itemlist[index]['product_name'];
                      CartData.itmUom = _itemlist[index]['uom'];
                      CartData.itmAmt = _itemlist[index]['list_price_wtax'];
                      CartData.itmQty = '1';
                      CartData.setCateg = _itemlist[index]['product_family'];
                      CartData.imgpath = _itemlist[index]['image'];
                      print(CartData.imgpath);
                      CartData.itmTotal =
                          (double.parse(_itemlist[index]['list_price_wtax']) *
                                  double.parse(CartData.itmQty!))
                              .toString();
                      if (_itemlist[index]['status'] == '0') {
                        GlobalVariables.outofStock = true;
                      } else {
                        GlobalVariables.outofStock = false;
                      }
                    });
                    if (_tmpitm.isNotEmpty) {
                      String msg = _tmpitm[0]['item_desc'].toString() +
                          ' is already added with ' +
                          _tmpitm[0]['item_qty'].toString() +
                          ' quantity. Add anyway?';
                      final action = await Dialogs.openDialog(
                          context, 'Confirmation', msg, false, 'No', 'Yes');
                      if (action == DialogAction.yes) {
                        showDialog(
                            context: context,
                            builder: (context) => AddDialog()).then((value) {
                          if (CartData.allProd) {
                            setState(() {
                              CartData.setCateg = 'ALL PRODUCTS';
                            });
                          } else {
                            setState(() {
                              refreshList();
                            });
                          }
                        });
                      } else {
                        if (CartData.allProd == true) {
                          setState(() {
                            CartData.setCateg = 'ALL PRODUCTS';
                          });
                        }
                      }
                    } else {
                      showDialog(
                          // barrierDismissible: false,
                          context: context,
                          builder: (context) => AddDialog()).then((value) {
                        if (CartData.allProd) {
                          setState(() {
                            CartData.setCateg = 'ALL PRODUCTS';
                          });
                        }
                      });
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 5),
                    height: 70,
                    // color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: 5,
                              height: 80,
                              color: ColorsTheme.mainColor,
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 3, top: 3),
                                width: 75,
                                color: Colors.white,
                                child: noImage
                                    ? Image(image: AssetsValues.noImageImg)
                                    // ? Image.file(File(
                                    //     "/data/data/com.example.salesman/app_flutter/images/906782_PCS.jpg"))

                                    : Image.file(File(imgPath.toString() +
                                        _itemlist[index]['image']))),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 85),
                              margin: EdgeInsets.only(left: 3),
                              // width: 180,
                              // color: Colors.green,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    // color: Colors.grey,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      _itemlist[index]['product_name'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: outofStock
                                              ? Colors.grey
                                              : Colors.black),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          width: 60,
                                          child: Text(
                                            _itemlist[index]['uom'],
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        // SizedBox(
                                        //   width: 5,
                                        // ),
                                        Container(
                                          width: 80,
                                          // color: Colors.grey,
                                          child: Text(
                                            formatCurrencyAmt.format(
                                                double.parse(_itemlist[index]
                                                    ['list_price_wtax'])),
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(left: 0),
                              // width: 105,
                              // color: Colors.grey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  // SizedBox(
                                  //   height: 40,
                                  // ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () async {
                                          // setState(() {
                                          addedAlready = false;
                                          if (_flist.isEmpty) {
                                            CartData.itmCode =
                                                _itemlist[index]['itemcode'];
                                            CartData.itmUom =
                                                _itemlist[index]['uom'];
                                            db.addfav(
                                                CustomerData.accountCode,
                                                CartData.itmCode,
                                                CartData.itmUom);
                                            loadFavorites();

                                            final action =
                                                await WarningDialogs.openDialog(
                                                    context,
                                                    'Information',
                                                    'Successfully added to favorites.',
                                                    false,
                                                    'OK');
                                            if (action == DialogAction.yes) {
                                              Navigator.pushReplacement(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return ProductperCategory();
                                              }));
                                            } else {}
                                          } else {
                                            _flist.forEach((element) {
                                              print(
                                                  _itemlist[index]['itemcode']);
                                              print(element['item_code']);
                                              if (_itemlist[index]
                                                      ['itemcode'] ==
                                                  element['item_code']) {
                                                addedAlready = true;
                                              }
                                            });
                                            if (!addedAlready) {
                                              CartData.itmCode =
                                                  _itemlist[index]['itemcode'];
                                              CartData.itmUom =
                                                  _itemlist[index]['uom'];
                                              db.addfav(
                                                  CustomerData.accountCode,
                                                  CartData.itmCode,
                                                  CartData.itmUom);
                                              loadFavorites();
                                              final action = await WarningDialogs
                                                  .openDialog(
                                                      context,
                                                      'Information',
                                                      'Successfully added to favorites.',
                                                      false,
                                                      'OK');
                                              if (action == DialogAction.yes) {
                                                Navigator.pushReplacement(
                                                    context, MaterialPageRoute(
                                                        builder: (context) {
                                                  return ProductperCategory();
                                                }));
                                              } else {}
                                            } else {
                                              showGlobalSnackbar(
                                                  'Information',
                                                  'Item already in favorites.',
                                                  Colors.blue,
                                                  Colors.white);
                                            }
                                          }
                                          // });
                                        },
                                        child: Container(
                                          // color: Colors.green,
                                          // padding: EdgeInsets.only(right: 20),
                                          child: !favorite
                                              ? Icon(
                                                  Icons.favorite_border,
                                                  color: ColorsTheme.mainColor,
                                                )
                                              : Icon(
                                                  Icons.favorite,
                                                  color: ColorsTheme.mainColor,
                                                ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          CartData.itmCode =
                                              _itemlist[index]['itemcode'];
                                          CartData.itmDesc =
                                              _itemlist[index]['product_name'];
                                          CartData.itmUom =
                                              _itemlist[index]['uom'];
                                          CartData.itmAmt = _itemlist[index]
                                              ['list_price_wtax'];
                                          CartData.itmQty = '1';
                                          CartData.setCateg = _itemlist[index]
                                              ['product_family'];
                                          CartData.itmTotal = (double.parse(
                                                      _itemlist[index]
                                                          ['list_price_wtax']) *
                                                  double.parse(
                                                      CartData.itmQty!))
                                              .toString();
                                          CartData.imgpath =
                                              _itemlist[index]['image'];
                                          if (_itemlist[index]['status'] ==
                                              '0') {
                                            GlobalVariables.outofStock = true;
                                          } else {
                                            GlobalVariables.outofStock = false;
                                          }
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AddDialog()).then((value) {
                                            if (CartData.allProd) {
                                              setState(() {
                                                CartData.setCateg =
                                                    'ALL PRODUCTS';
                                              });
                                            }
                                          });
                                        },
                                        child: Container(
                                            // color: Colors.grey,
                                            width: 60,
                                            padding: EdgeInsets.only(right: 5),
                                            child: Icon(
                                              Icons.add_circle,
                                              color: ColorsTheme.mainColor,
                                              size: 36,
                                            )),
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
                ),
              ],
            ),
          );
        },
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
                      if (CartData.setCateg == 'ALL PRODUCTS') {}
                      setState(() {
                        _searchController = str;
                        searchItems();
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
                        hintText: 'Search Product'),
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

  Container buildHeaderCont() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 80,
      // color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) {
              //   return ProductPage();
              // }));
              Navigator.pop(context);
            },
            child: Container(
              width: 50,
              height: 80,
              child: Icon(
                Icons.arrow_back,
                color: ColorsTheme.mainColor,
                size: 36,
              ),
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 100,
            height: 80,
            alignment: Alignment.centerLeft,
            // color: Colors.lightGreen,
            child: Text(
              CartData.setCateg!,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
