class Vehiculo {
  String placa;
  String tipo;
  String numeroserie;
  String combustible;
  int tanque;
  String trabajador;
  String depto;
  String resguardadopor;

  Vehiculo(
      {
        required this.placa,
        required this.tipo,
        required this.numeroserie,
        required this.combustible,
        required this.tanque,
        required this.trabajador,
        required this.depto,
        required this.resguardadopor
      });

  Map<String, dynamic> toMap() {
    return {
      'placa':placa,
      'tipo': tipo,
      'numeroserie': numeroserie,
      'combustible': combustible,
      'tanque': tanque,
      'trabajador': trabajador,
      'depto': depto,
      'resguardadopor': resguardadopor
    };
  }
}