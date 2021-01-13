import 'dart:convert';
import 'dart:async';
import 'package:clone/model/otpresponse.dart';
import 'package:clone/route_generator.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flushbar/flushbar.dart';
import 'package:clone/widget/intro_video.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:sms_autofill/sms_autofill.dart';

class LoginOTP extends StatefulWidget {
  LoginOTP({Key key}) : super(key: key);
  @override
  _LoginOTPState createState() => _LoginOTPState();
}

class _LoginOTPState extends State<LoginOTP> {
  Widget _myAnimatedWidget;
  String mobile = "";
  bool term = false;
  @override
  void initState() {
    super.initState();
    _myAnimatedWidget = _Logincard();
  }

  @override
  Widget build(BuildContext context) {
    //Cool provider importing
    // final ThreeButtonBloc threeButtonBloc =
    //     Provider.of<ThreeButtonBloc>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Stack(
        children: [
          IntroVideo(),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                onPressed: () {
                  Flushbar(message: "👷‍♂️ Coming Soon...")..show(context);
                  //Navigator.of(context).pushNamed('/url');
                },
              ),
              title: Center(
                child: Row(children: [
                  Spacer(),
                  Text("ICRIB\nAgency",
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white)),
                  Icon(
                    Icons.tag_faces,
                    color: Colors.white,
                    size: 40,
                  ),
                  Spacer()
                ]),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    //Navigator.of(context).pushNamed('/home');
                    print(MediaQuery.of(context).size.height / 210);
                    print(MediaQuery.of(context).size.height / 105);
                    Flushbar(message: "👷‍♂️ Coming Soon...")..show(context);
                    //Navigator.of(context).pushNamed('/home');
                    // final url = 'https://google.com';
                    // if (await canLaunch(url)) {
                    //   await launch(url);
                    // } else {
                    //   throw 'Could not launch $url';
                    // }
                  },
                )
              ],
            ),
            body: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                        height:
                            MediaQuery.of(context).size.height * 0.239115880),
                    AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      child: _myAnimatedWidget,
                    ),
                    Spacer(flex: 2),
                    MultiProvider(providers: [
                      FutureProvider<Position>(
                          create: (context) => geoService.getInitialLocation()),
                    ], child: _ThreeBButtons()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThreeBButtons extends StatelessWidget {
  const _ThreeBButtons({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //double pageHeight = MediaQuery.of(context).size.height;
    return Consumer<Position>(builder: (context, position, child) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(width: 10),
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () async {
                  final url = 'https://i-crib.co.ke/lists';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        bottom: BorderSide(width: 4.5, color: Colors.yellow),
                      ),
                    ),
                    height: 180,
                    child: Column(
                      children: [
                        Hero(
                          tag: "house",
                          child: Image(
                            fit: BoxFit.scaleDown,
                            height: 150,
                            image: AssetImage('assets/images/house_logo.jpeg'),
                          ),
                        ),
                        Text("Listings", style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (position != null) {
                        Navigator.of(context)
                            .pushNamed('/map', arguments: position);
                      } else {
                       
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Turn on location service"),
                          action: SnackBarAction(
                              textColor: Colors.yellow,
                              label: "Turn On",
                              onPressed: () {
                                AppSettings.openLocationSettings();
                                print("Opening Settings");
                              }),
                        ));
                      }
                    },
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      height: MediaQuery.of(context).size.height * 0.20495,
                      color: Colors.transparent,
                      child: LayoutBuilder(builder: (context, constraints) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border(
                                bottom:
                                    BorderSide(width: 4.5, color: Colors.white),
                              ),
                            ),
                            height:
                                MediaQuery.of(context).size.height * 0.102425,
                            width: constraints.maxWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.map,
                                  size: constraints.maxWidth / 2.5,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Service\nMap",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: MediaQuery.of(context).size.height * 0.20495,
                    color: Colors.transparent,
                    child: LayoutBuilder(builder: (context, constraints) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: GestureDetector(
                          onTap: () async {
                            final url = 'https://i-crib.co.ke';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border(
                                bottom:
                                    BorderSide(width: 4.5, color: Colors.white),
                              ),
                            ),
                            height:
                                MediaQuery.of(context).size.height * 0.102425,
                            width: constraints.maxWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.help_outline,
                                  size: constraints.maxWidth / 2.5,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Help\nContacts",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5),
          ],
        ),
      );
    });
  }
}

class _Logincard extends StatelessWidget {
  const _Logincard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            "Welcome To \nIcrib Residence",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
            ),
          ),
        ),
        Spacer(flex: 1),
        MaterialButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.0),
              bottomLeft: Radius.circular(8.0),
            ),
          ),
          padding: const EdgeInsets.all(20.0),
          onPressed: () {
            showMyDialog(context);
            //Navigator.of(context).pushNamed('/otprec');
          },
          color: Colors.yellow,
          child: Row(
            children: [
              Text(
                "LOGIN",
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 13),
              ),
              Icon(
                Icons.lock,
                size: 10,
                color: Colors.black,
              )
            ],
          ),
        )
      ],
    );
  }
}

class PopupForm extends StatefulWidget {
  PopupForm({Key key}) : super(key: key);

  @override
  _PopupFormState createState() => _PopupFormState();
}

class _PopupFormState extends State<PopupForm> {
  TextEditingController _mytextcontroller;
  bool _otploading = false;
  int otpstatus = 0;
  String mobile = "";
  //   String validatePassword(String value) {
  //   print('Value $value');

  //   if (value.startsWith("7")) {
  //     return "Please write number as 07xx";
  //   }
  //   return null;
  // }
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 100),
      child: AlertDialog(
        title: Icon(Icons.phone),
        content: Container(
          height: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please enter the number provided during house registration.',
                textAlign: TextAlign.center,
              ),
              Divider(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(flex: 2),
                  Expanded(
                    flex: 20,
                    child: TextField(
                      controller: _mytextcontroller,
                      showCursor: true,
                      autofocus: true,
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        //errorText: validatePassword(mobile),
                      ),
                      onChanged: (value) {
                        mobile = value;
                        print(mobile);
                      },
                    ),
                  ),
                  Spacer(flex: 1),
                ],
              ),
              SizedBox(height: 30),
              Spacer(),
              Text(
                "By choosing to proceed, you agree to the following terms of service",
                style: const TextStyle(color: Colors.black54, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () async {
                  final url = 'https://i-crib.co.ke/terms';
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Text(
                  "Terms & Conditions",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ),
        actions: <Widget>[
          OutlineButton(
            child: Text('CANCEL'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          _otploading
              ? CircularProgressIndicator(strokeWidth: 1.0)
              : MaterialButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('PROCCED', style: TextStyle(color: Colors.white)),
                  //getOTP()
                  onPressed: () async {
                    final appsignature = await SmsAutoFill().getAppSignature;
                    if (mobile.length > 9) {
                      setState(() {
                        _otploading = true;
                      });
                      otpstatus = await getOTP(mobile, appsignature, context);
                      if (otpstatus == 0) {
                        setState(() {
                          _otploading = true;
                        });
                      }
                    } else {
                      print("Lenght");
                    }
                  },
                ),
        ],
      ),
    );
  }
}

Future<void> showMyDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return PopupForm();
    },
  );
}

Future getOTP(mobile, appsign, context) async {
  OtpResponse data;
  print('Phone $mobile');
  if (mobile != null) {
    try {
      final response = await http.post(
        ("http://192.168.0.13:9003/" + "getotp"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: jsonEncode(
          {
            'phonenumber': mobile,
            'appsignature': appsign,
          },
        ),
      );
      var myjson = json.decode(response.body);
      data = OtpResponse.fromJson(myjson);
      print(data.messageCode);

      Navigator.of(context).pushNamed('/otprec', arguments: mobile);
    } catch (SocketException) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("No Network connection."),
                actions: [
                  MaterialButton(
                      color: Colors.black,
                      onPressed: () {
                        AppSettings.openWIFISettings();
                      },
                      child: Text("Turn on",
                          style: TextStyle(color: Colors.white)))
                ],
              ));
    }
  } else {
    print('Please add number');
  }
  return 0;
}
