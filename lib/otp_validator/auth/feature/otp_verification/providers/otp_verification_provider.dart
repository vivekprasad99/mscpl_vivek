import 'dart:async';

import 'package:flutter/material.dart';

class OtpVerificationProvider extends ChangeNotifier {


  String _timerText = '02:50';
  String getRemainingTime() => _timerText;



  updateRemainingTime(int timerMaxSeconds,int currentSeconds) {
    String timerText =
        '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}:${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';
    _timerText = timerText;
    notifyListeners();
  }
}