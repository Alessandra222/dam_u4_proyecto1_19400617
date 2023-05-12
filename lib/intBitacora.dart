import 'package:dam_u4_proyecto1_19400617/CapturarB.dart';
import 'package:dam_u4_proyecto1_19400617/bd.dart';
import 'package:dam_u4_proyecto1_19400617/bitacora.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class intBitacora extends StatefulWidget {
  const intBitacora({Key? key}) : super(key: key);

  @override
  State<intBitacora> createState() => _intBitacoraState();
}

class _intBitacoraState extends State<intBitacora> {
  var dateMask = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});

  TextEditingController buscarP = TextEditingController();
  TextEditingController fechaC = TextEditingController();
  bool consulta = false;
  int interfaz=0;

  List<String> _placa = [];
  String? selectedValueP;

  @override
  void initState() {
    super.initState();
    actPlacas();
  }

  Future<void> actPlacas() async {
    await getPlacasBi().then((placasBi) {
      setState(() {
        _placa = placasBi;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height:20),
          Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                    IconButton(
                        icon: Icon(Icons.sync,color: Color(0xFF667761)),
                        onPressed: () {
                          setState(() {
                            interfaz=0;
                          });
                        },
                        tooltip: 'Recargar'
                    ),
                SizedBox(width: 15,),
                Flexible(
                  child:
                TextField(
                    onSubmitted: (value) async {
                      await getBitacoraPorFecha(value);
                      setState(() {
                        interfaz=3;
                      });
                    },
                    controller: fechaC,
                    keyboardType: TextInputType.number,
                    inputFormatters: [dateMask],
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      hintText: "11/05/2023",
                      labelText: "Filtrar por fecha",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.event_available),
                    )),
                ),
                SizedBox(width: 15,),
                DropdownButtonHideUnderline(
                  child: Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.search), // Agregar el icono aquí
                        SizedBox(width: 8), // Agregar un espacio para separar el icono del DropdownButton
                        Expanded(
                          child: DropdownButton(
                            hint: Text('Filtrar por placa', style: TextStyle(fontSize: 14)),
                            items: _placa
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,style:TextStyle(fontSize: 14)),
                            ))
                                .toList(),
                            value: selectedValueP,
                            onChanged: (value) {
                              setState(() {
                                selectedValueP = value as String;
                                buscarP.text = selectedValueP!;
                                consulta = true;
                                interfaz=2;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 15,),
]),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future: interfaz==0 ? getBitacora() : interfaz==2 ? getBitacoraPorPlaca(buscarP.text) : interfaz==3 ? getBitacoraPorFecha(fechaC.text) : getBitacora(),
              builder: ((context, snapshot) {
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      if(snapshot.hasData){
                        return InkWell(
                          child: ListTile(
                            leading: Text(
                                "  \n ${snapshot.data?[index]['placa']} \n ${snapshot.data?[index]['fecha']} "),
                            title: Text(
                                "Motivo de uso:  ${snapshot.data?[index]['evento']} "),
                            subtitle: Text(
                                "Recursos: ${snapshot.data?[index]['recursos']}  Verifico: ${snapshot.data?[index]['verifico']} \n Fecha verificación: ${snapshot.data?[index]['fechaverificacion']}  "),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Color(0xFF667761)),
                                  onPressed: ()  {
                                    final verificoC = TextEditingController();
                                    final fechavC = TextEditingController();
                                    verificoC.text = snapshot.data?[index]['verifico'];
                                    fechavC.text = snapshot.data?[index]['fechaverificacion'];

                                    showModalBottomSheet(
                                        elevation: 20,
                                        context: context,
                                        isScrollControlled: true,
                                        builder: (builder) {
                                          return Container(
                                            padding: EdgeInsets.only(
                                                top: 15, left: 30, right: 30, bottom: MediaQuery
                                                .of(context)
                                                .viewInsets
                                                .bottom + 200
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("Modifique los datos que desea actualizar"),
                                                SizedBox(height: 10),
                                                TextField(controller: verificoC,
                                                    decoration: InputDecoration(labelText: "Verifico")),
                                                SizedBox(height: 10),
                                                TextField(controller: fechavC,
                                                    decoration: InputDecoration(labelText: "Fecha de verificacion")),
                                                SizedBox(height: 10),
                                                FilledButton(onPressed: () async{
                                                 Bitacora bi= Bitacora(
                                                      placa:snapshot.data?[index]['placa'],
                                                      fecha:snapshot.data?[index]['fecha'],
                                                      evento:snapshot.data?[index]['evento'],
                                                      recursos:snapshot.data?[index]['recursos'],
                                                      id1: snapshot.data?[index]['id1'],
                                                      verifico: verificoC.text,
                                                      fechaverificacion: fechavC.text);

                                                  await actualizarBitacora(bi).then((value){
                                                    Navigator.pop(context);
                                                  });

                                                }, child: Text("Guardar Cambios")),

                                              ],
                                            ),
                                          );
                                        });

                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      }else{
                        return Center(
                          child:CircularProgressIndicator(),
                        );
                      }}
                );
              }

              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (builder) => CapturarB()));
          //setState((){});
          actPlacas();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
