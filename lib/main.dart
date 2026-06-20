import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/map_screen.dart';
import 'screens/place_details_screen.dart';


void main() {
  runApp(SafeLankaApp());
}


class SafeLankaApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: "SafeLanka",

      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),


      home: HomeScreen(),


      routes: {

        "/map": (context) => MapScreen(),

        "/place": (context) => PlaceDetailsScreen(
          placeName: "City Hospital",
          placeType: "Hospital",
          distance: "0.8 km",
        ),

      },

    );
  }
}