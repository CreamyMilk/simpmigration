import 'dart:convert';

import 'package:clone/widget/timerFab.dart';
import 'package:flutter/material.dart';
import 'package:clone/model/otpconfirmmodel.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;

class OtpReceiver extends StatefulWidget {
  final phonenumber;
  OtpReceiver({
    Key key,
    @required this.phonenumber,
  }) : super(key: key);

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
      floatingActionButton: TimerFab(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Please wait for activation code sent to your \nphone number",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "${widget.phonenumber}",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.blue),
          ),
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
                  confirmOTP(widget.phonenumber, val, context);
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
    ("https://googlesecureotp.herokuapp.com/" + "verify"),
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
