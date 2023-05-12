import 'package:dam_u4_proyecto1_19400617/bd.dart';
import 'package:dam_u4_proyecto1_19400617/vehiculo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';//PARA EL TEXTFIELD NUMERICO

class ActualizarV extends StatefulWidget {
  final Vehiculo ve;
  const ActualizarV({Key? key,required this.ve}) : super(key: key);

  @override
  State<ActualizarV> createState() => _ActualizarVState();
}


class _ActualizarVState extends State<ActualizarV> {
  @override
  ActualizarV get widget => super.widget;

  @override
  void initState(){
    super.initState();
    act();
  }
  void act(){
    placaC.text = super.widget.ve.placa;   nsC.text = super.widget.ve.numeroserie;
    selectedValueT = super.widget.ve.tipo;    selectedValueC = super.widget.ve.combustible;
    tanqueC.text = super.widget.ve.tanque.toString(); trabajadorC.text = super.widget.ve.trabajador;
    selectedValueD = super.widget.ve.depto;   jefeC.text = super.widget.ve.resguardadopor;
  }

  final List<String> _tipo = ['Camion', 'Coche', 'Camioneta', 'Tracktor', 'Motocicleta'];
  String? selectedValueT;

  final List<String> _combustible = ['Diesel', 'Gasolina regular', 'Gasolina premium',];
  String? selectedValueC;
  final List<String> _depto = ['Jardineria', 'Seguridad', 'Direccion', 'Servicios Escolares'];
  String? selectedValueD;

  TextEditingController placaC = TextEditingController();
  TextEditingController nsC = TextEditingController();
  TextEditingController tanqueC = TextEditingController();
  TextEditingController trabajadorC = TextEditingController();
  TextEditingController jefeC = TextEditingController();

  @override
  Widget build(BuildContext context) {
   // final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(title: Text("Actualizar vehiculo"), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: [
          Tooltip(
            message: 'Placa no editable',
            child: TextField(
              enabled: false,
              controller: placaC,
              autofocus: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.credit_card), labelText: "PLACA"))),
          TextField(
              controller: nsC,
              decoration: InputDecoration(prefixIcon: Icon(Icons.document_scanner_rounded),labelText: "NUMERO SERIE")),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: Text('TIPO', style: TextStyle(fontSize: 14)),
              items: _tipo
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item,style:TextStyle(fontSize: 14)),
                      )).toList(),
              value: selectedValueT,
              onChanged: (value) {
                setState(() {
                  selectedValueT = value as String;
                });
              },
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: Text('COMBUSTIBLE', style: TextStyle(fontSize: 14)),
              items: _combustible
                  .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item,style:TextStyle(fontSize: 14)),
              )).toList(),
              value: selectedValueC,
              onChanged: (value) {
                setState(() {
                  selectedValueC = value as String;
                });
              },
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: Text('DEPARTAMENTO', style: TextStyle(fontSize: 14)),
              items: _depto
                  .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item,style:TextStyle(fontSize: 14)),
              )).toList(),
              value: selectedValueD,
              onChanged: (value) {
                setState(() {
                  selectedValueD = value as String;
                });
              },
            ),
          ),
          TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              controller: tanqueC,
              decoration: InputDecoration(prefixIcon: Icon(Icons.water_drop_outlined),labelText: "TANQUE")),
          SizedBox(height:10),
          TextField(
              controller: trabajadorC,
              decoration: InputDecoration(prefixIcon: Icon(Icons.account_circle_rounded),labelText: "TRABAJADOR")),
          SizedBox(height:10),
          TextField(
              controller: jefeC,
              decoration: InputDecoration(prefixIcon: Icon(Icons.man_sharp),labelText: "ENCARGADO")),
          SizedBox(height:20),
          ElevatedButton(
              onPressed: () async {
                Vehiculo ve = Vehiculo(
                    placa: placaC.text,
                    tipo: selectedValueT.toString(),
                    numeroserie: nsC.text,
                    combustible: selectedValueC.toString(),
                    tanque: int.parse(tanqueC.text),
                    trabajador: trabajadorC.text,
                    depto: selectedValueD.toString(),
                    resguardadopor: jefeC.text);
                await actualizarVehiculo(ve).then((value) {
                  if (value > 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("ACTUALIZADO CORRECTAMENTE!")));
                    Navigator.pop(context);
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("ERROR al insertar el vehiculo x.x")));
                  }
                });
              },
              child: Text("ACTUALIZAR"))
        ],
      ),
    );
  }
}
