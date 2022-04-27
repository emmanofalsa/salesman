import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/home/return_reason.dart';
import 'package:salesman/home/signature.dart';
import 'package:salesman/home/view_signature.dart';
// import 'package:salesman/menu.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/dialogs.dart';
import 'package:salesman/widgets/snackbar.dart';

class ReturnDialog extends StatelessWidget {
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
    final String returnStat = 'Returned';
    final String delAmt = '0.00';
    List _returnlist = [];

    final db = DatabaseHelper();

    final formatCurrencyTot =
        new NumberFormat.currency(locale: "en_US", symbol: "Php ");

    // final String date =
    //     DateFormat("yyyy-MM-dd H:mm:ss").format(new DateTime.now());
    setReturn() {
      // setState(() {
      db.addtoReturnedTran(
          OrderData.trans,
          CustomerData.accountCode,
          OrderData.name,
          OrderData.itmno,
          OrderData.grandTotal,
          UserData.id,
          OrderData.returnReason,
          OrderData.signature);
      db.updateReturnStatus(OrderData.trans, UserData.id, returnStat, delAmt,
          OrderData.signature);

      _returnlist = GlobalVariables.returnList;
      // print(_returnlist);
      _returnlist.forEach((element) {
        db.addtoReturnLine(
            OrderData.trans,
            element['itm_code'],
            element['item_desc'],
            element['uom'],
            element['amt'],
            element['del_qty'],
            element['tot_amt'],
            element['itm_cat']);
      });
      // });
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Return Order',
            style: TextStyle(
              color: Colors.black,
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
                        color: ColorsTheme.mainColor),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) {
            //   return ReturnReason();
            // }));
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: ReturnReason()));
          },
          child: Container(
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
                    child: Text('Reason for return',
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
          height: 5,
        ),
        GestureDetector(
          onTap: () {
            OrderData.setSign = false;
            if (OrderData.signature!.isNotEmpty) {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return ViewSignature();
              // }));
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: ViewSignature()));
            } else {
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return MyApp();
              // }));
              Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft, child: MyApp()));
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
            print(OrderData.returnReason);
            // ScaffoldMessenger.of(context).clearSnackBars();
            if (OrderData.returnReason.isEmpty) {
              // ScaffoldMessenger.of(context).showSnackBar(getSnackBar(
              //     "Input Reason for return", Colors.black, Colors.white));
              showGlobalSnackbar('Information', 'Input Reason for return.',
                  Colors.blue, Colors.white);
            } else {
              if (OrderData.signature == "") {
                {
                  // ScaffoldMessenger.of(context).showSnackBar(getSnackBar(
                  //     "Input signature", Colors.black, Colors.white));
                  showGlobalSnackbar('Information', 'Input signature.',
                      Colors.blue, Colors.white);
                }
              } else {
                final action = await Dialogs.openDialog(
                    context,
                    'Confirmation',
                    'Are you sure you want to return this transaction?',
                    true,
                    'No',
                    'Yes');
                if (action == DialogAction.yes) {
                  setReturn();
                  OrderData.returnOrder = false;
                  final action = await WarningDialogs.openDialog(context,
                      'Information', 'Returned Successfully!', false, 'OK');
                  if (action == DialogAction.yes) {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return Menu();
                    // }));
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/hepemenu', (Route<dynamic> route) => false);
                  }
                } else {
                  // Navigator.pop(context);
                }
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
                  'RETURN ORDER',
                  style: TextStyle(
                      color: Colors.black,
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
  }
}
