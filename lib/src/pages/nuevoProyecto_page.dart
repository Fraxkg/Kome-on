import 'package:flutter/material.dart';

class NuevoProyectoPage extends StatefulWidget {
  NuevoProyectoPage({Key key}) : super(key: key);

  @override
  _NuevoProyectoPageState createState() => _NuevoProyectoPageState();
}

class _NuevoProyectoPageState extends State<NuevoProyectoPage> {
  TextEditingController _inputFieldDateController = new TextEditingController();
  TextEditingController _inputFieldDateController2 = new TextEditingController();
  
  String _nombreUsuario="na";
  String _fechaInicio="";
  String _fechaFin="";
  String _nombreProyecto="";
  String _descripcion="";

  @override
  Widget build(BuildContext context) {
    
    var _loggedName = ModalRoute.of(context).settings.arguments;
    if ( _nombreUsuario != null ) {
      _nombreUsuario = _loggedName;
    }
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
            
            child: Column(
              children: <Widget>[
                Divider(),
                _crearNombre(_nombreUsuario),
                Divider(),
                _crearNombreProyecto(),
                Divider(),
                _crearDescripcion(),
                SizedBox(height: 30,),
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
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        
        labelText: 'Descripción del proyecto',
       
        
        icon: Icon(Icons.edit)
      ),
      onChanged: (valor) => setState(() {
          _descripcion = valor;
          
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
      onChanged: (valor) => setState(() {
          _nombreProyecto = valor;
          
        })
        
    );
  }

  Widget _crearNombre(String nombre,) {

    return TextFormField(
      //autofocus: true,
      initialValue: nombre,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        
        labelText: 'Nombre del líder',
        helperText: '*** Nombre de cuenta seleccionado por defecto',
        
        icon: Icon(Icons.account_circle)
      ),
      onChanged: (valor) => setState(() {
          _nombreUsuario = valor;
          
        })
        
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
      firstDate: new DateTime(2018),
      lastDate: new DateTime(2025),
      
      locale: Locale('es','ES')
    );

    if(picked != null && seleccion==1 ){
      setState(() {
        _fechaInicio=picked.year.toString()+"/"+picked.month.toString()+"/"+picked.day.toString();
        _inputFieldDateController.text = _fechaInicio;
        
      });
    }else if(picked != null && seleccion==1){
      setState(() {
        _fechaFin=picked.year.toString()+"/"+picked.month.toString()+"/"+picked.day.toString();
        _inputFieldDateController2.text = _fechaFin;
        
      });
    }
    print(_fechaInicio);
    print(_fechaFin);
  }
}