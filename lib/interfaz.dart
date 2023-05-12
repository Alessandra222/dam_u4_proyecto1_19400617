import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dam_u4_proyecto1_19400617/intBitacora.dart';
import 'package:dam_u4_proyecto1_19400617/intConsulta.dart';
import 'package:dam_u4_proyecto1_19400617/intVehiculo.dart';
import 'package:flutter/material.dart';

class Interfaz extends StatefulWidget {
  const Interfaz({Key? key}) : super(key: key);

  @override
  State<Interfaz> createState() => _InterfazState();
}

class _InterfazState extends State<Interfaz> {
  int _indice=0;
  bool dark = false;

  void _cambiarIndice(int indice){
    setState(() {
      _indice=indice;
    });
  }

  final List<Widget> _paginas = [
    intVehiculo(),
    intBitacora()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
            title: Text("CocheTec"),
            centerTitle: true,
          backgroundColor: Color(0xFF8661C1),
          actions:[
            IconButton(onPressed:(){
              setState((){
                dark=!dark;
                if(dark){ AdaptiveTheme.of(context).setDark();}
                else {AdaptiveTheme.of(context).setLight();}
              });
            }, icon: Icon(dark ? Icons.light_mode : Icons.dark_mode))
          ]
      ),
      body: _paginas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.car_repair), label:"Vehiculo"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month_rounded), label: "Bitacora")
        ],
        currentIndex: _indice,
        onTap: _cambiarIndice,
        iconSize: 30,
        showUnselectedLabels: false,
        backgroundColor: Color(0xFFD7D7F4),
        selectedItemColor: Color(0xFF3F3B6C),
        unselectedItemColor: Color(0xFF536878),
      ),
    );
  }
}
