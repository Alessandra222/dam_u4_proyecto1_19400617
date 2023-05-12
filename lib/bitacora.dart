class Bitacora {
  String?    id1;
  String? placa;
  String? fecha;
  String? evento;
  String? recursos;
  String verifico;
  String fechaverificacion;

  Bitacora(
      {
        this.id1,
        required this.placa,
        required this.fecha,
        required this.evento,
        required this.recursos,
        required this.verifico,
        required this.fechaverificacion,
      });

  Map<String, dynamic> toMap() {
    return {
      'placa':placa,
      'fecha':fecha,
      'evento':evento,
      'recursos':recursos,
      'verifico':verifico,
      'fechaverificacion': fechaverificacion
    };
  }
}