import 'package:flutter/material.dart';
import 'dart:async';
import 'package:dima_colombo_ghiazzi/ViewModel/MapViewModel.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Body extends StatefulWidget {
  final MapViewModel mapViewModel;

  Body({Key key, @required this.mapViewModel}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  StreamSubscription<Position> subscriber;
  Position userLocation;

  @override
  void initState() {
    super.initState();
    //subscriber = subscribeToViewModel();
    widget.mapViewModel.uploadPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Center(
          child: StreamBuilder<Position>(
              stream: widget.mapViewModel.position,
              builder: (context, snapshot) {
                return snapshot.data == null
                    ? CircularProgressIndicator()
                    : GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              snapshot.data.latitude, snapshot.data.longitude),
                          zoom: 16,
                        ),
                        myLocationButtonEnabled: true,
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          widget.mapViewModel.mapController
                              .complete(controller);
                        });
              })),
      Positioned(
          top: 60,
          right: 15,
          left: 15,
          child: Container(
              color: Colors.white,
              child: Row(children: <Widget>[
                IconButton(
                  splashColor: Colors.grey,
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.go,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 15),
                        hintText: "Search..."),
                  ),
                ),
              ])))
    ]);
  }

  /*StreamSubscription<Position> subscribeToViewModel() {
    return widget.mapViewModel.position.listen((userPosition) {
      if (userPosition != null) {
        userLocation = userPosition;
      }
    });
  }*/

  @override
  void dispose() {
    subscriber.cancel();
    super.dispose();
  }
}