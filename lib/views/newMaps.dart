// Copyright (c) 2020, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:clone/archive/dark_mode_map.dart';
import 'package:clone/model/locations_model.dart';
import 'package:clone/providers/gmapsProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

final _mapkey = GlobalKey<GoogleMapStateBase>();

class NewMap extends StatefulWidget {
  @override
  _NewMapState createState() => _NewMapState();
}

class _NewMapState extends State<NewMap> {
  bool _darkMapStyle = false;
  String _mapStyle;
  List<Marker> allMarkers = [];
  List<ServiceProvider> serviceProviders = [];
  PageController _pageController;
  int prevPage;

  List<Widget> _buildAddButtons() => [
        FloatingActionButton(
          child: Icon(Icons.pin_drop),
          onPressed: () {
            GoogleMap.of(_mapkey).addMarkerRaw(
              GeoCoord(33.875513, -117.550257),
              info: 'test info',
              onInfoWindowTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(
                        'This dialog was opened by tapping on the InfoWindow!'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: Navigator.of(context).pop,
                        child: Text('CLOSE'),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(width: 16),
        FloatingActionButton(
          child: Icon(Icons.directions),
          onPressed: () {
            GoogleMap.of(_mapkey).addDirection(
              'San Francisco, CA',
              'San Jose, CA',
              startLabel: '1',
              startInfo: 'San Francisco, CA',
              endIcon: 'assets/images/map-marker-warehouse.png',
              endInfo: 'San Jose, CA',
            );
          },
        ),
      ];

  @override
  void initState() {
    final _store = Provider.of<GMapProvider>(context, listen: false);
    serviceProviders = _store.serviceProviderShops;
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);

    super.initState();
  }

  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  moveCamera() async {
    final target =
        serviceProviders[_pageController.page.toInt()].locationCoords;

    GoogleMap.of(_mapkey).moveCamera(target);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Services Map'),
        ),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: GoogleMap(
                key: _mapkey,
                markers: {
                  Marker(
                    GeoCoord(34.0469058, -118.3503948),
                  ),
                },
                initialZoom: 12,
                initialPosition:
                    GeoCoord(34.0469058, -118.3503948), // Los Angeles, CA
                mapType: MapType.roadmap,
                mapStyle: _mapStyle,
                interactive: true,
                onTap: (coord) => print(coord?.toString()),
                mobilePreferences: const MobileMapPreferences(
                  trafficEnabled: true,
                  zoomControlsEnabled: false,
                ),
                webPreferences: WebMapPreferences(
                  fullscreenControl: true,
                  zoomControl: true,
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: FloatingActionButton(
                mini: true,
                child: Icon(Icons.person_pin_circle),
                onPressed: () {
                  final bounds = GeoCoordBounds(
                    northeast: GeoCoord(34.021307, -117.432317),
                    southwest: GeoCoord(33.835745, -117.712785),
                  );
                  GoogleMap.of(_mapkey).moveCameraBounds(bounds);
                  GoogleMap.of(_mapkey).addMarkerRaw(
                    GeoCoord(
                      (bounds.northeast.latitude + bounds.southwest.latitude) /
                          2,
                      (bounds.northeast.longitude +
                              bounds.southwest.longitude) /
                          2,
                    ),
                    onTap: (markerId) async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Text(
                            'This dialog was opened by tapping on the marker!\n'
                            'Marker ID is $markerId',
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: Navigator.of(context).pop,
                              child: Text('CLOSE'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Positioned(
              top: 16,
              right: kIsWeb ? 60 : 16,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  if (_darkMapStyle) {
                    GoogleMap.of(_mapkey).changeMapStyle(null);
                    _mapStyle = null;
                  } else {
                    GoogleMap.of(_mapkey).changeMapStyle(darkMapStyle);
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
              left: 16,
              right: kIsWeb ? 60 : 16,
              bottom: 20,
              child: Row(
                children: <Widget>[
                  Spacer(),
                  ..._buildAddButtons(),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 2,
              right: 2,
              child: ServiceCardLocation(
                pageControllerLocal: _pageController,
              ),
            )
          ],
        ),
      );
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
          storeP.serviceProviderShops.forEach((element) {
            return GoogleMap.of(_mapkey).addMarkerRaw(
              element.locationCoords,
              label: element.shopName,
              info: element.address,
              onTap: (String p) {
                {
                  pageControllerLocal.animateToPage(element.rank - 1,
                      duration: Duration(microseconds: 900),
                      curve: Curves.decelerate);
                }
              },
              onInfoWindowTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Text(
                        'This dialog was opened by tapping on the InfoWindow!'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: Navigator.of(context).pop,
                        child: Text('CLOSE'),
                      ),
                    ],
                  ),
                );
              },
            );
          });
          return PageView.builder(
              controller: pageControllerLocal,
              itemCount: storeP.serviceProviderShops.length,
              itemBuilder: (BuildContext context, int index) {
                return PersonalServiceCard(
                    index: index, pController: pageControllerLocal);
              });
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
