import 'dart:convert';
//import 'package:clone/model/cofee_model.dart';
import 'package:clone/model/cofee_model.dart';
import 'package:clone/providers/list_switcher_provider.dart';
import 'package:clone/views/kplc_card.dart';
import 'package:clone/views/rent_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

void upadateRentCard(String month, bool status, int amount) {
  var userBox = Hive.box('user');
  Map<String, dynamic> rent = {
    "month": month,
    "rentDue": amount,
    "rentStatus": status
  };
  userBox.put("rent", rent);
}

Future<void> addFakeService() async {
  List<Coffee> coffeeShop = [];
  var serveBox = Hive.box("serves");
  List<dynamic> servicesJson = [
    {
      "rank": "1",
      "shopName": "NEW available",
      "address": "NhcLangata",
      "contact": "0797678252",
      "description": "Available from 10 to 2",
      "Lat": "10.00",
      "Long": "50.00"
    }
  ];
  //List<dynamic> servicesJson = serveBox.get("services",defaultValue:[]);
  for (dynamic s in servicesJson) {
    coffeeShop.add(Coffee(
        rank: int.parse(s["rank"]),
        shopName: s["shopName"],
        address: s["address"],
        contact: 'tel:${s["contact"]}',
        description: s["description"],
        locationCoords:
            LatLng(double.parse(s["Lat"]), double.parse(s["Long"]))));
  }
  serveBox.put("servicesD", servicesJson);
}

void updateTransactions() async {
  final prefs = await SharedPreferences.getInstance();
  var userBox = Hive.box('user');
  List<Map<String, dynamic>> newtrans = [
    {
      "month": "Febuary",
      "time": "99/99/99",
      "rec": {
        "username": "New Trans",
        "branch": "SomeWhere Sukari,Kenya",
        "house": "B22",
        "receiptNumber": "WC2340923409",
        "description": "Mpesa Express 9.30am by 254797678353",
        "amount": 10020
      }
    }
  ];
  Map<String, dynamic> transactions = {
    'title': "Transactions",
    'data': newtrans,
  };
  userBox.put("transaction", jsonEncode(transactions));
  prefs.setString("user_transactions", jsonEncode(transactions));
  print("Transactions Added");
}

class AwesomeFAB extends StatelessWidget {
  const AwesomeFAB({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Position>(
      builder: (context, position, children) {
        return Consumer<ListSwitcherProvider>(
            builder: (context, storeP, children) {
          return SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            // child: Icon(Icons.add),
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            //visible: dialVisible,
            curve: Curves.easeIn,
            children: [
              SpeedDialChild(
                child: Icon(Icons.monochrome_photos, color: Colors.white),
                backgroundColor: Colors.green,
                onTap: () {
                  storeP.switchRents();
                  settingModalBottomSheet(context, '1');
                  print("STK push sent");
                },
                label: 'Pay Rent',
                labelStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                labelBackgroundColor: Colors.green,
              ),

              // SpeedDialChild(
              //   child: Icon(Icons.brush, color: Colors.white),
              //   backgroundColor: Colors.green,
              //   onTap: () {
              //     //addFakeService();
              //     //makeShops();
              //     //makeShops();
              //     //var userBox = Hive.box('user');
              //     //getLatestTrans();
              //     //userBox.put('rentStats',!(userBox.get('rentStats')));
              //     //updateTransactions();
              //     //upadateRentCard("January",false,2);
              //     //print("eee${userBox.get('rentStats')}");
              //     //print('Receipts');
              //     },
              //   label: 'Receipts',
              //   labelStyle:
              //       TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              //   labelBackgroundColor: Colors.green,
              // ),
              SpeedDialChild(
                child: Icon(Icons.map, color: Colors.white),
                backgroundColor: Colors.blue,
                onTap: () {
                  if (position != null) {
                    Navigator.of(context)
                        .pushNamed('/services', arguments: position);
                  } else {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text("Turn on location service")));
                  }
                },
                label: 'Services',
                labelStyle:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                labelBackgroundColor: Colors.blue,
              ),
              SpeedDialChild(
                child: Icon(Icons.bolt, color: Colors.black),
                backgroundColor: Colors.yellowAccent,
                onTap: () {
                  kplcModalBottomSheet(context, '10');
                  print("STK push sent");
                },
                label: 'Buy Tokens',
                labelStyle:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                labelBackgroundColor: Colors.yellowAccent,
              ),
            ],
          );
        });
      },
    );
  }
}
//WEB SOCKETS TO DO THIS OR A PULL TO REFRESH

// class OlfFAB extends StatefulWidget {
//   const OlfFAB({
//     Key key,
//     @required ScrollController cardsscrollcontroller,
//     @required this.fadeswitch,
//     @required this.complains,
//     @required this.transactions,
//   })  : _cardsscrollcontroller = cardsscrollcontroller,
//         super(key: key);

//   final ScrollController _cardsscrollcontroller;
//   final bool fadeswitch;
//   final Map<String, dynamic> complains;
//   final Map<String, dynamic> transactions;

//   @override
//   _OlfFABState createState() => _OlfFABState();
// }

// class _OlfFABState extends State<OlfFAB> {
//   @override
//   Widget build(BuildContext context) {
//     return FloatingActionButton(
//       backgroundColor: Theme.of(context).primaryColor,
//       child: Icon(
//         Icons.add,
//         color: Colors.white,
//       ),
//     );

//     // onPressed: () {
//     //   setState(() {
//     //     print(widget._cardsscrollcontroller.offset);
//     //     widget.fadeswitch = !widget.fadeswitch;
//     //     print(widget.fadeswitch);
//     //     _myAnimatedWidget = widget.fadeswitch == true
//     //         ? CardListings(
//     //             myItems: widget.complains,
//     //             key: ValueKey(2),
//     //           )
//     //         : CardListings(myItems: widget.transactions, key: ValueKey(1));
//     //   });
//     // });
//   }
// }
