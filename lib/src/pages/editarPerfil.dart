import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kome_on/src/models/desarrollador_model.dart';
import 'package:kome_on/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:kome_on/src/providers/desarrolladores_provider.dart';
import 'package:image_picker/image_picker.dart';

class EditarPerfilPage extends StatefulWidget {
  EditarPerfilPage({Key key}) : super(key: key);
  
  @override
  _EditarPerfilPageState createState() => _EditarPerfilPageState();
}

class _EditarPerfilPageState extends State<EditarPerfilPage> {

  // TextEditingController controllerNombre = new TextEditingController();
  // TextEditingController controllerAP = new TextEditingController();
  // TextEditingController controllerAM = new TextEditingController();
  
  bool flagGuardando =false;
  PickedFile foto;
  File fotoMostrar;
  String nombres="";
  String aP="";
  String aM="";
  final _prefs= new PreferenciasUsuario();
  final desarrolladorProvider = new DesarrolladorProvider();
  DesarrolladorModel dev= new DesarrolladorModel();
  final formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(55, 57, 84, 1.0),
        title: Text('Editar Perfil'),
        
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: _crearForm(desarrolladorProvider),
          ),
        ),
      ),
    );
  }
  Widget _crearForm(desarrolladorProvider){
    
  
    return FutureBuilder(
      
      future: desarrolladorProvider.cargarDesarrollador(),
      builder: (BuildContext context, AsyncSnapshot<List<DesarrolladorModel>> snapshot){
        
        if(snapshot.hasData){
          
          List<DesarrolladorModel> seleccion=[];
          final devs = snapshot.data;

            for(int j=0;j<devs.length;j++){
              if(devs[j].userId==_prefs.userId){
              seleccion.add(devs[j]);
              //print("c");
            }
            }
         
              Future.delayed(const Duration(seconds: 2), () {

// Here you can write your code

                  setState(() {
                    // Here you can write your code for open new view
                  });

                });
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1,
              
              itemBuilder: (context, i) =>_cuadroInfoDevs(context,seleccion[0]),
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
Widget _cuadroInfoDevs(context,dev){
  return Column(
    children: <Widget>[
        _crearAvatar(dev.perfilUrl),
        SizedBox(height:20),
        _crearNombre(dev.nombre),
        SizedBox(height:20),
        _crearPaterno(dev.apePaterno),
        SizedBox(height:20),
        _crearMaterno(dev.apeMaterno),
        SizedBox(height:20),
        RaisedButton(
          padding: EdgeInsets.all(20),
          child: Text('Guardar cambios',style: TextStyle(fontSize: 20),),
          color: Colors.cyan,
          textColor: Colors.white,
          shape: StadiumBorder(),
          
          onPressed:() async {
          if(flagGuardando){
            
          }else{
          setState(() {flagGuardando = true; });
           if(nombres!=""){
           dev.nombre=nombres;
          }
          if(aP!=""){
            dev.apePaterno=aP;
          }
          if(aM!=""){
           dev.apeMaterno=aM; 
          }
          setState(() {
            
          });
          llamarToast("Guardando cambios...");
          if(foto!=null){
            dev.perfilUrl=await desarrolladorProvider.subirImagen(fotoMostrar);
          }
          //print("mandar"+dev.id);
          desarrolladorProvider.editarDesarrollador(dev);
          //print(idProyecto);
          Navigator.pop(context);
          _showMyDialog(context);
        }  
          }
          
        
        )
        
        
    ]
    
    );
  

}
  Widget _crearAvatar(foto){
    return Column(
      children: [
        _mostrarFoto(foto),
        Row(
          children: [
            IconButton(
              icon: Icon(FlutterIcons.photo_faw),
              onPressed: (){
                _seleccionarFoto();
              },
            ),
            IconButton(
              icon: Icon(FlutterIcons.camera_faw),
              onPressed: (){
                _seleccionarCamara();
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _crearNombre(nombre){
    
    return TextFormField(
      //autofocus: true,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        hintText: nombre,
        labelText: 'Nombre/s',
       
        
        icon: Icon(FlutterIcons.user_alt_faw5s,color:Colors.black)
      ),
      
      validator: (value){
        if(value.length<2){
          return 'Ingrese un nombre válido';
        }else{
          return null;
        }
      },
      onChanged: (text){
        setState(() {
            
          
          });
        nombres=text;

        
        
      },
        
    );
  }
  Widget _crearPaterno(nombre){
    return TextFormField(
      //autofocus: true,
      // initialValue: nombre,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        hintText: nombre,
        labelText: 'Apellido Paterno',
       
        
        icon: Icon(FlutterIcons.blank_mco,color:Colors.white)
      ),
     
      validator: (value){
        if(value.length<2){
          return 'Ingrese un apellido válido';
        }else{
          return null;
        }},
      onChanged: (text){
        setState(() {

          });
        aP=text;
      },
        
    );
  }
  Widget _crearMaterno(nombre){
    return TextFormField(
      //autofocus: true,
      // initialValue: nombre,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0)
        ),
        
        hintText: nombre,
        labelText: 'Apellido Materno',
       
        
        icon: Icon(FlutterIcons.blank_mco,color:Colors.white)
      ),
      
      validator: (value){
        if(value.length<2){
          return 'Ingrese un apellido válido';
        }else{
          return null;
        }},
      onChanged: (text){
        setState(() {
            
          
          });
        aM=text;

        
        
      },
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
                Text('Perfil editado con éxito'),
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
  _mostrarFoto(fotoUsuario) {
    
    if (fotoUsuario != "" && foto==null) {
 
      return Container(
         decoration: BoxDecoration(
         
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.black)
         ),
        height: 300.0,
        width: 400.0,
        child: ClipRRect(
          
          borderRadius: BorderRadius.circular(30.0),
          child: FadeInImage(
          image: NetworkImage(fotoUsuario,),
          
          placeholder: AssetImage("assets/loading.gif"),
          fadeInDuration: Duration( milliseconds: 200 ),
          fit: BoxFit.cover,
        )
         ),
        
      );
      
 
    } else {
 
      if( foto != null ){
        return Container(
          decoration: BoxDecoration(
         
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(color: Colors.black)
         ),
          height: 300.0,
          width: 400.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: Image.file(
            fotoMostrar,
            
            fit: BoxFit.cover,
          
          )
          
        ),
        );
        
      }
      return Image.asset('assets/no-image.png');
    }
  }
  _seleccionarFoto() async {
    final _picker = ImagePicker();
    final pickedFile =await _picker.getImage(
      source: ImageSource.gallery
      
    );
    try {
      foto = PickedFile(pickedFile.path);
      fotoMostrar=File(pickedFile.path);
    } catch (e) {
      print('$e');
    }
    if(foto!=null){
      //clean

    }
    
    setState(() {});
  }
  _seleccionarCamara() async {
    final _picker = ImagePicker();
    final pickedFile =await _picker.getImage(
      source: ImageSource.camera
      
    );
    try {
      foto = PickedFile(pickedFile.path);
      fotoMostrar=File(foto.path);
    } catch (e) {
      print('$e');
    }
    if(foto!=null){
      //clean

    }
    
    setState(() {});
  }  
}
llamarToast(mensaje){
  return Fluttertoast.showToast(
    msg: mensaje,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black.withOpacity(0.6),
    textColor: Colors.white,
    fontSize: 16.0
);
}