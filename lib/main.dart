
import 'package:flutter/material.dart';
import 'package:kome_on/src/pages/development_page.dart';
import 'package:kome_on/src/pages/home_page.dart';
import 'package:kome_on/src/pages/story_page.dart';


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
        

        // '/develop'  : ( BuildContext context ) => DevelopmentPage(),
        // '/story'  : ( BuildContext context ) => StoryPage(),
      },
    );
  }
}