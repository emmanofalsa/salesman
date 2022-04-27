import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';

// class ReturnReason extends StatelessWidget {
//   final txtController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         iconTheme: IconThemeData(
//           color: Colors.black, //change your color here
//         ),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Text(
//                 'Return reason',
//                 style: TextStyle(fontSize: 14, color: ColorsTheme.mainColor),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Text(
//                 'DONE',
//                 style: TextStyle(fontSize: 12, color: ColorsTheme.mainColor),
//               ),
//             )
//           ],
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Expanded(
//             child: Container(
//               color: Colors.white,
//               width: MediaQuery.of(context).size.width,
//               padding: EdgeInsets.all(15),
//               child: Expanded(
//                 child: TextField(
//                   maxLines: 10,
//                   // controller: txtController,
//                   controller: txtController,
//                   inputFormatters: [
//                     // new WhitelistingTextInputFormatter(
//                     //     RegExp("[a-zA-Z ]")),
//                     FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
//                   ],
//                   onChanged: (String str) {
//                     OrderData.returnReason = str.toUpperCase();
//                   },
//                   decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'Type your reasons ...',
//                       hintStyle: TextStyle(
//                           color: Colors.black, backgroundColor: Colors.white)),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class ReturnReason extends StatefulWidget {
  @override
  _ReturnReasonState createState() => _ReturnReasonState();
}

class _ReturnReasonState extends State<ReturnReason> {
  final txtController = TextEditingController();
  void initState() {
    super.initState();
    txtController.text = OrderData.returnReason;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Return reason',
                style: TextStyle(fontSize: 14, color: ColorsTheme.mainColor),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                'DONE',
                style: TextStyle(fontSize: 12, color: ColorsTheme.mainColor),
              ),
            )
          ],
        ),
      ),
      // backgroundColor: Colors.blue,
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15),
              child: TextField(
                maxLines: 10,
                controller: txtController,
                inputFormatters: [
                  // new WhitelistingTextInputFormatter(
                  //     RegExp("[a-zA-Z ]")),
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                ],
                onChanged: (String str) {
                  OrderData.returnReason = str.toUpperCase();
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type your reasons ...',
                    hintStyle: TextStyle(
                        color: Colors.grey[500],
                        backgroundColor: Colors.white)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
