import 'package:flutter/material.dart';

class ThreeButtonBloc extends ChangeNotifier {
  bool _isLoginPopupOpen = true;

  bool get isLoginPopupOpen => _isLoginPopupOpen;

  set isLoginPopupOpen(bool val) {
    _isLoginPopupOpen = val;
    notifyListeners();
  }
}
