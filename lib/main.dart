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
            brightness: Brightness.light,
            primarySwatch: Colors.indigo,
            primaryColor: Color(0xFF5d5fee),
            scaffoldBackgroundColor: Color(0xFFf8f7fd),
            backgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              elevation: 0,
              brightness: Brightness.light,
              backgroundColor: Colors.transparent,
              textTheme: TextTheme(
                headline6: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              iconTheme: IconThemeData(
                color: Color(0xFF010105),
              ),
            ),
            textTheme: TextTheme(
              headline4: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade900,
              ),
              bodyText2: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade900,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Color(0xFF5d5fee),
                padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.indigo,
            primaryColor: Color(0xFF5d5fee),
            scaffoldBackgroundColor: Color(0xFF0a0a0a),
            backgroundColor: Color(0xFF29292b),
            appBarTheme: AppBarTheme(
              elevation: 0,
              brightness: Brightness.dark,
              backgroundColor: Colors.transparent,
              textTheme: TextTheme(
                headline6: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
            ),
            textTheme: TextTheme(
              headline4: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 16,
              ),
              bodyText2: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Color(0xFF5d5fee),
                padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
          ),
          onGenerateRoute: RouteGenerator.generateRoute,
          initialRoute: '/',
        ),
      );
}
