import 'package:flutter/material.dart';
import 'package:validacion_formulario/bloc/login_bloc.dart';
import 'package:validacion_formulario/bloc/provider.dart';
import 'package:validacion_formulario/providers/usuario_provider.dart';

class RegistroPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.white,
        child: Stack(children: [
          _fondo(context),
          _crearFormularioLogin(context),
        ]),
      ),
    );
  }

//Fondo para el login que se divide en 2 mitades una de un color naranja y otra de blanco
  Widget _fondo(BuildContext context) {
    return Column(children: [
      Stack(
        children: [
          //Color de fondo
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.orange.shade800, Colors.orange.shade200])),
          ),
          _crearCirculoFondo(100.0, 30, null),
          _crearCirculoFondo(-30, null, -20),

          _crearLogo()
        ],
      )
    ]);
  }

  Widget _crearCirculoFondo(double top, double left, double right) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white24,
        ),
      ),
    );
  }

  Widget _crearLogo() {
    return Container(
      height: 300.0,
      width: 400.0,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.supervised_user_circle_rounded,
                size: 100, color: Colors.white),
            Text(
              'Crear Cuenta',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _crearFormularioLogin(BuildContext context) {
    final bloc = Provider.of(context);

    return Center(
      child: Container(
        width: 350.0,
        height: 370.0,
        child: Card(
          elevation: 100.0,
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Registrarme',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
                SizedBox(
                  height: 20.0,
                ),
                _crearCampoTexto(
                    stream: bloc.emailStream,
                    sink: bloc.emailSink,
                    labelText: 'Correo Electronico',
                    icon: Icons.alternate_email_outlined,
                    obscureText: false),
                SizedBox(
                  height: 20,
                ),
                _crearCampoTexto(
                    stream: bloc.passwordStream,
                    sink: bloc.passwordSink,
                    labelText: 'Contraseña',
                    icon: Icons.lock_outlined,
                    obscureText: true),
                SizedBox(
                  height: 10.0,
                ),
                _crearBotonRegistro(
                    'Crear Cuenta', Colors.black, Colors.orangeAccent, bloc),
                _crearBotonLogin(context),
                SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _crearCampoTexto(
      {@required Stream<String> stream,
      @required Function(String) sink,
      @required String labelText,
      @required IconData icon,
      @required bool obscureText}) {
    return StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return TextField(
            obscureText: obscureText,
            decoration: InputDecoration(
                prefixIcon: Icon(
                  icon,
                  color: Colors.orangeAccent,
                ),
                border: OutlineInputBorder(),
                labelText: labelText,
                counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: sink,
          );
        });
  }

  Widget _crearBotonRegistro(
      String titulo, Color colorTexto, Color colorBoton, LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return ElevatedButton.icon(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  snapshot.hasData ? colorBoton : Colors.blueGrey,
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 40.0))),
            onPressed: snapshot.hasData
                ? () {
                    _login(context, bloc);
                  }
                : null,
            icon: Icon(Icons.login),
            label: Text(titulo,
                style: TextStyle(
                  color: colorTexto,
                )),
          );
        });
  }

  Widget _crearBotonLogin(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(
            1,
          ),
          backgroundColor: MaterialStateProperty.all<Color>(
            Colors.white,
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 65.0))),
      onPressed: () => Navigator.of(context).pushReplacementNamed('login'),
      icon: Icon(
        Icons.login,
        color: Colors.black87,
      ),
      label: Text('Login',
          style: TextStyle(
            color: Colors.black87,
          )),
    );
  }

  _login(BuildContext context, LoginBloc bloc) async {
    Map<String, dynamic> resp = await usuarioProvider.nuevoUsuario(
        email: bloc.email, password: bloc.password);
    if (resp['ok'] == true) Navigator.of(context).pushReplacementNamed('home');
    else{
         final snack = SnackBar(
      content: Text(
        resp['mensaje'],
        style: TextStyle(color: Colors.black, fontSize: 18.0),
      ),
      duration: Duration(milliseconds: 1500),
      backgroundColor: Colors.orangeAccent,
    );
     ScaffoldMessenger.of(context).showSnackBar(snack);
    }

  }
}
