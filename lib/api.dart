// import 'dart:async';
// import 'dart:io';

// import 'package:http/http.dart' as http;
// import 'package:retry/retry.dart';
// // import 'package:retry/retry.dart';
// import 'dart:convert';

// import 'package:salesman/url/url.dart';

// Future loginUser(String username, String password) async {
//   // String url = 'http://172.16.44.122/my_store/signin';
//   String url = UrlAddress.url + '/signin';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'username': username, 'password': password});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future loginHepe(String username, String password) async {
//   // String url = 'http://172.16.44.122/my_store/signin';
//   String url = UrlAddress.url + '/signinhepe';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'username': username, 'password': password});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getProcessed(String userId) async {
//   String url = UrlAddress.url + '/getprocessed';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'sm_code': userId});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getSalesmanList(String code) async {
//   String url = UrlAddress.url + '/getsmlist';
//   final response = await retry(() => http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'hepe_code': code}));
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getPending(String userId) async {
//   String url = UrlAddress.url + '/getpending';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'sm_code': userId});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getCustInfo(String cusCode) async {
//   String url = UrlAddress.url + '/getcustinfo';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'account_code': cusCode});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// //E ENCRYPT OG DECRYPT
// // Future getOrders(String transNo) async {
// //   String url = UrlAddress.url + '/getorders';
// //   final response = await http.post(url, headers: {
// //     "Accept": "Application/json"
// //   }, body: {
// //     'tran_no': transNo,
// //   });
// //   var convertedDatatoJson = jsonDecode(response.body);
// //   return convertedDatatoJson;
// // }

// // Future getRemovedOrders(String transNo) async {
// //   String url = UrlAddress.url + '/getremovedorders';
// //   final response = await http.post(url,
// //       headers: {"Accept": "Application/json"}, body: {'tran_no': transNo});
// //   var convertedDatatoJson = jsonDecode(response.body);
// //   return convertedDatatoJson;
// // }

// Future getUnservedOrders(String transNo) async {
//   String url = UrlAddress.url + '/getunservedorders';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'tran_no': transNo});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getReturnedOrders(String transNo) async {
//   String url = UrlAddress.url + '/getreturnedorders';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'tran_no': transNo});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getDeliveredOrders(String transNo) async {
//   String url = UrlAddress.url + '/getdeliveredorders';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'tran_no': transNo});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getAllTrans(String userId) async {
//   String url = UrlAddress.url + '/getalltrans';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'sm_code': userId});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getTransHistoryPerCustomer(String accountCode) async {
//   String url = UrlAddress.url + '/gethistory';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'account_code': accountCode});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getStatus(String userId, String status, String amt, String date,
//     String type, String signature) async {
//   String url = UrlAddress.url + '/getstatus';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'tran_no': userId,
//     'tran_stat': status,
//     'tot_del_amt': amt,
//     'date_del': date,
//     'pmeth_type': type,
//     'signature': signature
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future setReturnStatus(
//   String userId,
//   String status,
//   String delamt,
//   String date,
//   String signature,
//   String accountCode,
//   String sName,
//   String itmcount,
//   String retamt,
//   String smcode,
//   String reason,
// ) async {
//   String url = UrlAddress.url + '/setreturnstatus';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'tran_no': userId,
//     'tran_stat': status,
//     'tot_del_amt': delamt,
//     'date_del': date,
//     'signature': signature,
//     'account_code': accountCode,
//     'store_name': sName,
//     'itm_count': itmcount,
//     'tot_amt': retamt,
//     'hepe_code': smcode,
//     'reason': reason,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getCustomers(String userId) async {
//   String url = UrlAddress.url + '/getcustomer';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'salesman_code': userId});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future sCustomers(String userId, String name) async {
//   String url = UrlAddress.url + '/scustomer';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'salesman_code': userId, 'account_name': name});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future sHistory(String name) async {
//   String url = UrlAddress.url + '/shistory';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'tran_no': name});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future sCateg(String name) async {
//   String url = UrlAddress.url + '/scategory';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'category_name': name});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future sItems(String categ, String name) async {
//   String url = UrlAddress.url + '/searchitem';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'product_family': categ, 'product_name': name});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future sAllItems(String name) async {
//   String url = UrlAddress.url + '/searchallitem';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'product_name': name});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getTemp(String userId, String accountCode) async {
//   String url = UrlAddress.url + '/getcart';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'salesman_code': userId, 'account_code': accountCode});
//   var convertedDatatoJson = jsonDecode(response.body);
//   print(convertedDatatoJson);
//   return convertedDatatoJson;
// }

// Future updateTemp(String userId, String accountCode, String itmcode, String uom,
//     String qty, String itmtotal) async {
//   String url = UrlAddress.url + '/updatecart';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'salesman_code': userId,
//     'account_code': accountCode,
//     'item_code': itmcode,
//     'item_uom': uom,
//     'item_qty': qty,
//     'item_total': itmtotal,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future deleteItem(
//     String userId, String accountCode, String itmcode, String uom) async {
//   String url = UrlAddress.url + '/deleteitem';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'salesman_code': userId,
//     'account_code': accountCode,
//     'item_code': itmcode,
//     'item_uom': uom
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future deleteCart(String userId, String accountCode) async {
//   String url = UrlAddress.url + '/deletecart';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'salesman_code': userId, 'account_code': accountCode});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future addItem(String userId, String custId, String itmcode, String desc,
//     String uom, String amt, String qty, String itmtotal, String categ) async {
//   String url = UrlAddress.url + '/additem';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'salesman_code': userId,
//     'account_code': custId,
//     'item_code': itmcode,
//     'item_desc': desc,
//     'item_uom': uom,
//     'item_amt': amt,
//     'item_qty': qty,
//     'item_total': itmtotal,
//     'item_cat': categ
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getCateg() async {
//   String url = UrlAddress.url + '/getcateg';
//   final response =
//       await http.post(url, headers: {"Accept": "Application/json"}, body: {});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getUom(String itmcode) async {
//   String url = UrlAddress.url + '/getuom';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'itemcode': itmcode});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future setUom(String itmcode, String uom) async {
//   String url = UrlAddress.url + '/setuom';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'itemcode': itmcode, 'uom': uom});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getProducts(String name) async {
//   String url = UrlAddress.url + '/getproducts';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'product_family': name});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getAllProducts() async {
//   String url = UrlAddress.url + '/getallproducts';
//   final response =
//       await http.post(url, headers: {"Accept": "Application/json"}, body: {});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future addTranHead(
//     String userId,
//     String date,
//     String custId,
//     String storeName,
//     String payment,
//     String itmcount,
//     String totamt,
//     String stat,
//     String signature) async {
//   String url = UrlAddress.url + '/addtranhead';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'sm_code': userId,
//     'date_req': date,
//     'account_code': custId,
//     'store_name': storeName,
//     'p_meth': payment,
//     'itm_count': itmcount,
//     'tot_amt': totamt,
//     'tran_stat': stat,
//     'auth_signature': signature,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future addTranLine(
//     String tranNo,
//     String itmcode,
//     String desc,
//     String qty,
//     String uom,
//     String amt,
//     String totamt,
//     String categ,
//     String code,
//     String date) async {
//   String url = UrlAddress.url + '/addtranline';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'tran_no': tranNo,
//     'itm_code': itmcode,
//     'item_desc': desc,
//     'req_qty': qty,
//     'uom': uom,
//     'amt': amt,
//     'tot_amt': totamt,
//     'itm_cat': categ,
//     'account_code': code,
//     'date_req': date,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future addfav(String accountCode, String itmcd, String uom) async {
//   String url = UrlAddress.url + '/addfavorites';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'account_code': accountCode, 'item_code': itmcd, 'item_uom': uom});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getFav(String accountCode) async {
//   String url = UrlAddress.url + '/getfavorites';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'account_code': accountCode,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future deleteFav(String accountCode, String itmcode, String uom) async {
//   String url = UrlAddress.url + '/deletefav';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'account_code': accountCode,
//     'item_code': itmcode,
//     'item_uom': uom
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future addCheque(
//     String tranNo,
//     String accountCode,
//     String smCode,
//     String hepeCode,
//     String datetime,
//     String payeeName,
//     String payorName,
//     String bankName,
//     String chequeNo,
//     String branchCode,
//     String accountNo,
//     String chequeDate,
//     String amount,
//     String status,
//     String img) async {
//   String url = UrlAddress.url + '/addcheque';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'tran_no': tranNo,
//     'account_code': accountCode,
//     'sm_code': smCode,
//     'hepe_code': hepeCode,
//     'datetime': datetime,
//     'payee_name': payeeName,
//     'payor_name': payorName,
//     'bank_name': bankName,
//     'cheque_no': chequeNo,
//     'branch_code': branchCode,
//     'account_no': accountNo,
//     'cheque_date': chequeDate,
//     'amount': amount,
//     'status': status,
//     'image': img,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future checkChequeNo(String chequeno, String smcode) async {
//   String url = UrlAddress.url + '/checkcheque';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'cheque_no': chequeno, 'sm_code': smcode});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getCheque(String transNo) async {
//   String url = UrlAddress.url + '/getcheque';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'tran_no': transNo,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getOrderLimit() async {
//   String url = UrlAddress.url + '/gorderlimit';
//   final response =
//       await http.post(url, headers: {"Accept": "Application/json"}, body: {});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getDailySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getsmdailysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getWeeklySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getsmweeklysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getMonthlySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getsmmonthlysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getYearlySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getsmyearlysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getSalesType() async {
//   String url = UrlAddress.url + '/getsalestype';
//   final response =
//       await http.post(url, headers: {"Accept": "Application/json"}, body: {});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getTotalSalesType() async {
//   String url = UrlAddress.url + '/gettotalsalestype';
//   final response =
//       await http.post(url, headers: {"Accept": "Application/json"}, body: {});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getCustomerList(String code) async {
//   String url = UrlAddress.url + '/getcustlist';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'salesman_code': code});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getCustomerDailySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getcustdailysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getCustomerWeeklySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getcustweeklysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getCustomerMonthlySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getcustmonthlysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getCustomerYearlySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getcustyearlysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future minusQtytoLine(
//     String tran, String itmcode, String uom, String qty) async {
//   String url = UrlAddress.url + '/minustoline';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'tran_no': tran, 'itm_code': itmcode, 'uom': uom, 'del_qty': qty});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future addtoUnserved(String tran, String itmcode, String desc, String uom,
//     String amt, String qty, String itmtotal, String categ) async {
//   String url = UrlAddress.url + '/addtolog';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'tran_no': tran,
//     'itm_code': itmcode,
//     'item_desc': desc,
//     'uom': uom,
//     'amt': amt,
//     'qty': qty,
//     'tot_amt': itmtotal,
//     'itm_cat': categ,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future addQtytoLine(String tran, String itmcode, String desc, String uom,
//     String amt, String qty, String itmtotal, String categ) async {
//   String url = UrlAddress.url + '/addtoline';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'tran_no': tran,
//     'itm_code': itmcode,
//     'item_desc': desc,
//     'uom': uom,
//     'amt': amt,
//     'del_qty': qty,
//     'tot_amt': itmtotal,
//     'itm_cat': categ,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future deleteQtytoLog(
//     String tran, String itmcode, String uom, String qty) async {
//   String url = UrlAddress.url + '/deletetolog';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'tran_no': tran, 'itm_code': itmcode, 'uom': uom, 'qty': qty});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getBankList() async {
//   String url = UrlAddress.url + '/getbanklist';
//   final response =
//       await http.post(url, headers: {"Accept": "Application/json"}, body: {});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// /////SALESMAN SALES//////
// Future getMyDailySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getmydailysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getMyWeeklySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getmyweeklysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getMyMonthlySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getmymonthlysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getMyYearlySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getmyyearlysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getMySalesType() async {
//   String url = UrlAddress.url + '/getmysalestype';
//   final response =
//       await http.post(url, headers: {"Accept": "Application/json"}, body: {});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getMyTotalSalesType() async {
//   String url = UrlAddress.url + '/getmytotalsalestype';
//   final response =
//       await http.post(url, headers: {"Accept": "Application/json"}, body: {});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getMyCustomerList(String code) async {
//   String url = UrlAddress.url + '/getmycustlist';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'salesman_code': code});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getMyCustomerDailySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getmycustdailysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getMyCustomerWeeklySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getmycustweeklysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getMyCustomerMonthlySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getmycustmonthlysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getMyCustomerYearlySales(String userId, String type) async {
//   String url = UrlAddress.url + '/getmycustyearlysales';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'sm_code': userId, 'pmeth_type': type});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// ///CHANGE PASSWORD///

// Future changeSalesmanPassword(String code, String pass) async {
//   String url = UrlAddress.url + '/changesmpassword';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'user_code': code, 'password': pass});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future changeHepePassword(String code, String pass) async {
//   String url = UrlAddress.url + '/changehepepassword';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'user_code': code, 'password': pass});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// ///

// Future getPromos() async {
//   String url = UrlAddress.url + '/getpromos';
//   final response =
//       await http.post(url, headers: {"Accept": "Application/json"}, body: {});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future checkDiscounted(String usercode) async {
//   String url = UrlAddress.url + '/checkdiscounted';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'account_code': usercode,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future addtoReturnLine(String tran, String itmcode, String desc, String uom,
//     String amt, String qty, String itmtotal, String categ) async {
//   String url = UrlAddress.url + '/addreturnline';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'tran_no': tran,
//     'itm_code': itmcode,
//     'item_desc': desc,
//     'uom': uom,
//     'amt': amt,
//     'qty': qty,
//     'tot_amt': itmtotal,
//     'itm_cat': categ,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// /////////////////////CONSOLIDATED API"S///////////////////////////////////
// Future getConsolidatedApprovedRequestHead(String userId) async {
//   String url = UrlAddress.url + '/getCARHead';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'sm_code': userId});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getConsolidatedApprovedRequestLine(String code, String date) async {
//   String url = UrlAddress.url + '/getCARLine';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'account_code': code, 'date_req': date});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getTransactionNoList(String code, String date) async {
//   String url = UrlAddress.url + '/gettranlist';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'account_code': code, 'date_req': date});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getTranperLine(String itmcode, String code, String date) async {
//   String url = UrlAddress.url + '/gettranperline';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'itm_code': itmcode, 'account_code': code, 'date_req': date});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future getSameDayTransaction(String code, String date) async {
//   String url = UrlAddress.url + '/getCARHead';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"},
//       body: {'account_code': code, 'date_req': date});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future addsampletable(String img) async {
//   String url = UrlAddress.url + '/addsample';
//   final response = await http.post(url,
//       headers: {"Accept": "Application/json"}, body: {'signature': img});
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// /////NEW API

// Future checkStat() async {
//   try {
//     String url = UrlAddress.url + '/checkstat';
//     final response =
//         await http.post(url, headers: {"Accept": "Application/json"}, body: {});
//     var convertedDatatoJson = jsonDecode(response.body);
//     return convertedDatatoJson;
//   } on SocketException {
//     return 'ERROR1';
//   } on HttpException {
//     return 'ERROR2';
//   } on FormatException {
//     return 'ERROR3';
//   }
// }
// //RETRY
// // Future saveTransaction() async {
// //   final r = RetryOptions(maxAttempts: 8);
// //   String url = UrlAddress.url + '/savetransaction';
// //   final response = await r.retry(
// //     () => http.post(url,
// //         headers: {"Accept": "Application/json"},
// //         body: {}).timeout(Duration(seconds: 5)),
// //     retryIf: (e) => e is SocketException || e is TimeoutException,
// //   );
// //   var convertedDatatoJson = jsonDecode(response.body);
// //   return convertedDatatoJson;
// // }

// Future saveTransactionHead(
//     String userId,
//     String date,
//     String custId,
//     String storeName,
//     String payment,
//     String itmcount,
//     String totamt,
//     String stat,
//     String signature) async {
//   String url = UrlAddress.url + '/addtranhead';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'sm_code': userId,
//     'date_req': date,
//     'account_code': custId,
//     'store_name': storeName,
//     'p_meth': payment,
//     'itm_count': itmcount,
//     'tot_amt': totamt,
//     'tran_stat': stat,
//     'auth_signature': signature,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

// Future saveTransactionLine(
//     String tranNo,
//     String itmcode,
//     String desc,
//     String qty,
//     String uom,
//     String amt,
//     String totamt,
//     String categ,
//     String code,
//     String date) async {
//   String url = UrlAddress.url + '/addtranline';
//   final response = await http.post(url, headers: {
//     "Accept": "Application/json"
//   }, body: {
//     'tran_no': tranNo,
//     'itm_code': itmcode,
//     'item_desc': desc,
//     'req_qty': qty,
//     'uom': uom,
//     'amt': amt,
//     'tot_amt': totamt,
//     'itm_cat': categ,
//     'account_code': code,
//     'date_req': date,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }
