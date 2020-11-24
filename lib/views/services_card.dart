import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:app_settings/app_settings.dart';
class ServiceCard extends StatefulWidget {
  ServiceCard({Key key}) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  String _houseNumber = "-";
  int _compains = 1;
  bool _testvar = true;
  List<String> option = ["Maps", "History"];
  @override
  Widget build(BuildContext context) {
    return Consumer<Position>(
      builder: (BuildContext context, position, child) {
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
                    "HouseNo  :$_houseNumber",
                    style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  Container(child: Text("Services")),
                  PopupMenuButton(
                      onSelected: (value) {
                        choiceAction(value, context);
                      },
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
                "${_compains.toString()}",
                style: TextStyle(
                  //fontWeight: FontWeight.w200,
                  fontSize: 25.0,
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AnimatedContainer(
                    duration: Duration(seconds: 100),
                    color: Colors.transparent,
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.all(5.0),
                    child: MaterialButton(
                      color: _testvar ? Colors.white : Colors.grey,
                      child: Row(
                        children: [
                          Text("Rate Service",
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                      onPressed: () {
                        navigateToMap(context, position);
                      },
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(seconds: 100),
                    color: Colors.transparent,
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.all(5.0),
                    child: MaterialButton(
                      color: _testvar
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      child: Row(
                        children: [
                          Text("Go to Map ",
                              style: TextStyle(color: Colors.white)),
                          Icon(
                            Icons.zoom_out_map,
                            color: Colors.white,
                          )
                        ],
                      ),
                      onPressed: () {
                        navigateToMap(context, position);
                      },
                    ),
                  ),
                ],
              )
            ],

          ),
          //Kama uma
        );
      },
    );
  }

  void choiceAction(String choice, BuildContext context) {
    print(choice);
    //todo
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => UserTest(appTitle: choice)),
    // );
  }

  void navigateToMap(BuildContext context, Position pos) {
    print("Going to map");
    if (pos != null) {
      Navigator.of(context).pushNamed('/map', arguments: pos);
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(
                            content:Text("Turn on location service"),
                            action: SnackBarAction(
                              textColor: Colors.yellow,
                              label:"Turn On",
                              onPressed:(){
                                AppSettings.openLocationSettings();
                                print("Opening Settings");
                              }
                            ),));
    }
  }
}
