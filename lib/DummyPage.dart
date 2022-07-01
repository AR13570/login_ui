import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  String long, lat;
  Home({required this.long, required this.lat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text("Longitute: $long\nLatitude: $lat")),
      ),
    );
  }
}
