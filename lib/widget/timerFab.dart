import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

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
      label: CountdownTimer(
        textStyle: TextStyle(color: Colors.white),
        emptyWidget: Center(
          child: Text("Resend"),
        ),
        onEnd: () {
          setState(() {
            fabColor = Colors.green;
            endtim = 1;
          });
        },
        endTime: endtim,
      ),
      onPressed: () {
        setState(() {
          fabColor = Colors.grey;
          endtim = DateTime.now().millisecondsSinceEpoch + 1000 * 10;
        });
      },
    );
  }
}
