import 'package:dam_u4_proyecto1_19400617/bd.dart';
import 'package:dam_u4_proyecto1_19400617/bitacora.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CapturarB extends StatefulWidget {
  const CapturarB({Key? key}) : super(key: key);

  @override
  State<CapturarB> createState() => _CapturarBState();
}

class _CapturarBState extends State<CapturarB> {
  final placaC = TextEditingController();
  final fechaC = TextEditingController();
  final eventoC = TextEditingController();
  final recursosC = TextEditingController();
  final verificoC = TextEditingController();
  final fechavC = TextEditingController();

  var dateMask = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  List<String> _placas = [];
  String? selectedP;

  @override
  void initState() {
    super.initState();
    getPlacas().then((placas) {
      setState(() {
        _placas = placas;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Agregar Bitacora"), centerTitle: true),
        body: ListView(padding: EdgeInsets.all(30), children: [
          SizedBox(height: 5),
          TextField(
              controller: fechaC,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [dateMask],
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                labelText: "Fecha",
                hintText: "10/05/2023",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_month_rounded),
              )),
          SizedBox(height: 20),
          DropdownButtonHideUnderline(
            child: DropdownButton(
              hint:
                  Text('Seleccione una placa', style: TextStyle(fontSize: 16)),
              items: _placas
                  .map((placa) => DropdownMenuItem<String>(
                        value: placa,
                        child: Text(placa),
                      ))
                  .toList(),
              value: selectedP,
              onChanged: (value) {
                setState(() {
                  selectedP = value as String;
                  placaC.text = selectedP!;
                });
              },
            ),
          ),
          SizedBox(height: 20),
          TextField(
              controller: eventoC,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                labelText: "Evento",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event),
              )),
          SizedBox(height: 20),
          TextField(
              controller: recursosC,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                labelText: "Recursos",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.inventory_outlined),
              )),
          SizedBox(height: 20),
          TextField(
              controller: verificoC,
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                labelText: "Verifico",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.remove_red_eye_outlined),
              )),
          SizedBox(height: 20),
          TextField(
              controller: fechavC,
              keyboardType: TextInputType.number,
              inputFormatters: [dateMask],
              style: TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: "11/05/2023",
                labelText: "Fecha verificación",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.event_available),
              )),
          SizedBox(height: 20),
          ElevatedButton(
              onPressed: () async {
                if (placaC.text.isEmpty || fechaC.text.isEmpty || eventoC.text.isEmpty || recursosC.text.isEmpty ) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Por favor, llene todos los campos.")));
                } else {
                  if(fechavC.text.isEmpty && verificoC.text.isEmpty)
                  {
                    verificoC.text="SIN VERIFICAR";
                    fechavC.text="SIN VERIFICAR";
                  }

                  Bitacora bi = Bitacora(
                      placa: selectedP.toString(),
                      fecha: fechaC.text,
                      evento: eventoC.text,
                      recursos: recursosC.text,
                      verifico: verificoC.text,
                      fechaverificacion: fechavC.text);

                  await insertarBitacora(bi).then((value) {
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
        ]));
  }
}
