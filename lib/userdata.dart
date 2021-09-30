import 'dart:async';

import 'package:flutter/cupertino.dart';

class AppData {
  static String appName = 'E-COMMERCE(My NETgosyo App)';
  static String? appVersion;
  static String appYear = ' COPYRIGHT 2021';
  static bool appUptodate = true;
  static String updesc = 'SMAPP';
}

class UserData {
  static String? id;
  static String? firstname;
  static String? lastname;
  static String? position;
  static String? department;
  static String? division;
  static String? district;
  static String? contact;
  static String? postal;
  static String? email;
  static String? address;
  static String? routes;
  static String? trans;
  static String? sname;
  static String? username;
  static String? newPassword;
  static String? passwordAge;
  static String? img;
  static String? imgPath;
  static String? getImgfrom;
}

class OrderData {
  static String? trans;
  static String? pmeth;
  static String? name;
  static String? dateReq;
  static String? dateApp;
  static String? dateDel;
  static String? itmno;
  static String? address;
  static String? contact;
  static String? qty;
  static String? smcode;
  static String totamt = '0';
  static String retAmt = '0';
  static String totalDisc = '0';
  static String grandTotal = '0';
  static bool visible = true;
  static String? status;
  static String? changeStat;
  static String? signature;
  static String? pmtype;
  static bool setPmType = false;
  static bool setSign = false;
  static bool setChequeImg = false;
  static List tranLine = [];
  static bool returnOrder = false;
  static String? returnReason;
  static String? specialInstruction;
  static bool note = false;
}

class CustomerData {
  static String? id;
  static String? accountCode;
  static String? groupCode;
  static String? province;
  static String? city;
  static String? district;
  static String? accountName;
  static String? accountDescription;
  static String? contactNo;
  static String? paymentType;
  static String? status;
  static String? colorCode;
  static Color? custColor;
  static String? creditLimit;
  static String? creditBal;
  static bool discounted = false;
  static bool placeOrder = true;
  static List tranNoList = [];
}

class CartData {
  static String itmNo = '0';
  static String? itmLineNo;
  static String totalAmount = '0';
  static String? setCateg;
  static String? itmCode;
  static String? itmDesc;
  static String? itmUom;
  static String? itmAmt;
  static String? itmQty;
  static String? itmTotal;
  static String? cartTotal;
  static String? imgpath;
  static bool allProd = false;
}

class GlobalVariables {
  static String? itmQty;
  static int menuKey = 0;
  static String? tranNo;
  static bool isDone = false;
  static bool showSign = false;
  static bool showCheque = false;
  static List itemlist = [];
  static List favlist = [];
  static List returnList = [];
  static bool emptyFav = true;
  static bool processedPressed = false;
  static String? minOrder;
  static bool outofStock = false;
  static bool consolidatedOrder = false;
  static String appVersion = '01';
  static String updateType = '';
  static bool updateSpinkit = true;
  static bool uploaded = false;
  static String tableProcessing = '';
  static List processList = [];
  // static List<String> processList = List<String>();
  // processList['process'] = '';
  static bool viewPolicy = true;
  static bool dataPrivacyNoticeScrollBottom = false;
  static String? fpassUsername;
  static String? fpassmobile;
  static String? fpassusercode;
  static String statusCaption = '';
  static String? uploadLength;
  static bool upload = false;
  static bool? uploadSpinkit;
  static double? spinProgress;
  static bool passExp = false;
  static String? deviceData;
}

class GlobalTimer {
  static Timer? timerSessionInactivity;
}

class ChequeData {
  static String? payeeName;
  static String? payorName;
  static String? bankName;
  static String? chequeNum;
  static String? branchCode;
  static String? bankAccNo;
  static String? chequeDate;
  static String? status;
  static String? chequeAmt;
  static String? numToWords;
  static String? imgName;
  static bool changeImg = false;
}

class SalesData {
  static String? salesToday;
  static String? salesWeekly;
  static String? salesMonthly;
  static String? salesYearly;
  static String? salesmanSalesType;
  static String? customerSalesType;
  static String? overallSalesType;
  static String? smTotalCaption;
  static String? custTotalCaption;
}

class NetworkData {
  static Timer? timer;
  static bool connected = false;
  static bool errorMsgShow = true;
  static String? errorMsg;
  static bool uploaded = false;
  static String? errorNo;
}

class ForgetPassData {
  static String? type;
  static String? smsCode;
  static String? number;
}

class ChatData {
  static String? senderName;
  static String? accountCode;
  static String? accountName;
  static String? accountNum;
  static String? refNo;
  static String? status;
  static bool newNotif = false;
}

MyGlobals myGlobals = MyGlobals();

class MyGlobals {
  GlobalKey? _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey!;
}

class Spinkit {
  static String? label;
}
