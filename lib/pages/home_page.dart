import 'package:flutter/material.dart';
import 'package:validacion_formulario/bloc/provider.dart';
import 'package:validacion_formulario/model/producto_model.dart';
import 'package:validacion_formulario/preferencia_usuario/preferencia_usuario.dart';

class HomePage extends StatelessWidget {
  final preferenciasUsuario = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            preferenciasUsuario.token = '';
            Navigator.of(context).pushReplacementNamed('login');
          },
        ),
      ),
      body: Center(child: _listado(productosBloc)),
      floatingActionButton: _crearBotonFlotante(context,productosBloc),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _listado(ProductosBloc productosBloc) {
    return StreamBuilder(
        stream: productosBloc.productosController,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            return Container(
                padding: EdgeInsets.all(15.0),
                child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, i) {
                      return Column(
                        children: [
                          _crearItemLista(
                              context: context,
                              model: snapshot.data[i],
                              productosBloc: productosBloc),
                          SizedBox(
                            height: 20.0,
                          )
                        ],
                      );
                    }));
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _crearItemLista(
      {BuildContext context,
      ProductoModel model,
      ProductosBloc productosBloc}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('producto', arguments: model);
      },
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (DismissDirection dir) {
          productosBloc.eliminarProducto(model.id);
        },
        background: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.deepOrange.shade400),
        ),
        child: Card(
          elevation: 10.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              _cargarImagen(model),
              ListTile(
                title: Text(model.titulo),
                subtitle: Text(model.valor.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cargarImagen(ProductoModel model) {
    if (model.fotoUrl == null)
      return Image(
        image: AssetImage('assets/no-image.png'),
        fit: BoxFit.cover,
        height: 200.0,
        width: double.infinity,
      );
    return ClipRect(
      child: FadeInImage(
        image: NetworkImage(model.fotoUrl),
        placeholder: AssetImage('assets/cargando.gif'),
        fit: BoxFit.cover,
        height: 200.0,
        width: double.infinity,
      ),
    );
  }

  Widget _crearBotonFlotante(BuildContext context,ProductosBloc productosBloc) {
    return FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.shopping_cart_outlined),
        onPressed: () {
          Navigator.of(context).pushNamed('producto').whenComplete(() =>productosBloc.cargarProductos());
        
        });
  }
}
