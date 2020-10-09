import 'dart:convert';

import 'package:clone/model/mpesaconfirmcallback.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MpexaProvider extends ChangeNotifier {
  MpesaConfirmResponse data;

  Future getData(context) async {
    final response = await http.get(
        ("https://googlesecurev2.herokuapp.com/" + "confirmationmess"),
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
