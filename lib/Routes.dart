import 'package:RastreioMudanca/telas/DriverPainel.dart';
import 'package:RastreioMudanca/telas/Login.dart';
import 'package:RastreioMudanca/telas/MapUser.dart';
import 'package:RastreioMudanca/telas/Register.dart';
import 'package:RastreioMudanca/telas/UserPainel.dart';
import 'package:flutter/material.dart';

import 'telas/Home.dart';

class Routes {
  static Route<dynamic> gerarRotas(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (context) => Home());
        break;
      case "/register":
        return MaterialPageRoute(builder: (context) => Register());
        break;
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
        break;
      case "/painel-driver":
        return MaterialPageRoute(builder: (_) => DriverPainel());
        break;
      case "/painel-user":
        return MaterialPageRoute(builder: (_) => UserPainel());
        break;
      case "/map-user":
        return MaterialPageRoute(builder: (_) => MapUser(args));
        break;

      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(title: Text("Tela não encontrada!")),
        body: Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
