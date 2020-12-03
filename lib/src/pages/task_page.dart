import 'package:flutter/material.dart';
import 'package:kome_on/src/models/proyecto_model.dart';
import 'package:kome_on/src/models/tarea_model.dart';
import 'package:kome_on/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:kome_on/src/providers/proyectos_provider.dart';
import 'package:kome_on/src/providers/tareas_provider.dart';
import 'package:fluttertoast/fluttertoast.dart'; 
import 'package:intl/intl.dart';

class TaskPage extends StatefulWidget {
  TaskPage({Key key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  

  TareaModel tareaEdit;
  ProyectoModel proyecto = new ProyectoModel();
  final _prefs= new PreferenciasUsuario();
  String wipLimite='0';
  int _indexNave=0;
  bool _admin=false;
  bool _editMode=false;
  bool flagNoHistoria=true;
  Color tarjetaColor= Colors.amber[50];

  final tareasProvider= new TareasProvider();
  final proyectosProvider = new ProyectosProvider();
  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    List arguments = ModalRoute.of(context).settings.arguments;
    String _idTarea =arguments[0];
    String _wipActual =arguments[1];
    String _idProyecto =arguments[2];
    String _nombreTarea =arguments[3];
    String _responsable =arguments[4];
    String _esHistoria = arguments[5];
    String _tipoTarea = arguments[6];

    if(_tipoTarea=="Código"){
      tarjetaColor=Colors.red[50];
    }
    if(_tipoTarea=="Mantenimiento"){
      tarjetaColor=Colors.blue[50];
    }
    if(_tipoTarea=="Análisis"){
      tarjetaColor=Colors.green[50];
    }
    if(_tipoTarea=="Diseño"){
      tarjetaColor=Colors.amber[50];
    }
    
    if(_esHistoria=="si"){
      flagNoHistoria=false;
    }
    if(_responsable==_prefs.email&&_esHistoria=="no"){
      _admin=true;
    }
    // print(_idTarea+_wipActual);
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("$_nombreTarea"),
        backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        actions: <Widget>[
          Visibility(
            child: Switch(
              
              value: _editMode,
              onChanged: (value) {
                setState(() {
                  _editMode = value;
                  print("modo edicion: "+"$_editMode");
                });
              }
            ),
            visible: _admin,
          )
        ]
      ),
      
      body: _cuerpo(_editMode,_idTarea,_wipActual,_idProyecto),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
        canvasColor: Color.fromRGBO(55, 57, 84, 1.0),
        primaryColor: Colors.pinkAccent,
        textTheme: Theme.of(context).textTheme
          .copyWith( caption: TextStyle( color: Color.fromRGBO(116, 117, 152, 1.0) ) )
      ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              
              icon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'Desarrolladores',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Historias',
            ),
          ],
          currentIndex: _indexNave,
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
      
       
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _indexNave = index;
      int args=index;
      Navigator.pushReplacementNamed(context,'/home',arguments:args).then((value) => setState((){}));
      
    });
  }
  
  Widget _tabla(TareaModel tarea){
    tareaEdit=tarea;
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4.0),
        color: tarjetaColor
          ),
      child: SingleChildScrollView(
        child: Column(
          
      
          children: <Widget>[
            Divider(),
            Container(
              
              child:Text(tarea.nombre, style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
            ),
            SizedBox(
              height: 20,
            ),
            _descripcion(tarea),
            Divider(),
            _responsable(tarea),
            _fechas(tarea),
            Divider(),
            _atributos(queryData,tarea),
            
            SizedBox(
              height: 10,
            ),
            

          ],
        
        ),
      ),
    );
  }

  Widget _descripcion(TareaModel tarea){
    return Container(
      
      padding: EdgeInsets.only(left:10,right:10),
      child: Column(
        children: [
          Container(
            height: 50,
            
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text("Descripción", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
            decoration: BoxDecoration(
              border: Border.all(color: _colorBorderMain()),
              borderRadius: BorderRadius.circular(4.0),
              color: _colorMain()
                ),
          ),
          Container(
            height: 100,
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            
            child: Text(tarea.descTarea,
            style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
            decoration: BoxDecoration(
              border: Border.all(color: _colorBorderMain()),
              borderRadius: BorderRadius.circular(4.0),
              color: Colors.grey[300]
            ),
          )
        ],
      )
    );
  }

  Widget _responsable(TareaModel tarea){
    return Container(
      
      padding: EdgeInsets.only(left:10,right:10),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 110,
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text("Responsable", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
            decoration: BoxDecoration(
              border: Border.all(color: _colorBorderMain()),
              borderRadius: BorderRadius.circular(4.0),
              color: _colorMain()
                ),
          ),
          Expanded(
            child: Container(
              height: 50,
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              
              child: Text(tarea.responsable,
              style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
              decoration: BoxDecoration(
                border: Border.all(color:_colorBorderMain()),
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[300]
              ),
            ),
          )
        ],
      )
    );
  }

  Widget _fechas(TareaModel tarea){
    return Container(
      
      padding: EdgeInsets.only(left:10,right:10),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 110,
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text("Inico", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
            decoration: BoxDecoration(
              border: Border.all(color: _colorBorderMain()),
              borderRadius: BorderRadius.circular(4.0),
              color: _colorMain()
                ),
          ),
          Expanded(
            child: Container(
              height: 50,
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              
              child: Text(tarea.fechaInicio,
              style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
              decoration: BoxDecoration(
                border: Border.all(color: _colorBorderMain()),
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[300]
              ),
            ),
          ),
          Container(
            height: 50,
            width: 100,
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text("Fin", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
            decoration: BoxDecoration(
              border: Border.all(color: _colorBorderMain()),
              borderRadius: BorderRadius.circular(4.0),
              color: _colorMain()
                ),
          ),
          Expanded(
            child: Container(
              height: 50,
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              
              child: Text(tarea.fechaFin,
              style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
              decoration: BoxDecoration(
                border: Border.all(color: _colorBorderMain()),
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[300]
              ),
            ),
          )
        ],
      )
    );
  }

  Widget _atributos(MediaQueryData queryData, TareaModel tarea){
    return Container(
      
      padding: EdgeInsets.only(left:10,right:10),
      child: Row(
        children: <Widget>[
          Column(
            children: [
              Container(
                height: 50,
                width: queryData.size.width/3-15,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text("Estado", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color: _colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: _colorMain()
                    ),
              ),
              Container(
                height: 50,
                width: queryData.size.width/3-15,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                
                child: Text(tarea.estadoTarea,
                style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color:_colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.grey[300]
                ),
              )
            ],
          ),
          // Column(
          //   children: [
          //     Container(
          //       height: 50,
          //       width: queryData.size.width/4-11,
          //       padding: EdgeInsets.all(10),
          //       alignment: Alignment.center,
          //       child: Text("Requisito", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
          //       decoration: BoxDecoration(
          //         border: Border.all(color: _colorBorderMain()),
          //         borderRadius: BorderRadius.circular(4.0),
          //         color: _colorMain()
          //           ),
          //     ),
          //     Container(
          //       height: 50,
          //       width: queryData.size.width/4-11,
          //       padding: EdgeInsets.all(5),
          //       alignment: Alignment.center,
                
          //       child: Text(tarea.requisito,
          //       style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
          //       decoration: BoxDecoration(
          //         border: Border.all(color:_colorBorderMain()),
          //         borderRadius: BorderRadius.circular(4.0),
          //         color: Colors.grey[300]
          //       ),
          //     )
          //   ],
          // ),
          Column(
            children: [
              Container(
                height: 50,
                width: queryData.size.width/3-15,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text("Esfuerzo", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color: _colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: _colorMain()
                    ),
              ),
              Container(
                height: 50,
                width: queryData.size.width/3-15,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                
                child: Text(tarea.esfuerzo,
                style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color: _colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.grey[300]
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                height: 50,
                width: queryData.size.width/3-15,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text("Urgencia", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color: _colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: _colorMain()
                    ),
              ),
              Container(
                height: 50,
                width: queryData.size.width/3-15,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                
                child: Text(tarea.urgencia,
                style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color: _colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.grey[300]
                ),
              )
            ],
          ),
        ]
      )
        
    );
  }
  
  Widget _cuerpo(onof,_idTarea,_wipActual,_idProyecto){
    return Column(
      children: <Widget>[
        Stack(
          children: [
            _verificarWipProyecto(_idTarea,_idProyecto),
            _recuperarInfo(tareasProvider,_idTarea),
            _opcionesEdicion(onof,_idTarea),
            
          ],
        ),
        
        
        _recuperarInfoBtn(tareasProvider,_idTarea,_wipActual),
      ]
      
    ); 
    
  }
  Widget _recuperarInfo(tareasProvider,_idTarea){
    return FutureBuilder(
      future: tareasProvider.cargarTareas(),
      builder: (BuildContext context, AsyncSnapshot<List<TareaModel>> snapshot){
        if(snapshot.hasData){
          //print("buscar proyectos de"+_idProyecto);
          TareaModel seleccion;
          var tareas = snapshot.data;
            //print(_idProyecto);
              
            for(int j=0;j<tareas.length;j++){
              if(tareas[j].id==_idTarea){
                seleccion=tareas[j];
              }
            }
            return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            //4 ahorita
            itemCount: 1,
            itemBuilder: (context,i) => _tabla(seleccion),
            
              
          );

        }else{
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }
  Widget _recuperarInfoBtn(tareasProvider,_idTarea,_wipActual){
    return FutureBuilder(
      future: tareasProvider.cargarTareas(),
      builder: (BuildContext context, AsyncSnapshot<List<TareaModel>> snapshot){
        if(snapshot.hasData){
          //print("buscar proyectos de"+_idProyecto);
          TareaModel seleccion;
          var tareas = snapshot.data;
            //print(_idProyecto);
              
            for(int j=0;j<tareas.length;j++){
              if(tareas[j].id==_idTarea){
                seleccion=tareas[j];
              }
            }
            // tareaEdit=seleccion;
            return ListView.builder(
              
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            //4 ahorita
            itemCount: 1,
            itemBuilder: (context,i) => _botonAccion(seleccion,_wipActual),
            
              
          );

        }else{
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }
  
  Widget _botonAccion(TareaModel tarea,_wipActual){
    final DateTime now=DateTime.now();
    final DateFormat formatter =DateFormat('yyyy/MM/dd');
    final String formatted = formatter.format(now);


    print("la tarea es: "+tarea.estadoTarea);
    print("wip actual: "+_wipActual);
    if(tarea.estadoTarea=="To-do"){
      
      return Visibility(
        child: Container(
          margin: EdgeInsets.all(10),
          child: RaisedButton(
            
            padding: EdgeInsets.all(20),
            child: Text('Aceptar Tarea',style: TextStyle(fontSize: 20),),
            color: Colors.cyan,
            textColor: Colors.white,
            shape: StadiumBorder(),
            onPressed: (){
            if(tarea.responsable=="No asignado" || tarea.responsable==_prefs.email){
              if(int.parse(_wipActual)<int.parse(wipLimite)){
                tarea.estadoTarea="In progress";    
                tarea.responsable=_prefs.email;
                tarea.fechaInicio=formatted;
                tareasProvider.editarTarea(tarea); 
                setState(() {
                  
                });
              }else{
                llamarToast("Excediste el wip");
              }
            }else{
             return Container(width: 10,height: 10,);
            }

          } 
   ),
        ),
        visible: flagNoHistoria,
      ); 
    }else if(tarea.estadoTarea=="In progress"){
      return Visibility(
        child: Container(
          margin: EdgeInsets.all(10),
          child: RaisedButton(
            
            padding: EdgeInsets.all(20),
            child: Text('Finalizar Tarea',style: TextStyle(fontSize: 20),),
            color: Colors.cyan,
            textColor: Colors.white,
            shape: StadiumBorder(),
            onPressed: (){
              if(tarea.responsable=="No asignado" || tarea.responsable==_prefs.email){
             
                
                tarea.fechaFin=formatted;
                tarea.estadoTarea="Done";    
                tareasProvider.editarTarea(tarea); 
                setState(() {
                  
                });
              
            }else{
              llamarToast("No es tu Task");
             return Container(width: 10,height: 10,);
            }
                
             
              return Container(width: 10,height:10);
            

          } 
   ),
        ),
        visible: flagNoHistoria,
      ); 
    }else if(tarea.estadoTarea=="Done"){
      return Container(
        width: 10,
        height: 10,
      );
    }else{
      return Container(width: 10,height:10);
    }
   
  }
  _colorMain(){
    return Colors.teal[600];
  }
  _colorBorderMain(){
    return Colors.white;
  }
  _opcionesEdicion(bool onof,_idTarea){
    return Visibility(
      child: Row(
        
        children: <Widget>[
          InkWell(
            child: Container(margin: EdgeInsets.only(left:5, top: 10),width: 50, height:50,child: Icon(Icons.clear_outlined , color: Colors.red,size: 50,)
            ),onTap: (){
              _showMyDialogDelete(context,_idTarea,tareasProvider);
              
            },
          ),
          InkWell(
            child: Container(margin: EdgeInsets.only(left:1, top: 10),width: 50, height:50,child: Icon(Icons.mode_outlined  , color: Colors.red,size: 45,)

            ),onTap: (){
              List args=[_idTarea,"tarea"];
              Navigator.pushNamed(context, '/editarPage', arguments: args).then((value) => setState((){}));
            },
          ),
        
        ]
      ),
      
      visible: onof,
    );
  
  }
  Widget _verificarWipProyecto(String tareaId,_idProyecto){
    
    return FutureBuilder(
      future: proyectosProvider.cargarProyectos(),
      
      builder: (BuildContext context, AsyncSnapshot<List<ProyectoModel>> snapshot){
        if(snapshot.hasData){
          
          final proyecto = snapshot.data;
          for(int i=0;i<proyecto.length;i++){
            if(proyecto[i].id==_idProyecto){
              wipLimite=proyecto[i].wipLimit;
               
            }
          }
          print("wip limit: "+wipLimite);
          return Container(
            height: 10,
            width:10,
            child: Text("_idEquipo",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          );
          
        }else{
          return Center(child: CircularProgressIndicator());
        
        }
      }
    );
  }
}
void _showMyDialogDelete(context,_idTarea,TareasProvider tareasProvider) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text('¡Alerta!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('¿Seguro que deseas eliminar esta tarea?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Eliminar'),
            onPressed: () {
              tareasProvider.borrarTarea(_idTarea);
              
              Fluttertoast.showToast(
                  msg: "Tarea eliminada con éxito",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black.withOpacity(0.6),
                  textColor: Colors.white,
                  fontSize: 16.0
              );
              Navigator.popUntil(context,ModalRoute.withName('/project'));
            },
          ),
        ],
      );
    }
  );
}

llamarToast(mensaje){
  return Fluttertoast.showToast(
    msg: mensaje,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black.withOpacity(0.6),
    textColor: Colors.white,
    fontSize: 16.0
);
}

  