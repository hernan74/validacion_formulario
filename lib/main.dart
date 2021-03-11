import 'package:flutter/material.dart';

import 'package:validacion_formulario/bloc/provider.dart';
import 'package:validacion_formulario/pages/home_page.dart';
import 'package:validacion_formulario/pages/login_page.dart';
import 'package:validacion_formulario/pages/productos_page.dart';
import 'package:validacion_formulario/pages/registro_page.dart';
import 'package:validacion_formulario/preferencia_usuario/preferencia_usuario.dart';

final prefs = new PreferenciasUsuario();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(prefs.token);
    return Provider(
      child: MaterialApp(
        title: 'Validacion formulario',
        debugShowCheckedModeBanner: false,
        initialRoute: (prefs.token.isEmpty) ? 'login' : 'home',
        routes: {
          'login': (_) => Login(),
          'registro': (_) => RegistroPage(),
          'home': (_) => HomePage(),
          'producto': (_) => ProductoPage(),
        },
        theme: ThemeData(primaryColor: Colors.orangeAccent),
      ),
    );
  }
}
