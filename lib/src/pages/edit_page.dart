import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:kome_on/src/models/proyecto_model.dart';
import 'package:kome_on/src/models/tarea_model.dart';
import 'package:kome_on/src/providers/proyectos_provider.dart';
import 'package:kome_on/src/providers/tareas_provider.dart';

class EditPage extends StatefulWidget {
  EditPage({Key key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}
String tipo='Análisis';
  String _opcionSelecTipos;
  //analisis verder, diseño amairllo codigor rojo y mantenimiento azul
  List _tipos= ['Análisis', 'Diseño','Código','Mantenimiento'];
final formKey = GlobalKey<FormState>();
ProyectosProvider proyectosProvider = new ProyectosProvider();
TareasProvider tareasProvider = new TareasProvider();
bool flagGuardando =false;

// Infor a cambiar del proyecto
TextEditingController _inputFieldDateController = new TextEditingController();
String fechaFinDate="";
String _fechaFin="";
String _nombreProyecto="";
String _wipLimit="";
String _descProyecto="";

// Info a cambiar de la tarea
String _nombreTarea="";
String _descTarea="";
String _tipoTarea="";
String _esfuerzo="";
bool _urgencia=false;

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    
    
    List arguments = ModalRoute.of(context).settings.arguments;
    String _id=arguments[0];
    String _tipoPage=arguments[1];
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        title: Text('Editar Información'),
        
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: _tipo(_tipoPage,_id)
          ),
        ),
      ),
    );
  }
  Widget _tipo(_tipoPage,_id){
    if(_tipoPage=="proyecto"){
      return _crearFormProyecto(_id,flagGuardando);
    }else if(_tipoPage=="tarea"){
      return _crearFormTarea(_id,flagGuardando);
      }else{
      return Container();
    }
    
    
  }
  Widget _crearFormTarea(_idTarea,flagGuardando){
    
  
    return FutureBuilder(
      
      future: tareasProvider.cargarTareas(),
      builder: (BuildContext context, AsyncSnapshot<List<TareaModel>> snapshot){
        
        if(snapshot.hasData){
          
          List<TareaModel> seleccion=[];
          final tarea = snapshot.data;

            for(int j=0;j<tarea.length;j++){
              if(tarea[j].id==_idTarea){
              seleccion.add(tarea[j]);
              //print("c");
            }
            }
         
              Future.delayed(const Duration(seconds: 2), () {

// Here you can write your code

                  setState(() {
                    // Here you can write your code for open new view
                  });

                });
              return _formularioTarea(seleccion[0],flagGuardando);
          
        }else{
          return Column(
            children:<Widget>[
              Center(
              child: CircularProgressIndicator()
              ),
              Text("Cargando...")
            ]
              
          );

        }
      }
    );
}
  Widget _crearFormProyecto(_idProyecto,flagGuardando){
    
  
    return FutureBuilder(
      
      future: proyectosProvider.cargarProyectos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProyectoModel>> snapshot){
        
        if(snapshot.hasData){
          
          List<ProyectoModel> seleccion=[];
          final proyecto = snapshot.data;

            for(int j=0;j<proyecto.length;j++){
              if(proyecto[j].id==_idProyecto){
              seleccion.add(proyecto[j]);
              //print("c");
            }
            }
         
              Future.delayed(const Duration(seconds: 2), () {

// Here you can write your code

                  setState(() {
                    // Here you can write your code for open new view
                  });

                });
              return _formularioProyecto(seleccion[0],flagGuardando);
          
        }else{
          return Column(
            children:<Widget>[
              Center(
              child: CircularProgressIndicator()
              ),
              Text("Cargando...")
            ]
              
          );

        }
      }
    );
}

  Widget _formularioProyecto(ProyectoModel proyecto,flagGuardando){
    return Column(
      children: <Widget>[
          
          _crearNombre(proyecto.nombre),
          SizedBox(height:20),
          _crearDesc(proyecto.descripcion),
          SizedBox(height:20),
          _crearWip(proyecto.wipLimit),
          SizedBox(height:20),
          _crearFechaFin(proyecto.fechaFin),
          SizedBox(height:20),
          _submit(proyecto,flagGuardando),
          
          
      ]
      
      );
  
  }
  Widget _formularioTarea(TareaModel tarea,flagGuardando){
    return Column(
      children: <Widget>[
          
          _crearNombreTarea(tarea.nombre),
          SizedBox(height:20),
          _crearDescTarea(tarea.descTarea),
          SizedBox(height:20),
          _crearEsfuerzo(tarea.esfuerzo),
          SizedBox(height:20),
          Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Icon(FlutterIcons.class__mdi),
                    SizedBox(width:17),
                    _crearTipo(tarea.tipoTarea),
                  ]
                  
                ),
          SizedBox(height:20),
          _crearUrgencia(tarea.urgencia),
          SizedBox(height:20),
          _submitTarea(tarea,flagGuardando),
          
          
      ]
      
      );
  
  }
Widget _submitTarea(TareaModel tarea,flagGuardando){
  
  return RaisedButton(
    padding: EdgeInsets.all(20),
    child: Text('Guardar cambios',style: TextStyle(fontSize: 20),),
    color: Colors.cyan,
    textColor: Colors.white,
    shape: StadiumBorder(),
    
    onPressed:() async {
      if(!formKey.currentState.validate()){
      return;
    }
    formKey.currentState.save();
    if(flagGuardando){
      
    }else{
    setState(() {flagGuardando = true; });
      if(_nombreTarea!=""){
      tarea.nombre=_nombreTarea;
    }
    if(_descTarea!=""){
      tarea.descTarea=_descTarea;
    }
    if(_tipoTarea!=""){
      tarea.tipoTarea=_tipoTarea;
    }
    if(_esfuerzo!=""){
      tarea.esfuerzo=_esfuerzo;
    }
    if(_urgencia){

      tarea.urgencia="Si";
    }else{
      tarea.urgencia="No";
    }
    
    setState(() {
      
    });
    llamarToast("Guardando cambios...");
    
    //print("mandar"+dev.id);
    tareasProvider.editarTarea(tarea);
    //print(idProyecto);
    Navigator.pop(context);
    _showMyDialog(context);
  }  
    }
    
  
  );
}
  Widget _submit(ProyectoModel proyecto,flagGuardando){
  
  return RaisedButton(
    padding: EdgeInsets.all(20),
    child: Text('Guardar cambios',style: TextStyle(fontSize: 20),),
    color: Colors.cyan,
    textColor: Colors.white,
    shape: StadiumBorder(),
    
    onPressed:() async {
      if(!formKey.currentState.validate()){
      return;
    }
    formKey.currentState.save();
    if(flagGuardando){
      
    }else{
    setState(() {flagGuardando = true; });
      if(_nombreProyecto!=""){
      proyecto.nombre=_nombreProyecto;
    }
    if(_descProyecto!=""){
      proyecto.descripcion=_descProyecto;
    }
    if(_wipLimit!=""){
      proyecto.wipLimit=_wipLimit;
    }
    if(_fechaFin!=""){
      proyecto.fechaFin=_fechaFin;
    }
    
    setState(() {
      
    });
    llamarToast("Guardando cambios...");
    
    //print("mandar"+dev.id);
    proyectosProvider.editarProyecto(proyecto);
    //print(idProyecto);
    Navigator.pop(context);
    _showMyDialog(context);
  }  
    }
    
  
  );
}
  Widget _crearNombre(nombre){
    
    return TextFormField(
      //autofocus: true,
      initialValue: nombre,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        hintText: nombre,
        labelText: 'Nombre del proyecto',
       
        
        icon: Icon(Icons.book,color:Colors.black)
      ),
      
      validator: (value){
        if(value.length<2){
          return 'Ingrese un nombre válido';
        }else{
          return null;
        }
      },
      onChanged: (text){
        setState(() {
            
          
          });
        _nombreProyecto=text;

        
        
      },
        
    );
  }
  Widget _crearDesc(nombre){
    
    return TextFormField(
      //autofocus: true,
      initialValue: nombre,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        hintText: nombre,
        labelText: 'Descripción',
       
        
        icon: Icon(Icons.edit,color:Colors.black)
      ),
      
      validator: (value){
        if(value.length<2){
          return 'Ingrese una descripción válida';
        }else{
          return null;
        }
      },
      onChanged: (text){
        setState(() {
            
          
          });
        _descProyecto=text;

        
        
      },
        
    );
  }
  Widget _crearWip(wip){
   return TextFormField(
      initialValue: wip,
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      decoration: InputDecoration(
        
        labelText: 'WIP Limit',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)),
          icon: Icon(Icons.note,color:Colors.black),
      ),
      
      validator: (value) {
        int wip=int.parse(value);
        if ( value.length==1 ||value.length==2 && wip>=1 &&wip<=6  ) {
          return null;
        } else {
          return 'Sólo números enteros, el Wip limit >1 <6';
        }

      },
      onChanged: (text){
        setState(() {
            
          
          });
        _wipLimit=text;
      }
    );
}
  Widget _crearFechaFin(nombre) {
    return TextFormField(
      
      enableInteractiveSelection: false,
      controller: _inputFieldDateController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: nombre,
        labelText: 'Fecha de Finalización',
        suffixIcon: Icon(Icons.calendar_today_outlined),
        icon: Icon(Icons.calendar_today,color: Colors.black,)
      ),
      onSaved: (value)=>_fechaFin=value,
      validator: (value){
        if(value.length<3){
          return 'Ingrese una fecha válida';
        }else{
          return null;
        }},
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context,1);
  
      },
      onChanged: (texto){
        _fechaFin=texto;
      },
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
                Text('Edición realizada con éxito'),
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
  
  //// items de tarea
 Widget _crearNombreTarea(nombre){
    
    return TextFormField(
      //autofocus: true,
      initialValue: nombre,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        hintText: nombre,
        labelText: 'Nombre de la tarea',
       
        
        icon: Icon(Icons.book,color:Colors.black)
      ),
      
      validator: (value){
        if(value.length<2){
          return 'Ingrese un nombre válido';
        }else{
          return null;
        }
      },
      onChanged: (text){
        setState(() {
            
          
          });
        _nombreTarea=text;

        
        
      },
        
    );
  }
  Widget _crearDescTarea(nombre){
    
    return TextFormField(
      //autofocus: true,
      initialValue: nombre,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        hintText: nombre,
        labelText: 'Descripción',
       
        
        icon: Icon(Icons.edit,color:Colors.black)
      ),
      
      validator: (value){
        if(value.length<2){
          return 'Ingrese una descripción válida';
        }else{
          return null;
        }
      },
      onChanged: (text){
        setState(() {
            
          
          });
        _descTarea=text;

        
        
      },
        
    );
  }
   Widget _crearEsfuerzo(esfuerzo){
   return TextFormField(
      initialValue: esfuerzo,
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      decoration: InputDecoration(
        
        labelText: 'Esfuerzo',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)),
          icon: Icon(Icons.note,color:Colors.black),
      ),
      
      validator: (value){
        int esfuerzos=int.parse(value);
        if (esfuerzos>=1 && esfuerzos<=999  ) {
          return null;
        } else {
          return 'Sólo números enteros, >1 <999';
        }

      },
      onChanged: (text){
        setState(() {
            
          
          });
        _esfuerzo=text;
      }
    );
}

Widget _crearTipo(tipo){
  
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
                   _tipoTarea=op;
                });
              },
              
              hint: Text(tipo,style: TextStyle(
                      color: Colors.white,)),
            ),
          ),
        ),
      ),
    ); 
  }

 _crearUrgencia(urgencia){
   
   
    return Row(
      children:<Widget>[
        Icon(FlutterIcons.warning_faw),
        SizedBox(width:20),
        Text("Urgente",style: TextStyle(fontSize:18),) ,
        Switch(
          value: _urgencia,
          
          onChanged: (value){
            setState(() {
              _urgencia=value;
            });
          }
        ),
      ]
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
llamarToast(mensaje){
  return Fluttertoast.showToast(
    msg: mensaje,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black.withOpacity(0.6),
    textColor: Colors.white,
    fontSize: 16.0
);
}
_selectDate(BuildContext context,seleccion)async{

    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2019),
      lastDate: new DateTime(2028),
      
      locale: Locale('es','ES')
    );

    if(picked != null ){
      setState(() {
        fechaFinDate=picked.year.toString()+"/"+picked.month.toString()+"/"+picked.day.toString();
        _inputFieldDateController.text = fechaFinDate;
        
      });
    }
    // print(_fechaInicio);
    // print(_fechaFin);
  }
}