import 'dart:convert';
import 'package:clone/model/paymentResponse.dart';
import 'package:http/http.dart' as http;
import 'package:clone/widget/payments_selections.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

class RentPaymentCard extends StatefulWidget {
  RentPaymentCard({Key key}) : super(key: key);

  @override
  _RentPaymentCardState createState() => _RentPaymentCardState();
}

class _RentPaymentCardState extends State<RentPaymentCard> {
  String _month = "January";
  int _rentDue = 20000;
  bool _testvar = true;
  bool _rentstaus = true;
  List<String> option = ["All Transaction", "Recipts"];
  @override
  Widget build(BuildContext context) {
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
              PopupMenuButton(
                  onSelected: choiceAction,
                  icon: Icon(Icons.more_horiz),
                  itemBuilder: (BuildContext context) {
                    return option.map((String choice) {
                      return PopupMenuItem(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  }),
            ],
          ),
          Text(
            "Ksh.${_rentDue.toString()}",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 40.0,
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "RentStatus",
                    style: TextStyle(color: Colors.grey, fontSize: 10.0),
                  ),
                  MaterialButton(
                      color: _rentstaus ? Colors.greenAccent : Colors.redAccent,
                      onPressed: () {
                        setState(() {
                          _rentstaus = !_rentstaus;
                        });
                      },
                      child: Text(
                        _rentstaus ? "Paid" : "Due",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
              AnimatedContainer(
                duration: Duration(seconds: 100),
                color: Colors.transparent,
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(5.0),
                child: MaterialButton(
                  color:
                      _testvar ? Theme.of(context).primaryColor : Colors.grey,
                  child: Row(
                    children: [
                      Text("Pay now", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                  onPressed: () {
                    _settingModalBottomSheet(context, _rentDue.toString());
                    print("STK push sent");
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

void _settingModalBottomSheet(context, amountDue) {
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

Future _sendPayment(mobile, amountDue, ctx) async {
  showDialog(
    //Text(message['notification']['title']
    context: ctx,
    builder: (ctx) => AlertDialog(
        title: Text("Request Successful"),
        content: Text("Please intent sent\nworth Ksh.$amountDue \nto $mobile")),
  );

  PaymentResponse data;
  try {
    final response = await http.post(
      ("https://googlesecureotp.herokuapp.com/" + "payment"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode(
        //ensure that the user has bothe the socketID and the USER ID
        {
          'phonenumber': mobile,
          'amount': amountDue,
          'userID': 'Jotham254',
          'socketID': 'mee',
          'notifToken': 'sererer.erere.rwewe'
        },
      ),
    );
    var myjson = json.decode(response.body);
    data = PaymentResponse.fromJson(myjson);

    //Show Popup

    print(data.paymentCode);
    print(data.description);
  } catch (err) {
    print(err);
  }
}

void choiceAction(String choice) {
  print(choice);
  Navigator.of(null).pushNamed('/randomUser');
}

String validatePassword(String value) {
  if (!(value.length > 9) && value.isNotEmpty) {
    return "Mobile number should be in the format 254xxx";
  }
  return null;
}

class PaymentBottomSheet extends StatefulWidget {
  @override
  _PaymentBottomSheetState createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  final TextEditingController _testcontroller = TextEditingController();
  String mobile;
  String amountDue;
  @override
  void initState() {
    mobile = "0797678252";
    amountDue = "1";
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
                          "20,000",
                          style: TextStyle(
                              fontWeight: FontWeight.w100, fontSize: 25),
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
                  "Running low on Cash?",
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
                    icon: Icon(Icons.perm_contact_calendar),
                    onPressed: () async {
                      final PhoneContact contact =
                          await FlutterContactPicker.pickPhoneContact();
                      print(contact);
                      setState(() {
                        _testcontroller.text = contact.phoneNumber.number;
                        mobile = contact.phoneNumber.number;
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
                    height: 40,
                    minWidth: MediaQuery.of(context).size.width * .95,
                    onPressed: () async {
                      Navigator.pop(context);
                      await _sendPayment(mobile, "1", context);
                    },
                    color: Colors.black,
                    child: Text(
                      "Pay $amountDue",
                      style: TextStyle(color: Colors.white),
                    ),
                    autofocus: true,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
