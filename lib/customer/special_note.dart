import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';

class SpecialNote extends StatefulWidget {
  @override
  _SpecialNoteState createState() => _SpecialNoteState();
}

class _SpecialNoteState extends State<SpecialNote> {
  final txtController = TextEditingController();
  void initState() {
    super.initState();
    txtController.text = OrderData.specialInstruction!;
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
                'Add a note',
                style: TextStyle(fontSize: 14, color: ColorsTheme.mainColor),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (OrderData.specialInstruction.toString().isEmpty ||
                    OrderData.specialInstruction == '') {
                  setState(() {
                    OrderData.note = false;
                  });
                } else {
                  setState(() {
                    print('TRUE');
                    OrderData.note = true;
                  });
                }
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: TextField(
                  maxLines: 10,
                  controller: txtController,
                  inputFormatters: [
                    // new WhitelistingTextInputFormatter(
                    //     RegExp("[a-zA-Z ]")),
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                  ],
                  onChanged: (String str) {
                    OrderData.specialInstruction = str.toUpperCase();
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Type your special instructions ...',
                      hintStyle: TextStyle(color: Colors.grey[500])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
