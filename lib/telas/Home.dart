import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _login() {
    Navigator.pushNamed(context, "/login");
  }

  _client() {
    Navigator.pushNamed(context, "/painel-user");
  }

  _verificarUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    if (user != null) {
      Navigator.pushReplacementNamed(context, "/painel-driver");
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rastreie sua mudança",
          style: TextStyle(fontSize: 28),
        ),
        toolbarHeight: 200,
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 36),
                child: RaisedButton(
                  onPressed: () {
                    _login();
                  },
                  child: Text(
                    "Login Motorista",
                    style: TextStyle(fontSize: 20),
                  ),
                  color: Colors.blueGrey,
                  textColor: Colors.white,
                  padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
                ),
              ),
              RaisedButton(
                onPressed: () {
                  _client();
                },
                child: Text("Área Cliente", style: TextStyle(fontSize: 20)),
                color: Colors.blueGrey,
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(16, 32, 16, 32),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
