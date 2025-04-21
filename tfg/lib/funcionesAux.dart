bool validarFormatoHora(String hora) {
  final regexHora = RegExp(r'^\d{2}:\d{2}:\d{2}$');
  if (!regexHora.hasMatch(hora)) {
    return false;
  }

  final partes = hora.split(':');
  final horas = int.parse(partes[0]);
  final minutos = int.parse(partes[1]);
  final segundos = int.parse(partes[2]);

  return horas >= 0 && horas <= 23 &&
      minutos >= 0 && minutos <= 59 &&
      segundos >= 0 && segundos <= 59;
}