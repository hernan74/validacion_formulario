import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:validacion_formulario/model/producto_model.dart';
import 'package:validacion_formulario/providers/productos_privider.dart';

class ProductosBloc {
  final _productosController = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosProvider = new ProductosProvider();

  Stream<List<ProductoModel>> get productosController =>
      _productosController.stream;

  Stream<bool> get cargandoController => _cargandoController.stream;

  void cargarProductos() async {
    final listaProductos = await _productosProvider.cargarProductos();
    _productosController.sink.add(listaProductos);
  }

  void nuevoProducto(ProductoModel model) async {
    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto(model);

    _cargandoController.sink.add(true);
  }

  void modificarProducto(ProductoModel model) async {
    _cargandoController.sink.add(true);
    await _productosProvider.modificarProducto(model);
    _cargandoController.sink.add(true);
  }

  void eliminarProducto(String id) async {
    await _productosProvider.borrarProducto(id);
  }

  Future<String> subirFoto(File foto) async {
    _cargandoController.sink.add(true);
    await _productosProvider.subirImagen(foto);
    _cargandoController.sink.add(true);
  }

  void dispose() {
    _productosController.close();
    _cargandoController.close();
  }
}
