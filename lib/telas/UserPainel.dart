import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserPainel extends StatefulWidget {
  @override
  _UserPainelState createState() => _UserPainelState();
}

class _UserPainelState extends State<UserPainel> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _controllerCod = TextEditingController(text: "KVHAYP");
  String _messageError = "";
  bool _carregando = false;

  _signIn() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signInAnonymously();
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _validarCod() async {
    Firestore db = Firestore.instance;
    QuerySnapshot locate = await db
        .collection("users")
        .where(
          "code",
          isEqualTo: _controllerCod.text,
        )
        .where("location", isEqualTo: true)
        .limit(1)
        .getDocuments()
        .catchError((error) {
      print(error);
    });
    //DocumentSnapshot dataRastreio;
    //for (DocumentSnapshot data in locate.documents) {
    //print(data.data);
    //dataRastreio = data;
    //}
    setState(() {
      _carregando = true;
    });
    if(locate.documents.length == 0){
      setState(() {
        _messageError= "Código inválido ou motorista com localização desativada";
      });
      setState(() {
      _carregando = false;
    });
    }else{
      setState(() {
        _messageError= "";
      });
      setState(() {
      _carregando = false;
    });

    String code = _controllerCod.text;
     _gerarMap(code);
    }
  }

  _gerarMap(String code) {
    Navigator.pushNamed(context, "/map-user",arguments: code);
  }

  @override
  void initState() {
    super.initState();
    _signIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Painel Usuário"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 32),
                child: Text(
                  "Digite o código do motorista: ",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              TextField(
                controller: _controllerCod,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "Código do motorista",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 24),
                child: RaisedButton(
                  onPressed: () {
                    _validarCod();
                  },
                  child: Text(
                    "Rastreiar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Color(0xff1ebbd8),
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                ),
              ),
              _carregando
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    )
                  : Container(),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Center(
                  child: Text(
                    _messageError,
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
