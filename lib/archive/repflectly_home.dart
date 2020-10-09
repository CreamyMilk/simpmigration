import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final PageController ctrl = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: PageView(
              // scrollDirection: Axis.vertical,
              controller: ctrl,
              children: [
            Container(color: Colors.green),
            Container(color: Colors.blue),
            Container(color: Colors.orange),
            Container(color: Colors.red)
          ])),
    );
  }
}

class SlideShow extends StatefulWidget {
  SlideShow({Key key}) : super(key: key);

  @override
  _SlideShowState createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {
  final PageController ctrl = PageController(viewportFraction: 0.8);

  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    ctrl.addListener(() {
      int next = ctrl.page.round();

      if (currentPage != next) {
        currentPage = next;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView(
        controller: ctrl,
        children: [RentCardF(), RentCard(), RentCardF()],
      ),
    );
  }
}

class RentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var active = true;
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(
        top: top,
        bottom: 50,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                "https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX16852705.jpg"),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black87,
                blurRadius: blur,
                offset: Offset(offset, offset))
          ]),
    );
  }
}

class RentCardF extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var active = false;
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutQuint,
      margin: EdgeInsets.only(
        top: top,
        bottom: 50,
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(
                "https://d2gg9evh47fn9z.cloudfront.net/800px_COLOURBOX16852705.jpg"),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.black87,
                blurRadius: blur,
                offset: Offset(offset, offset))
          ]),
    );
  }
}
