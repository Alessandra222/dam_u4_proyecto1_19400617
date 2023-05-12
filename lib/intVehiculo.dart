import 'package:dam_u4_proyecto1_19400617/ActualizarV.dart';
import 'package:dam_u4_proyecto1_19400617/CapturarV.dart';
import 'package:dam_u4_proyecto1_19400617/bd.dart';
import 'package:dam_u4_proyecto1_19400617/vehiculo.dart';
import 'package:flutter/material.dart';

class intVehiculo extends StatefulWidget {
  const intVehiculo({Key? key}) : super(key: key);

  @override
  State<intVehiculo> createState() => _intVehiculoState();
}

class _intVehiculoState extends State<intVehiculo> {
TextEditingController buscarC = TextEditingController();

bool consulta = false;
final List<String> _depto = ['Todos','Jardineria', 'Seguridad', 'Direccion', 'Servicios Escolares'];
String? selectedValueD;

int interfaz=0;

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
            DropdownButtonHideUnderline(
              child: Expanded(
                child: Row(
                  children: [
                    Icon(Icons.search), // Agregar el icono aquí
                    SizedBox(width: 8), // Agregar un espacio para separar el icono del DropdownButton
                    Expanded(
                      child: DropdownButton(
                        hint: Text('Filtrar por departamento', style: TextStyle(fontSize: 14)),
                        items: _depto
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item,style:TextStyle(fontSize: 14)),
                        ))
                            .toList(),
                        value: selectedValueD,
                        onChanged: (value) {
                          setState(() {
                            selectedValueD = value as String;
                            buscarC.text = selectedValueD!;
                            interfaz=2;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width:20),
          ElevatedButton(onPressed: (){
            setState(() {
              interfaz=3;
            });
          }, child: Text("EN USO"))
          ]),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder(
              future:interfaz==0 ? getVehiculo() : interfaz==2 ? getVehiculosPorDepto(buscarC.text) : interfaz==3 ? getBitacoraVehiculo() : getBitacora(),
              builder: ((context, snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    if(snapshot.hasData){
                      return InkWell(
                        child: ListTile(
                          leading: Text(
                              "  \n ${snapshot.data?[index]['placa']} \n NS: ${snapshot.data?[index]['numeroserie']} "),
                          title: Text(
                              "Departamento de ${snapshot.data?[index]['depto']} "),
                          subtitle: Text(
                              "${snapshot.data?[index]['tipo']} ${snapshot.data?[index]['tanque']} lt  ${snapshot.data?[index]['combustible']}  \n  Jefe: ${snapshot.data?[index]['resguardadopor']}  Trabajador: ${snapshot.data?[index]['trabajador']} "),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.delete, color: Color(0xFF52050A)),
                                onPressed:()async
                                     {
                                       await eliminarVehiculo(snapshot.data?[index]['placa']).then((_) => setState(() {}));
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit, color: Color(0xFF667761)),
                                onPressed: () async {
                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => ActualizarV(ve:
                                   Vehiculo(
                                     placa:snapshot.data?[index]['placa'],
                                     tipo: snapshot.data?[index]['tipo'],
                                     numeroserie:snapshot.data?[index]['numeroserie'] ,
                                     combustible:snapshot.data?[index]['combustible']  ,
                                     tanque: snapshot.data?[index]['tanque'] ,
                                     trabajador:snapshot.data?[index]['trabajador'] ,
                                     depto: snapshot.data?[index]['depto'],
                                     resguardadopor: snapshot.data?[index]['resguardadopor']
                                   )
                                  )
                                  ));
                                  setState((){});
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
         await Navigator.push(context, MaterialPageRoute(builder: (builder) => CapturarV()));
          setState((){});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
