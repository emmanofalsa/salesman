import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/home/signature.dart';
import 'package:salesman/home/view_signature.dart';
import 'package:salesman/menu.dart';
import 'package:salesman/widgets/dialogs.dart';
import 'package:salesman/widgets/snackbar.dart';

import '../userdata.dart';

class ReceivedDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 0,
      backgroundColor: Colors.grey[100],
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    final String changeStat = 'Delivered';

    final db = DatabaseHelper();

    final formatCurrencyTot =
        new NumberFormat.currency(locale: "en_US", symbol: "Php ");

    final String date =
        DateFormat("yyyy-MM-dd H:mm:ss").format(new DateTime.now());
    OrderData.pmtype = 'CASH';
    setStatus() {
      db.getStatus(UserData.trans, changeStat, OrderData.grandTotal,
          OrderData.itmno, UserData.id, OrderData.pmtype, OrderData.signature);
      db.updateLineStatus(UserData.trans, changeStat, date);
      ChequeData.status = "Pending";
      if (OrderData.pmtype == "CHEQUE") {
        db.addCheque(
            OrderData.trans,
            CustomerData.accountCode,
            OrderData.smcode,
            UserData.id,
            date,
            ChequeData.payeeName,
            ChequeData.payorName,
            ChequeData.bankName,
            ChequeData.chequeNum,
            ChequeData.branchCode,
            ChequeData.bankAccNo,
            ChequeData.chequeDate,
            OrderData.grandTotal,
            ChequeData.status,
            ChequeData.imgName);
      }
    }

    // final formatCurrencyTot =
    //     new NumberFormat.currency(locale: "en_US", symbol: "Php ");
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Receive Order',
            style: TextStyle(
              color: Colors.green,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: 36.0,
                color: Colors.grey,
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 2 + 50,
                    child: Text(
                      OrderData.name!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.grey[850]),
                    ),
                  ),
                  Text(
                    CustomerData.district! +
                        ', ' +
                        CustomerData.city! +
                        ', ' +
                        CustomerData.province!,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey),
                  ),
                  Text(
                    formatCurrencyTot
                        .format(double.parse(OrderData.grandTotal)),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepOrange),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Container(
          color: Colors.white,
          child: Row(
            children: [
              Icon(
                Icons.comment,
                color: Colors.grey,
                size: 36,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Payment Method',
                      style: TextStyle(color: Colors.grey[800])),
                  Text(OrderData.pmtype!,
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              )),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
              )
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: () {
            OrderData.returnOrder = false;
            OrderData.setSign = false;
            if (OrderData.signature!.isNotEmpty) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return ViewSignature();
              }));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MyApp();
              }));
            }
          },
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Icon(
                  Icons.edit,
                  color: Colors.grey,
                  size: 36,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Text('Signature',
                        style: TextStyle(color: Colors.grey[800]))),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () async {
            if (OrderData.signature == "") {
              {
                showGlobalSnackbar('Information', 'Input signature.',
                    Colors.blue, Colors.white);
              }
            } else {
              print(OrderData.pmtype);
              final action = await Dialogs.openDialog(
                  context,
                  'Confirmation',
                  'Are you sure you want to receive this transaction?',
                  true,
                  'No',
                  'Yes');
              if (action == DialogAction.yes) {
                setStatus();
                OrderData.returnOrder = false;
                final action = await WarningDialogs.openDialog(context,
                    'Information', 'Received Successfully!', false, 'OK');
                if (action == DialogAction.yes) {
                  // Navigator.pushReplacement(context,
                  //     MaterialPageRoute(builder: (context) {
                  //   return Menu();
                  // }));
                  // Navigator.popAndPushNamed(context, '/hepemenu');
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/hepemenu', (Route<dynamic> route) => false);
                }
              } else {
                // Navigator.pop(context);
              }
            }
          },
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'RECEIVE ORDER',
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
    // return Stack(
    //   children: <Widget>[
    //     Container(
    //       // color: Colors.grey,
    //       padding: EdgeInsets.only(top: 50, bottom: 10, right: 5, left: 5),
    //       // margin: EdgeInsets.only(top: 16),
    //       decoration: BoxDecoration(
    //           color: Colors.grey[50],
    //           shape: BoxShape.rectangle,
    //           borderRadius: BorderRadius.circular(20),
    //           boxShadow: [
    //             BoxShadow(
    //               color: Colors.black26,
    //               blurRadius: 10.0,
    //               offset: Offset(0.0, 10.0),
    //             ),
    //           ]),
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: <Widget>[
    //           Container(
    //             height: 70,
    //             margin: EdgeInsets.only(bottom: 5),
    //             width: MediaQuery.of(context).size.width,
    //             color: Colors.white,
    //             // decoration: BoxDecoration(),
    //             child: Row(
    //               children: <Widget>[
    //                 Container(
    //                   width: 3,
    //                   height: MediaQuery.of(context).size.height,
    //                   color: Colors.deepOrange,
    //                 ),
    //                 Container(
    //                   margin: EdgeInsets.all(10),
    //                   width: 40,
    //                   height: 40,
    //                   child: Image(
    //                     image: AssetImage('assets/images/wpf_name.png'),
    //                   ),
    //                 ),
    //                 Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: <Widget>[
    //                     Container(
    //                       // color: Colors.grey,
    //                       width: MediaQuery.of(context).size.width / 2,
    //                       child: Text(
    //                         OrderData.name,
    //                         style: TextStyle(
    //                             fontSize: 16, fontWeight: FontWeight.w500),
    //                         overflow: TextOverflow.ellipsis,
    //                       ),
    //                     ),
    //                     Container(
    //                       child: Text(
    //                         CustomerData.district +
    //                             ', ' +
    //                             CustomerData.city +
    //                             ', ' +
    //                             CustomerData.province,
    //                         style: TextStyle(
    //                             fontSize: 12,
    //                             fontWeight: FontWeight.w500,
    //                             color: Colors.grey),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Container(
    //             margin: EdgeInsets.only(bottom: 5),
    //             height: 70,
    //             width: MediaQuery.of(context).size.width,
    //             color: Colors.white,
    //             // decoration: BoxDecoration(),
    //             child: Row(
    //               children: <Widget>[
    //                 Container(
    //                   width: 3,
    //                   height: MediaQuery.of(context).size.height,
    //                   color: Colors.deepOrange,
    //                 ),
    //                 Container(
    //                   margin: EdgeInsets.all(10),
    //                   width: 40,
    //                   height: 40,
    //                   child: Image(
    //                     image: AssetImage('assets/images/peso.png'),
    //                   ),
    //                 ),
    //                 Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: <Widget>[
    //                     Text(
    //                       'Amount',
    //                       style: TextStyle(
    //                           fontSize: 16, fontWeight: FontWeight.w500),
    //                     ),
    //                     Text(
    //                       formatCurrencyTot
    //                           .format(double.parse(OrderData.grandTotal)),
    //                       style: TextStyle(
    //                           fontSize: 12,
    //                           fontWeight: FontWeight.w500,
    //                           color: Colors.grey),
    //                     ),
    //                   ],
    //                 ),
    //               ],
    //             ),
    //           ),
    //           InkWell(
    //             onTap: () => {
    //               OrderData.pmtype = "",
    //               showDialog(
    //                   context: context, builder: (context) => PaymentType()),
    //             },
    //             child: Container(
    //               margin: EdgeInsets.only(bottom: 5),
    //               height: 70,
    //               width: MediaQuery.of(context).size.width,
    //               color: Colors.white,
    //               // decoration: BoxDecoration(),
    //               child: Row(
    //                 children: <Widget>[
    //                   Container(
    //                     width: 3,
    //                     height: MediaQuery.of(context).size.height,
    //                     color: Colors.deepOrange,
    //                   ),
    //                   Container(
    //                     margin: EdgeInsets.all(10),
    //                     width: 40,
    //                     height: 40,
    //                     child: Image(
    //                       image: AssetImage('assets/images/payment.png'),
    //                     ),
    //                   ),
    //                   Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: <Widget>[
    //                       Text(
    //                         'Payment Method',
    //                         style: TextStyle(
    //                             fontSize: 16, fontWeight: FontWeight.w500),
    //                       ),
    //                       Row(
    //                         children: <Widget>[
    //                           Container(
    //                             child: Text(
    //                               OrderData.pmeth,
    //                               style: TextStyle(
    //                                   fontSize: 12,
    //                                   fontWeight: FontWeight.w500,
    //                                   color: Colors.grey),
    //                             ),
    //                           ),
    //                           Container(
    //                             child: Text(
    //                               '  -  ',
    //                               style: TextStyle(
    //                                   fontSize: 12,
    //                                   fontWeight: FontWeight.w500,
    //                                   color: Colors.black),
    //                             ),
    //                           ),
    //                           Visibility(
    //                             child: Container(
    //                               child: Text(
    //                                 OrderData.pmtype,
    //                                 style: TextStyle(
    //                                     fontSize: 12,
    //                                     fontWeight: FontWeight.bold,
    //                                     color: Colors.green),
    //                               ),
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           GestureDetector(
    //             onTap: () => {
    //               OrderData.setSign = false,
    //               if (OrderData.signature.isNotEmpty)
    //                 {
    //                   Navigator.push(context,
    //                       MaterialPageRoute(builder: (context) {
    //                     return ViewSignature();
    //                   })),
    //                 }
    //               else
    //                 {
    //                   Navigator.push(context,
    //                       MaterialPageRoute(builder: (context) {
    //                     return MyApp();
    //                   })),
    //                 }
    //               // showDialog(
    //               //     context: context, builder: (context) => SignatureBox()),
    //             },
    //             child: Container(
    //               margin: EdgeInsets.only(bottom: 5),
    //               height: 70,
    //               width: MediaQuery.of(context).size.width,
    //               color: Colors.white,
    //               // decoration: BoxDecoration(),
    //               child: Row(
    //                 children: <Widget>[
    //                   Container(
    //                     width: 3,
    //                     height: MediaQuery.of(context).size.height,
    //                     color: Colors.deepOrange,
    //                   ),
    //                   Container(
    //                     margin: EdgeInsets.all(10),
    //                     width: 40,
    //                     height: 40,
    //                     child: Image(
    //                       image: AssetImage('assets/images/sign.png'),
    //                     ),
    //                   ),
    //                   Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: <Widget>[
    //                       Row(
    //                         children: <Widget>[
    //                           Text(
    //                             'Signature',
    //                             style: TextStyle(
    //                                 fontSize: 16, fontWeight: FontWeight.w500),
    //                           ),
    //                           SizedBox(
    //                             width: 10,
    //                           ),
    //                           Visibility(
    //                             visible: OrderData.setSign,
    //                             child: Icon(
    //                               Icons.check_circle,
    //                               size: 24,
    //                               color: Colors.green,
    //                             ),
    //                           ),
    //                         ],
    //                       ),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //           Container(
    //             // color: Colors.grey,
    //             child: Align(
    //               alignment: Alignment.bottomCenter,
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: <Widget>[
    //                   RaisedButton(
    //                     shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(20)),
    //                     color: Colors.green,
    //                     padding:
    //                         EdgeInsets.symmetric(horizontal: 40, vertical: 12),
    //                     onPressed: () => {
    //                       if (OrderData.pmtype == "")
    //                         {
    //                           {
    //                             showDialog(
    //                                 context: context,
    //                                 builder: (context) => NoPaymentDialog(
    //                                       title: 'Stop',
    //                                       description:
    //                                           'Please select COD-Payment Type.' +
    //                                               ' Enter Payment Type?',
    //                                       buttonText: 'Okay',
    //                                     )),
    //                           }
    //                         }
    //                       else
    //                         {
    //                           if (OrderData.signature == "")
    //                             {
    //                               {
    //                                 showDialog(
    //                                     context: context,
    //                                     builder: (context) => UnableDialog(
    //                                           title: 'Stop',
    //                                           description:
    //                                               'Unable to received an empty signature' +
    //                                                   ' Enter Signature?',
    //                                           buttonText: 'Okay',
    //                                         )),
    //                               }
    //                             }
    //                           else
    //                             {
    //                               showDialog(
    //                                   context: context,
    //                                   builder: (context) => ConfirmBox(
    //                                         title: 'Confirmation',
    //                                         description:
    //                                             'Are you sure you want to save this transaction?',
    //                                         buttonText: 'Confirm',
    //                                       )),
    //                             }
    //                         }
    //                     },
    //                     child: Text(
    //                       'Receive',
    //                       style: TextStyle(color: Colors.white),
    //                     ),
    //                   ),
    //                   SizedBox(
    //                     width: 5,
    //                   ),
    //                   RaisedButton(
    //                     shape: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(20),
    //                         side: BorderSide(color: Colors.deepOrange)),
    //                     color: Colors.white,
    //                     padding:
    //                         EdgeInsets.symmetric(horizontal: 40, vertical: 12),
    //                     onPressed: () {
    //                       OrderData.pmtype = "";
    //                       OrderData.setSign = false;
    //                       Navigator.pop(context);
    //                     },
    //                     child: Text(
    //                       'Cancel',
    //                       style: TextStyle(color: Colors.deepOrange),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     Container(
    //       padding: EdgeInsets.only(left: 10),
    //       height: 60,
    //       width: MediaQuery.of(context).size.width,
    //       // color: Colors.deepOrange,
    //       decoration: BoxDecoration(
    //           color: Colors.deepOrange,
    //           shape: BoxShape.rectangle,
    //           borderRadius: BorderRadius.only(
    //               topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: <Widget>[
    //           Text(
    //             'Receiving & Payment',
    //             style: TextStyle(
    //               color: Colors.white,
    //               fontSize: 24,
    //               fontWeight: FontWeight.w500,
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // );
  }
}
