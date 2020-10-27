import 'dart:convert';

import 'package:kome_on/src/models/proyecto_model.dart';
import 'package:http/http.dart' as http;
class ProyectosProvider{

  final String _url='https://kome-on.firebaseio.com';

  Future<bool>crearProyecto(ProyectoModel proyecto)async{
    final url='$_url/proyectos.json';
  
    final resp = await http.post(url, body: proyectoModelToJson(proyecto));

    final decodedData=json.decode(resp.body);

    print(decodedData);

    return true;
  
  }
  Future<List<ProyectoModel>> cargarProyectos()async{
    final url='$_url/proyectos.json';
    final resp= await http.get(url);

    final decodedData =json.decode(resp.body);

    print(decodedData);

    return[];
  }
}