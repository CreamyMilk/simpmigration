import 'dart:convert';
import 'package:clone/model/paymentResponse.dart';
import 'package:clone/providers/list_switcher_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:provider/provider.dart';

class KplcCard extends StatefulWidget {
  KplcCard({Key key}) : super(key: key);

  @override
  _KplcCardState createState() => _KplcCardState();
}

class _KplcCardState extends State<KplcCard> {
  Box<dynamic> userHiveBox;
  Map<String, dynamic> defrent = {
    "month": "October",
    "time": "00/00/00",
    "rentDue": 1578,
    "rentStatus": false
  };
  //Map<String,dynamic> rent;

  bool _testvar = true;

  List<String> option = ["Latest Receipt", "All Tokens"];

  @override
  void initState() {
    super.initState();
    userHiveBox = Hive.box('user');

    print("DTAT");
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('user').listenable(),
      builder: (context, box, widget) {
        // String _visualAmount = _rentDue.toString().replaceAllMapped(
        //     new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        //     (Match m) => '${m[1]},');
        return Container(
          padding: EdgeInsets.all(8.0),
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    " ",
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  Container(child: Text("🔩 KPLC")),
                  Consumer<ListSwitcherProvider>(
                    builder: (context, storeP, child) {
                      return PopupMenuButton(
                        onSelected: (String choice) {
                          print(choice);
                          if (choice == "All Tokens") {
                            storeP.switchElec();
                          } else {
                            Navigator.of(context)
                                .pushNamed("/tokens", arguments: 0);
                          }
                        },
                        icon: Icon(Icons.more_horiz),
                        itemBuilder: (BuildContext context) {
                          return option.map((String choice) {
                            return PopupMenuItem(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      );
                    },
                  ),
                ],
              ),
              Text(
                "Get Tokens",
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 25.0,
                ),
              ),
              Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(
                  children: [
                    Consumer<ListSwitcherProvider>(
                        builder: (context, storeP, child) {
                      return MaterialButton(
                          color: Colors.white,
                          onPressed: () {
                            storeP.switchElec();
                          },
                          child: Text(
                            "Past Tokens",
                            style: TextStyle(color: Colors.black),
                          ));
                    })
                  ],
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 100),
                  color: Colors.transparent,
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(5.0),
                  child: Consumer<ListSwitcherProvider>(
                      builder: (context, storeP, children) {
                    return MaterialButton(
                      color: _testvar
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      child: Row(
                        children: [
                          Text("Buy Now",
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      onPressed: () {
                        storeP.switchElec();
                        kplcModalBottomSheet(context, "10");
                        print("STK push sent");
                      },
                    );
                  }),
                )
              ])
            ],
          ),
        );
      },
    );
  }
}

void kplcModalBottomSheet(context, amountDue) {
  showModalBottomSheet(
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
    ),
    context: context,
    builder: (BuildContext context) {
      return PaymentBottomSheet();
    },
  );
}

Future _sendPayment(mobile, amountDue, accName, ctx) async {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  //v2 work with paymentapi responses
  PaymentResponse data;
  Flushbar(
    backgroundColor: Colors.grey[350],
    title: " Processing Payment 👷...",
    message: " 📲 No:$mobile  🔩 Amount:Ksh.$amountDue",
    icon: Icon(Icons.bolt, size: 35, color: Colors.yellow),
    leftBarIndicatorColor: Colors.yellowAccent,
    duration: Duration(seconds: 20),
    forwardAnimationCurve: Curves.easeInOutBack,
  )..show(ctx);
  try {
    String fcmToken = await _fcm.getToken();
    final response = await http.post(
      ("https://googlesecureotp.herokuapp.com/" + "payment"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode(
        //ensure that the user has bothe the socketID and the USER ID
        {
          "phonenumber": mobile,
          "amount": amountDue,
          "userID": accName ?? "Error",
          "socketID": "mee",
          "notifToken": fcmToken
        },
      ),
    );
    print("$accName");
    var myjson = json.decode(response.body);
    print(fcmToken);
    data = PaymentResponse.fromJson(myjson);
    print(data.paymentCode);
    print(data.description);
  } catch (SocketException) {
    print("msEE HAUNA WIFI");
    showDialog(
      //Text(message['notification']['title']
      context: ctx,
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("It seems that you are offline"),
            ],
          )),
    );
  }
}

String convertTo07(String f) {
  String no;
  String pl;
  String t5;
  no = f.replaceAll(new RegExp(r"\s+"), "");
  pl = no.replaceAll(new RegExp(r"\+"), "");
  t5 = pl.replaceAll(new RegExp(r"2547"), "07");
  return t5;
}

void choiceAction(String choice) {
  print(choice);
  Navigator.of(null).pushNamed('/randomUser');
}

String validateAmount(String value) {
  if (!(value.length > 4) && value.isNotEmpty) {
    if (value[0] != "0") {
      return "Allow purchases up to Ksh 9,999";
    }
    return null;
  }
  return null;
}

String validatePassword(String value) {
  if (!(value.length > 9) && value.isNotEmpty) {
    if (value[0] != "0") {
      return "Mobile number should be in the format 07xx";
    }
    return null;
  }
  return null;
}

class PaymentBottomSheet extends StatefulWidget {
  @override
  _PaymentBottomSheetState createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  Box<dynamic> userHiveBox;
  final TextEditingController _phoneficontroller = TextEditingController();
  final TextEditingController _amountficontroller = TextEditingController();
  String mobile;
  String amountDue = "10";
  String visualAmount;
  String accountName;
  @override
  void initState() {
    userHiveBox = Hive.box('user');
    var temp = userHiveBox.get('rent', defaultValue: {
      'rentDue': 0,
      'account': 'err',
      'month': "null",
      "rentStatus": false
    }); //Add default for non complains
    mobile = userHiveBox.get('mobile', defaultValue: "");
    accountName = "#po" + temp["account"];
    visualAmount = amountDue.replaceAllMapped(
        new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
          decoration: BoxDecoration(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.bolt),
                  Text(
                    "Token Purchase",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
                  ),
                  SizedBox()
                ],
              ),
              Divider(),
              SizedBox(height: 5),
              Row(
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Ksh :",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$visualAmount",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Number:",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          mobile,
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // SizedBox(
              //   height: 10,
              // ),
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Text(
              //     "Select Payment Method",
              //     style: TextStyle(fontWeight: FontWeight.w800),
              //   ),
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     PaymentTile(),
              //     // SizedBox(
              //     //   width: 10,
              //     // ),
              //     // PaymentTile(),
              //   ],
              // ),
              SizedBox(
                height: 20,
              ),

              TextField(
                autofocus: true,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    visualAmount = value;
                    amountDue = value;
                  });
                },
                controller: _amountficontroller,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(gapPadding: 0.9),
                  labelText: 'Amount',
                  hintText: 'In shillings',
                  errorText: validateAmount(_phoneficontroller.text),
                  prefixText: "",
                ),
                keyboardType: TextInputType.numberWithOptions(),
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Running low on Cash ?",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
                ),
              ),
              TextField(
                autofocus: true,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    mobile = value;
                  });
                },
                controller: _phoneficontroller,
                decoration: InputDecoration(
                  isDense: true,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.contacts),
                    onPressed: () async {
                      final PhoneContact contact =
                          await FlutterContactPicker.pickPhoneContact();

                      setState(() {
                        _phoneficontroller.text =
                            convertTo07(contact.phoneNumber.number);
                        mobile = convertTo07(contact.phoneNumber.number);
                      });
                    },
                  ),
                  border: OutlineInputBorder(gapPadding: 0.2),
                  hintText: 'Ask somone else to pay',
                  errorText: validatePassword(_phoneficontroller.text),
                  prefixText: "",
                ),
                keyboardType: TextInputType.numberWithOptions(),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: MaterialButton(
                    height: 40,
                    minWidth: MediaQuery.of(context).size.width * .95,
                    onPressed: () async {
                      Navigator.pop(context);
                      await _sendPayment(
                          mobile, amountDue, accountName, context);
                    },
                    color: Colors.orangeAccent,
                    child: Text(
                      "Pay $amountDue",
                      style: TextStyle(color: Colors.white),
                    ),
                    autofocus: true,
                  ),
                ),
              ),
              SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
