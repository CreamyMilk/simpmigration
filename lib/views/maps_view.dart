import 'dart:async';
import 'dart:convert';
import 'package:app_settings/app_settings.dart';
import 'package:clone/model/services_http_model.dart';
import 'package:http/http.dart' as http;
import 'package:clone/model/cofee_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

class MapSample extends StatefulWidget {
  final Position initialPosition;
  MapSample({
    Key key,
    @required this.initialPosition,
  }) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();

  List<Marker> allMarkers = [];
  PageController _pageController;
  int prevPage;
  @override
  void initState() {
    super.initState();
    makeShops();

    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  _coffeeShopList(index, panelCon) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 225.0,
            width: Curves.easeInOut.transform(value) * 450.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
        onDoubleTap: () {
          panelCon.animatePanelToPosition(0.9);
          //moveCamera();
        },
        child: Stack(
          children: [
            Center(
              child: Container(
                height: 150.0,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        offset: Offset(0.0, 4.0),
                        blurRadius: 10.0,
                      ),
                    ]),
                child: Container(
                  padding: EdgeInsets.only(left: 16.0, top: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coffeeShops[index].shopName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 5),
                      Text(
                        coffeeShops[index].address,
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey),
                      ),
                      SizedBox(height: 2),
                      Container(
                        width: 200.0,
                        child: Text(
                          coffeeShops[index].description,
                          style: TextStyle(
                              fontSize: 11.0, fontWeight: FontWeight.w300),
                        ),
                      ),
                      Spacer(),
                      Container(
                        child: InputChip(
                          backgroundColor: Colors.white,
                          avatar: Icon(
                            Icons.call,
                            color: Colors.blue,
                          ),
                          label: Text("Call"),
                          onPressed: () async {
                            final url = coffeeShops[index].contact;
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final PanelController panellConteoller = PanelController();
    return Scaffold(
      body: Stack(
        children: [
          SlidingUpPanel(
            color: Colors.transparent,
            controller: panellConteoller,
            boxShadow: [],
            maxHeight: MediaQuery.of(context).size.height * .24,
            minHeight: MediaQuery.of(context).size.height * .11,
            panel: SingleChildScrollView(
              child: Container(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: ValueListenableBuilder(
                  valueListenable: Hive.box('serves').listenable(),
                  builder: (context, box, widget) {
                    coffeeShops.forEach((element) {
                      allMarkers.add(Marker(
                          markerId: MarkerId(element.shopName),
                          draggable: false,
                          onTap: () => _pageController.animateToPage(
                              element.rank - 1,
                              duration: Duration(microseconds: 500),
                              curve: Curves.decelerate),
                          infoWindow: InfoWindow(
                              title: element.shopName,
                              snippet: element.address),
                          position: element.locationCoords));
                    });
                    return PageView.builder(
                        controller: _pageController,
                        itemCount: coffeeShops.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _coffeeShopList(index, panellConteoller);
                        });
                  },
                ),
              ),
            ),
            body: GoogleMap(
                markers: Set.from(allMarkers),
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                mapToolbarEnabled: false,
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                    bearing: 192.8334901395799,
                    target: LatLng(widget.initialPosition.latitude,
                        widget.initialPosition.longitude),
                    tilt: 59.440717697143555,
                    zoom: 16),
                onMapCreated: mapCreated),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: ChoiceChips(
                panelCon: panellConteoller,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          mini: true,
          onPressed: () {
            _goToTheLake(widget.initialPosition.latitude,
                widget.initialPosition.longitude);
            setState(() {
              allMarkers.clear();
              coffeeShops.forEach((element) {
                allMarkers.add(Marker(
                    markerId: MarkerId(element.shopName),
                    draggable: false,
                    onTap: () => _pageController.animateToPage(element.rank - 1,
                        duration: Duration(microseconds: 500),
                        curve: Curves.decelerate),
                    infoWindow: InfoWindow(
                        title: element.shopName, snippet: element.address),
                    position: element.locationCoords));
                allMarkers = allMarkers;
              });
            });

            panellConteoller.animatePanelToPosition(0.01);
            addFakeService();

            _goToTheLake(widget.initialPosition.latitude,
                widget.initialPosition.longitude);
            // showBottomSheet(
            //   context: context,
            //   builder: (BuildContext context) {
            //     return Container(
            //       color: Colors.redAccent,
            //       height: MediaQuery.of(context).size.height * 0.225,
            //     );
            //   },
            // );
            print('me');
          },
          //label: Text('My Location!'),
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }

  Future<void> addFakeService() async {
    var serveBox = Hive.box("serves");
    List<dynamic> servicesJson = [
      {
        "rank": "1",
        "shopName": "NEW available",
        "address": "NhcLangata",
        "contact": "0797678252",
        "description": "Available from 10 to 2",
        "Lat": "10.00",
        "Long": "50.00"
      }
    ];
    //List<dynamic> servicesJson = serveBox.get("services",defaultValue:[]);
    serveBox.put("servicesD", servicesJson);
  }

  Future<void> _goToTheLake(double lat, double long) async {
    final GoogleMapController controller = await _controller.future;
    final CameraPosition _kLake = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(lat, long),
        tilt: 59.4407176000097143555,
        zoom: 19.151926040649414);
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void mapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void rerenderMarkers(GoogleMapController controller) async {}
  moveCamera() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: coffeeShops[_pageController.page.toInt()].locationCoords,
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));

    controller.showMarkerInfoWindow(
        MarkerId(coffeeShops[_pageController.page.toInt()].shopName));
  }
}

class ChoiceChips extends StatefulWidget {
  final PanelController panelCon;
  ChoiceChips({@required this.panelCon});
  @override
  _ChoiceChipsState createState() => _ChoiceChipsState();
}

class _ChoiceChipsState extends State<ChoiceChips> {
  int indexSelected = -1;
  List<String> services = ["Gas", "Washing", "Gorceries"];
  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      for (final service in services)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChoiceChip(
              selectedColor: Colors.lightBlue[50],
              label: Text(service,
                  style: TextStyle(
                      color: indexSelected == services.indexOf(service)
                          ? Colors.blue
                          : Colors.black)),
              selected: indexSelected == services.indexOf(service),
              onSelected: (value) {
                //Do a lookup for all services that feet the criteria
                getServices(value, "0", "0", context);
                widget.panelCon.animatePanelToPosition(0.01);
                setState(() {
                  indexSelected = value ? services.indexOf(service) : -1;
                });
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
    ]);
  }
}

Future getServices(serviceName, lat, long, context) async {
  final serveBox = Hive.box('serves');
  ServicesNet data;
  print('Service requested for is  $serviceName');
  if (serviceName != null) {
    print("Got Data from api");
    try {
      final response = await http.post(
        ("http://192.168.0.13:9003/" + "service"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        },
        body: jsonEncode(
          {'name': serviceName, 'lat': lat, 'long': long},
        ),
      );
      var myjson = json.decode(response.body);
      data = ServicesNet.fromJson(myjson);
      var t = data.toJson();
      serveBox.put("servicesD", t["servicesArray"]);
      makeShops();
    } catch (SocketException) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Network error."),
                actions: [
                  MaterialButton(
                      color: Colors.black,
                      onPressed: () {
                        AppSettings.openWIFISettings();
                      },
                      child: Text("Turn on",
                          style: TextStyle(color: Colors.white)))
                ],
              ));
    }
  }
}
//*148*1*9228#
