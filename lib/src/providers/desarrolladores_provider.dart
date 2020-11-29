import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:kome_on/src/models/desarrollador_model.dart';
import 'package:mime_type/mime_type.dart';

class DesarrolladorProvider{
  final String _url='https://kome-on.firebaseio.com';

  Future<bool>crearDesarrollador(DesarrolladorModel desarrollador)async{
    final url='$_url/usuarios.json';
  
    final resp = await http.post(url, body: desarrolladorModelToJson(desarrollador));

    final decodedData=json.decode(resp.body);

    print(decodedData);

    return true;
  
  }

  Future<bool>editarDesarrollador(DesarrolladorModel desarrollador)async{
    print(desarrollador.id);
    final url='$_url/usuarios/${desarrollador.id}.json';
  
    final resp = await http.put(url, body: desarrolladorModelToJson(desarrollador));

    final decodedData=json.decode(resp.body);

    print(decodedData);

    return true;
  
  }


  Future<List<DesarrolladorModel>> cargarDesarrollador()async{
    final url='$_url/usuarios.json';
    final resp= await http.get(url);

    final Map<String, dynamic> decodedData =json.decode(resp.body);
    final List<DesarrolladorModel> desarrolladores = new List();

    if(decodedData == null) return [];
    decodedData.forEach((id, desarrollador) {
      final  desarrolladorTemp = DesarrolladorModel.fromJson(desarrollador);
      desarrolladorTemp.id=id;

      desarrolladores.add(desarrolladorTemp);
    });
    //print(proyectos[0].id);
    return desarrolladores;
  }

  Future<String> subirImagen(File imagen) async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dj8nfgjnp/image/upload?upload_preset=ojjytzsp');
    final mimeType = mime(imagen.path).split("/");

    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    final file =await http.MultipartFile.fromPath(
      'file',
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    imageUploadRequest.files.add(file);

    final streamResponse=await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if(resp.statusCode!=200 && resp.statusCode!=201){
      print("error");
      print(resp.body);
      return null;

    }

    final respData = json.decode(resp.body);

    return respData['secure_url'];


  }
}