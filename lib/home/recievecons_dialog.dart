import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/home/signature.dart';
import 'package:salesman/home/view_signature.dart';
import 'package:salesman/menu.dart';
import 'package:salesman/variables/colors.dart';
import 'package:salesman/widgets/dialogs.dart';
import 'package:salesman/widgets/snackbar.dart';

import '../userdata.dart';

class ReceivedConsolidatedDialog extends StatelessWidget {
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
    OrderData.pmtype = 'Cash on Delivery';
    setStatus() {
      if (CustomerData.discounted == true) {
        CustomerData.tranNoList.forEach((element) {
          if (element['disc_total'] == '0.00') {
            var result = db.getStatus(
                element['tran_no'],
                changeStat,
                element['total'],
                OrderData.itmno,
                date,
                OrderData.pmtype,
                OrderData.signature);
            print(result);
          } else {
            var result = db.getStatus(
                element['tran_no'],
                changeStat,
                element['disc_total'],
                OrderData.itmno,
                date,
                OrderData.pmtype,
                OrderData.signature);
            print(result);
          }

          ChequeData.status = "Pending";
          if (OrderData.pmtype == "CHEQUE") {
            db.addCheque(
                element['tran_no'],
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
                element['disc_total'],
                ChequeData.status,
                ChequeData.imgName);
          }
        });
      } else {
        CustomerData.tranNoList.forEach((element) {
          var result = db.getStatus(
              element['tran_no'],
              changeStat,
              element['total'],
              OrderData.itmno,
              date,
              OrderData.pmtype,
              OrderData.signature);
          print(result);
          ChequeData.status = "Pending";
          if (OrderData.pmtype == "CHEQUE") {
            db.addCheque(
                element['tran_no'],
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
                element['total'],
                ChequeData.status,
                ChequeData.imgName);
          }
        });
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
                  GlobalVariables.processedPressed = true;
                  GlobalVariables.menuKey = 0;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return Menu();
                  }));
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
  }
}
