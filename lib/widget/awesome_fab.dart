import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AwesomeFAB extends StatelessWidget {
  const AwesomeFAB({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          backgroundColor: Colors.deepOrange,
          onTap: () => print('Pay Rent'),
          label: 'Pay Rent',
          labelStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.deepOrangeAccent,
        ),
        SpeedDialChild(
          child: Icon(Icons.brush, color: Colors.white),
          backgroundColor: Colors.green,
          onTap: () => print('Receipts'),
          label: 'Receipts',
          labelStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.green,
        ),
        SpeedDialChild(
          child: Icon(Icons.map, color: Colors.white),
          backgroundColor: Colors.blue,
          onTap: () => print('Receipts'),
          label: 'Services',
          labelStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
          labelBackgroundColor: Colors.blue,
        ),
        // SpeedDialChild(
        //   child: Icon(Icons.map, color: Colors.white),
        //   backgroundColor: Colors.blue,
        //   onTap: () => print('THIRD CHILD'),
        //   labelWidget: Container(
        //     color: Colors.blueGrey,
        //     margin: EdgeInsets.only(right: 10),
        //     padding: EdgeInsets.all(6),
        //     child: Text('Service Map', style: TextStyle(color: Colors.white)),
        //   ),
        // ),
      ],
    );
  }
}

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
