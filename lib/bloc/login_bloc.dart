import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:validacion_formulario/validators/validator.dart';

class LoginBloc with Validator {
  final _emailController = new BehaviorSubject<String>();
  final _passwordController = new BehaviorSubject<String>();

  //Cargar valores al stream
  Function(String) get emailSink => _emailController.sink.add;
  Function(String) get passwordSink => _passwordController.sink.add;

  //Escuchar valores del stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(emailValidator);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(passwordValidator);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  String get email => _emailController.value;
  String get password => _passwordController.value;
  
  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
