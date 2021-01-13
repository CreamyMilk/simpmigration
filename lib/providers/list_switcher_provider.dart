import 'package:flutter/foundation.dart';

class ListSwitcherProvider extends ChangeNotifier {
  double value = 0.0;
  bool showTrans = true;

  void switchList() {
    showTrans = !showTrans;
    notifyListeners();
  }

  void switchElec() {
    showTrans = false;
    notifyListeners();
  }

  void switchRents() {
    showTrans = true;
    notifyListeners();
  }
}
