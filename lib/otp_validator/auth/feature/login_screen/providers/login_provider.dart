import 'package:flutter/cupertino.dart';

class LoginProvider extends ChangeNotifier {

  bool _isGetOtpVuttonDisabled = true;
  bool get isGetOtpVuttonDisabled => _isGetOtpVuttonDisabled;

  bool _isRadioButtonEnabled = false;
  bool get isRadioButtonEnabled => _isRadioButtonEnabled;

  void updateGetOtpButton(bool value) {
    _isGetOtpVuttonDisabled = value;
    notifyListeners();
  }

  void updateRadioButton(bool value) {
    _isRadioButtonEnabled = !value;
    notifyListeners();
  }
}