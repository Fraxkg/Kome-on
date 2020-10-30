import 'package:flutter/material.dart';
import 'package:kome_on/src/models/proyecto_model.dart';
import 'package:kome_on/src/models/tarea_model.dart';
import 'package:kome_on/src/providers/proyectos_provider.dart';
import 'package:kome_on/src/providers/tareas_provider.dart';

class NuevaTareaPage extends StatefulWidget {
  NuevaTareaPage({Key key}) : super(key: key);
  
  @override
  _NuevaTareaPageState createState() => _NuevaTareaPageState();
}

class _NuevaTareaPageState extends State<NuevaTareaPage> {

  MediaQueryData queryData;
  bool _flagUrgencia=false;
  String nombreProyecto = '';
  final proyectosProvider = new ProyectosProvider();
  final formKeyNuevaTarea = GlobalKey<FormState>();
  TareaModel tarea= new TareaModel();
  final tareaProvider = new TareasProvider();
  String tipo='Diseño';
  String requisito='Ninguno';
  List _tipos= ['Diseño', 'Análisis','Programación','a','Libre'];
  List _requisitos= ['Ninguno','actividad 1', 'actividad 2'];
  String _opcionSelecTipos;
  String _opcionSelecRequisitos;
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _inputFieldDateController2 = new TextEditingController();
  
  String _fechaInicio="";
  String _fechaFin="";

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    String _idProyecto = ModalRoute.of(context).settings.arguments;
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        title: Text('Nueva Tarea'),
        
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKeyNuevaTarea,
            child: Column(
              children: <Widget>[
                _verificarProyecto(_idProyecto,queryData),
                //_crearNombreProyecto(nombreProyecto),
                Divider(),
                _crearNombre(),
                SizedBox(height:20),
                Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.graphic_eq_outlined),
                    SizedBox(width:20),
                    _crearTipo(),
                    _crearRequisito()
                  ],
                ),
                SizedBox(height: 20),
                _crearDescripcion(),
                SizedBox(height: 20),
                _esfuerzo(),
                SizedBox(height: 20),
                _crearFechaInicio(),
                SizedBox(height: 20),
                _crearFechaFin(),
                Divider(),
                _crearUrgencia(),
                Divider(),
                RaisedButton(
                  
                  padding: EdgeInsets.all(20),
                  child: Text('Crear Tarea',style: TextStyle(fontSize: 20),),
                  color: Colors.cyan,
                  textColor: Colors.white,
                  shape: StadiumBorder(),
                  onPressed: (){
                  _submit(_idProyecto);
                  
                  } 
                ),
                
                  
               // _crearBoton()
              ],
            ),
          ),
        ),
      ),
       
    );
  }
  _crearUrgencia(){
    return Row(
      children:<Widget>[
        Text("Urgente",style: TextStyle(fontSize:16),) ,
        Switch(
          value: _flagUrgencia,
          
          onChanged: (value){
            setState(() {
              _flagUrgencia=value;
            });
          }
        ),
      ]
    );
  }
  Widget _crearFechaInicio() {
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _inputFieldDateController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Fecha de Inicio',
        labelText: 'Fecha de Inicio',
        suffixIcon: Icon(Icons.calendar_today_outlined),
        icon: Icon(Icons.calendar_today)
      ),
      onSaved: (value)=>tarea.fechaInicio=value,
      validator: (value){
        if(value.length<3){
          return 'Ingrese una fecha válida';
        }else{
          return null;
        }},
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context,1);
  
      },
    );
  }

  Widget _crearFechaFin() {
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _inputFieldDateController2,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Fecha de Finalización',
        labelText: 'Fecha de Finalización',
        suffixIcon: Icon(Icons.calendar_today_outlined),
        icon: Icon(Icons.calendar_today)
      ),
      onSaved: (value)=>tarea.fechaFin=value,
      validator: (value){
        if(value.length<3){
          return 'Ingrese una fecha válida';
        }
        else{
          return null;
        }},
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context,2);
  
      },
    );
  }
  

  Widget _crearTipo(){
    return Container(
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.cyan,
        border: Border.all(color: Color.fromRGBO(120, 0, 155, .5))
      ),
      padding: const EdgeInsets.only(right: 20.0, left: 20.0 ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
            //alignedDropdown: true,
          child: DropdownButton(
            
            icon: Icon(Icons.expand_more,color: Colors.white, ),
            dropdownColor: Colors.teal.withOpacity(.9),
            //focusColor: Color.fromRGBO(0, 106, 120,.5),
            style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            value: _opcionSelecTipos,
            items: getOpcionesDropdownTipos(),
            onTap: (){},

            onChanged: (op){
              setState(() {
                
                 _opcionSelecTipos = op;
              });
            },
            
            hint: Text("Tipo",style: TextStyle(
                    color: Colors.white,)),
          ),
        ),
      ),
    ); 
  }

  Widget _crearRequisito(){
    return Container(
      
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.cyan,
        border: Border.all(color: Color.fromRGBO(120, 0, 155, .5))
      ),
      padding: const EdgeInsets.only(right: 20.0, left: 20.0 ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
        //  alignedDropdown: true,
            child: DropdownButton(
            
            icon: Icon(Icons.expand_more,color: Colors.white, ),
            dropdownColor: Colors.teal.withOpacity(.9),
            //focusColor: Color.fromRGBO(0, 106, 120,.5),
            style:TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
            value: _opcionSelecRequisitos,
            items: getOpcionesDropdownRequisito(),
            onTap: (){},
           
            onChanged: (op){
              setState(() {
                
                 _opcionSelecRequisitos = op;
              });
            },
            
            hint: Text("Requisito",style: TextStyle(
                    color: Colors.white,)),
          ),
        ),
      ),
    ); 
  }
  
  Widget _crearDescripcion(){
    return TextFormField(
      //autofocus: true,
    keyboardType: TextInputType.multiline,
      maxLines: null,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        labelText: 'Descripción del proyecto',
        
        icon: Icon(Icons.edit)
      ),
      onSaved: (value)=>tarea.descTarea=value,
      validator: (value){
        if(value.length<3){
          return 'Ingrese una descripción';
        }else{
          return null;
        }
      },
      onChanged: (valor) => setState(() {
          
          
      })
        
    );
  }
  
  Widget _crearNombre(){
    return TextFormField(
      //autofocus: true,
     
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        
        labelText: 'Nombre de la tarea',
       
        
        icon: Icon(Icons.note_add_outlined)
      ),
      onSaved: (value)=>tarea.nombre=value,
      validator: (value){
        if(value.length<3){
          return 'Ingrese un nombre válido';
        }else if(value.length>25){
          return 'Nombre muy largo';
        
        }else{
          return null;
        }},
      onChanged: (valor) => setState(() {
         
          
        })
        
    );
  }

  Widget _esfuerzo(){
    return TextFormField(
      //autofocus: true,
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        
        labelText: 'Puntos de esfuerzo',
       
        
        icon: Icon(Icons.grade)
      ),
      onSaved: (value)=>tarea.esfuerzo=value,
      validator: (value){
        int wip=int.parse(value);
        if ( value.length==1 ||value.length==2 && wip>=1 &&wip<=20  ) {
          return null;
        } else {
          return 'Sólo números enteros, >1 <20';
        }

      },
      onChanged: (valor) => setState(() {
         
          
        })
        
    );
  }

  _submit(_idProyecto){
    if(!formKeyNuevaTarea.currentState.validate()){
      return;
    }
    formKeyNuevaTarea.currentState.save();
    //print(proyecto.nombre);
    if(_opcionSelecTipos!=null && _opcionSelecRequisitos!=null){
      tarea.proyectoId = _idProyecto;
      tarea.tipoTarea=_opcionSelecTipos;
      tarea.requisito=_opcionSelecRequisitos;
      if(_flagUrgencia){
        tarea.urgencia='Si';
      }else{
        tarea.urgencia='No';
      }
      tareaProvider.crearTarea(tarea);
      
    Navigator.pop(context);
    _showMyDialog(context);
    }else{
      _showMyDialogErrorDropdown(context);
    }
    
  }
  
  Widget _verificarProyecto(proyectoId,queryData){
    print(nombreProyecto);
    return FutureBuilder(
      future: proyectosProvider.cargarProyectos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProyectoModel>> snapshot){
        if(snapshot.hasData){
          
          final proyectos = snapshot.data;
          for(int i=0;i<proyectos.length;i++){
             if(proyectos[i].id==proyectoId){
               nombreProyecto=proyectos[i].nombre;
               print(nombreProyecto);
             }
          }
         
            return Container(
              
              width:queryData.size.width,
              child: Text(nombreProyecto,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              );
          
        }else{
          return Center(child: CircularProgressIndicator());
        
        }
      }
    );
      

  }
  
  void _showMyDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('¡Perfecto!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Tarea creada con éxito'),
                Text('Es hora de trabajar (ง •᷄ω•)ว'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  void _showMyDialogErrorDropdown(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: Text('¡Error!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Error, selecciona un tipo y un requisito'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
  
  List<DropdownMenuItem<String>>getOpcionesDropdownTipos(){
    
  List<DropdownMenuItem<String>> lista = new List();
    
    _tipos.forEach((tipo){
      lista.add(DropdownMenuItem(
        child: Text(tipo),
        value: tipo,
      ));
    });
    return lista;
  }

  List<DropdownMenuItem<String>>getOpcionesDropdownRequisito(){
      
    List<DropdownMenuItem<String>> lista = new List();
      
      _requisitos.forEach((requisito){
        lista.add(DropdownMenuItem(
          child: Text(requisito),
          value: requisito,
        ));
      });
      return lista;
  }

  _selectDate(BuildContext context,seleccion)async{

    DateTime picked = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(2019),
      lastDate: new DateTime(2028),
      
      locale: Locale('es','ES')
    );

    if(picked != null && seleccion==1 ){
      setState(() {
        _fechaInicio=picked.year.toString()+"/"+picked.month.toString()+"/"+picked.day.toString();
        _inputFieldDateController.text = _fechaInicio;
        
      });
    }else if(picked != null && seleccion==2){
      setState(() {
        _fechaFin=picked.year.toString()+"/"+picked.month.toString()+"/"+picked.day.toString();
        _inputFieldDateController2.text = _fechaFin;
        
      });
    }
    // print(_fechaInicio);
    // print(_fechaFin);
  }

}
