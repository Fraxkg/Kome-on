
import 'package:flutter/material.dart';
import 'package:kome_on/src/pages/home_page.dart';
import 'package:kome_on/src/pages/project_page.dart';
import 'package:kome_on/src/pages/task_page.dart';


void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kome on',
      initialRoute: '/',
      routes: {
        '/'         : ( BuildContext context ) => HomePage(),
        '/project'  : ( BuildContext context ) => ProjectPage(),
        '/task'     : ( BuildContext context ) => TaskPage(),
      },
    );
  }
}