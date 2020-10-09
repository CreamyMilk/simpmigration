import 'dart:convert';

import 'package:clone/model/otpresponse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtpProvider extends ChangeNotifier {
  OtpResponse apidata;

  Future getOTP(context) async {
    final response = await http.post(
      ("http://googlesecureotp.herokuapp.com/" + "otp"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode(
        {
          'phonenumber': '2540000',
          'appsignature': 'bEcXXteUfQi',
        },
      ),
    );
    var myjson = json.decode(response.body);
    this.apidata = OtpResponse.fromJson(myjson);
    notifyListeners();
    return apidata;
  }
}
