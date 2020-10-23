import 'dart:convert';
import 'dart:math';
import 'package:clone/services/geolocation_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:clone/views/issues_card.dart';
import 'package:clone/views/rent_card.dart';
import 'package:clone/views/services_card.dart';
import 'package:clone/widget/awesome_fab.dart';
import 'package:clone/widget/pdf_button.dart';
import 'package:clone/widget/slidingContainer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:clone/model/loginotpmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewCardLayout extends StatefulWidget {
  HomeViewCardLayout({Key key, this.transitionAnime}) : super(key: key);
  final Animation<double> transitionAnime;

  @override
  _HomeViewCardLayoutState createState() => _HomeViewCardLayoutState();
}

class _HomeViewCardLayoutState extends State<HomeViewCardLayout> {
  Box<dynamic> userHiveBox;
  String _username;
  Map<String,dynamic> soletrans={"month":"Jan","rec":{"username":"boom","branch":"Kahawa Sukari,Kenya","house":"A12","receiptNumber":"WC2340923409","description":"Mpesa Express 9.30am by 254797678353","amount":4384}};
  Map<String, dynamic> defaulttransactions;
  Map<String, dynamic> defaultcomplains = {
    'title': "Expenses",
    'data': ["Water", "Painting", "Gas"]
  };
  bool fadeswitch;

  @override
  void initState() {
    super.initState();
    userHiveBox = Hive.box('user');
    _username = userHiveBox.get('username', defaultValue: "JohnDoe");
    fadeswitch = true;
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
                  Navigator.of(context).pushNamed('/');
                  print(
                      'Card should be the percenage ${300 / MediaQuery.of(context).size.height}% while Listings${400 / MediaQuery.of(context).size.height}%');
                },
              )),
          //floatingActionButton: OlfFAB(cardsscrollcontroller: _cardsscrollcontroller, fadeswitch: fadeswitch, _complains: _complains, _transactions: _transactions),
            floatingActionButton: AwesomeFAB(),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh:(){
                return Future.delayed(Duration(seconds: 3),(){
                  print("Fetching new data");
                  return "";
                });
              },
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
                      child: CardListings()),
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
class CardListings extends StatefulWidget {
  CardListings({
    Key key,
  }) : super(key: key);
  
  @override
  _CardListingsState createState() => _CardListingsState();
}
void uTransactions()async{
  final prefs = await SharedPreferences.getInstance();
  final jsonTrans = prefs.getString('user_transactions') ?? '';
  Transaction tt = Transaction.fromJson(json.decode(jsonTrans));
  var userBox = Hive.box('user');
  userBox.put("transaction",tt.toJson());
  print("Transactions Added ${tt.toJson()}");
} 
class _CardListingsState extends State<CardListings> {
  @override
  void initState() {
    //uTransactions 
    //();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: Hive.box('user').listenable(),
      builder: (context, box, widget) {
         //print("localfile--<${ new Map<String, dynamic>.from(snapshot.value);}>---");
        var temp =  box.get('transaction');
        var local  = json.decode(temp);
  print("SDSSD$local");
        if(true){
        return Container(
        color: Colors.white38,
        //Bottom Listing size 400
        //height: MediaQuery.of(context).size.height * 0.4554588205448669,
        height:400,
        child: ReorderableListView(
          header: Row(
            children: [
              SizedBox(
                height: 29,
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  local['title'],
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
              final item = local['data'].removeAt(oldIndex);
              local['data'].insert(newIndex, item);
            });
          },
          children: [
            for (final item in local['data'])
              ExpansionTile(
                key: ValueKey(Random().nextInt(10000)),
                title: Text(item["month"]),
                subtitle: Text("${item["time"]}"),
                leading: Icon(Icons.access_time),
                trailing: Text("Ksh.${item["rec"]["amount"].toString()}",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                children: [
                  Row(
                    children: [
                      CreatePdfStatefulWidget(
                        transData: item["rec"]),
                       ],
                  )
                ],
              ),
          ],
        ),
      );}else{
        print("$local");
        return Text('JKDSJDKJSKDJ');
      }});
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