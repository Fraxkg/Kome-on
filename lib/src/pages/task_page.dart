import 'package:flutter/material.dart';
import 'package:kome_on/src/models/tarea_model.dart';
import 'package:kome_on/src/providers/tareas_provider.dart';
 
class TaskPage extends StatefulWidget {
  TaskPage({Key key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  int _indexNave=0;
  bool _editMode=false;
  final tareasProvider= new TareasProvider();
  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    String _idTarea = ModalRoute.of(context).settings.arguments;
    print(_idTarea);
    queryData = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Plataforma en línea de\neducación para niños"),
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
      
      body: _cuerpo(_editMode,_idTarea),
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
      Navigator.pushReplacementNamed(context,'/home',arguments:args);
      
    });
  }
  Widget _tabla(TareaModel tarea){
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(4.0),
        color: Colors.amberAccent[100]
          ),
      child: SingleChildScrollView(
        child: Column(
          
      
          children: <Widget>[
            Divider(),
            Container(
              
              child:Text("#1  "+"Diseño de interfaces", style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20),)
            ),
            SizedBox(
              height: 20,
            ),
            _descripcion(tarea),
            Divider(),
            _responsable(),
            _fechas(tarea),
            Divider(),
            _atributos(queryData,tarea),
            
            SizedBox(
              height: 10,
            ),
            

          ],
        
        ),
      ),
    );
  }

  Widget _descripcion(TareaModel tarea){
    return Container(
      
      padding: EdgeInsets.only(left:10,right:10),
      child: Column(
        children: [
          Container(
            height: 50,
            
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text("Descripción", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
            decoration: BoxDecoration(
              border: Border.all(color: _colorBorderMain()),
              borderRadius: BorderRadius.circular(4.0),
              color: _colorMain()
                ),
          ),
          Container(
            height: 100,
            padding: EdgeInsets.all(5),
            alignment: Alignment.center,
            
            child: Text(tarea.descTarea,
            style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
            decoration: BoxDecoration(
              border: Border.all(color: _colorBorderMain()),
              borderRadius: BorderRadius.circular(4.0),
              color: Colors.grey[300]
            ),
          )
        ],
      )
    );
  }

  Widget _responsable(){
    return Container(
      
      padding: EdgeInsets.only(left:10,right:10),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 110,
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text("Responsable", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
            decoration: BoxDecoration(
              border: Border.all(color: _colorBorderMain()),
              borderRadius: BorderRadius.circular(4.0),
              color: _colorMain()
                ),
          ),
          Expanded(
            child: Container(
              height: 50,
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              
              child: Text("Francisco guillermo de la toba balgamidades",
              style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
              decoration: BoxDecoration(
                border: Border.all(color:_colorBorderMain()),
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[300]
              ),
            ),
          )
        ],
      )
    );
  }

  Widget _fechas(TareaModel tarea){
    return Container(
      
      padding: EdgeInsets.only(left:10,right:10),
      child: Row(
        children: [
          Container(
            height: 50,
            width: 110,
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text("Inico", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
            decoration: BoxDecoration(
              border: Border.all(color: _colorBorderMain()),
              borderRadius: BorderRadius.circular(4.0),
              color: _colorMain()
                ),
          ),
          Expanded(
            child: Container(
              height: 50,
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              
              child: Text(tarea.fechaInicio,
              style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
              decoration: BoxDecoration(
                border: Border.all(color: _colorBorderMain()),
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[300]
              ),
            ),
          ),
          Container(
            height: 50,
            width: 100,
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Text("Fin", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
            decoration: BoxDecoration(
              border: Border.all(color: _colorBorderMain()),
              borderRadius: BorderRadius.circular(4.0),
              color: _colorMain()
                ),
          ),
          Expanded(
            child: Container(
              height: 50,
              padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              
              child: Text(tarea.fechaFin,
              style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
              decoration: BoxDecoration(
                border: Border.all(color: _colorBorderMain()),
                borderRadius: BorderRadius.circular(4.0),
                color: Colors.grey[300]
              ),
            ),
          )
        ],
      )
    );
  }

  Widget _atributos(MediaQueryData queryData, TareaModel tarea){
    return Container(
      
      padding: EdgeInsets.only(left:10,right:10),
      child: Row(
        children: <Widget>[
          Column(
            children: [
              Container(
                height: 50,
                width: queryData.size.width/4-11,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text("Estado", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color: _colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: _colorMain()
                    ),
              ),
              Container(
                height: 50,
                width: queryData.size.width/4-11,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                
                child: Text(tarea.estadoTarea,
                style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color:_colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.grey[300]
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                height: 50,
                width: queryData.size.width/4-11,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text("Requisito", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color: _colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: _colorMain()
                    ),
              ),
              Container(
                height: 50,
                width: queryData.size.width/4-11,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                
                child: Text(tarea.requisito,
                style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color:_colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.grey[300]
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                height: 50,
                width: queryData.size.width/4-11,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text("Esfuerzo", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color: _colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: _colorMain()
                    ),
              ),
              Container(
                height: 50,
                width: queryData.size.width/4-11,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                
                child: Text(tarea.esfuerzo,
                style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color: _colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.grey[300]
                ),
              )
            ],
          ),
          Column(
            children: [
              Container(
                height: 50,
                width: queryData.size.width/4-11,
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                child: Text("Urgencia", style:TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color: _colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: _colorMain()
                    ),
              ),
              Container(
                height: 50,
                width: queryData.size.width/4-11,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                
                child: Text(tarea.urgencia,
                style:TextStyle(fontSize: 15),textAlign: TextAlign.center,),
                decoration: BoxDecoration(
                  border: Border.all(color: _colorBorderMain()),
                  borderRadius: BorderRadius.circular(4.0),
                  color: Colors.grey[300]
                ),
              )
            ],
          ),
        ]
      )
        
    );
  }
  _cuerpo(onof,_idTarea){
    return Stack(
      children: [

        _recuperarInfo(tareasProvider,_idTarea),
        _opcionesEdicion(onof),
        
      ],
    );
  }
   Widget _recuperarInfo(tareasProvider,_idTarea){
      return FutureBuilder(
        future: tareasProvider.cargarTareas(),
        builder: (BuildContext context, AsyncSnapshot<List<TareaModel>> snapshot){
          if(snapshot.hasData){
            //print("buscar proyectos de"+_idProyecto);
            TareaModel seleccion;
            var tareas = snapshot.data;
              //print(_idProyecto);
                
                for(int j=0;j<tareas.length;j++){
                  if(tareas[j].id==_idTarea){
                    seleccion=tareas[j];
                  }
                }

                return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                //4 ahorita
                itemCount: 1,
                itemBuilder: (context,i) => _tabla(seleccion),
                
                 
              );

          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      );
  }
  _opcionesEdicion(bool onof){
    return Visibility(
      child: Row(
        
        children: <Widget>[
          InkWell(
            child: Container(margin: EdgeInsets.only(left:5, top: 10),width: 50, height:50,child: Icon(Icons.clear_outlined , color: Colors.red,size: 50,)
            ),onTap: (){

            },
          ),
          InkWell(
            child: Container(margin: EdgeInsets.only(left:1, top: 10),width: 50, height:50,child: Icon(Icons.mode_outlined  , color: Colors.red,size: 45,)
            
            ),onTap: (){
              
            },
          ),
        
        ]
      ),
      
      visible: onof,
    );

  }
  _colorMain(){
    return Colors.teal[600];
  }
  _colorBorderMain(){
    return Colors.white;
  }
}