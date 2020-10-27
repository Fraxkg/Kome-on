
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:kome_on/src/pages/home_page.dart';
import 'package:kome_on/src/pages/nuevoProyecto_page.dart';
import 'package:kome_on/src/pages/project_page.dart';
import 'package:kome_on/src/pages/task_page.dart';


void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
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
      initialRoute: '/',
      routes: {
        '/'               : ( BuildContext context ) => HomePage(),
        '/project'        : ( BuildContext context ) => ProjectPage(),
        '/task'           : ( BuildContext context ) => TaskPage(),
        '/nuevoProyecto'   : ( BuildContext context ) => NuevoProyectoPage(),
      },
    );
  }
}