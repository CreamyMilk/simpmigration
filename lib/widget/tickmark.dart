import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Tick extends StatefulWidget {
  @override
  _TickState createState() => _TickState();
}

class _TickState extends State<Tick> {
  bool _animationswitch;

  @override
  void initState() {
    super.initState();
    _animationswitch = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Container(
            child: AspectRatio(
              aspectRatio: 2.5,
              child: FlareActor(
                'assets/tick.flr',
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: _animationswitch ? "go" : 'idle',
              ),
            ),
          ),
          onTap: () {
            setState(() {
              _animationswitch = !_animationswitch;
              print(_animationswitch);
            });
          },
        ),
        Text("Your Transaction was successful",
            style: TextStyle(
              color: Colors.green,
              fontSize: 12,
            )),
      ],
    );
  }
}
