import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kome_on/src/models/desarrollador_model.dart';
import 'package:kome_on/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:kome_on/src/providers/desarrolladores_provider.dart';

class UsuarioProvider{
  final desarrolladorProvider = new DesarrolladorProvider();
  DesarrolladorModel desarrollador= new DesarrolladorModel();
  
  final String _firebaseToken='AIzaSyC_EUDL86QFI8KF6TVcX8qBBwLRRzhAIzM';
  final _pref=new PreferenciasUsuario();
//login
  Future<Map<String, dynamic>>login(String email, String password)async{
     final authData ={
      'email': email,
      'password': password,
      'returnSecureToken':true
    };

    final resp= await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String,dynamic> decodedResp =json.decode(resp.body);
    print(decodedResp);
    if(decodedResp.containsKey('idToken')){

      _pref.token=decodedResp['idToken'];
      _pref.userId=decodedResp['localId'];
      _pref.email=decodedResp['email'];
      //salvar token
      return {"ok":true,'token':decodedResp['idToken'],'userId':decodedResp['localId'],'email':decodedResp['email']};
    }else{
      return {"ok":false,'mensaje':decodedResp['error']['message']};
    }
  }

//registro
  Future<Map<String, dynamic>> nuevoUsuario(String email,String password, String nombre, String apePaterno, String apeMaterno)async{
    final authData ={
      'email': email,
      'password': password,
      'returnSecureToken':true
    };

    final resp= await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: json.encode(authData)
    );

    Map<String,dynamic> decodedResp =json.decode(resp.body);
    print(decodedResp);
    if(decodedResp.containsKey('idToken')){
      _pref.token=decodedResp['idToken'];
      _pref.userId=decodedResp['localId'];
      _pref.email=decodedResp['email'];

      desarrollador.perfilUrl="https://res.cloudinary.com/dj8nfgjnp/image/upload/v1606634988/drwwtwerokrz44fxfida.png";
      desarrollador.nombre=nombre;
      desarrollador.apeMaterno=apeMaterno;
      desarrollador.apePaterno=apePaterno;
      desarrollador.correo=email;
      desarrollador.userId=decodedResp['localId'];
      
      desarrolladorProvider.crearDesarrollador(desarrollador);
      

      //salvar token
      return {"ok":true,'token':decodedResp['idToken'],'userId':decodedResp['localId'],'email':decodedResp['email']};
    }else{
      return {"ok":false,'mensaje':decodedResp['error']['message']};
    }
  }
}