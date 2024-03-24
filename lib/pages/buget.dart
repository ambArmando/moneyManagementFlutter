import 'package:flutter/material.dart';

class Buget extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() => BugetState();
}

class BugetState extends State<Buget> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(child: Text("buget page")),
    );
  }
}