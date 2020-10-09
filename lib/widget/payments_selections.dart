import 'package:flutter/material.dart';

class PaymentsChoice extends StatefulWidget {
  PaymentsChoice({Key key}) : super(key: key);

  @override
  _PaymentsChoiceState createState() => _PaymentsChoiceState();
}

class _PaymentsChoiceState extends State<PaymentsChoice> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [],
    );
  }
}

class PaymentTile extends StatefulWidget {
  @override
  _PaymentTileState createState() => _PaymentTileState();
}

class _PaymentTileState extends State<PaymentTile> {
  bool _enabled = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MaterialButton(
          minWidth: 25,
          height: 30,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: _enabled
                  ? BorderSide(color: Colors.red)
                  : BorderSide(color: Colors.grey)),
          elevation: 3.0,
          padding: EdgeInsets.all(10.0),
          color: Colors.white,
          onPressed: () {
            setState(() {
              _enabled = !_enabled;
            });
          },
          child: ColorFiltered(
            colorFilter: _enabled
                ? ColorFilter.mode(
                    Colors.transparent,
                    BlendMode.multiply,
                  )
                : ColorFilter.matrix(<double>[
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
                    0,
                  ]),
            child: Container(
              width: 45,
              height: 35,
              child: Image.asset(
                'assets/mpesa.png',
                fit: BoxFit.scaleDown,
                width: 10,
                height: 5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
