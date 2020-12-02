
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kome_on/src/models/desarrollador_model.dart';
import 'package:kome_on/src/models/equipo_model.dart';
import 'package:kome_on/src/models/miembro_model.dart';
import 'package:kome_on/src/models/proyecto_model.dart';
import 'package:kome_on/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:kome_on/src/providers/desarrolladores_provider.dart';
import 'package:kome_on/src/providers/equipos_provider.dart';
import 'package:kome_on/src/providers/miembros_provider.dart';
import 'package:kome_on/src/providers/proyectos_provider.dart';

 
class HomePage extends StatefulWidget {
   
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final proyectosProvider = new ProyectosProvider();
  final desarrolladorProvider = new DesarrolladorProvider();
  final equiposProvider = new EquiposProvider();
  final miembrosProvider = new MiembrosProvider();

  // String _nombreUsuario="Francisco Sánchez";
  // bool flagRefreshData=false;
  // bool flagRefreshDataProyect=false;
  String urlAvatar='https://avatars1.githubusercontent.com/u/44996719?v=4';
  bool flagCodigoValido=false;
  bool flagCodigoExiste=false;
  bool _firstRun=false;
  List equipos=[];
  List allEquipos=[];
  List proyectos=[];
  MediaQueryData queryData;
  int _indexNave =0;
  
  final tabsTitle=[
    Text("Proyectos"),
     
    Text("Desarrolladores"),
        
    Text("Historias"),
       
  ];

  

  @override
  Widget build(BuildContext context) {
    
    int _regresarHome = ModalRoute.of(context).settings.arguments;
    if(_regresarHome==null ){
      // print(_regresarHome);
    }else{
      // print(_regresarHome);
      if(!_firstRun){
        _indexNave=_regresarHome; 
        _firstRun=true;
      }
     
    }
    // final List userInfo = ModalRoute.of(context).settings.arguments;
    // final userId=userInfo[0];
    // final userEmail=userInfo[1];
    // print(userId+userEmail);
    final _prefs= new PreferenciasUsuario();
    @override
  //   void initState(){
  //   super.initState();
  //   _obtenerEquipos(queryData,miembrosProvider,_prefs.userId)
  //                 _obtenerProyectos(queryData,equiposProvider)  
  // }
    // print("-------------------home");
    // print("desde preferencias");
    // print(_prefs.userId); print(_prefs.email);
    // print("----------------");
    //print(_prefs.token['localId']);
    final String userId=_prefs.userId;
    final String userEmail=_prefs.email;
    
   
    queryData = MediaQuery.of(context);
    var floatingButton=[
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children:<Widget>[
        FloatingActionButton(
          backgroundColor: Colors.pink[300],
          child: Icon(FlutterIcons.refresh_ccw_fea),
          onPressed: (){
            print("refresh");
            
            setState(() {});
          },
        ),
        
        FloatingActionButton(
          heroTag: "btnProyectoNuevo",
          backgroundColor: Colors.pink[300],
          child: Icon(Icons.add_circle_outline_outlined),
          onPressed: (){
            List args=["$userId","$userEmail"];
            Navigator.pushNamed(context, '/nuevoProyecto',arguments: args).then((value) => setState((){}));
          
          },
        ),
        ] 
      ),
      FloatingActionButton(
          backgroundColor: Colors.pink[300],
          child: Icon(FlutterIcons.refresh_ccw_fea),
          onPressed: (){
            print("refresh");
            
            setState(() {});
          },
        ),
      Container(),
    ];
  
    var tabsBody=[
         
    _crearTablero(queryData,proyectosProvider),

    //Inicio de home        //
    //_cardPostick(queryData,context),
    
    //inicio de desar
    _crearTableroDevs(queryData,desarrolladorProvider),
      //Inicio de historias
    Center(child: Text('Historias')),
    ];
    
    return WillPopScope(
      onWillPop: ()async=>false,
        child: Container(
        width:double.infinity,
        height: double.infinity,
        
        child: Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
            elevation: 20,
            title: tabsTitle[_indexNave],
            backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
            actions: <Widget>[
              
              Container(
                margin: EdgeInsets.only(right: 10.0),
                child: InkWell(
                  child: CircleAvatar(

                   
                    child: ClipRRect(
          
                      borderRadius: BorderRadius.circular(30.0),
                      child: FadeInImage(
                      image: NetworkImage(urlAvatar,),
                      
                      placeholder: AssetImage("assets/loading.gif"),
                      fadeInDuration: Duration( milliseconds: 200 ),
                      fit: BoxFit.cover,
                    )
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/editarPerfil').then((value) => setState((){}));
                  },
                ),
              )
            ]
          ),
            
            drawer: Drawer(
              child: _hamList(_prefs)
            ),
            
            body:SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _obtenerAvatar(desarrolladorProvider,userId),
                  _obtenerEquipos(queryData,miembrosProvider,_prefs.userId),
                  _obtenerProyectos(queryData,equiposProvider),  
                  tabsBody[_indexNave],
                ],
              ),
            ),
             
            bottomNavigationBar: Theme(
              data: Theme.of(context).copyWith(
              canvasColor: Color.fromRGBO(55, 57, 84, 1.0),
              primaryColor: Colors.white,
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
                    icon: Icon(Icons.supervised_user_circle),
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
            floatingActionButton: floatingButton[_indexNave],
          ),
      ),
    );
    
  }
  void _onItemTapped(int index) {
    setState(() {
      _indexNave=index;
      
    });
  }
  // Future<Null> _handleRefresh() async {
  //   await new Future.delayed(new Duration(seconds: 1));

  //   setState(() {
      
  //   });

  //   return null;
  // }
  Widget _hamList(_prefs){
    return ListView(
      children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color.fromRGBO(63, 63, 156, 1.0),
              Color.fromRGBO(90, 70, 178, 1.0)
              ]
            )
          ),
          child: Container(
            child: Column(
              children: [
                
                FadeInImage(placeholder: AssetImage("assets/placeholder.png"), image: AssetImage("assets/placeholder.png"),width: 100,height:100,),
                Text("Hola, "+_prefs.email,style: TextStyle(color: Colors.white,fontSize: 20)),
              ],
            ),
          ) 
        ),
        ListTile(
          leading: Icon(FlutterIcons.page_add_fou,color: Colors.black,),
          title: Text('Agregar proyecto existente',style: TextStyle(fontSize: 16),),
          onTap: (){
            _unirseGrupoDialog(context,_prefs);
          },
        ),
        Divider(color: Colors.black,),
        ListTile(
          leading: Icon(FlutterIcons.log_out_ent,color: Colors.black,),
          title: Text('Cerrar Sesión',style: TextStyle(fontSize: 16),),
          onTap: (){
            Navigator.pushReplacementNamed(context, "/login");
            
          },
        ),
        Divider(color: Colors.black,),
      ],
    );
  }

void _unirseGrupo(String idEquipo,_prefs){
  
  // final String _url="https://kome-on.firebaseio.com/equipos/$idEquipo.json";
  // final resp= await http.get(_url);
  MiembroModel miembro= new MiembroModel();
  // final Map<String, dynamic> decodedData =json.decode(resp.body);
  miembro.equipoId=idEquipo;
  miembro.userId=_prefs.userId;
  miembro.email=_prefs.email;
  print(miembro.email+miembro.equipoId);
  miembrosProvider.agregarMiembroNuevo(miembro);
  
 
}
void _unirseGrupoDialog(context,_prefs) {
  flagCodigoValido=true;
  flagCodigoExiste=false;
  String idEquipo='';
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('Ingresa el código'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                
                Center(
                  child: TextField(
                    
                   onChanged: (valor) {
                     
                     idEquipo=valor;
                    },
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                  )
                
                )
                
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:Text("Aceptar",style: TextStyle(fontSize: 20)),
              onPressed: (){

                for(int j=0;j<allEquipos.length;j++){
                  if(allEquipos[j]==idEquipo){
                    flagCodigoExiste=true;
                  }
                }

                for(int i=0;i<equipos.length;i++){
                  if(equipos[i]==idEquipo){
                    flagCodigoValido=false;
                  }
                }

                if(flagCodigoValido && flagCodigoExiste){
                  _unirseGrupo(idEquipo,_prefs);
                  Navigator.pop(context);
                }else if(!flagCodigoValido){
                  llamarToast("Ya eres parte de ese grupo");
                  flagCodigoValido=true;
                   flagCodigoExiste=false;
                }else{
                  llamarToast("El código no es válido");
                  flagCodigoValido=true;
                  flagCodigoExiste=false;
                }
                
                
              }
            ),
            TextButton(
              child: Text('Cancelar',style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
  Widget _obtenerAvatar(DesarrolladorProvider desarrolladorProvider,userId){
    print("wasting data");
    
    return FutureBuilder(
      
      future: desarrolladorProvider.cargarDesarrollador(),
      builder: (BuildContext context, AsyncSnapshot<List<DesarrolladorModel>> snapshot){
        if(snapshot.hasData){
          
          final miembro = snapshot.data;
            for(int j=0;j<miembro.length;j++){

              if(miembro[j].userId==userId){
               urlAvatar=miembro[j].perfilUrl;
              }
          }
        //  print("2"+"$equipos");
          return Container(
            height: 1,
          );
          
        }else{
          return Container(
            height: 1,

          );

        }
      }
    );
    
  
  
}
Widget _obtenerEquipos(queryData,MiembrosProvider miembrosProvider,userId){
    print("wasting data");
    
    return FutureBuilder(
      
      future: miembrosProvider.cargarMiembro(),
      builder: (BuildContext context, AsyncSnapshot<List<MiembroModel>> snapshot){
        if(snapshot.hasData){
          equipos=[];
          final miembro = snapshot.data;
            for(int j=0;j<miembro.length;j++){

              allEquipos.add(miembro[j].equipoId);
              
              if(miembro[j].userId==userId){
                equipos.add(miembro[j].equipoId);
              }
          }
        //  print("2"+"$equipos");
          return Container(
            height: 1,
          );
          
        }else{
          return Container(
            height: 1,

          );

        }
      }
    );
    
  
  
}

Widget _obtenerProyectos(queryData,EquiposProvider equiposProvider){
//   Future.delayed(const Duration(seconds: 2), () {

// // Here you can write your code

//                   setState(() {
//                     // Here you can write your code for open new view
//                   });

//                 });
     return FutureBuilder(
    future: equiposProvider.cargarEquipo(),
    builder: (BuildContext context, AsyncSnapshot<List<EquipoModel>> snapshot){
      if(snapshot.hasData){
        proyectos=[];
        final equipo = snapshot.data;
          for(int j=0;j<equipo.length;j++){
            for(int k=0;k<equipos.length;k++){
              if(equipo[j].id==equipos[k]){
                proyectos.add(equipo[j].idProyecto);
              }
            }
            
          }
        //print(proyectos);
        return Container(
          height: 1,
        );
        
      }else{
        return Container(
          height: 1,

        );

      }
    }
  );
  
 
}
Widget _crearTablero(queryData,proyectosProvider){
  
    return FutureBuilder(
      
      future: proyectosProvider.cargarProyectos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProyectoModel>> snapshot){
        
        if(snapshot.hasData){
          
          List<ProyectoModel> seleccion=[];
          final proyectoSel = snapshot.data;

          for(int j=0;j<proyectoSel.length;j++){
            for(int k=0;k<proyectos.length;k++){
              if(proyectoSel[j].id==proyectos[k]){
              seleccion.add(proyectoSel[j]);
              //print("c");
            }
            }
          }
//               Future.delayed(const Duration(seconds: 2), () {

// // Here you can write your code

//                   setState(() {
//                     // Here you can write your code for open new view
//                   });

//                 });
              return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: seleccion.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                
                crossAxisCount: 2,
                childAspectRatio: .7,
              ),
              itemBuilder: (context, i) =>_cardPostick(queryData,context,seleccion[i]),
            );
          
        }else{
          return Column(
            children:<Widget>[
              Center(
              child: CircularProgressIndicator()
              ),
              Text("No hay proyectos aún, agrega uno o actualiza la página")
            ]
              
          );

        }
      }
    );
}
Widget _crearTableroDevs(queryData,desarrolladorProvider){
  
    return FutureBuilder(
      
      future: desarrolladorProvider.cargarDesarrollador(),
      builder: (BuildContext context, AsyncSnapshot<List<DesarrolladorModel>> snapshot){
        
        if(snapshot.hasData){
          
          final devs = snapshot.data;

              
              return GridView.builder(
                physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: devs.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                
                crossAxisCount: 2,
                childAspectRatio: .7,
              ),
              itemBuilder: (context, i) =>_devs(queryData,context,devs[i]),
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
}
//widget tablero de devs
Widget _devs(queryData,context,DesarrolladorModel dev){
  
  return Container(
    margin: EdgeInsets.all(5),
    
    child:Column(
      children:<Widget>[
        Container( 
          height: 150,
          width: 200,
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
//Wdiget creacion de proyectos
Widget _cardPostick(MediaQueryData screenWidth,  context, ProyectoModel proyecto){

  return  InkWell(
    child: Padding(
      
      padding: const EdgeInsets.all(4.0),
      child: Container(
//margin de los cuadros
        margin: EdgeInsets.only(top:10,left:4,right:4),
        //margin: EdgeInsets.all(100),
        child:Column(
          children: [
            Text(
              
              "${proyecto.nombre}"+"\n",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
              ),
            Icon(Icons.developer_board_rounded,size:50,color: Colors.white,),
            Text( 
              "\n"+"${proyecto.fechaInicio}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
          ],
        ),
        
        padding: EdgeInsets.all(16.0),
        width: screenWidth.size.width/2-18,
        height: 280,
        
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              offset: Offset(0.0, 3.0), //(x,y)
              blurRadius: 6.0,
            ),
          ],
          color: Colors.teal[400],
          border: Border.all(
            
            color: Colors.white,
            width: 0,
          ),
          borderRadius: BorderRadius.all( Radius.circular(2)),
        ),
      ),
    ),
    onTap: (){
      List args= ["${proyecto.id}", "${proyecto.nombre}","${proyecto.fechaInicio}","${proyecto.responsable}"];
      Navigator.pushNamed(context, '/project',arguments: args);
    },
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


//colorcitos
//Color.fromRGBO(55, 57, 84, 1.0),

  