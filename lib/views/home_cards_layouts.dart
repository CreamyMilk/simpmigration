import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:simpmigration/constants.dart';
import 'package:simpmigration/model/payment_update.dart';
import 'package:simpmigration/providers/list_switcher_provider.dart';
import 'package:simpmigration/services/geolocation_service.dart';
import 'package:simpmigration/views/TokensList.dart';
import 'package:simpmigration/views/rent_card.dart';
import 'package:simpmigration/widget/awesome_fab.dart';
import 'package:simpmigration/widget/pdf_button.dart';
import 'package:simpmigration/widget/slidingContainer.dart';

class HomeViewCardLayout extends StatefulWidget {
  HomeViewCardLayout({Key key, this.transitionAnime}) : super(key: key);
  final Animation<double> transitionAnime;

  @override
  _HomeViewCardLayoutState createState() => _HomeViewCardLayoutState();
}

class _HomeViewCardLayoutState extends State<HomeViewCardLayout> {
  Box<dynamic> userHiveBox;
  String _username;
  dynamic soletrans = {
    "month": "Jan",
    "rec": {
      "username": "boom",
      "branch": "Kahawa Sukari,Kenya",
      "house": "A12",
      "receiptNumber": "WC2340923409",
      "description": "Mpesa Express 9.30am by 254797678353",
      "amount": 4384
    }
  };
  Map<String, dynamic> defaulttransactions;
  Map<String, dynamic> defaultcomplains = {
    'title': "Expenses",
    'data': ["Water", "Painting", "Gas"]
  };
  bool fadeswitch;

  @override
  void initState() {
    super.initState();
    userHiveBox = Hive.box(Constants.HiveBoxName);
    _username =
        userHiveBox.get(Constants.UserNameStore, defaultValue: "JohnDoe");
    fadeswitch = true;
  }

  @override
  Widget build(BuildContext context) {
    final GeolocatorService geoService = GeolocatorService();
    return MultiProvider(
      providers: [
        FutureProvider<Position>(
          initialData: Position(latitude: 0, longitude: 12),
          create: (context) => geoService.getInitialLocation(),
        ),
      ],
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: false,
            title: Text("Good Morning, \nKinyua",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500)),
            backgroundColor: Theme.of(context).primaryColor,
            actions: [
              IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    dynamic box = Hive.box(Constants.HiveBoxName);
                    box.put(Constants.IsLoggedInStore, false);
                    if (Platform.isAndroid) {
                      FirebaseMessaging.instance.unsubscribeFromTopic(box.get(
                          Constants.NotificationTopicStore,
                          defaultValue: "."));
                    }
                    Navigator.of(context).pushNamed('/login');
                  })
            ],
          ),
          floatingActionButton: AwesomeFAB(),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: getLatestTrans,
              child: ListView(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      child: Text(
                        "Hello, $_username",
                        style: TextStyle(
                          letterSpacing: 2.0,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w100,
                        ),
                      ),
                    ),
                  ),
                  //Slider area
                  SlidingContainer(
                    initialOffsetX: 5,
                    intervalStart: 0,
                    intervalEnd: 0.5,
                    childs: Container(
                      margin: EdgeInsets.all(10.0),
                      //color: Colors.red[50],
                      height: MediaQuery.of(context).size.height *
                          0.2915941154086502, //Cards Height
                      child: ListView(
                        padding: EdgeInsets.all(4.0),
                        scrollDirection: Axis.horizontal,
                        children: [
                          SizedBox(width: 20),
                          PageCard(
                            childwidget: RentPaymentCard(),
                            gradients: [Colors.white, Colors.lightGreen[200]],
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                  //Bottom Listing
                  SlidingContainer(
                    initialOffsetX: -1,
                    intervalStart: 0.5,
                    intervalEnd: 1,
                    childs: Container(child: CardListings()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CardListings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ListSwitcherProvider>(builder: (context, storeP, child) {
      return AnimatedSwitcher(
        switchInCurve: Curves.easeInOutBack,
        duration: Duration(seconds: 3),
        child: storeP.showTrans ? TransList() : TokenList(),
      );
    });
  }
}

class PageCard extends StatelessWidget {
  final Widget childwidget;
  final List<Color> gradients;
  const PageCard({@required this.childwidget, @required this.gradients});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 1,
        width: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: gradients),
          //color: Colors.lightBlue[100],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: this.childwidget);
  }
}

class TransList extends StatefulWidget {
  @override
  _TransListState createState() => _TransListState();
}

class _TransListState extends State<TransList> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(Constants.HiveBoxName).listenable(),
        builder: (context, box, widget) {
          var temp = box.get(Constants.TransactionStore);
          var local = json.decode(temp);
          //print("SDSSD$local");
          if (true) {
            return Container(
              color: Colors.white70,
              //Bottom Listing size 400
              height: MediaQuery.of(context).size.height *
                  (0.9 - 0.2915941154086502),
              //height:400,
              child: ReorderableListView(
                header: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            local['title'],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 4.0),
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 1),
                  ],
                ),
                onReorder: (oldIndex, newIndex) {
                  //print(oldIndex);
                  //print(newIndex);
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final item = local['data'].removeAt(oldIndex);

                    local['data'].insert(newIndex, item);
                    box.put(Constants.TransactionStore, jsonEncode(local));
                  });
                },
                children: [
                  for (final item in local['data'])
                    ExpansionTile(
                      key: ValueKey(Random().nextInt(10000)),
                      title: Text(item["month"]),
                      subtitle: Text("${item["time"]}"),
                      leading: CircleAvatar(
                        backgroundColor: Colors.greenAccent[100],
                        foregroundColor: Colors.transparent,
                        child: Icon(Icons.call_merge, color: Colors.black),
                        radius: 20,
                      ),
                      trailing: Text(
                          "Ksh.${(item["rec"]["amount"].toString()).replaceAllMapped(new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 15),
                            CreatePdfStatefulWidget(transData: item["rec"]),
                          ],
                        )
                      ],
                    ),
                ],
              ),
            );
          }
        });
  }
}
