import 'dart:convert';

import 'package:kome_on/src/models/equipo_model.dart';
import 'package:http/http.dart' as http;
import 'package:kome_on/src/models/miembro_model.dart';
import 'package:kome_on/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:kome_on/src/providers/miembros_provider.dart';

class EquiposProvider{
  final miembrosProvider = new MiembrosProvider();
  MiembroModel miembro= new MiembroModel();
  final _prefs= new PreferenciasUsuario();
  final String _url='https://kome-on.firebaseio.com';

  Future<bool>crearEquipo(EquipoModel equipo)async{
    final url='$_url/equipos.json';

    final resp = await http.post(url, body: equipoModelToJson(equipo));

    final decodedData=json.decode(resp.body);

    print(decodedData["name"]);
    String equipoId=decodedData["name"];
    miembro.email=_prefs.email;
    miembro.userId=_prefs.userId;
    miembro.equipoId=equipoId;
    miembrosProvider.agregarMiembroLider(miembro);

    return true;
  
  }
  
  Future<List<EquipoModel>> cargarEquipo()async{
    final url='$_url/equipos.json';
    final resp= await http.get(url);
    
    final Map<String, dynamic> decodedData =json.decode(resp.body);
    
    final List<EquipoModel> equipos = new List();
    
    if(decodedData == null) return [];
    decodedData.forEach((id, equipo) {
      
      final equipoTemp = EquipoModel.fromJson(equipo);
      equipoTemp.id=id;

      equipos.add(equipoTemp);
    });
    
    //print(equipo[0].id);
    return equipos;
  }

}