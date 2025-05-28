import 'package:flutter/material.dart';
import 'package:tfg/API.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/constantes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

bool validarFormatoHora(String hora) {
  final regexHora = RegExp(r'^\d{2}:\d{2}$');
  if (!regexHora.hasMatch(hora)) {
    return false;
  }

  final partes = hora.split(':');
  final minutos = int.parse(partes[0]);
  final segundos = int.parse(partes[1]);

  return minutos >= 0 && minutos <= 59 &&
      segundos >= 0 && segundos <= 59;
}

void mensaje(BuildContext context, String mensaje, {bool error=false}){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content:Text(mensaje, style: TextStyle(fontSize: 20.sp)),
        duration: Duration(seconds: 4),
        backgroundColor: error ? Colores.rojo : Colores.verde,
    )
  );
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

Widget botonPopUp(String texto, Function() func, String asset){
  final double alturaBoton=6.h;

  return InkWell(
    onTap: func,
    child: Container(
        padding: EdgeInsets.all(1.h),
        height: alturaBoton,
        margin: EdgeInsets.all(1.h),
        alignment: Alignment.center,
        color: Colores.naranja,
        child: Row(
          children: [
            Text(texto,style: TextStyle(color: Colores.blanco,fontSize: 19.sp),),
            Spacer(),
            Image.asset(asset, height: alturaBoton,width: alturaBoton,)
          ],
        )
    ),
  );
}

String stringDate(DateTime fecha){
  return "${fecha.year}-${fecha.month}-${fecha.day}";
}

int gestorDeComas(String numero){

  late final int out;

  if(numero.contains(comasPuntos)){
    out=int.parse(numero.replaceAll(comasPuntos, ''));
  }else{
    out=int.parse(numero)*100;
  }



  return out;
}