import 'package:clone/archive/users_data.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class IssuesCard extends StatefulWidget {
  IssuesCard({Key key}) : super(key: key);

  @override
  _IssuesCardState createState() => _IssuesCardState();
}

class _IssuesCardState extends State<IssuesCard> {   
  Box<dynamic> userHiveBox;
  
  String _houseNumber = "-";
  int _compains;
  List<String> option = ["Details", "Contact Us"];
  @override
  void initState(){
        super.initState();
        userHiveBox = Hive.box('user');
         _compains = userHiveBox.get("lastIssue",defaultValue:"0");
  }
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
                "HouseNo  :$_houseNumber",
                style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black),
              ),
              Container(child: Text("Issues")),
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
                },
              ),
            ],
          ),
          Text(
            "${_compains.toString()}",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 35.0,
            ),
          ),
          Text(
            "complains",
            style: TextStyle(
              fontWeight: FontWeight.w200,
              fontSize: 20.0,
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
                  color: Colors.white ,
                  child: Row(
                    children: [
                      Text("Past Complains",
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/complain');
                    // setState(() {
                    //   _testvar = !_testvar;
                    // });
                    print("STK push sent");
                  },
                ),
              ),
              AnimatedContainer(
                duration: Duration(seconds: 100),
                color: Colors.transparent,
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.all(5.0),
                child: Hero(
                  tag:"report",
                                  child: MaterialButton(
                    color:
                        Theme.of(context).primaryColor,
                    child: Row(
                      children: [
                        Text("Report !", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/complain');
                      print("STK push sent");
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

void choiceAction(String choice) {
  print(choice);
  Navigator.push(
    null,
    MaterialPageRoute(builder: (_) => UserTest(appTitle: "ok")),
  );
}
