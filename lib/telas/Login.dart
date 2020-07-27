import 'package:RastreioMudanca/model/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail =
      TextEditingController(text: "teste@hotmail.com");
  TextEditingController _controllerPassword =
      TextEditingController(text: "teste123");
  String _messageError = "";
  bool _carregando = false;
  _validarCampos() {
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (password.isNotEmpty && password.length > 6) {
        User user = User();
        user.email = email;
        user.password = password;

        _logUser(user);
      } else {
        setState(() {
          _messageError = "Preencha a senha! digite mais de 6 caracteres";
        });
      }
    } else {
      setState(() {
        _messageError = "Preencha um E-mail válido";
      });
    }
  }

  _logUser(User user) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    setState(() {
      _carregando = true;
    });
    auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((firebaseUser) {
      _redirecionarPainel();
    }).catchError((error) {
      print("erro");
      _messageError =
          "Erro ao autenticar usuário, verifique e-mail e senha e tente novamente!";
    });
  }

  _redirecionarPainel() {
    setState(() {
      _carregando = false;
    });

    Navigator.pushNamedAndRemoveUntil(context, "/painel-driver", (_) => false);
  }

  _verificarUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    if (user != null) {
      _redirecionarPainel();
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
        body: Container(
      color: Colors.blueGrey,
      padding: EdgeInsets.all(16),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Center(
                    child: Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  controller: _controllerEmail,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      hintText: "e-mail",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50))),
                ),
              ),
              TextField(
                controller: _controllerPassword,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                    hintText: "senha",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50))),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16, bottom: 24),
                child: RaisedButton(
                  onPressed: () {
                    _validarCampos();
                  },
                  child: Text(
                    "Entrar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  color: Color(0xff1ebbd8),
                  padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                ),
              ),
              Center(
                child: GestureDetector(
                  child: Text(
                    "Não tem conta? Cadastre-se!",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, "/register");
                  },
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
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, "/painel-user");
                    },
                    child: Text(
                      "Usuário? entre aqui",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
