import 'package:flutter_google_maps/flutter_google_maps.dart';

const darkMapStyle = r'''
[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#181818"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1b1b1b"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#373737"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3c3c3c"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4e4e4e"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3d3d3d"
      }
    ]
  }
]
''';

const polygon = <GeoCoord>[
  GeoCoord(32.707868, -117.191018),
  GeoCoord(32.705645, -117.191096),
  GeoCoord(32.697756, -117.166664),
  GeoCoord(32.686486, -117.163206),
  GeoCoord(32.675876, -117.169452),
  GeoCoord(32.674726, -117.165233),
  GeoCoord(32.679833, -117.158487),
  GeoCoord(32.677571, -117.153893),
  GeoCoord(32.671987, -117.160079),
  GeoCoord(32.667547, -117.160477),
  GeoCoord(32.654748, -117.147579),
  GeoCoord(32.651933, -117.150312),
  GeoCoord(32.649676, -117.144334),
  GeoCoord(32.631665, -117.138201),
  GeoCoord(32.632033, -117.132249),
  GeoCoord(32.630156, -117.137234),
  GeoCoord(32.628072, -117.136479),
  GeoCoord(32.630315, -117.131443),
  GeoCoord(32.625930, -117.135312),
  GeoCoord(32.623754, -117.131664),
  GeoCoord(32.627465, -117.130883),
  GeoCoord(32.622598, -117.128791),
  GeoCoord(32.622622, -117.133183),
  GeoCoord(32.618690, -117.133634),
  GeoCoord(32.618980, -117.128403),
  GeoCoord(32.609847, -117.132502),
  GeoCoord(32.604198, -117.125333),
  GeoCoord(32.588260, -117.122032),
  GeoCoord(32.591164, -117.116851),
  GeoCoord(32.587601, -117.105968),
  GeoCoord(32.583792, -117.104434),
  GeoCoord(32.570566, -117.101382),
  GeoCoord(32.569256, -117.122378),
  GeoCoord(32.560825, -117.122903),
  GeoCoord(32.557753, -117.131040),
  GeoCoord(32.542737, -117.124883),
  GeoCoord(32.534156, -117.126062),
  GeoCoord(32.563255, -117.134963),
  GeoCoord(32.584055, -117.134263),
  GeoCoord(32.619405, -117.140001),
  GeoCoord(32.655293, -117.157349),
  GeoCoord(32.669944, -117.169624),
  GeoCoord(32.682710, -117.189445),
  GeoCoord(32.685297, -117.208773),
  GeoCoord(32.679814, -117.224882),
  GeoCoord(32.697212, -117.227058),
  GeoCoord(32.707701, -117.219816),
  GeoCoord(32.711931, -117.214107),
  GeoCoord(32.715026, -117.196521),
  GeoCoord(32.713053, -117.189703),
  GeoCoord(32.707868, -117.191018),
];

// LayoutBuilder(
//   builder: (context, constraints) =>
//       constraints.maxWidth < 1000
//           ? Row(children: _buildClearButtons())
//           : Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: _buildClearButtons(),
//             ),
// ),
// List<Widget> _buildClearButtons() => [
//       RaisedButton.icon(
//         color: Colors.red,
//         textColor: Colors.white,
//         icon: Icon(Icons.bubble_chart),
//         label: Text('CLEAR POLYGONS'),
//         onPressed: () {
//           GoogleMap.of(_key).clearPolygons();
//           setState(() => _polygonAdded = false);
//         },
//       ),
//       const SizedBox(width: 16),
//       RaisedButton.icon(
//         color: Colors.red,
//         textColor: Colors.white,
//         icon: Icon(Icons.pin_drop),
//         label: Text('CLEAR MARKERS'),
//         onPressed: () {
//           GoogleMap.of(_key).clearMarkers();
//         },
//       ),
//       const SizedBox(width: 16),
//       RaisedButton.icon(
//         color: Colors.red,
//         textColor: Colors.white,
//         icon: Icon(Icons.directions),
//         label: Text('CLEAR DIRECTIONS'),
//         onPressed: () {
//           GoogleMap.of(_key).clearDirections();
//         },
//       ),
//     ];
