
import 'package:flutter/material.dart';
import 'package:kome_on/src/providers/proyectos_provider.dart';
 
class HomePage extends StatefulWidget {
   
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final proyectosProvider = new ProyectosProvider();

  String _nombreUsuario="Francisco Sánchez";
  bool _firstRun=false;
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
   
//nav bar desde otra pantalla
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
   
    queryData = MediaQuery.of(context);
    var floatingButton=[
      FloatingActionButton(
            backgroundColor: Colors.pink[300],
            child: Icon(Icons.add_circle_outline_outlined),
            onPressed: (){
             
             Navigator.pushNamed(context, '/nuevoProyecto',arguments: _nombreUsuario);
            },
          ),
      Container(),
      Container(),
    ];
    var tabsBody=[
//Inicio de home
    ListView(
    padding: EdgeInsets.all(10.0),//symmetric(horizontal: 50.0, vertical: 10.0),
      children: <Widget>[
        
        Wrap(
        
          children: <Widget>[
            _crearTablero(proyectosProvider),
            _cardPostick(queryData,context),
            
            
           
          ],  
        )
      ],
    ),
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
          body: tabsBody[_indexNave],
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
}

Widget _crearTablero(proyectosProvider){
    return FutureBuilder(
      future: proyectosProvider.cargarProyectos(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return;
      }
    );
}

//Wdiget creacion de proyectos
Widget _cardPostick(MediaQueryData screenWidth,  context){

  return  InkWell(
    child: Padding(
      
      padding: const EdgeInsets.all(4.0),
      child: Container(
        
        child:Column(
          children: [
            Text(
              
              "Plataforma en línea de educación para niños con autismo"+"\n",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),
              ),
            Icon(Icons.developer_board_rounded,size:50,color: Colors.white,),
            Text( 
              "\n"+"Inicio: 17/12/21",
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
      Navigator.pushNamed(context, '/project');
    },
  );
  
  
}

//colorcitos
//Color.fromRGBO(55, 57, 84, 1.0),

  