import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salesman/db/db_helper.dart';
import 'package:salesman/session/session_timer.dart';
import 'package:salesman/userdata.dart';
import 'package:salesman/variables/colors.dart';

class SalesmanBooked extends StatefulWidget {
  const SalesmanBooked({Key? key}) : super(key: key);

  @override
  State<SalesmanBooked> createState() => _SalesmanBookedState();
}

class _SalesmanBookedState extends State<SalesmanBooked> {
  String todayBooked = '0.00';
  String weeklyBooked = '0.00';
  String monthlyBooked = '0.00';
  String yearlyBooked = '0.00';
  String tbNo = '0';
  String wbNo = '0';
  String mbNo = '0';
  String ybNo = '0';

  String weekStart = "";
  String weekEnd = "";

  String startDate = "";
  String endDate = "";

  DateTime sDate = DateTime.now();
  DateTime eDate = DateTime.now();

  List _temp = [];

  final db = DatabaseHelper();

  final String today =
      DateFormat("EEEE, MMM-dd-yyyy").format(new DateTime.now());
  final date =
      DateTime.parse(DateFormat("yyyy-mm-dd").format(new DateTime.now()));

  final String month = DateFormat("MMMM yyyy").format(new DateTime.now());
  final String year = DateFormat("yyyy").format(new DateTime.now());

  final formatCurrencyAmt =
      new NumberFormat.currency(locale: "en_US", symbol: "P");
  final formatCurrencyTot =
      new NumberFormat.currency(locale: "en_US", symbol: "Php ");

  void initState() {
    super.initState();
    viewBooked();
    // getWeek();
    getDataRange();
    print(UserData.id);
  }

  viewBooked() async {
    getTodayBooked();
    getWeeklyBooked();
    getMonthlyBooked();
    getYearlyBooked();
  }

  getDataRange() async {
    var rsp = await db.getAllTran();
    _temp = rsp;
    print(_temp[0]['date_req'].toString());
    print(_temp.last['date_req'].toString());
    sDate = DateTime.parse(_temp[0]['date_req'].toString());
    eDate = DateTime.parse(_temp.last['date_req'].toString());
    setState(() {
      startDate = DateFormat("MMM. dd, yyyy").format(sDate);
      endDate = DateFormat("MMM. dd, yyyy").format(eDate);
    });
    print(startDate);
    print(endDate);
  }

  getTodayBooked() async {
    todayBooked = '0.00';
    List _tlist = [];
    var rsp = await db.getTodayBooked(UserData.id.toString());
    _tlist = rsp;
    _tlist.forEach((element) {
      setState(() {
        todayBooked =
            (double.parse(todayBooked) + double.parse(element['tot_amt']))
                .toString();
        tbNo = _tlist.length.toString();
      });
    });
  }

  getWeeklyBooked() async {
    DateTime dateTime = DateTime.now();
    DateTime d1 = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    DateTime d2 =
        dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
    weekStart = DateFormat("MMM dd ").format(d1);
    weekEnd = DateFormat("MMM dd yyyy ").format(d2);

    weeklyBooked = '0.00';
    List _wlist = [];
    var rsp = await db.getWeeklyBooked(UserData.id.toString(), d1, d2);
    _wlist = rsp;
    _wlist.forEach((element) {
      setState(() {
        weeklyBooked =
            (double.parse(weeklyBooked) + double.parse(element['tot_amt']))
                .toString();
        wbNo = _wlist.length.toString();
      });
    });
  }

  getMonthlyBooked() async {
    monthlyBooked = '0.00';
    List _mlist = [];
    var rsp = await db.getMonthlyBooked(UserData.id.toString());
    _mlist = rsp;
    _mlist.forEach((element) {
      setState(() {
        monthlyBooked =
            (double.parse(monthlyBooked) + double.parse(element['tot_amt']))
                .toString();
        mbNo = _mlist.length.toString();
      });
    });
  }

  getYearlyBooked() async {
    yearlyBooked = '0.00';
    List _ylist = [];
    var rsp = await db.getYearlyBooked(UserData.id.toString());
    _ylist = rsp;
    _ylist.forEach((element) {
      setState(() {
        yearlyBooked =
            (double.parse(yearlyBooked) + double.parse(element['tot_amt']))
                .toString();
        ybNo = _ylist.length.toString();
      });
    });
  }

  void handleUserInteraction([_]) {
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
        appBar: AppBar(
          toolbarHeight: 75,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Booked",
                textAlign: TextAlign.right,
                style: TextStyle(
                    color: ColorsTheme.mainColor,
                    fontSize: 45,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(child: headerCont()),
              ],
            ),
            Row(
              children: [
                Expanded(child: todayCont()),
              ],
            ),
            Row(
              children: [
                Expanded(child: weekCont()),
              ],
            ),
            Row(
              children: [
                Expanded(child: monthCont()),
              ],
            ),
            Row(
              children: [
                Expanded(child: yearCont()),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Note:',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data shown above is base on the date stated in header.',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 12),
                      ),
                      Text(
                        'If you want to load the accurate data. Kindly perform a full sync.',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container headerCont() => Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 50,
        // width: MediaQuery.of(context).size.width / 2 - 30,
        decoration: BoxDecoration(
            color: Colors.grey[300],
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(0)),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'Booked Summary for ' +
                          UserData.id.toString() +
                          '(' +
                          UserData.lastname.toString() +
                          ', ' +
                          UserData.firstname.toString() +
                          ')',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    SizedBox(width: 10),
                    Text(
                      'As of ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      startDate,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      ' to ',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      endDate,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '.',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );

  Container todayCont() => Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 100,
        // width: MediaQuery.of(context).size.width / 2 - 30,
        decoration: BoxDecoration(
            color: Colors.blue[300],
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Today',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 36,
                            ),
                          ),
                        ),
                        Text(
                          formatCurrencyAmt
                              .format(double.parse(todayBooked.toString()))
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          today,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      tbNo + ' Order(s)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      );

  Container weekCont() => Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 100,
        // width: MediaQuery.of(context).size.width / 2 - 30,
        decoration: BoxDecoration(
            color: Colors.orange[300],
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Week',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 36,
                            ),
                          ),
                        ),
                        Text(
                          formatCurrencyAmt
                              .format(double.parse(weeklyBooked.toString()))
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          weekStart + " - " + weekEnd,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      wbNo + ' Order(s)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      );

  Container monthCont() => Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 100,
        // width: MediaQuery.of(context).size.width / 2 - 30,
        decoration: BoxDecoration(
            color: Colors.green[300],
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Month',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 36,
                            ),
                          ),
                        ),
                        Text(
                          formatCurrencyAmt
                              .format(double.parse(monthlyBooked.toString()))
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          month,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      mbNo + ' Order(s)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      );

  Container yearCont() => Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 100,
        // width: MediaQuery.of(context).size.width / 2 - 30,
        decoration: BoxDecoration(
            color: Colors.purple[300],
            border: Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5, right: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Year',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 36,
                            ),
                          ),
                        ),
                        Text(
                          formatCurrencyAmt
                              .format(double.parse(yearlyBooked.toString()))
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          year,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      ybNo + ' Order(s)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      );
}
