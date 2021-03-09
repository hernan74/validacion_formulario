import 'package:flutter/material.dart';
import 'package:validacion_formulario/bloc/login_bloc.dart';

class Provider extends InheritedWidget {

  
  final loginBloc = new LoginBloc();

  Provider({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }
}
