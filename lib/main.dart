import 'package:flutter/material.dart';
import 'package:validacion_formulario/bloc/provider.dart';
import 'package:validacion_formulario/pages/home_page.dart';
import 'package:validacion_formulario/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Validacion formulario',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {'login': (_) => Login(), 'home': (_) => HomePage()},
        theme: ThemeData(
          primaryColor: Colors.orangeAccent
        ),
      ),
    );
  }
}
