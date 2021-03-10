import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:validacion_formulario/model/producto_model.dart';
import 'package:validacion_formulario/providers/productos_privider.dart';
import 'package:validacion_formulario/utils/number_utils.dart';

class ProductoPage extends StatefulWidget {
  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productoProvider = new ProductosProvider();
  ProductoModel productoModel = new ProductoModel();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    final ProductoModel model = ModalRoute.of(context).settings.arguments;
    if (model != null) {
      productoModel = model;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.image_outlined),
              onPressed: () {
                _procesarImagen(ImageSource.gallery);
              }),
          IconButton(
              icon: Icon(Icons.camera_alt_outlined),
              onPressed: () {
                _procesarImagen(ImageSource.camera);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _campoFoto(),
                SizedBox(
                  height: 15.0,
                ),
                _campoProducto(),
                SizedBox(
                  height: 15.0,
                ),
                _campoPrecio(),
                _campoProductoDisponible(),
                _guardar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoFoto() {
    if (productoModel.fotoUrl != null)
      return Image(
        image: NetworkImage(productoModel.fotoUrl),
      );

    if (foto != null) {
      return Image.file(
        foto,
        fit: BoxFit.cover,
        height: 300.0,
      );
    }
    return Image.asset('assets/no-image.png');
  }

  Widget _campoProducto() {
    return TextFormField(
      initialValue: productoModel.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
        border: OutlineInputBorder(),
      ),
      onSaved: (valor) => productoModel.titulo = valor,
      validator: (valor) {
        if (valor.length < 3) {
          return 'Ingrese un nombre para el producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _campoPrecio() {
    return TextFormField(
      initialValue: productoModel.valor.toString(),
      keyboardType:
          TextInputType.numberWithOptions(decimal: true, signed: false),
      decoration:
          InputDecoration(labelText: 'Precio', border: OutlineInputBorder()),
      onSaved: (valor) => productoModel.valor = double.parse(valor),
      validator: (valor) {
        if (isNumeric(valor)) {
          return null;
        } else {
          return 'Ingrese solo numeros';
        }
      },
    );
  }

  Widget _campoProductoDisponible() {
    return SwitchListTile(
        value: productoModel.disponible,
        activeColor: Colors.orangeAccent,
        title: Text('Disponible'),
        onChanged: (valor) => setState(() {
              productoModel.disponible = valor;
            }));
  }

  Widget _guardar() {
    return ElevatedButton.icon(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(Colors.orangeAccent),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
              EdgeInsets.symmetric(horizontal: 40.0))),
      onPressed: _guardando ? null : _submit,
      icon: Icon(Icons.save_outlined),
      label: Text('Guardar'),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });
    if (foto != null) {
      productoModel.fotoUrl = await productoProvider.subirImagen(foto);
    }
    if (productoModel.id == null) {
      productoProvider.crearProducto(productoModel);
      _mostrarSnackBar('Nuevo Producto agregado');
    } else {
      productoProvider.modificarProducto(productoModel);
      _mostrarSnackBar('Producto Modificado');
    }

    Navigator.pop(context);
  }

  void _mostrarSnackBar(String mensaje) {
    final snack = SnackBar(
      content: Text(
        mensaje,
        style: TextStyle(color: Colors.black, fontSize: 18.0),
      ),
      duration: Duration(milliseconds: 1500),
      backgroundColor: Colors.orangeAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  void _procesarImagen(ImageSource origin) async {
    final _picker = ImagePicker();

    final pickedFile = await _picker.getImage(
      source: origin,
    );
    if (pickedFile == null) return;

    foto = File(pickedFile.path);

    if (foto != null) {
      productoModel.fotoUrl = null;
    }

    setState(() {});
  }
}
