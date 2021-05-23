import 'dart:convert';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:provider/provider.dart';
import 'package:simpmigration/constants.dart';
import 'package:simpmigration/model/paymentResponse.dart';
import 'package:simpmigration/providers/list_switcher_provider.dart';
import 'package:simpmigration/widget/payments_selections.dart';

class RentPaymentCard extends StatefulWidget {
  RentPaymentCard({Key key}) : super(key: key);

  @override
  _RentPaymentCardState createState() => _RentPaymentCardState();
}

class _RentPaymentCardState extends State<RentPaymentCard> {
  Box<dynamic> userHiveBox;
  Map<String, dynamic> defrent = {
    "month": "October",
    "time": "00/00/00",
    "rentDue": 1578,
    "rentStatus": false
  };
  //Map<String,dynamic> rent;
  String _month;
  int _rentDue;
  bool _testvar = true;
  bool _status = false;
  List<String> option = [
    "Past Transactions",
  ];

  @override
  void initState() {
    super.initState();
    userHiveBox = Hive.box(Constants.HiveBoxName);
    var temp = userHiveBox.get(Constants.RentPayableStore, defaultValue: {
      'rentDue': 0,
      'month': "October",
      "rentStatus": false
    }); //Add default for non complains
    _month = temp["month"];
    _rentDue = temp['rentDue'];
    _status = temp["rentStatus"];
    print("DTAT");
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(Constants.HiveBoxName).listenable(),
      builder: (context, box, widget) {
        var local = userHiveBox.get(Constants.RentPayableStore, defaultValue: {
          'rentDue': 0,
          'month': "October",
          "rentStatus": false
        });
        _month = local["month"];
        _rentDue = local['rentDue'];
        _status = local["rentStatus"];
        String _visualAmount = _rentDue.toString().replaceAllMapped(
            new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},');
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
                    "Month  :",
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  Container(child: Text("$_month")),
                  Consumer<ListSwitcherProvider>(
                      builder: (context, storeP, child) {
                    return PopupMenuButton(
                      onSelected: (String choice) {
                        print(choice);
                        storeP.switchRents();
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
                  }),
                ],
              ),
              Text(
                "Ksh.$_visualAmount",
                style: TextStyle(
                  fontWeight: FontWeight.w100,
                  fontSize: 30.0,
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text(
                        "RentBillStatus",
                        style: TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      Consumer<ListSwitcherProvider>(
                          builder: (context, storeP, children) {
                        return MaterialButton(
                            color:
                                _status ? Colors.greenAccent : Colors.red[300],
                            onPressed: () {
                              storeP.switchRents();
                            },
                            child: Text(
                              _status ? "Paid" : "Due",
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
                            Text("Pay now",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                        onPressed: () {
                          storeP.switchRents();
                          settingModalBottomSheet(context, _rentDue.toString());
                          print("STK push sent");
                        },
                      );
                    }),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

void settingModalBottomSheet(context, amountDue) {
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
  //v2 work with paymentapi responses
  PaymentResponse data;
  Flushbar(
    backgroundColor: Colors.grey[350],
    title: " Processing Payment 🤵...",
    message: " 📲 No:$mobile  💱 Amount:Ksh.$amountDue",
    icon: Icon(
      Icons.bubble_chart,
      size: 40,
      color: Colors.white,
    ),
    leftBarIndicatorColor: Colors.yellowAccent,
    duration: Duration(seconds: 20),
    forwardAnimationCurve: Curves.easeInOutBack,
  )..show(ctx);
  try {
    final response = await http.post(
      Uri.parse("https://googlesecureotp.herokuapp.com/payment"),
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
        },
      ),
    );
    print("$accName");
    var myjson = json.decode(response.body);
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
  final TextEditingController _testcontroller = TextEditingController();
  String mobile;
  String amountDue;
  String visualAmount;
  String accountName;
  @override
  void initState() {
    userHiveBox = Hive.box(Constants.HiveBoxName);
    var temp = userHiveBox.get(Constants.RentPayableStore, defaultValue: {
      'rentDue': 0,
      'account': 'err',
      'month': "null",
      "rentStatus": false
    }); //Add default for non complains
    mobile = userHiveBox.get(Constants.PhoneNumberStore, defaultValue: "");
    amountDue = temp["rentDue"].toString();
    accountName = temp["account"];
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
                  Icon(Icons.arrow_downward),
                  Text(
                    "Rent Payment",
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
                          "Amount:",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "$visualAmount",
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 20,
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
                              fontWeight: FontWeight.w400, fontSize: 20),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          mobile,
                          style: TextStyle(
                              fontWeight: FontWeight.w100, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Payment Method",
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  PaymentTile(),
                  // SizedBox(
                  //   width: 10,
                  // ),
                  // PaymentTile(),
                ],
              ),
              SizedBox(
                height: 20,
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
                controller: _testcontroller,
                decoration: InputDecoration(
                  isDense: true,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.contacts),
                    onPressed: () async {
                      final PhoneContact contact =
                          await FlutterContactPicker.pickPhoneContact();

                      setState(() {
                        _testcontroller.text =
                            convertTo07(contact.phoneNumber.number);
                        mobile = convertTo07(contact.phoneNumber.number);
                      });
                    },
                  ),
                  border: OutlineInputBorder(gapPadding: 0.5),
                  hintText: 'Ask somone else to pay',
                  errorText: validatePassword(_testcontroller.text),
                  prefixText: "",
                ),
                keyboardType: TextInputType.numberWithOptions(),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  child: MaterialButton(
                    height: 45,
                    minWidth: MediaQuery.of(context).size.width * .95,
                    onPressed: () async {
                      Navigator.pop(context);
                      await _sendPayment(
                          mobile, amountDue, accountName, context);
                    },
                    color: Colors.black,
                    child: Text(
                      "Pay $amountDue",
                      style: TextStyle(color: Colors.white),
                    ),
                    autofocus: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
