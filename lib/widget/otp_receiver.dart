import 'dart:convert';

import 'package:clone/model/loginotpmodel.dart';
import 'package:clone/widget/timerFab.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_consent/sms_consent.dart';
import 'package:hive/hive.dart';

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
  String _receivedCode = '';
  @override
  void initState() {
    super.initState();
    initSMSState();
  }

  Future<void> initSMSState() async {
    String receivedCode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      String temp = await SmsConsent.startSMSConsent();
      receivedCode = temp.substring(0, 4);
    } on PlatformException {
      receivedCode = '';
    }
    if (!mounted) return;
    setState(() => _receivedCode = receivedCode);
  }

  @override
  void dispose() {
    SmsConsent.stopSMSConsent();
    super.dispose();
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
              currentCode: _receivedCode,
              autofocus: false,
              codeLength: 4,
              onCodeChanged: (val) {
                print(val);
                if (val.length == 4) {
                  Flushbar(message: "🔐 Verifying OTP...")..show(context);
                  print("doing some naviagion here $val");
                  confirmOTP(widget.phonenumber, val, context);
                  //Navigator.of(context).pop();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  // void _listenforOTP() async {
  //   await SmsAutoFill().listenForCode;
  // }
}

Future confirmOTP(mobile, code, context) async {
  Otploginresponse data;
  final response = await http.post(
    ("http://92.222.201.138:9003/" + "verifyotp"),
    headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    },
    body: jsonEncode(
      {
        'phonenumber': mobile,
        'otp': code,
      },
    ),
  );
  var myjson = json.decode(response.body);
  //print(myjson);
  data = Otploginresponse.fromJson(myjson);
  //print(data.info);
  if (data.message == 0) {
    _cacheUserDetails(data.info.toJson());
    final prefs = await SharedPreferences.getInstance();
    var tempStore = data.info.transaction.toJson();
    var tokenStore = data.info.token.toJson();
    //print("JSON --<>I--NG ${jsonEncode(tempStore)}");
    //   List<Map<String,dynamic>> newtrans=tempStore.toList();
    //     Map<String, dynamic> transactions = {
    //   'title': "Transactions",
    //   'data': newtrans,
    // };
    prefs.setString("user_transactions", jsonEncode(tempStore));
    prefs.setString("tokens_string", jsonEncode(tokenStore));
    prefs.setString("user_token", data.message.toString()).then((bool success) {
      if (success) {
        Navigator.of(context).pushNamed('/home');
      } else {
        //Show that storage
      }
    });
  } else if (data.message == 34) {
    print("Show snackbar that the otp supplied is invalid");
  } else {
    Navigator.of(context).pushNamed('/home');
  }
}

_cacheUserDetails(apidata) {
  final userHiveBox = Hive.box('user');
  print("AAPI$apidata");
  var newtrans = apidata["transaction"];
  var newtokens = apidata["token"];
  // Map<String, dynamic> transactions = {
  //   'title': "Transactions",
  //   'data': newtrans,
  // };

  userHiveBox.put("transaction", jsonEncode(newtrans));
  userHiveBox.put("tokens", jsonEncode(newtokens));
  //con.data=transactions;
  //Map<String, dynamic> complains = {
  //'title': "Expenses",
  //'data': ["Water", "Painting", "Gas"]
  //};
  //Map<String,dynamic> rent = {"month":'January',"rentDue":77,"rentStatus":false};
  //Map<String,dynamic> data = {'username':"LOGGEDIN",'uid': '34','mobile':'0797678252','transaction':transactions,'lastIssue':'number AND ARRAY','lastService':'number and'};

  //trBox.put("transaction",transactions);
  userHiveBox.put("username", apidata["username"]);
  userHiveBox.put("mobile", apidata["mobile"]);
  userHiveBox.put("rent", apidata["rent"]);
  userHiveBox.put("uid", apidata["uid"]);
  //new
  userHiveBox.put("lastIssue", apidata["lastIssue"]);
  //userHiveBox.putAll(apidata);
  print("Inserting login info");
}
