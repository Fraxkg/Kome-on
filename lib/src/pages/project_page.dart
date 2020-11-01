

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kome_on/src/models/proyecto_model.dart';
import 'package:kome_on/src/models/tarea_model.dart';
import 'package:kome_on/src/providers/proyectos_provider.dart';
import 'package:kome_on/src/providers/tareas_provider.dart';

class ProjectPage extends StatefulWidget {
  ProjectPage({Key key}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {

  
  MediaQueryData queryData;
  final proyectosProvider = new ProyectosProvider();
  final tareasProvider = new TareasProvider();
  int _indexNave=0;

  @override
  Widget build(BuildContext context) {
    String _idProyecto = ModalRoute.of(context).settings.arguments;
    //print(_idProyecto);
    queryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("$_idProyecto"),
        backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        actions: <Widget>[
          InkWell(
            onLongPress: (){
              
            },
            child: Icon(Icons.note_add,size: 38,),
            onTap: (){
              Navigator.pushNamed(context, '/nuevaTarea', arguments: _idProyecto).then((value) => setState((){}));
              
            },
          ),InkWell(
            onLongPress: (){
              
            },
            child: Icon(Icons.supervised_user_circle,size: 38,),
            onTap: (){
              
              
            },
          ),
          
        ]
      ),
      body: RefreshIndicator(onRefresh: _handleRefresh,child:_pantallaProyectos(queryData,_idProyecto)),
     
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
  Widget _pantallaProyectos(MediaQueryData queryData,_idProyecto){
    return SingleChildScrollView(
          child: Column(
        children: [
          
          _tablero(_idProyecto),
          Divider(),
          _recuperarInfo(queryData,proyectosProvider,_idProyecto),
          Divider(),
          Divider(),
          
          
          Divider(),
        ],
      ),
    );
  }

//informacion de las tareas ToDo
Widget _recuperarInfoTareaToDo(queryData,tareasProvider,_idProyecto){
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
                itemBuilder: (context,i) => _crearTareas(seleccion[i]),
                
              );

          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      );
  }
// in p rogress
Widget _recuperarInfoTareaInProgress(queryData,tareasProvider,_idProyecto){
      return FutureBuilder(
        future: tareasProvider.cargarTareas(),
        builder: (BuildContext context, AsyncSnapshot<List<TareaModel>> snapshot){
          if(snapshot.hasData){
            //print("buscar proyectos de"+_idProyecto);
            List<TareaModel> seleccion=[];
            var tareas = snapshot.data;
              //print(_idProyecto);
                
                for(int j=0;j<tareas.length;j++){
                  if(tareas[j].proyectoId==_idProyecto && tareas[j].estadoTarea=="In progress"){
                    seleccion.add(tareas[j]);
                  }
                }

                return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                //4 ahorita
                itemCount: seleccion.length,
                itemBuilder: (context,i) => _crearTareas(seleccion[i]),
                
              );

          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      );
  }
/// done
Widget _recuperarInfoTareaDone(queryData,tareasProvider,_idProyecto){
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
                itemBuilder: (context,i) => _crearTareas(seleccion[i]),
                
              );

          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      );
  }
  
//crear postiti
  _crearTareas(TareaModel tarea){
    List<double> margenes=_numero25();
    double l =margenes[0];
    double r =margenes[1];
    return InkWell(
      child: Container(
        height: 100,
        
        margin: EdgeInsets.only(left:l, top: 5, bottom: 5,right:r),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color:_colorBorderMain()),
          borderRadius: BorderRadius.zero,
          color: Colors.yellow[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 3.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],

        ),
        child: Text(tarea.nombre,style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center),
      ),
      onTap: (){
        String idTarea=tarea.id;
        Navigator.pushNamed(context, '/task',arguments: idTarea).then((value) => setState((){}));
      },
    );
  }
 //informacion del proyecto
  Widget _recuperarInfo(queryData,proyectosProvider,_idProyecto){
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
                itemBuilder: (context,i) => _generarInfo(queryData, context, seleccion),
                
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
  Widget _generarInfo(MediaQueryData screenWidth,  context, ProyectoModel proyecto){
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
                    child:_actividad()
                  ),
                  Container(
                    margin: EdgeInsets.only(left:5, top: 5, bottom: 5,right:0),
                    child:_estadisticas()
                  ),
                  
                  
                ],
              
      ),
    );
  }
 
  
  Widget _tablero(_idProyecto){
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
                          _recuperarInfoTareaToDo(queryData, tareasProvider, _idProyecto)
                         
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
                          _recuperarInfoTareaInProgress(queryData, tareasProvider, _idProyecto)
                         
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
                          _recuperarInfoTareaDone(queryData, tareasProvider, _idProyecto)
                         
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
            Text("JUan 1",style: TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center),
            Text("Ramon 2",style: TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center),
            Text("Pedrito sola",style: TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
  Widget _actividad(){
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
            SizedBox(height: 10,),
            Text("JUan1",style: TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center),
            Text("terminó #1",style: TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center),
            SizedBox(height: 5,),
            Text("Ramon 2",style: TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center),
            Text("terminó #2",style: TextStyle(color: Colors.black,fontSize: 16,),textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
  Widget _estadisticas(){
    return Container(
      width:getMediaWidth(queryData.size.width),
      height:90,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.zero,
        color: Colors.blue[100],
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
          SizedBox(height: 10,),
          Text("Estadísticas",style: TextStyle(color: Colors.black,fontSize: 18, fontWeight:FontWeight.bold), textAlign: TextAlign.center),
          SizedBox(height: 10,),
          Icon(Icons.play_arrow,size: 40,)
          
        ],
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

}