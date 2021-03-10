import 'package:flutter/material.dart';
import 'package:validacion_formulario/model/producto_model.dart';
import 'package:validacion_formulario/providers/productos_privider.dart';

class HomePage extends StatelessWidget {
  final productosProvider = new ProductosProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(child: _listado()),
      floatingActionButton: _crearBotonFlotante(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _listado() {
    return FutureBuilder(
        future: productosProvider.cargarProductos(),
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
                              context: context, model: snapshot.data[i]),
                              SizedBox(height: 20.0,)
                        ],
                      );
                    }));
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget _crearItemLista({BuildContext context, ProductoModel model}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('producto', arguments: model);
      },
      child: Dismissible(
        key: UniqueKey(),
        onDismissed: (DismissDirection dir) {
          productosProvider.borrarProducto(model.id);
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

  Widget _crearBotonFlotante(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.orangeAccent,
        child: Icon(Icons.shopping_cart_outlined),
        onPressed: () {
          Navigator.of(context).pushNamed('producto');
        });
  }
}
