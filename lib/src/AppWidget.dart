// ignore: file_names
import 'package:flutter/material.dart';
import 'home/HomeView.dart';

class AppWidget extends StatelessWidget{
  
  const AppWidget({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.cyan),
      title: 'Catálogo Marvel',
      home: const Home()
      );
  }

}