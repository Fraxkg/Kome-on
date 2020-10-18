
import 'package:flutter/material.dart';
 
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MediaQueryData queryData;
  int _indexNave =0;

  final appBars=[
    AppBar(
        title: Text("Proyectos"),
        backgroundColor: _colorMainHome(400),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
            
              child: Text('?',style: TextStyle(color: Colors.black),),
              backgroundColor: Colors.white,
            ),
          )
        ]
      ),
    AppBar(
        title: Text("Desarrolladores"),
        backgroundColor: _colorMainDeve(400),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
            
              child: Text('?',style: TextStyle(color: Colors.black),),
              backgroundColor: Colors.white,
            ),
          )
        ]
      ),
      AppBar(
        title: Text("Historias"),
        backgroundColor: _colorMainStories(400),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: CircleAvatar(
            
              child: Text('?',style: TextStyle(color: Colors.black),),
              backgroundColor: Colors.white,
            ),
          )
        ]
      ),
  ];

  

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    var tabsBody=[
    //Inicio de home
    ListView(
    padding: EdgeInsets.all(10.0),//symmetric(horizontal: 50.0, vertical: 10.0),
      children: <Widget>[
        
        Wrap(
        
          children: <Widget>[
            _cardPostick(queryData,0),
            _cardPostick(queryData,1),
            _cardPostick(queryData,1),
            _cardPostick(queryData,2),
            _cardPostick(queryData,0),
           
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: FractionalOffset(0.0, 0.6),
          end: FractionalOffset(0.0, 1.0),
          colors: [
            Color.fromRGBO(52, 54, 101, 1.0),
            Color.fromRGBO(35, 37, 57, 1.0)
          ]
        )
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: appBars[_indexNave],
          drawer: Drawer(

          ),
          body: tabsBody[_indexNave],
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
              selectedItemColor: _colorNavBar(_indexNave),
              onTap: _onItemTapped,
            ),
          ),
           
        ),
    );
    
  }
  void _onItemTapped(int index) {
    setState(() {
      _indexNave = index;

      
    });
  }
}
//generacion de proyectos
Widget _cardPostick(MediaQueryData screenWidth, int color){
  
  return Stack(
      children: <Widget>[
        
        InkWell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.all(16.0),
              width: screenWidth.size.width/2-26,
              height: screenWidth.size.width/2-26,
              decoration: BoxDecoration(
                color: _colorPostick(color),
                border: Border.all(
                  color: Colors.black,
                  width: 4,
                ),
                borderRadius: BorderRadius.all( Radius.circular(20)),
                
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 7,
                    blurRadius: 7,
                    offset: Offset(3, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
          ),
          onTap: (){

          },
        ),
        
        InkWell(
          
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0, top: 60.0),
             // color:Color.fromRGBO(120, 245, 90, 0.2), 
              height: 120,
              width: 170,
            
              child: Text("Placeholder"+"\n"+"Inicio: 101010",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            
            ),
          ),
        
          onTap: (){
      
          },
        ),
        
      ]
      
  );
}

//Colorcitos
_colorMainHome(int intensidad){
    return Colors.orangeAccent[intensidad];
  }
_colorMainDeve(int intensidad){
    return Colors.teal[intensidad];
  }
_colorMainStories(int intensidad){
    return Colors.pink[intensidad];
  }
// _colorAzul(int intensidad){
//     return Colors.lightBlue[intensidad];
//   }
_colorPostick(color){
  switch(color){
  case 0:
     return Colors.pink[100];
    break;
  case 1:
      return Colors.orangeAccent[100];
    break;
  case 2:
      return Colors.teal[100];
    break;
  default:
  return Colors.amber[100];
    break;
}
  
}
_colorNavBar(index){
  switch(index){
    case 0:
  
      return Colors.orangeAccent[400];
      break;
    case 1:
   
      return Colors.teal[400];
      break;
    case 2:
    
      return Colors.pink[400];
      break;
    default:
    
      return Colors.orangeAccent[400];
      break;

  }
}



// Widget _postick(){
//   return Container(
//     child: FadeInImage(
      
//       image: AssetImage('assets/postick.png'),
//       placeholder: AssetImage('assets/loading.gif'),
//       fadeInDuration: Duration(milliseconds:200),

//       fit: BoxFit.fill,
//     ),
//   );
// }

  