import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:const  Color(0xffe8e8e8),
      child: Scaffold(
        
       // appBar: AppBar(title: const Text("About"),centerTitle: true,backgroundColor: Colors.transparent,),
        body: Center(  
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.all(10),
            child: Column(children: const [
              Image(image: AssetImage("assets/splash_logo.png")),
              Text("This application for education purpose.Made By Dipprokash Sardar, a final year student of MCA'22 Dept of The A.K.C.S.I.T under University of calcutta ",style: TextStyle(fontSize: 20),)
            ]),
          ),
        ),
      ),
      
    );
  }
}