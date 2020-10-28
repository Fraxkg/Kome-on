// import 'package:flutter/material.dart';
// void ayuda(){
  bool isNumeric( String s ) {

  if ( s.isEmpty ) return false;

  final n = num.tryParse(s);

  return ( n == null ) ? false : true;

}
// }
// void _mostrarAlerta(BuildContext context, String mensaje){
//   showDialog(
//     context: context,
//     builder: (context){
//       return AlertDialog(
//         title: Text("Oh uh"),
//         content: Text(mensaje),
//         actions: <Widget>[
//           FlatButton(
//             child:Text('Ok'),
//             onPressed: ()=> Navigator.of(context).pop,
//           )
//         ],

//       );
//     }
    
  
//   );
// }