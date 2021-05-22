import 'package:flutter/material.dart';

class TimerFab extends StatefulWidget {
  const TimerFab({Key key}) : super(key: key);

  @override
  _TimerFabState createState() => _TimerFabState();
}

class _TimerFabState extends State<TimerFab> {
  Color fabColor;
  int endtim;
  @override
  void initState() {
    fabColor = Colors.grey;
    endtim = DateTime.now().millisecondsSinceEpoch + 1000 * 20;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: fabColor,
      icon: Icon(Icons.ac_unit),
      label: Text("10"),
      onPressed: () {
        setState(() {
          fabColor = Colors.grey;
          endtim = DateTime.now().millisecondsSinceEpoch + 1000 * 10;
        });
      },
    );
  }
}
