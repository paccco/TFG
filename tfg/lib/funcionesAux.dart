import 'package:tfg/API.dart';
import 'package:tfg/ConexionBDLocal.dart';

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

Future<bool> descargarRutina(int idRutina, String nombreRutina) async{
  final rutina=await getRutina(idRutina,usuario: true);
  final ejercicios=await getEjerciciosRutinaDescargar(idRutina);

  final String nuevoNombreRutina="$nombreRutina-${rutina['usuario']}";

  final resRutina = await BDLocal.instance.insertRutina(nuevoNombreRutina, "${rutina['descripcion']}", "${rutina['descansos']}");

  List<Future<String>> futures = List.empty(growable: true);

  ejercicios.forEach((value){
    Map<String,dynamic> aux=Map.from(value);
    aux['nombre']=("${value['nombre']}-${rutina['usuario']}");
    futures.add(BDLocal.instance.insertEjercicios(aux));
  });

  final resEjericios=await Future.wait(futures);

  if(resRutina.isNotEmpty && !resEjericios.contains("")){
    final res=await BDLocal.instance.modEjerRutina(nuevoNombreRutina, resEjericios);

    final sinErrores=res!=0;

    if(sinErrores){
      await registrarDescarga(idRutina);
    }

    return sinErrores;
  }

  return false;
}