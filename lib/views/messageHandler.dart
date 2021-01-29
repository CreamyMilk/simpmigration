import 'dart:convert';
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:clone/model/cofee_model.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:clone/model/payment_update.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMessageHandler extends StatefulWidget {
  @override
  _MyMessageHandlerState createState() => _MyMessageHandlerState();
}

class _MyMessageHandlerState extends State<MyMessageHandler> {
  String userToken;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState() {
    super.initState();
    makeShops();
    //v2 reg.ister ios push notification service
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(),
      );
    } else {
      //_saveDeviceToken();
    }
    //Subscribe to topic frontEND
    _fcm.subscribeToTopic("tenant");
    //Unsubscribe to topic
    //_fcm.unsubscribeFromTopic("Teneant");
    _fcm.configure(
      //Use for popups and ticks
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage :$message");
        var ms = message["data"];
        var type = ms["type"];
        var desc = ms["desc"];
        if (type == "0") {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: AspectRatio(
                  aspectRatio: 1.5,
                  child: FlareActor(
                    'assets/tick.flr',
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                    animation: 'go',
                  ),
                ),
                content: Text("$desc", textAlign: TextAlign.center)),
          );
          getLatestTrans();
        } else {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: AspectRatio(
                aspectRatio: 1.5,
                child: FlareActor(
                  'assets/fail.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: 'Failure',
                ),
              ),
              content: Text("$desc", textAlign: TextAlign.center),
            ),
          );
          getLatestTrans();
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onMessage :$message");
      },
      //App closed and you press notification
      onLaunch: (Map<String, dynamic> message) async {
        print("onMessage :$message");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _getStartUpPage(context);
    return Container(
      // color: _getStartUpColor(context),
      color: Color(0x000E1F),
      child: Center(
        child: Hero(
            tag: 'house',
            child: FadeIn(
              child: Image(
                fit: BoxFit.scaleDown,
                image: AssetImage('assets/images/house_logo.jpeg'),
              ),
              duration: Duration(seconds: 3),
              curve: Curves.easeIn,
            )),
      ),
    );
  }

  // ignore: unused_element
  _saveDeviceToken() async {
    // Get the current user
    String uid = 'Patrick254';
    String fcmToken = await _fcm.getToken();

    //Send to backend
    if (fcmToken != null) {
      final data = {
        'uid': uid,
        'token': fcmToken,
        'platform': Platform.operatingSystem
      };
      //http.post
      print(data);

      _sendTokenHTTP(data);
    }
  }

  Future updateRent() async {
    PaymentUpdateModel data;
    final prefs = await SharedPreferences.getInstance();
    final userHiveBox = Hive.box('user');
    var userID = userHiveBox.get("uid", defaultValue: "no");
    final response = await http.post(
      ("http://92.222.201.138:9003/" + "getnewtrans"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode(
        {
          'uid': userID, //mobile,
        },
      ),
    );
    var myjson = json.decode(response.body);
    data = PaymentUpdateModel.fromJson(myjson);
    var transactions = data.transaction.toJson();
    var powertoken = data.token.toJson();
    var rent = data.rent.toJson();
    userHiveBox.put("rent", jsonEncode(rent));
    userHiveBox.put("transaction", jsonEncode(transactions));
    prefs.setString("user_transactions", jsonEncode(transactions));
    prefs.setString("tokens_string", jsonEncode(powertoken));
    print("Transactions Added by a push notification");
  }

  _sendTokenHTTP(final data) async {
    return http.post(
      "https://googlesecureotp.herokuapp.com/fmctoken",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
  }
}

_cacheUserDetails(jsonString, jsonStringToken) {
  final userHiveBox = Hive.box('user');
  if (jsonString == "no") {
    print("THEIR IS NO DATA TO STORED DATA");
  } else {
    userHiveBox.put("transaction", jsonString);
  }

  if (jsonStringToken == "no") {
    print("THEIR IS NO TOKENS TO STORED DATA");
  } else {
    userHiveBox.put("tokens", jsonStringToken);
  }
  //dd Map<String, dynamic> transactions = {
  //  "title": "Transactions",
  // "data": [{"month":"Febuary","time":"99/99/99","rec":{"username":"New Trans","branch":"SomeWhere Sukari,Kenya","house":"B22","receiptNumber":"WC2340923409","description":"Mpesa Express 9.30am by 254797678353","amount":10020}}],
  //};
  //   Map<String, dynamic> complains = {
  //   'title': "Expenses",
  //   'data': ["Water", "Painting", "Gas"]
  // };
  //Map<String,dynamic> data = {'transaction':transactions};
  // final jstring =jsonEncode(data);
  // print(jstring);
  //userHiveBox.put('trs',transactions);
}

_getStartUpPage(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final userToken = prefs.getString('user_token') ?? "";
  final userTrans = prefs.getString('user_transactions') ?? "no";
  final userTokens = prefs.getString('tokens_string') ?? "no";
  _cacheUserDetails(userTrans, userTokens);
  print("UserToken ilikuwa $userToken");
  Future.delayed(Duration(seconds: 3), () {
    userToken == "0"
        ? Navigator.of(context).pushNamed('/home')
        : Navigator.of(context).pushNamed('/login');
  });
}

// _getStartUpColor(context) {
//   var connectionStatus = Provider.of<ConnectivityStatus>(context);
//   switch (connectionStatus) {
//     case ConnectivityStatus.Cellular:
//       return Color(0x000E1F);
//     case ConnectivityStatus.WiFi:
//       return Color(0x000E1F);
//     case ConnectivityStatus.Offline:
//       return Color(0x000E1F);
//     default:
//       return Color(0x000E1F);
// }
//}
