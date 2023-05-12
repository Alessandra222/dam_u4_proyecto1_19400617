import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_u4_proyecto1_19400617/bitacora.dart';
import 'package:dam_u4_proyecto1_19400617/vehiculo.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
CollectionReference crVehiculo = db.collection('vehiculo');

Future<List> getVehiculo() async{
  List vehiculo=[];

  QuerySnapshot qVehiculo = await crVehiculo.get();

  qVehiculo.docs.forEach((documento) {
    vehiculo.add(documento.data());
  });

  await Future.delayed(Duration(milliseconds: 100));
  return vehiculo;
}

Future<int> insertarVehiculo(Vehiculo v) async {
  try {
    await crVehiculo.add(v.toMap());
    return 1;
  } catch (e) {
    return 0;
  }
}

Future<int> actualizarVehiculo(Vehiculo v) async {
  QuerySnapshot qVehiculo = await crVehiculo.get();
  String uid = "";
  qVehiculo.docs.forEach((documento) {
    if (v.placa == documento['placa']) {
      uid = documento.id;
    }
  });
  await crVehiculo.doc(uid).set(v.toMap());
  return 1;
}

Future<void> eliminarVehiculo(String p) async {
  QuerySnapshot qVehiculo = await crVehiculo.get();
  String uid = "";

  qVehiculo.docs.forEach((documento) {
    if (p == documento['placa']) {
      uid = documento.id;
    }
  });

  if (uid.isNotEmpty) {
    await crVehiculo.doc(uid).delete();
    print('El vehículo con placa $p ha sido eliminado correctamente');
  } else {
    print('No se encontró ningún vehículo con la placa $p');
  }
}

Future<List> getVehiculosPorDepto(String departamento) async{
  List vehiculos=[];

  QuerySnapshot qVehiculo = await crVehiculo.where('depto', isEqualTo: departamento).get();
  qVehiculo.docs.forEach((documento) {
    vehiculos.add(documento.data());
  });
  if (departamento == "Todos")
     return await getVehiculo();

  return vehiculos;
}

/////////////////////////////////////////////////////////////////////////////
CollectionReference crBitacora = db.collection('Bitacora');

Future<List> getBitacora() async{
  List bitacora=[];

  QuerySnapshot qBitacora = await crBitacora.get();

  qBitacora.docs.forEach((documento) {
    Map <String, dynamic> ids= {'id1':documento.id};
    Map <String, dynamic> cont = documento.data() as Map<String, dynamic>;
    ids = {...ids, ...cont};
    bitacora.add(ids);
  });
  return bitacora;

}

Future<int> insertarBitacora(Bitacora b) async {

  try {
    await crBitacora.add(b.toMap());
    return 1;
  } catch (e) {
    return 0;
  }
}


Future<List<String>> getPlacas() async {
  List<String> placas = [];
  QuerySnapshot query = await crVehiculo.get();
  query.docs.forEach((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String placa = data['placa'];
    placas.add(placa);
  });
  return placas;
}

Future<List<String>> getPlacasBi() async {
  List<String> placasBi = [];
  QuerySnapshot query = await crBitacora.get();
  query.docs.forEach((doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    String placa = data['placa'];

    if (!placasBi.contains(placa)) { // Verificar si la placa ya existe en la lista
      placasBi.add(placa); // Agregar la placa a la lista si no está presente
    }
  });
  return placasBi;
}

Future<int> actualizarBitacora(Bitacora b) async {
  String uid = b.id1.toString();
  await crBitacora.doc(uid).set(b.toMap());
  return 1;
}

Future<List> getBitacoraPorPlaca(String placa) async{
  List bitacora=[];
  QuerySnapshot qBitacora = await crBitacora.where('placa', isEqualTo: placa).get();
  qBitacora.docs.forEach((documento) {
    bitacora.add(documento.data());
  });
  return bitacora;
}

Future<List> getBitacoraPorFecha(String fecha) async{
  List bitacora=[];
  QuerySnapshot qBitacora = await crBitacora.where('fecha', isEqualTo: fecha).get();
  qBitacora.docs.forEach((documento) {
    bitacora.add(documento.data());
  });
  return bitacora;
}

Future<List> getBitacoraVehiculo() async{
  List uso=[];
  List pla=[];

  QuerySnapshot qBitacora = await crBitacora.where('fechaverificacion', isEqualTo: "SIN VERIFICAR").get();

  await Future.forEach(qBitacora.docs,(documento) async {
    Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    QuerySnapshot qPlaca = await crVehiculo.where('placa', isEqualTo: data['placa']).get();
    if(!pla.contains(qPlaca.docs[0]['placa'])) {
      pla.add(qPlaca.docs[0]['placa']);
      uso.add(qPlaca.docs[0]);
    }
  });
  return uso;
}







