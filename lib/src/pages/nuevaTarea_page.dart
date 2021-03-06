import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kome_on/src/models/equipo_model.dart';
import 'package:kome_on/src/models/miembro_model.dart';
import 'package:kome_on/src/models/proyecto_model.dart';
import 'package:kome_on/src/models/tarea_model.dart';
import 'package:kome_on/src/providers/equipos_provider.dart';
import 'package:kome_on/src/providers/miembros_provider.dart';
import 'package:kome_on/src/providers/proyectos_provider.dart';
import 'package:kome_on/src/providers/tareas_provider.dart';

class NuevaTareaPage extends StatefulWidget {
  NuevaTareaPage({Key key}) : super(key: key);
  
  @override
  _NuevaTareaPageState createState() => _NuevaTareaPageState();
}

class _NuevaTareaPageState extends State<NuevaTareaPage> {
  String _idEquipo='';
  MediaQueryData queryData;
  bool _flagUrgencia=false;
  String nombreProyecto = '';
  final proyectosProvider = new ProyectosProvider();
  final formKeyNuevaTarea = GlobalKey<FormState>();
  TareaModel tarea= new TareaModel();
  final equiposProvider = new EquiposProvider();
  final tareaProvider = new TareasProvider();
  final miembroProvider = new MiembrosProvider();

  String tipo='Análisis';
  String _opcionSelecTipos;
  //analisis verder, diseño amairllo codigor rojo y mantenimiento azul
  List _tipos= ['Análisis', 'Diseño','Código','Mantenimiento'];

  String requisito='Ninguno';
  List _requisitos= ['Ninguno'];
  String _opcionSelecRequisitos;

  String miembro="No asignado";
  List _miembros= ["No asignado"];
  String _opcionSelecMiembros;


  // TextEditingController _inputFieldDateController = new TextEditingController();
  // TextEditingController _inputFieldDateController2 = new TextEditingController();
  
  // String _fechaInicio="";
  // String _fechaFin="";

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    String _idProyecto = ModalRoute.of(context).settings.arguments;
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        title: Text('Nueva Tarea'),
        
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKeyNuevaTarea,
            child: Column(
              children: <Widget>[
                _verificarEquipo(_idProyecto),
                _verificarProyecto(_idProyecto,queryData),
                //_crearNombreProyecto(nombreProyecto),
                Divider(),
                _crearNombre(),
                SizedBox(height:20),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(FlutterIcons.class__mdi),
                    SizedBox(width:17),
                    _crearTipo(),
                  ]
                  
                ),
                
                // SizedBox(height:20),
                
                // Row(
                //   mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     Icon(FlutterIcons.note_oct,color: Colors.black),
                //     SizedBox(width:17),
                //     _obtenerTareas(_idProyecto),
                //   ]
                  
                // ),
                SizedBox(height: 20),
                _crearDescripcion(),
                SizedBox(height: 20),
                _esfuerzo(),
                // SizedBox(height: 20),
                // _crearFechaInicio(),
                // SizedBox(height: 20),
                // _crearFechaFin(),
                Divider(),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(Icons.verified_user),
                    SizedBox(width:17),
                    _obtenerMiembros(),
                  ]
                  
                ),
                
                Divider(),
                _crearUrgencia(),
                Divider(),
                RaisedButton(
                  
                  padding: EdgeInsets.all(20),
                  child: Text('Crear Tarea',style: TextStyle(fontSize: 20),),
                  color: Colors.cyan,
                  textColor: Colors.white,
                  shape: StadiumBorder(),
                  onPressed: (){
                  _submit(_idProyecto);
                  
                  } 
                ),
                
                  
               // _crearBoton()
              ],
            ),
          ),
        ),
      ),
       
    );
  }
//   Widget _obtenerTareas(_idProyecto){
//     return FutureBuilder(
//         future: tareaProvider.cargarTareas(),
//         builder: (BuildContext context, AsyncSnapshot<List<TareaModel>> snapshot){
//           if(snapshot.hasData){
//             //print("buscar proyectos de"+_idProyecto);
//             //MiembroModel seleccion;
//             var tareas = snapshot.data;
//               //print(_idProyecto);
                
//                 //print(_idEquipo);
//                 _requisitos=["No asignado"];
//                 for(int j=0;j<tareas.length;j++){
//                   if(tareas[j].proyectoId==_idProyecto){
//                    // print("si entra");
                    
                    
//                     _requisitos.add(tareas[j].nombre);
                   
//                   }
//                 }
//                 // print("aaaa"+miembro);
//                 // print(_miembros);
//                 Future.delayed(const Duration(milliseconds: 500), () {

// // Here you can write your code

//                   setState(() {
//                     // Here you can write your code for open new view
//                   });

//                 });
//                 return _crearRequisito();

//           }else{
//             return Center(child: CircularProgressIndicator());
//           }
//         }
//       );
//   }
  Widget _obtenerMiembros(){
    return FutureBuilder(
        future: miembroProvider.cargarMiembro(),
        builder: (BuildContext context, AsyncSnapshot<List<MiembroModel>> snapshot){
          if(snapshot.hasData){
            //print("buscar proyectos de"+_idProyecto);
            //MiembroModel seleccion;
            var miembros = snapshot.data;
              //print(_idProyecto);
                
                //print(_idEquipo);
                _miembros=["No asignado"];
                for(int j=0;j<miembros.length;j++){
                  if(miembros[j].equipoId==_idEquipo){
                   // print("si entra");
                    
                    
                    _miembros.add(miembros[j].email);
                   
                  }
                }
                // print("aaaa"+miembro);
                // print(_miembros);
                Future.delayed(const Duration(milliseconds: 500), () {

// Here you can write your code

                  setState(() {
                    // Here you can write your code for open new view
                  });

                });
                return _crearMiembros();

          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      );
  }
  
  _crearUrgencia(){
    return Row(
      children:<Widget>[
        Icon(FlutterIcons.warning_faw),
        SizedBox(width:20),
        Text("Urgente",style: TextStyle(fontSize:18),) ,
        Switch(
          value: _flagUrgencia,
          
          onChanged: (value){
            setState(() {
              _flagUrgencia=value;
            });
          }
        ),
      ]
    );
  }
 
  Widget _crearTipo(){
    return Expanded(
          child: Container(
        
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Colors.cyan,
          border: Border.all(color: Color.fromRGBO(120, 0, 155, .5))
        ),
        padding: const EdgeInsets.only(right: 20.0, left: 20.0 ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
              //alignedDropdown: true,
            child: DropdownButton(
              
              icon: Icon(Icons.expand_more,color: Colors.white, ),
              dropdownColor: Colors.teal.withOpacity(.9),
              //focusColor: Color.fromRGBO(0, 106, 120,.5),
              style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              value: _opcionSelecTipos,
              items: getOpcionesDropdownTipos(),
              onTap: (){},

              onChanged: (op){
                setState(() {
                  
                   _opcionSelecTipos = op;
                });
              },
              
              hint: Text("Tipo",style: TextStyle(
                      color: Colors.white,)),
            ),
          ),
        ),
      ),
    ); 
  }
  Widget _crearMiembros(){
    // print("emial lider"+miembro);
    // print("lista"+_miembros.toString()); 
    return Expanded(
          child: Container(
        
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.cyan,
          border: Border.all(color: Color.fromRGBO(120, 0, 155, .5))
        ),
        padding: const EdgeInsets.only(right: 20.0, left: 20.0 ),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
              //alignedDropdown: true,
            child: DropdownButton(
              
              icon: Icon(Icons.expand_more,color: Colors.white, ),
              dropdownColor: Colors.teal.withOpacity(.9),
              //focusColor: Color.fromRGBO(0, 106, 120,.5),
              style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
              value: _opcionSelecMiembros,
              items: getOpcionesDropdownMiembros(),
              onTap: (){},

              onChanged: (op){
                setState(() {
                  
                   _opcionSelecMiembros = op;
                });
              },
              
              hint: Text("Responsable",style: TextStyle(
                      color: Colors.white,)),
            ),
          ),
        ),
      ),
    ); 
  }

  // Widget _crearRequisito(){
  //   return Expanded(
  //         child: Container(
        
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(15.0),
  //         color: Colors.cyan,
  //         border: Border.all(color: Color.fromRGBO(120, 0, 155, .5))
  //       ),
  //       padding: const EdgeInsets.only(right: 20.0, left: 20.0 ),
  //       child: DropdownButtonHideUnderline(
  //         child: ButtonTheme(
  //         //  alignedDropdown: true,
  //             child: DropdownButton(
              
  //             icon: Icon(Icons.expand_more,color: Colors.white, ),
  //             dropdownColor: Colors.teal.withOpacity(.9),
  //             //focusColor: Color.fromRGBO(0, 106, 120,.5),
  //             style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
  //             value: _opcionSelecRequisitos,
  //             items: getOpcionesDropdownRequisito(),
  //             onTap: (){},
             
  //             onChanged: (op){
  //               setState(() {
                  
  //                  _opcionSelecRequisitos = op;
  //               });
  //             },
              
  //             hint: Text("Requisito",style: TextStyle(
  //                     color: Colors.white,)),
  //           ),
  //         ),
  //       ),
  //     ),
  //   ); 
  // }
  
  Widget _crearDescripcion(){
    return TextFormField(
      //autofocus: true,
    keyboardType: TextInputType.multiline,
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        labelText: 'Descripción de la tarea',
        
        icon: Icon(Icons.edit,color: Colors.black,)
      ),
      onSaved: (value)=>tarea.descTarea=value,
      validator: (value){
        if(value.length<3){
          return 'Ingrese una descripción';
        }else{
          return null;
        }
      },
      onChanged: (valor) => setState(() {
          
          
      })
        
    );
  }
  
  Widget _crearNombre(){
    return TextFormField(
      //autofocus: true,
     
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        
        labelText: 'Nombre de la tarea',
       
        
        icon: Icon(FlutterIcons.sticky_note_faw,color:Colors.black)
      ),
      onSaved: (value)=>tarea.nombre=value,
      validator: (value){
        if(value.length<3){
          return 'Ingrese un nombre válido';
        }else if(value.length>25){
          return 'Nombre muy largo';
        
        }else{
          return null;
        }},
      onChanged: (valor) => setState(() {
         
          
        })
        
    );
  }

  Widget _esfuerzo(){
    return TextFormField(
      //autofocus: true,
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        
        labelText: 'Puntos de esfuerzo',
       
        
        icon: Icon(Icons.grade,color: Colors.black,)
      ),
      onSaved: (value)=>tarea.esfuerzo=value,
      validator: (value){
        int esfuerzos=int.parse(value);
        if (esfuerzos>=1 && esfuerzos<=999  ) {
          return null;
        } else {
          return 'Sólo números enteros, >1 <999';
        }

      },
      onChanged: (valor) => setState(() {
         
          
        })
        
    );
  }

  _submit(_idProyecto){
    if(!formKeyNuevaTarea.currentState.validate()){
      return;
    }
    formKeyNuevaTarea.currentState.save();
    //print(proyecto.nombre);
    if(_opcionSelecTipos!=null && _opcionSelecRequisitos!=null){
      tarea.proyectoId = _idProyecto;
      tarea.tipoTarea=_opcionSelecTipos;
      tarea.requisito=_opcionSelecRequisitos;
      tarea.responsable=_opcionSelecMiembros;
      if(_flagUrgencia){
        tarea.urgencia='Si';
      }else{
        tarea.urgencia='No';
      }
      tareaProvider.crearTarea(tarea);
      
    Navigator.pop(context);
    _showMyDialog(context);
    }else{
      _showMyDialogErrorDropdown(context);
    }
    
  }
  
  Widget _verificarProyecto(proyectoId,queryData){
    //print(nombreProyecto);
    return FutureBuilder(
      future: proyectosProvider.cargarProyectos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProyectoModel>> snapshot){
        if(snapshot.hasData){
          
          final proyectos = snapshot.data;
          for(int i=0;i<proyectos.length;i++){
             if(proyectos[i].id==proyectoId){
               nombreProyecto=proyectos[i].nombre;
               //print(nombreProyecto);
             }
          }
         
            return Container(
              
              width: queryData.size.width,
              child: Text(nombreProyecto,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              );
          
        }else{
          return Center(child: CircularProgressIndicator());
        
        }
      }
    );
      

  }
  
  void _showMyDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('¡Perfecto!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tarea creada con éxito'),
                Text('Es hora de trabajar (ง •᷄ω•)ว'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  void _showMyDialogErrorDropdown(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('¡Error!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Error, selecciona un tipo y un requisito'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
  
  List<DropdownMenuItem<String>>getOpcionesDropdownTipos(){
    
  List<DropdownMenuItem<String>> lista = new List();
    
    _tipos.forEach((tipo){
      lista.add(DropdownMenuItem(
        child: Text(tipo),
        value: tipo,
      ));
    });
    return lista;
  }

  List<DropdownMenuItem<String>>getOpcionesDropdownRequisito(){
      
    List<DropdownMenuItem<String>> lista = new List();
      
      _requisitos.forEach((requisito){
        lista.add(DropdownMenuItem(
          child: Text(requisito),
          value: requisito,
        ));
      });
      return lista;
  }

  List<DropdownMenuItem<String>>getOpcionesDropdownMiembros(){
      
    List<DropdownMenuItem<String>> lista = new List();
      
      _miembros.forEach((miembro){
        lista.add(DropdownMenuItem(
          child: Text(miembro),
          value: miembro,
        ));
      });
      return lista;
  }

 

  
  Widget _verificarEquipo(String proyectoId){
      
      return FutureBuilder(
        future: equiposProvider.cargarEquipo(),
        
        builder: (BuildContext context, AsyncSnapshot<List<EquipoModel>> snapshot){
          if(snapshot.hasData){
            
            final equipo = snapshot.data;
            for(int i=0;i<equipo.length;i++){
              if(equipo[i].idProyecto==proyectoId){
                _idEquipo=equipo[i].id;
                
              }
            }
          
            return Container(
              height: 5,
              width:30,
              child: Text(_idEquipo,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            );
            
          }else{
            return Center(child: CircularProgressIndicator());
          
          }
        }
      );
    }
}
