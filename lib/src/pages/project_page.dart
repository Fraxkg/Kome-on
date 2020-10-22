import 'package:flutter/material.dart';

class ProjectPage extends StatefulWidget {
  ProjectPage({Key key}) : super(key: key);

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  bool _editMode= false;
  int _indexNave=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Plataforma en línea de educación para niños con autismo"),
        backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        actions: <Widget>[
          Switch(
            value: _editMode,
            onChanged: (value) {
              setState(() {
                _editMode = value;
                print(_editMode);
              });
            }
          )
        ]
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
          selectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        
        onPressed: (){
          Navigator.pushNamed(context, '/task');
        },
      ),
       
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _indexNave = index;

      
    });
  }
}