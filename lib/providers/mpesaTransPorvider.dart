import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simpmigration/model/mpesaconfirmcallback.dart';

class MpexaProvider extends ChangeNotifier {
  MpesaConfirmResponse data;

  Future getData(context) async {
    final response = await http.get(
        Uri.parse("https://googlesecurev2.herokuapp.com/confirmationmess"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        });
    var myjson = json.decode(response.body);
    this.data = MpesaConfirmResponse.fromJson(myjson);
    notifyListeners();
    return data;
  }
}
