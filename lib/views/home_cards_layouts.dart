import 'dart:math';
import 'dart:developer';
import 'package:clone/services/geolocation_service.dart';
import 'package:clone/views/issues_card.dart';
import 'package:clone/views/rent_card.dart';
import 'package:clone/views/services_card.dart';
import 'package:clone/widget/awesome_fab.dart';
import 'package:clone/widget/pdf_button.dart';
import 'package:clone/widget/slidingContainer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeViewCardLayout extends StatefulWidget {
  HomeViewCardLayout({Key key, this.transitionAnime}) : super(key: key);
  final Animation<double> transitionAnime;

  @override
  _HomeViewCardLayoutState createState() => _HomeViewCardLayoutState();
}

class _HomeViewCardLayoutState extends State<HomeViewCardLayout> {
  String _username = "Patrick";

  Map<String, dynamic> transactions = {
    'title': "Transactions",
    'data': ["Oct", "Sept", "August", "July", "June", "May", "Feb", "Jan"],
  };
  Map<String, dynamic> complains = {
    'title': "Expenses",
    'data': ["Water", "Painting", "Gas"]
  };
  Widget _myAnimatedWidget;
  ScrollController _cardsscrollcontroller;
  bool fadeswitch;

  @override
  void initState() {
    super.initState();
    fadeswitch = true;
    _myAnimatedWidget = CardListings(
      myItems: transactions,
      key: ValueKey(1),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GeolocatorService geoService = GeolocatorService();
    return MultiProvider(
      providers: [
        FutureProvider<Position>(
          create: (context) => geoService.getInitialLocation(),
        ),
      ],
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs
                          .setString("user_token", "Loggedut")
                          .then((bool success) {
                        if (success) {
                          Navigator.of(context).pushNamed('/login');
                        }
                      });
                    })
              ],
              leading: IconButton(
                icon: Icon(Icons.account_circle),
                color: Colors.white,
                onPressed: () {
                  print(
                      'Card should be the percenage ${300 / MediaQuery.of(context).size.height}% while Listings${400 / MediaQuery.of(context).size.height}%');
                },
              )),
          //floatingActionButton: OlfFAB(cardsscrollcontroller: _cardsscrollcontroller, fadeswitch: fadeswitch, complains: complains, transactions: transactions),
          floatingActionButton: AwesomeFAB(),
          body: SafeArea(
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
                        fontSize: 30.0,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 1.0),
                //Slider area
                SlidingContainer(
                  initialOffsetX: 5,
                  intervalStart: 0,
                  intervalEnd: 0.5,
                  childs: Container(
                    margin: EdgeInsets.all(16.0),
                    //color: Colors.red[50],
                    height: MediaQuery.of(context).size.height *
                        0.3415941154086502, //Cards Height
                    child: ListView(
                      controller: _cardsscrollcontroller,
                      padding: EdgeInsets.all(4.0),
                      scrollDirection: Axis.horizontal,
                      children: [
                        PageCard(
                          childwidget: RentPaymentCard(),
                          gradients: [Colors.white, Colors.lightGreen[100]],
                        ),
                        SizedBox(width: 10),
                        PageCard(
                          childwidget: IssuesCard(),
                          gradients: [Colors.white, Colors.red[100]],
                        ),
                        SizedBox(width: 10),
                        PageCard(
                          childwidget: ServiceCard(),
                          gradients: [Colors.white, Colors.lightBlue[100]],
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                ),

                //Bottom Listing
                SlidingContainer(
                  initialOffsetX: -1,
                  intervalStart: 0.5,
                  intervalEnd: 1,
                  childs: Container(
                    child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        child: _myAnimatedWidget),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CardListings extends StatefulWidget {
  const CardListings({
    Key key,
    @required this.myItems,
  }) : super(key: key);

  final Map<String, dynamic> myItems;

  @override
  _CardListingsState createState() => _CardListingsState();
}

class _CardListingsState extends State<CardListings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white38,
      //Bottom Listing size 400
      height: MediaQuery.of(context).size.height * 0.4554588205448669,
      child: ReorderableListView(
        header: Row(
          children: [
            SizedBox(
              height: 29,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                widget.myItems['title'],
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 5.0),
              ),
            ),
          ],
        ),
        onReorder: (oldIndex, newIndex) {
          print(oldIndex);
          print(newIndex);
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = widget.myItems['data'].removeAt(oldIndex);
            widget.myItems['data'].insert(newIndex, item);
          });
        },
        children: [
          for (final item in widget.myItems['data'])
            ExpansionTile(
              key: ValueKey(item),
              title: Text(item),
              subtitle: Text("${Timeline.now}"),
              leading: Icon(Icons.album),
              trailing: Text("Ksh.${Random().nextInt(10000).toString()}",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              children: [
                Row(
                  children: [
                    CreatePdfStatefulWidget(),
                  ],
                )
              ],
            ),
        ],
      ),
    );
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
