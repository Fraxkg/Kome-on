import 'package:flutter/material.dart';

import 'package:kome_on/src/models/proyecto_model.dart';
import 'package:kome_on/src/providers/proyectos_provider.dart';
class NuevoProyectoPage extends StatefulWidget {
  
  NuevoProyectoPage({Key key}) : super(key: key);

  @override
  _NuevoProyectoPageState createState() => _NuevoProyectoPageState();
}

class _NuevoProyectoPageState extends State<NuevoProyectoPage> {
  
  final formKey = GlobalKey<FormState>();

  ProyectoModel proyecto= new ProyectoModel();
  final proyectoProvider = new ProyectosProvider();
  
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _inputFieldDateController2 = new TextEditingController();
  
  
  String _fechaInicio="";
  String _fechaFin="";
  

  @override
  Widget build(BuildContext context) {
    
    final List userInfo = ModalRoute.of(context).settings.arguments;
    String userId=userInfo[0];
    String userEmail=userInfo[1];
    
//controllers de text field
    

    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        title: Text('Nuevo Proyecto'),
        
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                Divider(),
                _crearNombre(userEmail,userId),
                Divider(),
                _crearNombreProyecto(),
                Divider(),
                _crearDescripcion(),
                SizedBox(height: 30,),
                _crearWip(),
                SizedBox(height:30),
                _crearFechaInicio(),
                SizedBox(height:30),
                _crearFechaFin(),
                SizedBox(height:50),
                RaisedButton(
                  padding: EdgeInsets.all(20),
                  child: Text('Crear proyecto',style: TextStyle(fontSize: 20),),
                  color: Colors.cyan,
                  textColor: Colors.white,
                  shape: StadiumBorder(),
                  onPressed: (){
                    _submit();
                  } 
                )
                  
               // _crearBoton()
              ],
            ),
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
      onSaved: (value)=>proyecto.descripcion=value,
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
  
  Widget _crearNombreProyecto(){
    return TextFormField(
      //autofocus: true,
     
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        
        labelText: 'Nombre del proyecto',
       
        
        icon: Icon(Icons.book)
      ),
      onSaved: (value)=>proyecto.nombre=value,
      validator: (value){
        if(value.length<3){
          return 'Ingrese un nombre válido';
        }else if(value.length>73){
          return 'Nombre muy largo';
        
        }else{
          return null;
        }},
      onChanged: (valor) => setState(() {
         
          
        })
        
    );
  }

  Widget _crearNombre(String nombre,userId) {

    return TextFormField(
      //autofocus: true,
      enabled: false,
      initialValue: nombre,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        
        labelText: 'Email del responsable',
        helperText: '*** Email de cuenta seleccionado por defecto',
        
        icon: Icon(Icons.account_circle)
      ),
      onSaved: (value){
        proyecto.responsable=value;
        proyecto.userId=userId;
      },
      validator: (value){
        if(value.length<3){
          return 'Ingrese un email';
        }else{
          return null;
        }},
      onChanged: (valor) => setState(() {
          
          
        })
        
    );

  }
  Widget _crearWip() {
    return TextFormField(
     
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      decoration: InputDecoration(
        
        labelText: 'WIP Limit',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)),
          icon: Icon(Icons.note),
      ),
      onSaved: (value){
        
        proyecto.wipLimit = value;
      },
      validator: (value) {
        int wip=int.parse(value);
        if ( value.length==1 ||value.length==2 && wip>=1 &&wip<=6  ) {
          return null;
        } else {
          return 'Sólo números enteros, el Wip limit >1 <6';
        }

      },
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
      onSaved: (value)=>proyecto.fechaInicio=value,
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
      onSaved: (value)=>proyecto.fechaFin=value,
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

  void _submit(){
    if(!formKey.currentState.validate()){
      return;
    }
    formKey.currentState.save();
    //print(proyecto.nombre);
    
    proyectoProvider.crearProyecto(proyecto);
    //print(idProyecto);
    Navigator.pop(context);
    _showMyDialog(context);
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
                Text('Proyecto creado con éxito'),
                Text('Recuerda agregar tareas'),
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
}