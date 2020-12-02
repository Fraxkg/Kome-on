import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kome_on/src/models/desarrollador_model.dart';
import 'package:kome_on/src/models/equipo_model.dart';
import 'package:kome_on/src/models/miembro_model.dart';
import 'package:kome_on/src/providers/desarrolladores_provider.dart';
import 'package:kome_on/src/providers/equipos_provider.dart';
import 'package:kome_on/src/providers/miembros_provider.dart';
import 'package:kome_on/src/providers/proyectos_provider.dart';
import 'package:kome_on/src/providers/tareas_provider.dart';

class AllStaticsPage extends StatefulWidget {
  AllStaticsPage({Key key}) : super(key: key);

  @override
  _AllStaticsPageState createState() => _AllStaticsPageState();
}

class _AllStaticsPageState extends State<AllStaticsPage> {

  final proyectosProvider = new ProyectosProvider();
  final desarrolladorProvider = new DesarrolladorProvider();
  final tareasProvider = new TareasProvider();
  final equiposProvider = new EquiposProvider();
  final miembrosProvider = new MiembrosProvider();
  
  String _idEquipo='';
  List devs=[];
  

  @override
  Widget build(BuildContext context) {
    List arguments = ModalRoute.of(context).settings.arguments;
    String _idProyecto=arguments[0];
    String _fechaInicioProyecto=arguments[1];

    return Container(
       child: Scaffold(
         appBar: AppBar(
          title: SingleChildScrollView(child: Text("Estadísticas")),
          backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
          
        ),
        body: _cuerpo(_idProyecto,_fechaInicioProyecto),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[300],
          child: Icon(FlutterIcons.refresh_ccw_fea),
          onPressed: (){
            print("refresh");
            
            setState(() {});
          },
        ),
       ),
       
    );
  }
  Widget _cuerpo(_idProyecto,_fechaInicioProyecto){
    return SingleChildScrollView(
      child: Column(
        children: [
                    
          _verificarEquipo(_idProyecto),
          _recuperarInfoMiembros(_idProyecto,_fechaInicioProyecto),
          Divider(),
          // _recuperarInfo(queryData,proyectosProvider,_idProyecto,aux),
         
          SizedBox(height:6),
    
        ],
      ),
    );
  }
  Widget _recuperarInfoMiembros(_idProyecto,_fechaInicioProyecto){
    
    return FutureBuilder(
      
        future: miembrosProvider.cargarMiembro(),
        builder: (BuildContext context, AsyncSnapshot<List<MiembroModel>> snapshot){
          if(snapshot.hasData){
            //print("buscar proyectos de"+_idProyecto);
            devs=[];
            
            var miembros = snapshot.data;
              //print(_idProyecto);
                
                for(int j=0;j<miembros.length;j++){
                  if(miembros[j].equipoId==_idEquipo){
                    devs.add(miembros[j].userId);
                    
                  }
                }
                Future.delayed(const Duration(seconds: 1));
                return Container(
                  child: _recuperarInfoDevs(_idProyecto,_fechaInicioProyecto),
                );

          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      );
  }
  Widget _recuperarInfoDevs(_idProyecto,_fechaInicioProyecto){
    return FutureBuilder(
        future: desarrolladorProvider.cargarDesarrollador(),
        builder: (BuildContext context, AsyncSnapshot<List<DesarrolladorModel>> snapshot){
          if(snapshot.hasData){
            //print("buscar proyectos de"+_idProyecto);
           List<DesarrolladorModel> seleccion=[];
            
            var miembros = snapshot.data;
              //print(_idProyecto);
                
                for(int j=0;j<miembros.length;j++){
                  for(int k=0; k<devs.length;k++){
                    if(miembros[j].userId==devs[k]){
                    seleccion.add(miembros[j]);
                    
                  }
                  }
                  
                }

                return ListView.builder(
                 physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                //4 ahorita
                itemCount: seleccion.length,
                itemBuilder: (context,i) => _mostrarListaDevs(seleccion[i],_idProyecto,_fechaInicioProyecto),
                
                 
              );

          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      );
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
            height: 1,
          );
          
        }else{
          return Center(child: CircularProgressIndicator());
        
        }
      }
    );
  }

  Widget _mostrarListaDevs(DesarrolladorModel dev,_idProyecto,_fechaInicioProyecto){
    String userId=dev.userId;
    List args=["$userId","$_idProyecto","$_fechaInicioProyecto"];
    return ListTile(
      title: Text(dev.nombre+" "+dev.apePaterno+" "+dev.apeMaterno),
      subtitle: Text(dev.correo,style: TextStyle(color: Colors.blue),),  
      leading: CircleAvatar(
        backgroundImage: NetworkImage(dev.perfilUrl),
      ),
      
      onTap: () => Navigator.pushNamed(context, '/statics',arguments: args),
    );
  }
}