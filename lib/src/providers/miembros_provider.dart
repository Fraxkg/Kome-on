import 'dart:convert';

import 'package:kome_on/src/models/miembro_model.dart';
import 'package:http/http.dart' as http;
class MiembrosProvider{

  final String _url='https://kome-on.firebaseio.com';

  Future<bool>agregarMiembroLider(MiembroModel equipo)async{
    final url='$_url/miembros.json';
  
    final resp = await http.post(url, body: miembroModelToJson(equipo));

    final decodedData=json.decode(resp.body);

    print(decodedData["name"]);

    return true;
  
  }
  Future<bool>agregarMiembroNuevo(MiembroModel equipo)async{
    final url='$_url/miembros.json';
  
    final resp = await http.post(url, body: miembroModelToJson(equipo));

    final decodedData=json.decode(resp.body);

    print(decodedData["name"]);
    

    return true;
  
  }
  Future<List<MiembroModel>> cargarMiembro()async{
    final url='$_url/miembros.json';
    final resp= await http.get(url);

    final Map<String, dynamic> decodedData =json.decode(resp.body);
    final List<MiembroModel> miembros = new List();

    if(decodedData == null) return [];
    decodedData.forEach((id, miembro) {
      final  miembroTemp = MiembroModel.fromJson(miembro);
      miembroTemp.id=id;

      miembros.add(miembroTemp);
    });
    //print(equipo[0].id);
    return miembros;
  }
}