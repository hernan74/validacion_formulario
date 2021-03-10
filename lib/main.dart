import 'package:flutter/material.dart';
import 'package:validacion_formulario/bloc/provider.dart';
import 'package:validacion_formulario/pages/home_page.dart';
import 'package:validacion_formulario/pages/login_page.dart';
import 'package:validacion_formulario/pages/productos_page.dart';
import 'package:validacion_formulario/pages/registro_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Validacion formulario',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login'   : (_) => Login(),
          'registro': (_) => RegistroPage(),
          'home'    : (_) => HomePage(),
          'producto': (_) => ProductoPage(),
        },
        theme: ThemeData(primaryColor: Colors.orangeAccent),
      ),
    );
  }
}
