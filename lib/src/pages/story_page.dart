import 'package:flutter/material.dart';

class StoryPage extends StatefulWidget {
  StoryPage({Key key}) : super(key: key);

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
int _indexNave =2;
@override
Widget build(BuildContext context) {
  return Scaffold(
      appBar: AppBar(
        title: Text("Historias"),
        backgroundColor: _colorRosa(400),
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
       
      drawer: Drawer(

      ),
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
          selectedItemColor: _colorRosa(400),
          onTap: _onItemTapped,
        ),
      ),
       
    );
  }
  void _onItemTapped(int index) {
    setState(() {
      _indexNave = index;
      switch (_indexNave){
        case 0:
          Navigator.pushNamed(context, '/');
          break;
        case 1:
          Navigator.pushNamed(context, '/develop');
          break;
       
      }
    });
  }
}


//Colorcitos

// _colorNaranja(int intensidad){
//     return Colors.orangeAccent[intensidad];
//   }
// _colorTeal(int intensidad){
//     return Colors.teal[intensidad];
//   }
_colorRosa(int intensidad){
    return Colors.pink[intensidad];
  }
// _colorAzul(int intensidad){
//     return Colors.lightBlue[intensidad];
//   }

