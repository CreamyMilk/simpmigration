import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:simpmigration/constants.dart';
import 'package:simpmigration/providers/gmapsProvider.dart';
import 'package:simpmigration/providers/list_switcher_provider.dart';
import 'package:simpmigration/route_generator.dart';
import 'package:simpmigration/services/geolocation_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  }
  await Hive.openBox(Constants.HiveBoxName);
  runApp(MyApp());
}

final navigationKey = GlobalKey<NavigatorState>();
//Dff

class MyApp extends StatelessWidget {
  final String appTitle = 'Icrib Tenant';
  final GeolocatorService geoService = GeolocatorService();
  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider<ListSwitcherProvider>(
              create: (context) => ListSwitcherProvider()),
          ChangeNotifierProvider<GMapProvider>(
              create: (context) => GMapProvider()),
        ],
        child: MaterialApp(
          title: appTitle,
          debugShowCheckedModeBanner: false,
          navigatorKey: navigationKey,
          theme: ThemeData(
            primaryColor: Colors.black,
            accentColor: Colors.black38,
            scaffoldBackgroundColor: Color(0xFFF3F5F7),
          ),
          darkTheme: ThemeData(
            primaryColor: Colors.black,
            accentColor: Colors.black38,
            scaffoldBackgroundColor: Color(0xFFF3F5F7),
          ),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/',
        ),
      );
}
