import 'dart:convert';

import 'package:kome_on/src/models/equipo_model.dart';
import 'package:kome_on/src/models/proyecto_model.dart';
import 'package:http/http.dart' as http;
import 'package:kome_on/src/providers/equipos_provider.dart';

class ProyectosProvider{
  final equipoProvider = new EquiposProvider();
  EquipoModel equipo= new EquipoModel();
  final String _url='https://kome-on.firebaseio.com';
  

  Future<bool>crearProyecto(ProyectoModel proyecto)async{
    final url='$_url/proyectos.json';
  
    final resp = await http.post(url, body: proyectoModelToJson(proyecto));

    final decodedData=json.decode(resp.body);

    print(decodedData["name"]);
    equipo.idProyecto=decodedData["name"];
    equipoProvider.crearEquipo(equipo);
    
    return true;
  
  }
  Future<List<ProyectoModel>> cargarProyectos()async{
    final url='$_url/proyectos.json';
    final resp= await http.get(url);

    final Map<String, dynamic> decodedData =json.decode(resp.body);
    final List<ProyectoModel> proyectos = new List();

    if(decodedData == null) return [];
    decodedData.forEach((id, proyecto) {
      
      final  proTemp = ProyectoModel.fromJson(proyecto);
      proTemp.id=id;

      proyectos.add(proTemp);
    });
    //print(proyectos[0].id);
    return proyectos;
  }
}