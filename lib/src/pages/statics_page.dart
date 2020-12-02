import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kome_on/src/models/desarrollador_model.dart';
import 'package:kome_on/src/providers/desarrolladores_provider.dart';

class StaticsPage extends StatefulWidget {
  StaticsPage({Key key}) : super(key: key);

  @override
  _StaticsPageState createState() => _StaticsPageState();
}

class _StaticsPageState extends State<StaticsPage> {

  
  DesarrolladorProvider desarrolladorProvider = new DesarrolladorProvider();
  
  @override
  Widget build(BuildContext context) {
    List arguments = ModalRoute.of(context).settings.arguments;
    String _userId = arguments[0];
    String _idProyecto=arguments[1];
    String _fechaInicioProyecto=arguments[2];
    List nodash=_fechaInicioProyecto.split("/");
    List<int> _fechaInicioLista=[];
    _fechaInicioLista.add(int.parse(nodash[0]));
    _fechaInicioLista.add(int.parse(nodash[1]));
    _fechaInicioLista.add(int.parse(nodash[2]));


    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: SingleChildScrollView(child: Text("Estadísticas")),
          backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        ),
        body: _mainBody(_userId,_fechaInicioProyecto)
      ),
    );
  }

  Widget _mainBody(_userId,_fechaInicioProyecto){
    return Column(
      children: <Widget>[
        
        _obtenerPerfil(_userId),
        SizedBox(height:30),
        _mostrarStatics(_fechaInicioProyecto),

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

  Widget _mostrarPerfil(context, DesarrolladorModel dev){
    return Container(
      child:Column(
      children:<Widget>[
        Container( 
          decoration: BoxDecoration(
         
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.black)
         ),
          margin: EdgeInsets.only(left:40,right:40,top: 20, bottom: 10),
          
          child: ClipRRect(

            borderRadius: BorderRadius.circular(20.0),
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

  Widget _mostrarStatics(_fechaInicioProyecto){
    return Center(
      
      child: Column(
        children:<Widget>[
         Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                Icon(FlutterIcons.star_ent,size: 40, color: Colors.blue[900],),
                Text("Puntos de esfuerzo",style: TextStyle(fontSize: 16)),
                Text("6",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
              ],
            ),
            SizedBox(width:30),
            Column(
              children: <Widget>[
                Icon(FlutterIcons.tasklist_oct,size: 40,color: Colors.blue[900]),
                Text("Tareas realizadas",style: TextStyle(fontSize: 16)),
                Text("3",style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,)),
              ],
            )
          ],
        ), 
         Center(
          child: Text(_fechaInicioProyecto)
         )
        
        ] 
        
      ),

     
    ); 
  }
}