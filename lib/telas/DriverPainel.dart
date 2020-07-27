import 'dart:async';

import 'package:RastreioMudanca/model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:location/location.dart';

class DriverPainel extends StatefulWidget {
  @override
  _DriverPainelState createState() => _DriverPainelState();
}

class _DriverPainelState extends State<DriverPainel> {
  List<String> itemsMenu = ["Configurações", "Deslogar"];
  Firestore db = Firestore.instance;
  String _name = "";
  String _code = "";
  Color _color = Colors.lightBlue;
  String _btnText = "Ativar Localização";
  //Location _locationTracker = Location();
  StreamSubscription _locationSubscription;
  _deslogarUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    //FirebaseUser userAuth = await auth.currentUser();
    //db
    //.collection("users")
    //.document(userAuth.uid)
    //  .updateData({"location": false});

    auth.signOut();
    Navigator.pushReplacementNamed(context, "/login");
  }

  _escolhaMenuItem(String escolha) {
    switch (escolha) {
      case "Deslogar":
        _deslogarUser();
        break;
      case "Configurações":
        break;
    }
  }

  _userData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userAuth = await auth.currentUser();

    DocumentSnapshot userData =
        await db.collection("users").document(userAuth.uid).get();
    if (!userData.exists) {
      auth.signOut();
      Navigator.pushNamedAndRemoveUntil(context, "/", (_) => false);
    } else {
      User user = User();
      user.name = userData["name"];
      user.cod = userData["code"];
      if (userData["location"] == null) {
        setState(() {
          _color = Colors.lightBlue;
          _btnText = "Ativar Localização";
        });
      } else {
        if (userData["location"] == true) {
          setState(() {
            _color = Colors.red;
            _btnText = "Desativar Localização";
          });
        }
      }
      setState(() {
        _name = user.name;
        _code = user.cod;
      });
    }
  }

  _addListenerLocation() async {
    var geolocator = Geolocator();
    var locationOptions =
        LocationOptions(accuracy: LocationAccuracy.best, distanceFilter: 3);
    geolocator
        .getPositionStream(locationOptions)
        .listen((Position position) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseUser userAuth = await auth.currentUser();
      db.collection("users").document(userAuth.uid).updateData(
          {"longitude": position.longitude, "latitude": position.latitude});
    });
    /*var location = await _locationTracker.getLocation();
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseUser userAuth = await auth.currentUser();
      db.collection("users").document(userAuth.uid).updateData(
          {"longitude": location.longitude, "latitude": location.latitude});
    

    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }

    _locationSubscription =
        _locationTracker.onLocationChanged.listen((newLocalData) async {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseUser userAuth = await auth.currentUser();
      db.collection("users").document(userAuth.uid).updateData(
          {"longitude": newLocalData.longitude, "latitude": newLocalData.latitude});
    });*/
  }

  _localization() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser userAuth = await auth.currentUser();
    DocumentSnapshot userDb =
        await db.collection("users").document(userAuth.uid).get();
    bool isActive = userDb["location"];
    if (isActive == false) {
      db
          .collection("users")
          .document(userAuth.uid)
          .updateData({"location": true});
      setState(() {
        _color = Colors.red;
        _btnText = "Desativar Localização";
      });
      _addListenerLocation();
    } else {
      db
          .collection("users")
          .document(userAuth.uid)
          .updateData({"location": false});
      setState(() {
        _color = Colors.lightBlue;
        _btnText = "Ativar Localização";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _userData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel motorista"),
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itemsMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Text(
                "Olá " + _name,
                style: TextStyle(fontSize: 20),
              )),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("Seu código é " + _code),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: RaisedButton(
                  onPressed: () {
                    _localization();
                  },
                  color: _color,
                  child: Text(
                    _btnText,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
