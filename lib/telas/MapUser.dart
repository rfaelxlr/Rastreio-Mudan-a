import 'dart:async';

import 'package:RastreioMudanca/model/DataRastreio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapUser extends StatefulWidget {
  String code;
  MapUser(this.code);
  @override
  _MapUserState createState() => _MapUserState();
}

class _MapUserState extends State<MapUser> {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-8.278126, -35.971968), zoom: 14.47);
  Set<Marker> _markers = {};
  Position _userPosition;
  Position _driverPosition;

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _recoverLastLocation() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() {
      if (position != null) {
        /*_cameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 14.47);*/
        _showUserMarker(position);
      }
    });
  }

  _moveCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  

   _addListenerLocation() {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 5);
    geolocator.getPositionStream(locationOptions).listen((Position position) {
      _showUserMarker(position);
      setState(() {
        _userPosition = position;
      });
     
    });
    
  }

  _addListenerDriverLocation() async {
    String code = widget.code;
    Firestore db = Firestore.instance;
    StreamSubscription<QuerySnapshot> locate = await db
        .collection("users")
        .where(
          "code",
          isEqualTo: code,
        )
        .where("location", isEqualTo: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      if (event.documents.length != 0) {
        DocumentSnapshot dataRastreio = event.documents.first;

        DataRastreio data = DataRastreio();
        data.location = dataRastreio["location"];
        data.latitude = dataRastreio["latitude"];
        data.longitude = dataRastreio["longitude"];
        if (data.location != false) {
          //_cameraPosition = CameraPosition(
              //target: LatLng(data.latitude, data.longitude), zoom: 19);
          _showDriverMarker(LatLng(data.latitude, data.longitude));
          setState(() {
            _driverPosition = Position(latitude: data.latitude,longitude:data.longitude);

           });
          print(data.latitude);

          //_moveCamera(_cameraPosition);
          var nLat,nLon,sLat,sLon;
          if(_driverPosition.latitude <= _userPosition.latitude){
            sLat = _driverPosition.latitude;
            nLat = _userPosition.latitude;
          }else{
            sLat = _userPosition.latitude;
            nLat= _driverPosition.latitude;
          }
          if(_driverPosition.longitude <= _userPosition.longitude){
            sLon = _driverPosition.longitude;
            nLon = _userPosition.longitude;
          }else{
            sLon = _userPosition.longitude;
            nLon= _driverPosition.longitude;
          }
          LatLngBounds latLngBounds = LatLngBounds(
              southwest: LatLng(sLat, sLon),
              northeast: LatLng(nLat, nLon));
          _moveCameraBounds(latLngBounds);
          
        }
      }
    });
  }

  _showUserMarker(Position position) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "images/passageiro.png")
        .then((BitmapDescriptor icone) {
      Marker clientMarker = Marker(
          markerId: MarkerId("Cliente"),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(title: "Cliente"),
          icon: icone);
          
      setState(() {
        _markers.add(clientMarker);
      });
    });
  }

  _showDriverMarker(LatLng latLng) async {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRatio),
            "images/motorista.png")
        .then((BitmapDescriptor icone) {
      Marker driverMarker = Marker(
          markerId: MarkerId("motorista"),
          position: LatLng(latLng.latitude, latLng.longitude),
          infoWindow: InfoWindow(title: "Motorista"),
          icon: icone);
      print(latLng.latitude);
    
      setState(() {
        _markers.add(driverMarker);
        // _moveCamera(CameraPosition(
            //target: LatLng(latLng.latitude, latLng.longitude), zoom: 19));
      });
    });
  }
  _moveCameraBounds(LatLngBounds latLngBounds) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController
        .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 80));
  }

  @override
  void initState() {
    super.initState();
    _recoverLastLocation();
    _addListenerLocation();
    _addListenerDriverLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Localização do motorista"),
      ),
      body: Container(
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _cameraPosition,
          onMapCreated: _onMapCreated,
          myLocationEnabled: false,
          myLocationButtonEnabled: false,
          markers: _markers,
        ),
      ),
    );
  }
}
