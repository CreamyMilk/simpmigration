import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:simpmigration/constants.dart';
import 'package:simpmigration/utils/utils.dart';

class NewRentPaymentSheet extends StatefulWidget {
  @override
  _NewRentPaymentSheetState createState() => _NewRentPaymentSheetState();
}

class _NewRentPaymentSheetState extends State<NewRentPaymentSheet> {
  int selectedOption;

  Box<dynamic> userHiveBox;
  String mobile;
  String amountDue;
  String visualAmount;
  String accountName;
  @override
  void initState() {
    selectedOption = 0;
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
          margin: const EdgeInsets.only(top: 5, left: 5, right: 5),
          decoration: BoxDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const XMargin(20),
                  Text(
                    "Rent Payment",
                    style: TextStyle(
fontSize: 20
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Divider(),
              const YMargin(5),
              RadioListTile(
                contentPadding: EdgeInsets.only(top:10,bottom:10),
                activeColor: Colors.green,
                onChanged: (x) {
                  setState(() {
                    selectedOption = 1;
                  });
                },
                selected: selectedOption == 1,
                selectedTileColor: Colors.greenAccent.withOpacity(0.2),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ColorFiltered(
                      colorFilter:
                          selectedOption == 1 ? normalFilter : greyFilter,
                      child: Image.asset(
                        "assets/safaricom.png",
                        width: 70,
                        height: 70,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Pay Directly With Mpesa")
                  ],
                ),
                groupValue: true,
                value: selectedOption == 1,
              ),
              const YMargin(10),
              RadioListTile(
                activeColor: Colors.green,
                contentPadding: EdgeInsets.only(top:10,bottom:10),
                onChanged: (x) {
                  setState(() {
                    selectedOption = 2;
                  });
                },
                selected: selectedOption == 2,
                selectedTileColor: Colors.greenAccent.withOpacity(0.2),
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ColorFiltered(
                      colorFilter:
                          selectedOption == 2 ? normalFilter : greyFilter,
                      child: Image.asset(
                        "assets/wallet.jpg",
                        width: 70,
                        height: 70,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text("Pay With Wallet")
                  ],
                ),
                groupValue: true,
                value: selectedOption == 2,
              ),
              Divider(),
              const YMargin(20),
              Align(
                child: AnimatedContainer(
                  duration: Duration(seconds: 1),
                  height: 50,
                  width: selectedOption != 0 ? screenWidth(context, percent: 0.8): screenWidth(context, percent: 1.0),
                  decoration: BoxDecoration(
                    color: selectedOption != 0
                        ? Colors.greenAccent[400]
                        : Colors.grey[200],
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey[400].withOpacity(0.3),
                          offset: Offset(0, 13),
                          blurRadius: 30)
                    ],
                  ),
                  // ignore: deprecated_member_use
                  child: FlatButton(
                    onPressed: () {},
                    color: Colors.transparent,
                    child: Text(
                      selectedOption != 0 ? "Continue " : "Pick One",
                      style: TextStyle(
                          color: selectedOption != 0
                              ? Colors.white
                              : Colors.blueGrey,
                          fontSize: 20,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ),
              ),
              const YMargin(20),
            ],
          ),
        ),
      ),
    );
  }
}

const normalFilter = ColorFilter.mode(
  Colors.transparent,
  BlendMode.multiply,
);
const greyFilter = ColorFilter.matrix(<double>[
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0.2126,
  0.7152,
  0.0722,
  0,
  0,
  0,
  0,
  0,
  1,
  0
]);
