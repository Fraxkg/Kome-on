

import 'dart:math';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kome_on/src/models/equipo_model.dart';
import 'package:kome_on/src/models/miembro_model.dart';
import 'package:kome_on/src/models/proyecto_model.dart';
import 'package:kome_on/src/models/tarea_model.dart';
import 'package:kome_on/src/pages/task_page.dart';
import 'package:kome_on/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:kome_on/src/providers/equipos_provider.dart';
import 'package:kome_on/src/providers/miembros_provider.dart';
import 'package:kome_on/src/providers/proyectos_provider.dart';
import 'package:kome_on/src/providers/tareas_provider.dart';

class ProjectPage extends StatefulWidget {
  ProjectPage({Key key}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  int aux=0;
  String wip="0";
  
  final _prefs= new PreferenciasUsuario();
  MediaQueryData queryData;
  bool flagAdmin=false;
  String _idEquipo='';
  final proyectosProvider = new ProyectosProvider();
  final tareasProvider = new TareasProvider();
  final equiposProvider = new EquiposProvider();
   final miembrosProvider = new MiembrosProvider();
  int _indexNave=0;
  String adminOP='1';
  // List _adminOP= ['1','2','3'];
  String adminOPSelec;

  @override
  Widget build(BuildContext context) {
    List arguments = ModalRoute.of(context).settings.arguments;
    String _idProyecto=arguments[0];
    String _nombreProyecto=arguments[1];
    String _proyectoFechaInicio=arguments[2];
    String _proyectoResponsable=arguments[3];
    String _esHistoria= arguments[4];

    print(_esHistoria);
    if(_prefs.email==_proyectoResponsable &&_esHistoria=="no"){
      flagAdmin=true;
    }
    //print(_idProyecto);
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(child: Text("$_nombreProyecto")),
        backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        actions: <Widget>[
          Visibility(
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                child: DropdownButton(
                  //icon: Icon(Icons.expand_more,size: 40,color: Colors.white,),
                  style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                  items: getOpcionesAdmin(_idProyecto),
                  value: adminOPSelec,
                  dropdownColor: Color.fromRGBO(55, 57, 84, 1.0),
                  onTap: (){},
                  onChanged: (op){
                      setState(() {
                        
                      });
                    },
                  hint: Icon(Icons.admin_panel_settings,size: 38,color: Colors.white),
                ),
              ),
            ),
          visible:flagAdmin,
          ),
          
         
        ]
      ),
      body: RefreshIndicator(onRefresh: _handleRefresh,child:_pantallaProyectos(queryData,_idProyecto,aux,_proyectoFechaInicio,_proyectoResponsable,_esHistoria)),
     
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
      Navigator.pushReplacementNamed(context,'/home',arguments: args);
      
    });
  }
  
  Widget _pantallaProyectos(MediaQueryData queryData,_idProyecto,aux,_proyectoFechaInicio,_proyectoResponsable,_esHistoria){
    
    return SingleChildScrollView(
      child: Column(
        children: [
          
          _tablero(_idProyecto,_proyectoResponsable,_esHistoria),
          Divider(),
          _verificarEquipo(_idProyecto),
          Divider(),
          _recuperarInfo(queryData,proyectosProvider,_idProyecto,aux,_proyectoFechaInicio,_proyectoResponsable),
          
          
          Divider(),
          SizedBox(height:6),
          

          
        ],
      ),
    );
  }

//informacion de las tareas ToDo
Widget _recuperarInfoTareaToDo(queryData,tareasProvider,_idProyecto,_proyectoResponsable,_esHistoria){
  return FutureBuilder(
    future: tareasProvider.cargarTareas(),
    builder: (BuildContext context, AsyncSnapshot<List<TareaModel>> snapshot){
      if(snapshot.hasData){
        //print("buscar proyectos de"+_idProyecto);
        List<TareaModel> seleccion=[];
        var tareas = snapshot.data;
          //print(_idProyecto);
            
            for(int j=0;j<tareas.length;j++){
              if(tareas[j].proyectoId==_idProyecto && tareas[j].estadoTarea=="To-do"){
                seleccion.add(tareas[j]);
              }
            }

            return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            //4 ahorita
            itemCount: seleccion.length,
            itemBuilder: (context,i) => _crearTareas(seleccion[i],_idProyecto,_proyectoResponsable,_esHistoria),
            
          );

      }else{
        return Center(child: CircularProgressIndicator());
      }
    }
  );
}
// in p rogress
Widget _recuperarInfoTareaInProgress(queryData,tareasProvider,_idProyecto,aux,_proyectoResponsable,_esHistoria){
      return FutureBuilder(
        future: tareasProvider.cargarTareas(),
        builder: (BuildContext context, AsyncSnapshot<List<TareaModel>> snapshot){
          if(snapshot.hasData){
            //print("buscar proyectos de"+_idProyecto);
            List<TareaModel> seleccion=[];
            var tareas = snapshot.data;
              //print(_idProyecto);
                wip="0";
                aux=0;
                for(int j=0;j<tareas.length;j++){
                  if(tareas[j].proyectoId==_idProyecto && tareas[j].estadoTarea=="In progress"){
                    seleccion.add(tareas[j]);
                    if(tareas[j].responsable==_prefs.email){
                      aux=int.parse(wip);
                      wip=(aux+1).toString();
                    }
                  }
                }
                print(wip);
                return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                //4 ahorita
                itemCount: seleccion.length,
                itemBuilder: (context,i) => _crearTareas(seleccion[i],_idProyecto,_proyectoResponsable,_esHistoria),
                
              );

          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      );
  }
/// done
Widget _recuperarInfoTareaDone(queryData,tareasProvider,_idProyecto,_proyectoResponsable,_esHistoria){
      return FutureBuilder(
        future: tareasProvider.cargarTareas(),
        builder: (BuildContext context, AsyncSnapshot<List<TareaModel>> snapshot){
          if(snapshot.hasData){
            //print("buscar proyectos de"+_idProyecto);
            List<TareaModel> seleccion=[];
            var tareas = snapshot.data;
              //print(_idProyecto);
                
                for(int j=0;j<tareas.length;j++){
                  if(tareas[j].proyectoId==_idProyecto && tareas[j].estadoTarea=="Done"){
                    seleccion.add(tareas[j]);
                  }
                }

                return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                //4 ahorita
                itemCount: seleccion.length,
                itemBuilder: (context,i) => _crearTareas(seleccion[i],_idProyecto,_proyectoResponsable,_esHistoria),
                
              );

          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      );
  }

//crear postiti
_crearTareas(TareaModel tarea, _idProyecto,_proyectoResponsable,_esHistoria){
    List<double> margenes=_numero25();
    Color mainColor=Colors.yellow[200];
    Color borderColor=Colors.white;
    Color shadowColor=Colors.grey;
    double l =margenes[0];
    double r =margenes[1];
    bool flagUrgencia=true;

   

///si es urgencia
    if(tarea.urgencia=="No"){
      flagUrgencia=false;
    }
  ////colores por tarea
    if(tarea.tipoTarea=="Análisis"){
      mainColor=Colors.green[200];
  ///color si es tuyo
      if(tarea.responsable==_prefs.email){
        borderColor=Colors.green[700];
        shadowColor=Colors.green[700];
      }

    }else if(tarea.tipoTarea=="Diseño"){
      mainColor=Colors.yellow[200];
      ///color si es tuyo
      if(tarea.responsable==_prefs.email){
        borderColor=Colors.orangeAccent[700];
        shadowColor=Colors.orangeAccent[700];
      }

    }else if(tarea.tipoTarea=="Código"){
      mainColor=Colors.red[200];
      ///color si es tuyo
      if(tarea.responsable==_prefs.email){
        borderColor=Colors.redAccent[700];
        shadowColor=Colors.redAccent[700];
      }

    }else if(tarea.tipoTarea=="Mantenimiento"){
      mainColor=Colors.blue[200];
      ///color si es tuyo
      if(tarea.responsable==_prefs.email){
        borderColor=Colors.blueAccent[700];
        shadowColor=Colors.blueAccent[700];
      }

    }else{
      mainColor=Colors.yellow[200];
    }

    return InkWell(
      child: Stack(
        children: <Widget>[
          Container(
            height: 100,
            margin: EdgeInsets.only(left:l, top: 5, bottom: 5,right:r),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color:borderColor),
              borderRadius: BorderRadius.zero,
              color: mainColor,
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  offset: Offset(0.0, 3.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ],

            ),
            child: Text(tarea.nombre,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center),
          ),
          
              
              Center(
                child: Container(
                  padding:EdgeInsets.only(top:75),
                  margin: EdgeInsets.only(left:l,right:r),
                  child: Visibility(
                    child: Icon(FlutterIcons.warning_ent, color: Colors.red,),
                    visible: flagUrgencia,
                  ),
                ),
              )
            
          
        ]
      ),
      onTap: (){
        
        String idTarea=tarea.id;
        List args=["$idTarea","$wip","$_idProyecto","${tarea.nombre}","$_proyectoResponsable",_esHistoria];
        Navigator.pushNamed(context, '/task',arguments: args).then((value) => setState((){}));
      },
    );
  }
 //informacion del proyecto
  Widget _recuperarInfo(queryData,proyectosProvider,_idProyecto,aux,_proyectoFechaInicio,_proyectoResponsable){
      return FutureBuilder(
        future: proyectosProvider.cargarProyectos(),
        builder: (BuildContext context, AsyncSnapshot<List<ProyectoModel>> snapshot){
          if(snapshot.hasData){
            //print("buscar proyectos de"+_idProyecto);
            ProyectoModel seleccion;
            var proyectos = snapshot.data;
              //print(_idProyecto);
                
                for(int j=0;j<proyectos.length;j++){
                  if(proyectos[j].id==_idProyecto){
                    seleccion=proyectos[j];
                  }
                }

                return GridView.builder(
                 physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                //4 ahorita
                itemCount: 1,
                itemBuilder: (context,i) => _generarInfo(queryData, context, seleccion,_idProyecto,_proyectoFechaInicio,_proyectoResponsable),
                
                 gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  
                  crossAxisCount: 1,
                  
                  childAspectRatio: 2,
                ),
              );

          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      );
  }

  Widget _recuperarInfoMiembros(){
      return FutureBuilder(
        future: miembrosProvider.cargarMiembro(),
        builder: (BuildContext context, AsyncSnapshot<List<MiembroModel>> snapshot){
          if(snapshot.hasData){
            //print("buscar proyectos de"+_idProyecto);
           List<MiembroModel> seleccion=[];
            
            var miembros = snapshot.data;
              //print(_idProyecto);
                
                for(int j=0;j<miembros.length;j++){
                  if(miembros[j].equipoId==_idEquipo){
                    seleccion.add(miembros[j]);
                    
                  }
                }

                return ListView.builder(
                 physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                //4 ahorita
                itemCount: seleccion.length,
                itemBuilder: (context,i) => _nombreMiembros(seleccion[i]),
                
                 
              );

          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      );
  }
  
  Widget _generarInfo(MediaQueryData screenWidth,  context, ProyectoModel proyecto,_idProyecto,_proyectoFechaInicio,_proyectoResponsable){
    //print(proyecto.nombre+"si entro");
    return Container(
          
          child: Wrap(
                children: [
                  
                  Container(
                    margin: EdgeInsets.only(left:10, top: 5, bottom: 5,right:5),
                    child:_inicio(proyecto.fechaInicio)
                  ),
                  Container(
                    margin: EdgeInsets.only(left:0, top: 5, bottom: 5,right:0),
                    child:_conclusion(proyecto.fechaFin)
                  ),
                  Container(
                    margin: EdgeInsets.only(left:5, top: 5, bottom: 5,right:0),
                    child:_limit(proyecto.wipLimit)
                  ),
                  Container(
                    margin: EdgeInsets.only(left:10, top: 5, bottom: 5,right:5),
                    child:_colaboradores()
                  ),
                  Container(
                    margin: EdgeInsets.only(left:0, top: 5, bottom: 5,right:0),
                    child:_actividad(_idProyecto)
                  ),
                  Container(
                    margin: EdgeInsets.only(left:5, top: 5, bottom: 5,right:0),
                    child:_estadisticas(_idProyecto,_proyectoFechaInicio)
                  ),
                  
                  
                ],
              
      ),
    );
  }

  Widget _tablero(_idProyecto,_proyectoResponsable,_esHistoria){
    return Container(
      margin: EdgeInsets.only(left:5, top: 10, bottom: 10,right:5),
      
      child: Row(
          
          children: [
            Expanded(
              child: Column(
                
                children: <Widget>[
                  
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color:_colorBorderMain()),
                      borderRadius: BorderRadius.zero,
                      color: _colorRellenoMain()
                    ),
                    child: Text("To-Do",style: TextStyle(color: Colors.white,fontSize: 20,),textAlign: TextAlign.center),
                ),
                  
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color:_colorBorderMain()),
                      borderRadius: BorderRadius.zero,
                      color: Colors.grey[300],
                        
                      
                    ),
                    child: SingleChildScrollView(
                      child: Column(
///empiezan tareas To-do
///margin right left tiene que ser =25
                        children: <Widget>[
    //insercionS
                          _recuperarInfoTareaToDo(queryData, tareasProvider, _idProyecto,_proyectoResponsable,_esHistoria)
                         
                        ],
                      ),
                    )
                   
                  ), 
                ]
                
              ),
            ),
            Expanded(
              child: Column(
                
                children: <Widget>[
                  
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color:_colorBorderMain()),
                      borderRadius: BorderRadius.zero,
                      color: _colorRellenoMain()
                    ),
                    child: Text("In progress",style: TextStyle(color: Colors.white,fontSize: 20,),textAlign: TextAlign.center),
                ),
                  
                  Container(
                    height: 300,
                    
                    decoration: BoxDecoration(
                      border: Border.all(color:_colorBorderMain()),
                      borderRadius: BorderRadius.zero,
                      color: Colors.grey[300]
                    ),
                    child: SingleChildScrollView(
                      child: Column(
///empiezan tareas To-do
///margin right left tiene que ser =25
                        children: <Widget>[
    //insercionS
                          _recuperarInfoTareaInProgress(queryData, tareasProvider, _idProyecto,aux,_proyectoResponsable,_esHistoria)
                         
                        ],
                      ),
                    )
                    
                  ),
                  
                ]
                
              ),
            ),
            Expanded(
              child: Column(
                
                children: <Widget>[
                  
                  Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color:_colorBorderMain()),
                      borderRadius: BorderRadius.zero,
                      color: _colorRellenoMain()
                    ),
                    child: Text("Done",style: TextStyle(color: Colors.white,fontSize: 20,),textAlign: TextAlign.center),
                ),
                  
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color:_colorBorderMain()),
                      borderRadius: BorderRadius.zero,
                      color: Colors.grey[300]
                    ), 
                    child: SingleChildScrollView(
                      child: Column(
///empiezan tareas To-do
///margin right left tiene que ser =25
                        children: <Widget>[
    //insercionS
                          _recuperarInfoTareaDone(queryData, tareasProvider, _idProyecto,_proyectoResponsable,_esHistoria)
                         
                        ],
                      ),
                    )
                  ),
                  
                ]
                
              ),
            ),
          ],
        ),
        
      
      
    );
  }
  
  Widget _inicio(fechaInicio){
    return Container(
      width:getMediaWidth(queryData.size.width),
      height:90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.zero,
        color: Colors.pink[100],
        boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 3.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
      ),
      child: Column(
        children: [
          SizedBox(height: 30,),
          Text("$fechaInicio",style: TextStyle(color: Colors.black,fontSize: 20, fontWeight:FontWeight.bold), textAlign: TextAlign.center),
          SizedBox(height: 10,),
          Text("Inicio",style: TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center)
        ],
      ),
    );
  }
  
  Widget _conclusion(fechaFin){
    return Container(
      width:getMediaWidth(queryData.size.width),
      height:90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.zero,
        color: Colors.green[100],
        boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 3.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
      ),
      child: Column(
        children: [
          SizedBox(height: 30,),
          Text("$fechaFin",style: TextStyle(color: Colors.black,fontSize: 20, fontWeight:FontWeight.bold), textAlign: TextAlign.center),
          SizedBox(height: 10,),
          Text("Conclusión",style: TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center)
        ],
      ),
    );
  }
  
  Widget _limit(wip){
    return Container(
      width:getMediaWidth(queryData.size.width),
      height:90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.zero,
        color: Colors.deepPurple[100],
        boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 3.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
      ),
      child: Column(
        children: [
          SizedBox(height: 30,),
          Text("$wip",style: TextStyle(color: Colors.black,fontSize: 20, fontWeight:FontWeight.bold), textAlign: TextAlign.center),
          SizedBox(height: 10,),
          Text("WIP limit",style: TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center)
        ],
      ),
    );
  }
  
  Widget _colaboradores(){
    return Container(
      width:getMediaWidth(queryData.size.width),
      height:90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.zero,
        color: Colors.orange[100],
        boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 3.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [

            
            SizedBox(height: 10,),
            Text("Colaboradores",style: TextStyle(color: Colors.black,fontSize: 18, fontWeight:FontWeight.bold), textAlign: TextAlign.center),
            SizedBox(height: 10,),
            _recuperarInfoMiembros(),
          ],
        ),
      ),
    );
  }
  
  Widget _nombreMiembros(MiembroModel miembro){
    return Text(miembro.email,style: TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center);
  }
  
  Widget _actividad(_idProyecto){
    return Container(
      width:getMediaWidth(queryData.size.width),
      height:90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.zero,
        color: Colors.purple[100],
        boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 3.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            
            SizedBox(height: 10,),
            Text("Actividad",style: TextStyle(color: Colors.black,fontSize: 18, fontWeight:FontWeight.bold), textAlign: TextAlign.center),
            _obtenerActividad(_idProyecto),
            
            
          ],
        ),
      ),
    );
  }
  Widget _obtenerActividad(_idProyecto){
   
  return FutureBuilder(
    future: tareasProvider.cargarTareas(),
    builder: (BuildContext context, AsyncSnapshot<List<TareaModel>> snapshot){
      if(snapshot.hasData){
        //print("buscar proyectos de"+_idProyecto);
        final DateTime now=DateTime.now();
        final DateFormat formatter =DateFormat('yyyy/MM/dd');
        final String formatted = formatter.format(now);
        // print(formatted);
        List nodash=formatted.split("/");
        List<int> _fechaActual=[];
        _fechaActual.add(int.parse(nodash[0]));
        _fechaActual.add(int.parse(nodash[1]));
        _fechaActual.add(int.parse(nodash[2]));

        List<TareaModel> seleccion=[];
        var tareas = snapshot.data;
          //print(_idProyecto);
        
        
            
            for(int j=0;j<tareas.length;j++){
              if(tareas[j].proyectoId==_idProyecto && tareas[j].estadoTarea=="In progress" ){
                String _fechatarea=tareas[j].fechaInicio;
                List nodash=_fechatarea.split("/");
                List<int> _fecha=[];
                _fecha.add(int.parse(nodash[0]));
                _fecha.add(int.parse(nodash[1]));
                _fecha.add(int.parse(nodash[2]));

                List<int> resta=[];
                
                
                for(int j=0;j<_fecha.length;j++){
                  resta.add((_fechaActual[j] - _fecha[j]).abs()); 
                }
                
                int ano=resta[0]*365;
                int mes=resta[1]*30;
                
                int difDias=ano+mes+resta[2];

                if(difDias<=7){
                seleccion.add(tareas[j]);
                }
                
              }
              else if(tareas[j].proyectoId==_idProyecto && tareas[j].estadoTarea=="Done" ){
                String _fechatarea=tareas[j].fechaFin;
                List nodash=_fechatarea.split("/");
                List<int> _fecha=[];
                _fecha.add(int.parse(nodash[0]));
                _fecha.add(int.parse(nodash[1]));
                _fecha.add(int.parse(nodash[2]));

                List<int> resta=[];
                
                
                for(int j=0;j<_fecha.length;j++){
                  resta.add((_fechaActual[j] - _fecha[j]).abs()); 
                }
                
                int ano=resta[0]*365;
                int mes=resta[1]*30;
                
                int difDias=ano+mes+resta[2];

                if(difDias<=7){
                seleccion.add(tareas[j]);
                }
                
              }
            }
            if (seleccion.isNotEmpty){
              return GridView.builder(
                 physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                //4 ahorita
                itemCount: seleccion.length,
                itemBuilder: (context,i) => _mostrarActividad(seleccion[i]),
                
                 gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  
                  crossAxisCount: 1,
                  
                  childAspectRatio: 3,
                ),
              );
            }else{
              return Container(child: Text("Sin actividad en 1 semana",style:TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center));
            }
             
          

      }else{
        return Center();
      }
    }
  );

 }
  
  Widget _mostrarActividad(TareaModel tarea){
    if(tarea.estadoTarea=="In progress"){
     return Column(children: [
      SizedBox(height: 2,),
      Text("${tarea.responsable}",style: TextStyle(color: Colors.blue,fontSize: 16,),textAlign: TextAlign.center),
      Text("Empezó ${tarea.nombre}",style: TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center),
    ],);
     
    }else{
      return Column(children: [
      SizedBox(height: 2,),
      Text("${tarea.responsable}",style: TextStyle(color: Colors.blue,fontSize: 16,),textAlign: TextAlign.center),
      Text("Terminó ${tarea.nombre}",style: TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center),
    ],);
    }
    
  }

  Widget _estadisticas(_idProyecto,_proyectoFechaInicio){
    List args=[_idProyecto,_proyectoFechaInicio];
    return Container(
      width:getMediaWidth(queryData.size.width),
      height:90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.zero,
        color: Colors.blue[100],
        boxShadow: [
            BoxShadow(
              color: Colors.blue,
              offset: Offset(0.0, 3.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
      ),
      child: InkWell(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Text("Estadísticas",style: TextStyle(color: Colors.black,fontSize: 18, fontWeight:FontWeight.bold), textAlign: TextAlign.center),
              SizedBox(height: 10,),
              Icon(FlutterIcons.area_graph_ent,size: 40,)
              
            ],
          ),
        ),
        onTap: ()=>Navigator.pushNamed(context, "/allStatics", arguments: args),
      ),
    );
  }

  _colorBorderMain(){
    return Colors.white;
  }
  _colorRellenoMain(){
    return Colors.blue;
  }
  double getMediaWidth(double width) {
  if (width >= 500)  {
      return queryData.size.width/6-15;
  } 
  return queryData.size.width/3-10; 
}
  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));

    setState(() {
      
    });

    return null;
  }

  List<double> _numero25(){
    final _rng = new Random();
    double numero1 = _rng.nextInt(22-3).toDouble();
    double numero2 = 25-(numero1);
    var margen=[numero1,numero2];
    return margen;
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
            height: 10,
            width:30,
            child: Text(_idEquipo,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          );
          
        }else{
          return Center(child: CircularProgressIndicator());
        
        }
      }
    );
  }
  List<DropdownMenuItem<String>>getOpcionesAdmin(_idProyecto){
      
    List<DropdownMenuItem<String>> lista = new List();
     // lista.add(DropdownMenuItem(child: Icon(Icons.admin_panel_settings,size: 38,color: Colors.white)));
      lista.add(DropdownMenuItem(
          child: Center(
            child: InkWell(
                onLongPress: (){
                  
                },
                child: Icon(FlutterIcons.edit_ant,size: 38,color: Colors.white),
                onTap: (){
                  // Navigator.pushNamed(context, '/nuevaTarea', arguments: _idProyecto).then((value) => setState((){}));
                  
                },
              ),
          ),
          value: adminOP,
        ));
    
    lista.add(DropdownMenuItem(
          child: Center(
            child: InkWell(
                onLongPress: (){
                  
                },
                child: Icon(FlutterIcons.addfile_ant,size: 38,color: Colors.white),
                onTap: (){
                  Navigator.pushNamed(context, '/nuevaTarea', arguments: _idProyecto).then((value) => setState((){}));
                  
                },
              ),
          ),
            value: adminOP,
        ));
        lista.add(DropdownMenuItem(
          child: Center(
            child: InkWell(
                onLongPress: (){
                  
                },
                child: Icon(FlutterIcons.user_plus_fea,size: 38,color: Colors.white),
                onTap: (){
                  _invitarMiembros(context, _idEquipo);
                  
                },
              ),
          ),
            value: adminOP,
        ));
    
    
    return lista;

  }
}
void _invitarMiembros(context,_idEquipo) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('Invita gente a participar en tu proyecto'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Asegurate de que tus compañeros tengan este código: \n'),
                Center(
                  child: SelectableText(
                    
                    _idEquipo,
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                )
                )
                
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar',style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            InkWell(
              child:Icon(FlutterIcons.clipboard_fea,size: 30),
              onTap: (){
               // ClipboardManager.copyToClipBoard("$_idEquipo");
                 FlutterClipboard.copy('$_idEquipo');
                llamarToast("Código copiado en el portapapeles");
              }
            ),
           
          ],
        );
      }
    );
  }