import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/EntreSeries.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/EntrrenamientoListarEjericicos.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/RealizandoEjercicio.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/RellenaMarca.dart';

class FlujoEntrenamiento{
  late final _rutina;
  late final List<String> _listaEjercicios;
  late final Map<String,String> _ejerciciosTipo;
  late final String _descanso;

  FlujoEntrenamiento._privateConstructor(String rutina, List<String> listaEjercicios, Map<String,String> ejerciciosTipo, String descanso) {
    _rutina = rutina;
    _listaEjercicios = listaEjercicios;
    _ejerciciosTipo = ejerciciosTipo;
    _descanso = descanso;
  }

  static Future<FlujoEntrenamiento> crear(String rutina) async{
    final datosRutina = await BDLocal.instance.getRutina(rutina);
    final camposRutinas = await BDLocal.instance.camposRutinas;
    final List<String> listaEjercicios=datosRutina[camposRutinas[2]]==null ? [] : datosRutina[camposRutinas[2]].split(',');
    final String descanso=datosRutina[camposRutinas[3]];
    Map<String,String> ejerciciosTipo={};

    for(var ejercicio in listaEjercicios){
      final datosEjercicio = await BDLocal.instance.getEjercicio(ejercicio);
      final camposEjercicios = await BDLocal.instance.camposEjercicios;

      int tipoInt = datosEjercicio[camposEjercicios[1]];
      String tipo = tipoInt.toRadixString(2).padLeft(8,'0');

      ejerciciosTipo[ejercicio]=tipo;
    }

    return new FlujoEntrenamiento._privateConstructor(rutina, listaEjercicios, ejerciciosTipo, descanso);
  }

  Future<bool> ejecutar(BuildContext context) async{

    if(_listaEjercicios.isEmpty){
      return false;
    }

    await Navigator.push(context, MaterialPageRoute(builder: (builder)=>EntrenamientoListarEjericicos(
        ejercicios: _listaEjercicios,
        descanso: _descanso
        )
      )
    );

    /**
     * En este map el ejercicio es la clave hacia otro map donde guardo las marcas con sus valores
     * */

    Map<String,List<Map<String,dynamic>>> marcas={};
    for(var ejercicio in _listaEjercicios){
      //Preguntamos si quiere empezar el ejercicio

      marcas[ejercicio]=[];
      await Navigator.push(context, MaterialPageRoute(builder: (builder)=>EntreSeries(ejercicio: ejercicio, primeraSerie: true)));

      bool exit=false;
      while(!exit){
        await Navigator.push(context, MaterialPageRoute(builder: (builder)=>RealizandoEjercicio(ejercicio: ejercicio)));

        final marca =
          await Navigator.push(context, MaterialPageRoute(builder: (builder)=>RellenaMarca(ejercicio: ejercicio, tipo: _ejerciciosTipo[ejercicio]!)));

        marcas[ejercicio]!.add(marca);

        exit = await Navigator.push(context, MaterialPageRoute(builder: (builder)=>EntreSeries(ejercicio: ejercicio)));
      }
    }

    print(marcas);
    return true;
  }
}