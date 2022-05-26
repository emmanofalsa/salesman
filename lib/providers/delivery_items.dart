import 'package:flutter/material.dart';

class DeliveryCounter with ChangeNotifier {
  int _itmNo = 0;

  int get itmNo => _itmNo;

  void setTotal(int no) {
    _itmNo = no;
    notifyListeners();
  }
}
