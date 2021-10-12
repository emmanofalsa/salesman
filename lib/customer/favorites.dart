import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:salesman/api.dart';
// import 'package:salesman/customer/product_page.dart';
import 'package:salesman/db/db_helper.dart';
// import 'package:salesman/url/url.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/assets.dart';
import 'package:salesman/variables/colors.dart';
import 'dart:ui' as ui;
import 'package:salesman/widgets/dialogs.dart';
import 'package:salesman/widgets/elevated_button.dart';
import 'package:salesman/widgets/snackbar.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List _flist = [];
  bool noImage = false;
  String? imgPath;
  final db = DatabaseHelper();

  final formatCurrencyAmt =
      new NumberFormat.currency(locale: "en_US", symbol: "₱");

  void initState() {
    super.initState();
    loadItempath();
  }

  loadItempath() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + '/';
    imgPath = firstPath;
    setState(() {
      _flist = GlobalVariables.favlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  // buildHeaderCont(),
                  SizedBox(
                    height: 5,
                  ),
                  buildFavListCont(),
                ],
              ),
            ),
          ),
          Container(
            height: 160,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 16, right: 16, top: 30, bottom: 5),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 15,
                  ),
                  buildHeaderCont(),
                ],
              ),
            ),
          ),
          // buildSummaryCont(context),
        ],
      ),
    );
  }

  Container buildFavListCont() {
    if (GlobalVariables.emptyFav == true) {
      return Container(
        padding: EdgeInsets.all(50),
        margin: EdgeInsets.only(top: 200),
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        // color: ColorsTheme.mainColor,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.favorite_border,
              size: 100,
              color: Colors.orange[500],
            ),
            Text(
              'You have not added any product in your favorites list.',
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
      margin: EdgeInsets.only(top: 110),
      // color: Colors.amber,
      // height: 510,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 1),
        itemCount: _flist.length,
        itemBuilder: (context, index) {
          final item = _flist[index].toString();
          if (_flist[index]['image'] == '') {
            // print(_list[index]['image']);
            noImage = true;
          } else {
            noImage = false;
          }

          return Dismissible(
            background: Container(
              alignment: AlignmentDirectional.centerEnd,
              color: ColorsTheme.mainColor,
              child: Icon(
                Icons.delete,
                color: Colors.white,
                size: 36,
              ),
            ),
            direction: DismissDirection.endToStart,
            key: Key(item),
            onDismissed: (direction) {
              db.deleteFav(CustomerData.accountCode, _flist[index]['itemcode'],
                  _flist[index]['uom']);
              _flist.removeAt(index);
            },
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () => {
                    CartData.itmCode = _flist[index]['itemcode'],
                    CartData.itmDesc = _flist[index]['product_name'],
                    CartData.itmUom = _flist[index]['uom'],
                    CartData.itmAmt = _flist[index]['list_price_wtax'],
                    CartData.itmQty = '1',
                    CartData.imgpath = _flist[index]['image'],
                    CartData.itmTotal =
                        (double.parse(_flist[index]['list_price_wtax']) *
                                double.parse(CartData.itmQty))
                            .toString(),
                    print('Item Amount:' + CartData.itmAmt!),
                    print('Item Qty:' + CartData.itmQty),
                    print(CartData.itmTotal),
                    print(CartData.imgpath),
                    showDialog(
                        context: context, builder: (context) => AddDialog()),
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
                            if (GlobalVariables.viewImg)
                              Container(
                                margin: EdgeInsets.only(left: 3, top: 3),
                                width: 75,
                                color: Colors.white,
                                child: noImage
                                    ? Image(image: AssetsValues.noImageImg)
                                    : Image.file(File(imgPath.toString() +
                                        _flist[index]['image'])),
                              )
                            else if (!GlobalVariables.viewImg)
                              Container(
                                  margin: EdgeInsets.only(left: 3, top: 3),
                                  width: 75,
                                  color: Colors.white,
                                  child: Image(image: AssetsValues.noImageImg))
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
                                      _flist[index]['product_name'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
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
                                            _flist[index]['uom'],
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
                                                double.parse(_flist[index]
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
                                      // InkWell(
                                      //   onTap: () => {
                                      //     CartData.itmCode =
                                      //         _flist[index]['itemcode'],
                                      //     CartData.itmUom =
                                      //         _flist[index]['uom'],
                                      //     addfav(
                                      //         CustomerData.accountCode,
                                      //         CartData.itmCode,
                                      //         CartData.itmUom),
                                      //     showDialog(
                                      //         context: context,
                                      //         builder: (context) =>
                                      //             AddFavorites()),
                                      //   },
                                      //   child: Container(
                                      //     // color: Colors.green,
                                      //     // padding: EdgeInsets.only(right: 20),
                                      //     child: !favorite
                                      //         ? Icon(
                                      //             Icons.favorite_border,
                                      //             color: Colors.deepOrange,
                                      //           )
                                      //         : Icon(
                                      //             Icons.favorite,
                                      //             color: Colors.deepOrange,
                                      //           ),
                                      //   ),
                                      // ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      InkWell(
                                        onTap: () => {
                                          CartData.itmCode =
                                              _flist[index]['itemcode'],
                                          CartData.itmDesc =
                                              _flist[index]['product_name'],
                                          CartData.itmUom =
                                              _flist[index]['uom'],
                                          CartData.itmAmt =
                                              _flist[index]['list_price_wtax'],
                                          CartData.itmQty = '1',
                                          CartData.itmTotal = (double.parse(
                                                      _flist[index]
                                                          ['list_price_wtax']) *
                                                  double.parse(CartData.itmQty))
                                              .toString(),
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  AddDialog()),
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
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
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
            alignment: Alignment.center,
            // color: Colors.lightGreen,
            child: Text(
              CustomerData.accountName! + "'s Favorites",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddDialog extends StatefulWidget {
  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final db = DatabaseHelper();
  String? imgPath;
  TextEditingController qtyController = TextEditingController()..text = '1';
  final formatCurrencyAmt =
      new NumberFormat.currency(locale: "en_US", symbol: "₱");

  List _tolist = [];
  List _setlist = [];

  void initState() {
    super.initState();
    getUomList();
  }

  uomonChanged() async {
    var setU = await db.setUom(CartData.itmCode, CartData.itmUom);
    _setlist = setU;
    setState(() {
      _setlist.forEach((element) {
        CartData.itmAmt = (element['list_price_wtax']);
        CartData.itmTotal =
            (double.parse(CartData.itmAmt!) * double.parse(CartData.itmQty))
                .toString();
        CartData.imgpath = (element['image']);
        print('Item Amount:' + CartData.itmAmt!);
        print('Item Qty:' + CartData.itmQty);
        print(CartData.itmTotal);
      });
    });
  }

  getUomList() async {
    var documentDirectory = await getApplicationDocumentsDirectory();
    var firstPath = documentDirectory.path + '/';
    imgPath = firstPath;
    var getU = await db.getUom(CartData.itmCode);
    setState(() {
      _tolist = getU;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    qtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              // color: Colors.grey,
              padding: EdgeInsets.only(top: 60, bottom: 16, right: 5, left: 5),
              margin: EdgeInsets.only(top: 100),
              decoration: BoxDecoration(
                  color: Colors.grey[50],
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2 + 80,
                    height: 200,
                    // color: Colors.grey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width - 100,
                          // color: Colors.grey,
                          child: Text(
                            CartData.itmDesc!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                formatCurrencyAmt
                                    .format(double.parse(CartData.itmAmt!)),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButton<String>(
                                    value: CartData.itmUom,
                                    items: _tolist.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(
                                          item['uom'],
                                          style: TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                        value: item['uom'].toString(),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        CartData.itmUom = newValue!;
                                        uomonChanged();
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width / 2,
                          child: Text(
                            'Quantity',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20),
                          width: MediaQuery.of(context).size.width / 2,
                          // color: Colors.grey,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (int.parse(CartData.itmQty) > 0) {
                                      int i = 0;
                                      i = int.parse(CartData.itmQty) - 1;
                                      CartData.itmQty = i.toString();
                                      CartData.itmTotal =
                                          (double.parse(CartData.itmAmt!) *
                                                  double.parse(CartData.itmQty))
                                              .toString();
                                      // print(CartData.itmTotal);
                                      qtyController.text = CartData.itmQty;
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.indeterminate_check_box,
                                  color: ColorsTheme.mainColor,
                                  size: 36,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 40,
                                child: TextField(
                                  textDirection: ui.TextDirection.rtl,
                                  controller: qtyController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    // WhitelistingTextInputFormatter.digitsOnly
                                  ],
                                  onChanged: (text) {
                                    setState(() {
                                      CartData.itmQty = qtyController.text;
                                      if (double.parse(CartData.itmQty) > 100) {
                                        qtyController.text = '100';
                                        CartData.itmQty = '100';
                                      }
                                      CartData.itmTotal =
                                          (double.parse(CartData.itmAmt!) *
                                                  double.parse(CartData.itmQty))
                                              .toString();
                                      print(CartData.itmTotal);
                                    });
                                  },
                                  onTap: () => qtyController.selection =
                                      TextSelection(
                                          baseOffset: 0,
                                          extentOffset:
                                              qtyController.value.text.length),
                                ),
                                // child: Text(
                                //   CartData.itmQty,
                                //   style: TextStyle(
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.w500,
                                //     color: Colors.black,
                                //   ),
                                //   textAlign: TextAlign.center,
                                // ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    if (double.parse(CartData.itmQty) >= 100) {
                                      qtyController.text = '100';
                                      CartData.itmQty = '100';
                                    } else {
                                      int i = 0;
                                      i = int.parse(CartData.itmQty) + 1;
                                      CartData.itmQty = i.toString();
                                      CartData.itmTotal =
                                          (double.parse(CartData.itmAmt!) *
                                                  int.parse(CartData.itmQty))
                                              .toString();
                                      qtyController.text = CartData.itmQty;
                                    }
                                  });
                                },
                                child: Icon(
                                  Icons.add_box,
                                  color: ColorsTheme.mainColor,
                                  size: 36,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    // color: Colors.grey,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            style: raisedButtonDialogStyle,
                            onPressed: () async {
                              // setState(() {
                              print(CartData.itmQty);
                              if (CartData.itmQty == "0") {
                                showGlobalSnackbar(
                                    'Information',
                                    'Unable to add empty quantity!',
                                    Colors.blue,
                                    Colors.white);
                              } else {
                                CartData.totalAmount =
                                    (double.parse(CartData.totalAmount) +
                                            double.parse(CartData.itmTotal!))
                                        .toString();
                                CartData.itmNo =
                                    (int.parse(CartData.itmNo) + 1).toString();
                                db.addItemtoCart(
                                    UserData.id,
                                    CustomerData.accountCode,
                                    CartData.itmCode,
                                    CartData.itmDesc,
                                    CartData.itmUom,
                                    CartData.itmAmt,
                                    CartData.itmQty,
                                    CartData.itmTotal,
                                    CartData.setCateg,
                                    CartData.imgpath);
                                final action = await WarningDialogs.openDialog(
                                    context,
                                    'Information',
                                    'Item added to cart.',
                                    false,
                                    'OK');
                                if (action == DialogAction.yes) {
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return FavoritesPage();
                                  }));
                                } else {}
                              }
                              // });
                            },
                            child: Text(
                              'ADD TO CART',
                              style: TextStyle(color: Colors.white),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: ColorsTheme.mainColor, width: 2)),
              width: 180,
              height: 150,
              child: Image.file(File(imgPath.toString() + CartData.imgpath!)),
              // color: Colors.grey,
            ),
          ],
        ),
      ],
    );
  }
}
