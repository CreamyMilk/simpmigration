import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:clone/model/otpconfirmmodel.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

class OtpReceiver extends StatefulWidget {
  OtpReceiver({Key key}) : super(key: key);

  @override
  _OtpReceiverState createState() => _OtpReceiverState();
}

class _OtpReceiverState extends State<OtpReceiver> {
  @override
  void initState() {
    super.initState();
    _listenforOTP();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.ac_unit),
        onPressed: () {},
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Enter Received Pin Here"),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 50,
              vertical: 10,
            ),
            child: PinFieldAutoFill(
              autofocus: false,
              codeLength: 4,
              onCodeChanged: (val) {
                print(val);
                if (val.length == 4) {
                  confirmOTP("254599", val, context);
                  //Navigator.of(context).pop();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  void _listenforOTP() async {
    await SmsAutoFill().listenForCode;
  }
}

Future confirmOTP(mobile, code, context) async {
  OtpVerify data;
  final response = await http.post(
    ("http://googlesecureotp.herokuapp.com/" + "verify"),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    },
    body: jsonEncode(
      {
        'phonenumber': mobile,
        'code': code,
      },
    ),
  );
  var myjson = json.decode(response.body);
  data = OtpVerify.fromJson(myjson);
  print(data.message);
  if (data.message == 0) {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user_token", data.message.toString()).then((bool success) {
      if (success) {
        Navigator.of(context).pushNamed('/home');
      } else {
        //Show that storage
      }
    });
  } else {
    Navigator.of(context).pushNamed('/home');
  }

  //Navigator.of(context).pop();
}
