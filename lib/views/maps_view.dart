import 'dart:async';

import 'package:clone/model/cofee_model.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
    coffeeShops.forEach((element) {
      allMarkers.add(Marker(
          markerId: MarkerId(element.shopName),
          draggable: false,
          onTap: () => _pageController.animateToPage(element.rank - 1,
              duration: Duration(microseconds: 500), curve: Curves.decelerate),
          infoWindow:
              InfoWindow(title: element.shopName, snippet: element.address),
          position: element.locationCoords));
    });
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  _coffeeShopList(index) {
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
        onTap: () {
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
                          avatar: Icon(
                            Icons.call,
                            color: Colors.blue,
                          ),
                          label: Text("Call Now"),
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
    return Scaffold(
      body: Stack(
        children: [
          Text("Search here"),
          GoogleMap(
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
          Positioned(
            bottom: 10.0,
            child: Container(
              height: 200.0,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                controller: _pageController,
                itemCount: coffeeShops.length,
                itemBuilder: (BuildContext context, int index) {
                  return _coffeeShopList(index);
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton.extended(
          onPressed: () {
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
          label: Text('My Location!'),
          icon: Icon(Icons.directions_boat),
        ),
      ),
    );
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
