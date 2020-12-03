import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kome_on/src/models/desarrollador_model.dart';
import 'package:kome_on/src/models/tarea_model.dart';
import 'package:kome_on/src/providers/desarrolladores_provider.dart';
import 'package:kome_on/src/providers/tareas_provider.dart';
import 'package:intl/intl.dart';

class StaticsPage extends StatefulWidget {
  StaticsPage({Key key}) : super(key: key);

  @override
  _StaticsPageState createState() => _StaticsPageState();
}

class _StaticsPageState extends State<StaticsPage> {

  
  DesarrolladorProvider desarrolladorProvider = new DesarrolladorProvider();
  TareasProvider tareasProvider = new TareasProvider();

  int totalEsfuerzo=0;
  int totalTareas=0;
  int afinidadDiseno=0;
  int afinidadAnalisis=0;
  int afinidadCodigo=0;
  int afinidadMantenimiento=0;

  int promedioEsfuerzo=0;
  int promedioTareas=0;
  

  @override
  Widget build(BuildContext context) {
    List arguments = ModalRoute.of(context).settings.arguments;
    String _userId = arguments[0];
    String _idProyecto=arguments[1];
    String _fechaInicioProyecto=arguments[2];
    String _responsable=arguments[3];

    final DateTime now=DateTime.now();
    final DateFormat formato =DateFormat('yyyy/MM/dd');
    final String fechaFormateada = formato.format(now);
    List nodashFecha=fechaFormateada.split("/");
    List<int> _fechaActual=[];
    _fechaActual.add(int.parse(nodashFecha[0]));
    _fechaActual.add(int.parse(nodashFecha[1]));
    _fechaActual.add(int.parse(nodashFecha[2]));

    print(_fechaInicioProyecto);
    List nodash=_fechaInicioProyecto.split("/");
    List<int> _fechaInicioLista=[];
    _fechaInicioLista.add(int.parse(nodash[0]));
    _fechaInicioLista.add(int.parse(nodash[1]));
    _fechaInicioLista.add(int.parse(nodash[2]));

    List<int> resta=[];
    for(int j=0;j<_fechaInicioLista.length;j++){
      resta.add((_fechaActual[j] - _fechaInicioLista[j]).abs()); 
    }
    
    int ano=resta[0]*365;
    int mes=resta[1]*30;
    
    int diasDesdeProyecto=ano+mes+resta[2];
    double diasEntreSemana=diasDesdeProyecto/7;

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: SingleChildScrollView(child: Text("Estadísticas")),
          backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        ),
        body: _mainBody(_userId,_fechaInicioProyecto,_responsable,_idProyecto,diasEntreSemana)
      ),
    );
  }

  Widget _mainBody(_userId,_fechaInicioProyecto,_responsable,_idProyecto,diasEntreSemana){
    return Column(
      children: <Widget>[
        
        _obtenerPerfil(_userId),
        SizedBox(height:30),
        _obtenerStatics(_responsable,_idProyecto,_fechaInicioProyecto,diasEntreSemana),
        //_mostrarStatics(_fechaInicioProyecto),

      ]
      
    );
  }
  Widget _obtenerPerfil(_userId){
    return FutureBuilder(
      
      future: desarrolladorProvider.cargarDesarrollador(),
      builder: (BuildContext context, AsyncSnapshot<List<DesarrolladorModel>> snapshot){
        
        if(snapshot.hasData){
          
          List<DesarrolladorModel> seleccion=[];
          final devs = snapshot.data;

            for(int j=0;j<devs.length;j++){
              if(devs[j].userId==_userId){
                seleccion.add(devs[j]);
                //print("c");
              }
            }

            return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1,
              
              itemBuilder: (context, i) => _mostrarPerfil(context,seleccion[i]),
            );
          
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
  

  Widget _obtenerStatics(_responsable,_idProyecto,_fechaInicioProyecto,diasEntreSemana){
    return FutureBuilder(
      
      future: tareasProvider.cargarTareas(),
      builder: (BuildContext context, AsyncSnapshot<List<TareaModel>> snapshot){
        
        if(snapshot.hasData){
          
          
          final tareas = snapshot.data;

            for(int j=0;j<tareas.length;j++){
              if(tareas[j].responsable==_responsable && tareas[j].proyectoId==_idProyecto && tareas[j].estadoTarea=="Done"){
                //sumar tareasa por tipo
                switch(tareas[j].tipoTarea){
                  case "Código":
                    afinidadCodigo++;
                    break;
                  case "Análisis":
                    afinidadAnalisis++;
                    break;
                  case "Diseño":
                    afinidadDiseno++;
                    break;
                  case "Mantenimiento":
                    afinidadMantenimiento++;
                    break;
                }
                //sumar tareas totales y puntos de esfuerzo
                totalTareas++;
                totalEsfuerzo=totalEsfuerzo+int.parse(tareas[j].esfuerzo);

              }
            }

            promedioEsfuerzo=(totalEsfuerzo/diasEntreSemana).round();
            promedioTareas=(totalTareas/diasEntreSemana).round();

            return _mostrarStatics();
          
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

  Widget _mostrarPerfil(context, DesarrolladorModel dev){
    return Container(
      child:Column(
      children:<Widget>[
        Container( 
          width: 350,
          height: 250,
          decoration: BoxDecoration(
         
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.black, width: 2)
          
         ),
          margin: EdgeInsets.only(left:40,right:40,top: 20, bottom: 10),
          
          child: ClipRRect(

            borderRadius: BorderRadius.circular(30.0),
            
            child: FadeInImage(
            image: NetworkImage(dev.perfilUrl),
            
            placeholder: AssetImage("assets/loading.gif"),
            fadeInDuration: Duration( milliseconds: 200 ),
            fit: BoxFit.cover,
            )
          ),
        
        ),
        Text(
          dev.correo,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.blue),
        ),
        Text(
          dev.nombre,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
          
        ),
        Row(
          mainAxisAlignment:MainAxisAlignment.center,
          children: <Widget>[
          
          Text(
          dev.apePaterno+" ",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
          
        ),
        Text(
          dev.apeMaterno,
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
          
        )
        ],)
      ]
    )
    );
  }

  Widget _mostrarStatics(){
    //Afinidad con C____ <--formato
    String afinidad ="Ninguna afinidad";
    afinidad =algoritmoAfinidad();

    Color color1=Colors.blueGrey[300];
    Color color2=Colors.blueGrey[200];
    Icon icono= Icon(FlutterIcons.sad_cry_faw5);
    switch(afinidad){
      case "Afinidad con Código":
        color1=Colors.red[200];
        color2=Colors.red[100];
        icono= Icon(FlutterIcons.code_faw);
        break;
      case "Afinidad con Análisis":
        color1=Colors.green[300];
        color2=Colors.green[200];
        icono= Icon(FlutterIcons.magnifying_glass_ent);
        break;
      case "Afinidad con Mantenimiento":
        color1=Colors.blue[300];
        color2=Colors.blue[200];
        icono= Icon(FlutterIcons.wrench_faw);
        break;
      case "Afinidad con Diseño":
        color1=Colors.amber[300];
        color2=Colors.amber[200];
        icono= Icon(FlutterIcons.paint_brush_faw);
        break;
    }
    return Center(
      
      child: Column(
        children:<Widget>[
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Icon(FlutterIcons.star_ent,size: 40, color: Colors.blue[900],),
                Text("Puntos de esfuerzo",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                Text("Promedio semanal",style: TextStyle(fontSize: 16)),
                Text("$promedioEsfuerzo",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
              ],
            ),
            SizedBox(width:30),
            Column(
              children: <Widget>[
                Icon(FlutterIcons.tasklist_oct,size: 40,color: Colors.blue[900]),
                Text("Tareas realizadas",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                Text("Promedio semanal",style: TextStyle(fontSize: 16)),
                Text("$promedioTareas",style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,)),
              ],
            )
          ],
        ), 
         Center(
          
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(color: Colors.black, width: 2),
              gradient: LinearGradient(
                colors: <Color>[
                color1,color2
                ]
              )
          ),
            margin: EdgeInsets.only(top:50),
            height:45,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children:<Widget>[
               icono,
                Text(" $afinidad",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),) 
              ]
              
            )
            
          )
         )
        
        ] 
        
      ),

     
    ); 
  }

  String algoritmoAfinidad(){
    String resultado="Ninguna afinidad";
    
    List<Map<String, dynamic>> afinidades = [
      {"afinidad": "Afinidad con Código",        "No.": afinidadCodigo},
      {"afinidad": "Afinidad con Análisis",      "No.": afinidadAnalisis},
      {"afinidad": "Afinidad con Diseño",        "No.": afinidadDiseno},
      {"afinidad": "Afinidad con Mantenimiento", "No.": afinidadMantenimiento},
    ];
    
    if (afinidades != null && afinidades.isNotEmpty) {
      afinidades.sort((a, b) => a['No.'].compareTo(b['No.']));
      resultado= afinidades.last['afinidad'];
    }
    if(afinidadCodigo==0 && afinidadAnalisis==0 && afinidadMantenimiento==0 && afinidadDiseno==0){
      resultado="Ninguna afinidad";
    }
    return resultado;
  }
  
}