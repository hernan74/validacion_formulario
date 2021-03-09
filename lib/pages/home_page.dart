import 'package:flutter/material.dart';
import 'package:validacion_formulario/bloc/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(bloc.email==null?'':bloc.email),
            Text(bloc.password==null?'':bloc.password)
          ],
        ),
      ),
    );
  }
}
