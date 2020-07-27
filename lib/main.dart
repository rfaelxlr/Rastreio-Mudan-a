import 'package:RastreioMudanca/Routes.dart';
import 'package:RastreioMudanca/telas/Home.dart';
import 'package:flutter/material.dart';
final ThemeData temaPadrao = ThemeData(
  primaryColor: Color(0xff37474f),
  accentColor: Color(0xff546e7a), 
);
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home() ,
    theme: temaPadrao,
    initialRoute: "/",
    onGenerateRoute: Routes.gerarRotas,
    
  ));
}

