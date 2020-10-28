
import 'package:flutter/material.dart';
import 'package:kome_on/src/models/proyecto_model.dart';
import 'package:kome_on/src/providers/proyectos_provider.dart';

 
class HomePage extends StatefulWidget {
   
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  final proyectosProvider = new ProyectosProvider();

  // String _nombreUsuario="Francisco Sánchez";
  // bool _firstRun=false;
  MediaQueryData queryData;
  int _indexNave =0;
  
  final appBars=[
    AppBar(
        elevation: 20,
        title: Text("Proyectos"),
        backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
            
              child: Icon(Icons.account_circle,color: Colors.black,),
              backgroundColor: Colors.white,
            ),
          )
        ]
      ),
    AppBar(
        elevation: 20,
        title: Text("Desarrolladores"),
        backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
            
              child: Icon(Icons.account_circle,color: Colors.black,),
              backgroundColor: Colors.white,
            ),
          )
        ]
      ),
      AppBar(
        elevation: 20,
        title: Text("Historias"),
        backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
            
              child: Icon(Icons.account_circle,color: Colors.black,),
              backgroundColor: Colors.white,
            ),
          )
        ]
      ),
  ];

  

  @override
  Widget build(BuildContext context) {
    
    // int _regresarHome = ModalRoute.of(context).settings.arguments;
    // if(_regresarHome==null ){
    //   // print(_regresarHome);
    // }else{
    //   // print(_regresarHome);
    //   if(!_firstRun){
    //     _indexNave=_regresarHome; 
    //     _firstRun=true;
    //   }
     
    // }
    final List userInfo = ModalRoute.of(context).settings.arguments;
    String userId=userInfo[0];
    String userEmail=userInfo[1];
    print(userId+userEmail);
    
   
    queryData = MediaQuery.of(context);
    var floatingButton=[
      FloatingActionButton(
            backgroundColor: Colors.pink[300],
            child: Icon(Icons.add_circle_outline_outlined),
            onPressed: (){
              List args=["$userId","$userEmail"];
              Navigator.pushNamed(context, '/nuevoProyecto',arguments: args).then((value) => setState((){}));
             
            },
          ),
      Container(),
      Container(),
    ];
  
    var tabsBody=[
//Inicio de home        //
  //_cardPostick(queryData,context),
   RefreshIndicator(onRefresh: _handleRefresh,child: _crearTablero(queryData,proyectosProvider)),
      
    //inicio de desar
    Container(child: Text('Desarrolladores')),
      //Inicio de historias
    Center(child: Text('Historias')),
    ];
    
    return Container(
      width:double.infinity,
      height: double.infinity,
      
      child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: appBars[_indexNave],
          
          drawer: Drawer(

          ),
          
          body:tabsBody[_indexNave],
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
          floatingActionButton: floatingButton[_indexNave],
        ),
    );
    
  }
  void _onItemTapped(int index) {
    setState(() {
      _indexNave=index;
      
    });
  }
  Future<Null> _handleRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));

    setState(() {
      
    });

    return null;
  }
}

Widget _crearTablero(queryData,proyectosProvider){
    return FutureBuilder(
      future: proyectosProvider.cargarProyectos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProyectoModel>> snapshot){
        if(snapshot.hasData){
          
          final proyectos = snapshot.data;
         
              
              return GridView.builder(
              itemCount: proyectos.length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: .7,
              ),
              itemBuilder: (context, i) =>_cardPostick(queryData,context,proyectos[i]),
            );
          
        }else{
          return Center(child: CircularProgressIndicator());
        }
      }
    );
}

 
//Wdiget creacion de proyectos
Widget _cardPostick(MediaQueryData screenWidth,  context, ProyectoModel proyecto){

  return  InkWell(
    child: Padding(
      
      padding: const EdgeInsets.all(4.0),
      child: Container(
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
      String args="${proyecto.id}";
      Navigator.pushNamed(context, '/project',arguments: args);
    },
  );
  
  
}

//colorcitos
//Color.fromRGBO(55, 57, 84, 1.0),

  