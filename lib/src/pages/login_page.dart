import 'package:flutter/material.dart';

import 'package:kome_on/src/providers/usuario_provider.dart';

class LoginPage extends StatefulWidget {
  
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email='';
  String password='';
  final usuarioProvider= new UsuarioProvider();

   final formKeyLogin = GlobalKey<FormState>();
  Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  
  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    
     RegExp regExp   = new RegExp(pattern);
    queryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: () async => false,
          child: Container(
         child: Scaffold(
           
           body: Stack(
          children: <Widget>[
            _crearFondo( context ),
            _loginForm(queryData,regExp),
            
          ],
        )
         ),
      ),
    );
  }
//forms
  Widget _loginForm(MediaQueryData queryData,regExp){
    return SingleChildScrollView(
      child: Form(
        key: formKeyLogin,
        child: Column(
          children: <Widget>[

            SafeArea(
              child: Container(
                height: 180.0,
              ),
            ),

            Container(
              width: queryData.size.width-100,
              margin: EdgeInsets.symmetric(vertical: 30.0),
              padding: EdgeInsets.symmetric( vertical: 50.0 ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                    spreadRadius: 3.0
                  )
                ]
              ),
              child: Column(
                children: <Widget>[
                  Text('Inicia Sesión', style: TextStyle(fontSize: 20.0)),
                  SizedBox( height: 60.0 ),
                  _crearEmail(regExp),
                  SizedBox( height: 30.0 ),
                  _crearPassword(),
                  SizedBox( height: 30.0 ),
                  _crearBoton()
                ],
              ),
            ),

            FlatButton(
              child: Text('Crear una nueva cuenta'),
              onPressed: ()=> Navigator.pushReplacementNamed(context, '/registro'),
            ),
            SizedBox( height: 100.0 )
          ],
        ),
      ),
    );
  }
//boton
Widget _crearBoton() {

 
  return RaisedButton(
    child: Container(
      padding: EdgeInsets.symmetric( horizontal: 80.0, vertical: 15.0),
      child: Text('Ingresar'),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5.0)
    ),
    elevation: 0.0,
    color: Colors.deepPurple,
    textColor: Colors.white,
    onPressed: ()=> _submit()
  );

    
  }
//crear password
  Widget _crearPassword(){
    return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),

          child: TextFormField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon( Icons.lock_outline, color: Colors.deepPurple ),
              labelText: 'Contraseña',
              
            ),
            validator: (value){
              if(value.length<6){
                return 'Contraseña muy corta';
              }else{
                return null;
              }
            },
            onChanged: (valor){ 
              setState( (){});
              password=valor;
            }
          ),

        );
  }
//submit
  _submit()async{
    if(!formKeyLogin.currentState.validate()){
        return;
      }

      formKeyLogin.currentState.save();

      Map info= await usuarioProvider.login(email,password);

      if(info['ok']){
        print (info['userId']);
        // String userId=info['userId'];
        // String emailU=info['email'];
        //List args=["$userId","$emailU"];
        Navigator.pushReplacementNamed(context, "/home");
      }else{
        _mostrarAlerta(context,info['mensaje']);
      }
      
      //Navigator.pushReplacementNamed(context, "/home");
      //formKeyLogin.crearProyecto(proyecto);
      
      //Navigator.pop(context);
      //_showMyDialog(context);
  }

//email
  Widget _crearEmail(regExp){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),

        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon( Icons.alternate_email, color: Colors.deepPurple ),
            hintText: 'ejemplo@correo.com',
            labelText: 'Correo electrónico',
            
          ),
          
          validator: (value){
            if ( regExp.hasMatch( value ) ) {
              return null;
            } else {
              return 'Ingrese un correo válido';
            }
          },
          onChanged: (valor){ 
              setState( (){});
              email=valor;
            }
        ),

      );
  }
//fondo
  Widget _crearFondo(BuildContext context) {

    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color> [
            Color.fromRGBO(63, 63, 156, 1.0),
            Color.fromRGBO(90, 70, 178, 1.0)
          ]
        )
      ),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );


    return Stack(
      children: <Widget>[
        fondoMorado,
        Positioned( top: 90.0, left: 30.0, child: circulo ),
        Positioned( top: -40.0, right: -30.0, child: circulo ),
        Positioned( bottom: -50.0, right: -10.0, child: circulo ),
        Positioned( bottom: 120.0, right: 20.0, child: circulo ),
        Positioned( bottom: -50.0, left: -20.0, child: circulo ),
        
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon( Icons.person_pin_circle, color: Colors.white, size: 100.0 ),
              SizedBox( height: 10.0, width: double.infinity ),
              Text('Bienvenido a Kome-on', style: TextStyle( color: Colors.white, fontSize: 25.0 )),
              
            ],
          ),
        )

      ],
    );

  }
  void _mostrarAlerta(BuildContext context, String mensaje){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text("Oh uh"),
        content: Text(mensaje),
        actions: <Widget>[
          FlatButton(
            child:Text('Ok'),
            onPressed: ()=> Navigator.of(context).pop(),
          )
        ],

      );
    }
    
  
  );
}
}