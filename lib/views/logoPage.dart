import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:simpmigration/constants.dart';
import 'package:simpmigration/main.dart';
import 'package:simpmigration/model/locations_model.dart';
import 'package:simpmigration/model/payment_update.dart';
import 'package:simpmigration/widget/fadeIn.dart';

class LogoPage extends StatefulWidget {
  @override
  _LogoPageState createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  Box<dynamic> hiveBox = Hive.box(Constants.HiveBoxName);
  @override
  void initState() {
    super.initState();
    makeShops();
    if (Platform.isAndroid) {
      FirebaseMessaging.onMessage.listen((event) {
        getLatestTrans();
        showCupertinoDialog(
            context: navigationKey.currentContext,
            builder: (context) =>
                AlertDialog(title: Text("ok"), content: Text("Updateo")));
      });
      FirebaseMessaging.instance.getToken().then((String token) {
        hiveBox.get(Constants.RawFCMTokenStore, defaultValue: "all");
      });

      FirebaseMessaging.instance.subscribeToTopic(
          hiveBox.get(Constants.NotificationTopicStore, defaultValue: "."));
      FirebaseMessaging.instance.subscribeToTopic(hiveBox
          .get(Constants.AllUsersNotificationTopic, defaultValue: "all"));
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage message) {});
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        getLatestTrans();
      });
      FirebaseMessaging.onBackgroundMessage((message) {
        return getLatestTrans();
      });
    }
  }

  void autoNavigate(BuildContext context) {
    bool isLoggedIn =
        hiveBox.get(Constants.IsLoggedInStore, defaultValue: false);
    Future.delayed(Duration(seconds: 4), () {
      !isLoggedIn
          ? Navigator.of(context).pushReplacementNamed("/login")
          : Navigator.of(context).pushReplacementNamed("/home");
    });
  }

  @override
  Widget build(BuildContext context) {
    autoNavigate(context);
    return Container(
      color: Colors.black,
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
}
