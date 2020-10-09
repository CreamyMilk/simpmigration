import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'home_cards_layouts.dart';
import 'login_otp.dart';

class StartUpView extends StatefulWidget {
  @override
  _StartUpViewState createState() => _StartUpViewState();
}

class _StartUpViewState extends State<StartUpView> {
  String userToken;

  @override
  void initState() async {
    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('user_token') ?? "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return userToken == "" ? LoginOTP() : HomeViewCardLayout();
  }
}
