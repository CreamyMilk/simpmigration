import 'dart:convert';
import 'dart:io';
import 'package:clone/enums/connectivity_status.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyMessageHandler extends StatefulWidget {
  @override
  _MyMessageHandlerState createState() => _MyMessageHandlerState();
}
class _MyMessageHandlerState extends State<MyMessageHandler> {
  String userToken;
  double op;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  @override
  void initState() {
    super.initState();

    FirebaseCrashlytics.instance.setUserIdentifier("JOTHAM CRASHES");
    //_initalHive();
    //v2 register ios push notification service
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(
        IosNotificationSettings(),
      );
    } else {
      _saveDeviceToken();
    }
    op = 0.0;
    //Subscribe to topic frontEND
    _fcm.subscribeToTopic("tenant"); 
    //Unsubscribe to topic
    //_fcm.unsubscribeFromTopic("Teneant");
    _fcm.configure(
      //Use for popups and ticks
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage :$message");
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
              content: Text("Your Transaction was Succesful")),
        );
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
      color: _getStartUpColor(context),
      child: Center(
        child: Hero(
          tag: 'house',
          child: AnimatedOpacity(
            duration: Duration(seconds: 10),
            opacity: op,
            child: Image(
              fit: BoxFit.scaleDown,
              image: AssetImage('assets/images/house_logo.jpeg'),
            ),
          ),
        ),
      ),
    );
  }

  //Get token, save it to the datbase for current user
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
      setState(() {
        op = 1;
      });
      _sendTokenHTTP(data);
    }
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
_cacheUserDetails(jsonString){
  final userHiveBox = Hive.box('user');
  if(jsonString =="no"){
    print("THE IS NO STORED DATA");
  }else{
    userHiveBox.put("transaction",jsonString);
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
  _cacheUserDetails(userTrans);
  print("UserToken ilikuwa $userToken");
  Future.delayed(Duration(seconds: 1), () {
    userToken == "0"
        ? Navigator.of(context).pushNamed('/home')
        : Navigator.of(context).pushNamed('/login');
  });
}

_getStartUpColor(context) {
  var connectionStatus = Provider.of<ConnectivityStatus>(context);
  switch (connectionStatus) {
    case ConnectivityStatus.Cellular:
      return Color(0x000E1F);
    case ConnectivityStatus.WiFi:
      return Color(0x000E1F);
    case ConnectivityStatus.Offline:
      return Color(0x000E1F);
    default:
      return Color(0x000E1F);
  }
}
