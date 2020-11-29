
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kome_on/src/pages/editarPerfil.dart';

import 'package:kome_on/src/pages/home_page.dart';
import 'package:kome_on/src/pages/login_page.dart';
import 'package:kome_on/src/pages/nuevaTarea_page.dart';
import 'package:kome_on/src/pages/nuevoProyecto_page.dart';
import 'package:kome_on/src/pages/project_page.dart';
import 'package:kome_on/src/pages/registro_page.dart';
import 'package:kome_on/src/pages/task_page.dart';
import 'package:kome_on/src/preferencias_usuario/preferencias_usuario.dart';



Future<void>main()async{
  
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
//date picker en español
      localizationsDelegates: [
   // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''), // English, no country code
        const Locale('he', ''), // Hebrew, no country code
        const Locale.fromSubtags(languageCode: 'zh'), // Chinese *See Advanced Locales below*
        // ... other locales the app supports
      ],
//se acaba datepicker
      title: 'Kome on',
      initialRoute: '/home',
      routes: {
        '/home'           : ( BuildContext context ) => HomePage(),
        '/project'        : ( BuildContext context ) => ProjectPage(),
        '/task'           : ( BuildContext context ) => TaskPage(),
        '/nuevoProyecto'  : ( BuildContext context ) => NuevoProyectoPage(),
        '/login'          : ( BuildContext context ) => LoginPage(),
        '/registro'       : ( BuildContext context ) => RegistroPage(),
        '/nuevaTarea'     : ( BuildContext context ) => NuevaTareaPage(),
        '/editarPerfil'   : ( BuildContext context ) => EditarPerfilPage()
      },
    );
  }
}

//adentro del log out buutton
// void logoutUser(){
// SharedPreferences prefs = await SharedPreferences.getInstance();
// prefs?.clear() 
//  Navigator.pushAndRemoveUntil(
//       context, 
//       ModalRoute.withName("/SplashScreen"), 
//      ModalRoute.withName("/Home")
//     );
// }