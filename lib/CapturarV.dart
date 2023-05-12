import 'package:dam_u4_proyecto1_19400617/bd.dart';
import 'package:dam_u4_proyecto1_19400617/vehiculo.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart'; //PARA EL TEXTFIELD NUMERICO

class CapturarV extends StatefulWidget {
  const CapturarV({Key? key}) : super(key: key);

  @override
  State<CapturarV> createState() => _CapturarVState();
}

class _CapturarVState extends State<CapturarV> {
  final List<String> _tipo = ['Camion', 'Coche', 'Camioneta', 'Tracktor', 'Motocicleta'];
  String? selectedValueT;

  final List<String> _combustible = ['Diesel', 'Gasolina regular', 'Gasolina premium',];
  String? selectedValueC;

  final List<String> _depto = ['Jardineria', 'Seguridad', 'Direccion', 'Servicios Escolares'];
  String? selectedValueD;

  final placaC = TextEditingController(); final nsC = TextEditingController();
  final tipoC = TextEditingController(); final combustibleC = TextEditingController();
  final tanqueC = TextEditingController(); final trabajadorC = TextEditingController();
  final deptoC = TextEditingController(); final jefeC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Insertar coche"), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: [
          TextField(
              controller: placaC,
              autofocus: true,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.credit_card), labelText: "PLACA")),
          TextField(
              controller: nsC,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.document_scanner_rounded),
                  labelText: "NUMERO SERIE")),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: Text('TIPO', style: TextStyle(fontSize: 14)),
              items: _tipo
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: TextStyle(fontSize: 14)),
                      ))
                  .toList(),
              value: selectedValueT,
              onChanged: (value) {
                setState(() {
                  selectedValueT = value as String;
                  tipoC.text = selectedValueT!;
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
                        child: Text(item, style: TextStyle(fontSize: 14)),
                      ))
                  .toList(),
              value: selectedValueC,
              onChanged: (value) {
                setState(() {
                  selectedValueC = value as String;
                  combustibleC.text = selectedValueC!;
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
                        child: Text(item, style: TextStyle(fontSize: 14)),
                      ))
                  .toList(),
              value: selectedValueD,
              onChanged: (value) {
                setState(() {
                  selectedValueD = value as String;
                  deptoC.text = selectedValueD!;
                });
              },
            ),
          ),
          TextField(
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: tanqueC,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.water_drop_outlined),
                  labelText: "TANQUE")),
          SizedBox(height: 10),
          TextField(
              controller: trabajadorC,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_rounded),
                  labelText: "TRABAJADOR")),
          SizedBox(height: 10),
          TextField(
              controller: jefeC,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.man_sharp), labelText: "ENCARGADO")),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                if (placaC.text.isEmpty || nsC.text.isEmpty || tipoC.text.isEmpty || combustibleC.text.isEmpty ||
                    tanqueC.text.isEmpty || trabajadorC.text.isEmpty || deptoC.text.isEmpty || jefeC.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Por favor, llene todos los campos.")));
                } else {
                  Vehiculo ve = Vehiculo(
                      placa: placaC.text,
                      tipo: tipoC.text,
                      numeroserie: nsC.text,
                      combustible: combustibleC.text,
                      tanque: int.parse(tanqueC.text),
                      trabajador: trabajadorC.text,
                      depto: deptoC.text,
                      resguardadopor: jefeC.text);

                  await insertarVehiculo(ve).then((value) {
                    if (value > 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("INSERTADO CON EXITO!")));
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("ERROR al insertar el vehiculo x.x")));
                    }
                  });
                }
              },
              child: Text("INSERTAR"))
        ],
      ),
    );
  }
}
