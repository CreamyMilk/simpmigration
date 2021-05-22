import 'dart:convert';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:simpmigration/constants.dart';
import 'package:simpmigration/model/loginotpmodel.dart';
import 'package:simpmigration/widget/timerFab.dart';
import 'package:hive/hive.dart';

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
    Uri.parse("http://92.222.201.138:9003/verifyotp"),
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
  switch (data.message) {
    case 0:
      _cacheUserDetails(data.info.toJson());
      Navigator.of(context).pushNamed('/home');
      break;
    case 34:
      print("Show snackbar that the otp supplied is invalid");
      break;
    default:
      Navigator.of(context).pushNamed('/home');
      break;
  }
}

_cacheUserDetails(apidata) {
  Box<dynamic> userHiveBox = Hive.box(Constants.HiveBoxName);
  print("AAPI$apidata");
  var newtrans = apidata["transaction"];
  var newtokens = apidata["token"];

  userHiveBox.put(Constants.TransactionStore, jsonEncode(newtrans));
  userHiveBox.put(Constants.PowerTokensStore, jsonEncode(newtokens));
  userHiveBox.put(Constants.UserNameStore, apidata["username"]);
  userHiveBox.put(Constants.PhoneNumberStore, apidata["mobile"]);
  userHiveBox.put(Constants.RentPayableStore, apidata["rent"]);
  userHiveBox.put(Constants.UserIDStore, apidata["uid"]);
  userHiveBox.put(Constants.BranchIDStore, "8"); //👀 When we have more branches
  userHiveBox.put(Constants.ReportedIssuesStore, apidata["lastIssue"]);
  print("Inserting login info");
}
