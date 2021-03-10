import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:validacion_formulario/model/producto_model.dart';

class ProductosProvider {
  final String _urlFireBase =
      'flutter-varios-c0dcf-default-rtdb.firebaseio.com';
  final String _urlCloudinary =
      'https://api.cloudinary.com/v1_1/dmbiaibqc/image/upload?upload_preset=qdb9qe06';

  Future<bool> crearProducto(ProductoModel productoModel) async {
    final url = Uri.https(_urlFireBase, '/productos.json');

    final resp = await http.post(url, body: productoModelToJson(productoModel));

    final decodeData = json.decode(resp.body);

    return true;
  }

  Future<bool> modificarProducto(ProductoModel productoModel) async {
    final url = Uri.https(_urlFireBase, '/productos/${productoModel.id}.json');

    final resp = await http.put(url, body: productoModelToJson(productoModel));

    final decodeData = json.decode(resp.body);

    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = Uri.https(_urlFireBase, '/productos.json');

    final resp = await http.get(url);

    final Map<String, dynamic> decodeData = json.decode(resp.body);

    if (decodeData == null) return [];

    List<ProductoModel> lista = [];

    decodeData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;
      lista.add(prodTemp);
    });
    return lista;
  }

  Future<int> borrarProducto(String id) async {
    final url = Uri.https(Uri.encodeFull(_urlFireBase), '/productos/$id.json');

    final resp = await http.delete(url);

    final decodeData = json.decode(resp.body);

    return 1;
  }

  Future<String> subirImagen(File imagen) async {
    //De este modo no se puede cargar la url. Utilizar Uri.parse
   // final url = Uri.https(Uri.encodeFull(_urlCloudinary),'');
    final mineType = mime(imagen.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST',Uri.parse(_urlCloudinary));

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mineType[0], mineType[1]));
    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salio mal');
      print(resp.body);
      return null;
    }
    final respData = json.decode(resp.body);
    print(respData['secure_url']);

    return respData['secure_url'];
  }
}
