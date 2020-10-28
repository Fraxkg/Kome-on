import 'dart:convert';

import 'package:kome_on/src/models/tarea_model.dart';
import 'package:http/http.dart' as http;
class TareasProvider{

  final String _url='https://kome-on.firebaseio.com';

  Future<bool>crearTarea(TareaModel proyecto)async{
    final url='$_url/tareas.json';
  
    final resp = await http.post(url, body: tareaModelToJson(proyecto));

    final decodedData=json.decode(resp.body);

    print(decodedData);

    return true;
  
  }
  Future<List<TareaModel>> cargarTareas()async{
    final url='$_url/tareas.json';
    final resp= await http.get(url);

    final Map<String, dynamic> decodedData =json.decode(resp.body);
    final List<TareaModel> tareas = new List();

    if(decodedData == null) return [];
    decodedData.forEach((id, tarea) {
      final  tareaTemp = TareaModel.fromJson(tarea);
      tareaTemp.id=id;

      tareas.add(tareaTemp);
    });
    //print(proyectos[0].id);
    return tareas;
  }
}