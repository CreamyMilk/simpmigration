import 'package:clone/archive/dark_mode_map.dart';
import 'package:clone/model/locations_model.dart';
import 'package:clone/providers/gmapsProvider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
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
  GoogleMapController gcontrol;
  List<ServiceProvider> serviceProviders = [];
  List<Marker> allMarkers = [];
  PageController _pageController;
  bool _darkMapStyle = true;
  int prevPage;
  String _mapStyle;

  @override
  void initState() {
    final _store = Provider.of<GMapProvider>(context, listen: false);
    serviceProviders = _store.serviceProviderShops;
    allMarkers = _store.markers;
    _store.addStoredMarkers(_pageController);
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      print(_mapStyle);
      moveCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<GMapProvider>(builder: (context, storeP, child) {
          return Text('${storeP.chosenservice} near you');
        }),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
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
          Positioned(
            top: 16,
            left: 16,
            child: FloatingActionButton(
              mini: true,
              child: Icon(Icons.person_pin_circle),
              onPressed: () {
                final CameraPosition _kLake = CameraPosition(
                    bearing: 192.8334901395799,
                    target: LatLng(widget.initialPosition.latitude,
                        widget.initialPosition.longitude),
                    tilt: 59.4407176000097143555,
                    zoom: 19.151926040649414);
                gcontrol.animateCamera(CameraUpdate.newCameraPosition(_kLake));
              },
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              onPressed: () async {
                if (_darkMapStyle) {
                  gcontrol.setMapStyle(null);

                  _mapStyle = null;
                } else {
                  gcontrol.setMapStyle(darkMapStyle);
                  _mapStyle = darkMapStyle;
                }
                setState(() => _darkMapStyle = !_darkMapStyle);
              },
              backgroundColor: _darkMapStyle ? Colors.black : Colors.white,
              child: Icon(
                _darkMapStyle ? Icons.wb_sunny : Icons.brightness_3,
                color: _darkMapStyle ? Colors.white : Colors.black,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 2,
            right: 2, //New Service card
            child: ServiceCardLocation(
              pageControllerLocal: _pageController,
            ),
          ),
        ],
      ),
    );
  }

  void mapCreated(GoogleMapController controller) async {
    gcontrol = controller;
    gcontrol.setMapStyle(null);
  }

  void rerenderMarkers(GoogleMapController controller) async {}
  moveCamera() {
    gcontrol.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: serviceProviders[_pageController.page.toInt()].locationCoords,
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));

    gcontrol.showMarkerInfoWindow(
        MarkerId(serviceProviders[_pageController.page.toInt()].shopName));
  }
}

class ServiceCardLocation extends StatelessWidget {
  final PageController pageControllerLocal;

  const ServiceCardLocation({Key key, @required this.pageControllerLocal})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      child: Consumer<GMapProvider>(
        builder: (context, storeP, child) {
          return PageView.builder(
            controller: pageControllerLocal,
            itemCount: storeP.serviceProviderShops.length,
            itemBuilder: (BuildContext context, int index) {
              return PersonalServiceCard(
                index: index,
                pController: pageControllerLocal,
              );
            },
          );
        },
      ),
    );
  }
}

class PersonalServiceCard extends StatelessWidget {
  const PersonalServiceCard({Key key, this.pController, this.index})
      : super(key: key);
  final PageController pController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (pController.position.haveDimensions) {
          value = pController.page - index;
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
          print("Yeah");
          //moveCamera();
        },
        child: Consumer<GMapProvider>(builder: (context, storeP, child) {
          return Stack(
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
                          storeP.serviceProviderShops[index].shopName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 5),
                        Text(
                          storeP.serviceProviderShops[index].address,
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                        SizedBox(height: 2),
                        Container(
                          width: 200.0,
                          child: Text(
                            storeP.serviceProviderShops[index].description,
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
                              final url =
                                  storeP.serviceProviderShops[index].contact;
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
          );
        }),
      ),
    );
  }
}
