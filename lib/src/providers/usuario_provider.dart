import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kome_on/src/preferencias_usuario/preferencias_usuario.dart';



class UsuarioProvider{

  final String _firebaseToken='AIzaSyC_EUDL86QFI8KF6TVcX8qBBwLRRzhAIzM';
  final _pref=new PreferenciasUsuario();

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

  Future<Map<String, dynamic>> nuevoUsuario(String email,String password)async{
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
      //salvar token
      return {"ok":true,'token':decodedResp['idToken'],'userId':decodedResp['localId'],'email':decodedResp['email']};
    }else{
      return {"ok":false,'mensaje':decodedResp['error']['message']};
    }
  }
}