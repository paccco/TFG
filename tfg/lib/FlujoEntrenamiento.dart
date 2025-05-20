import 'package:flutter/material.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/funcionesAux.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/EntreSeries.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/EntrrenamientoListarEjericicos.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/RealizandoEjercicio.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/RellenaMarca.dart';

class FlujoEntrenamiento{
  late final List<String> _listaEjercicios;
  late final Map<String,String> _ejerciciosTipo;
  late final String _descanso;

  FlujoEntrenamiento._privateConstructor(String rutina, List<String> listaEjercicios, Map<String,String> ejerciciosTipo, String descanso) {
    _listaEjercicios = listaEjercicios;
    _ejerciciosTipo = ejerciciosTipo;
    _descanso = descanso;
  }

  static Future<FlujoEntrenamiento> crear(String rutina) async{
    final datosRutina = await BDLocal.instance.getRutina(rutina);
    final camposRutinas = await BDLocal.camposRutinas;
    final List<String> listaEjercicios=datosRutina[camposRutinas[2]]==null ? [] : datosRutina[camposRutinas[2]].split(',');
    final String descanso=datosRutina[camposRutinas[3]];
    Map<String,String> ejerciciosTipo={};

    if(listaEjercicios.isNotEmpty){
      for(var ejercicio in listaEjercicios){
        final datosEjercicio = await BDLocal.instance.getEjercicio(ejercicio);
        final camposEjercicios = await BDLocal.camposEjercicios;

        int tipoInt = datosEjercicio[camposEjercicios[1]];
        String tipo = tipoInt.toRadixString(2).padLeft(8,'0');

        ejerciciosTipo[ejercicio]=tipo;
      }
    }

    return FlujoEntrenamiento._privateConstructor(rutina, listaEjercicios, ejerciciosTipo, descanso);
  }

  Map<String,bool> _comprobarMeta(Map<String,dynamic> meta, Map<String,dynamic> marca){

    final camposMarca=BDLocal.camposMarca;
    Map<String,bool> resultado={};

    for (var campo in meta.keys) {
      if(meta[campo] != null && marca[campo] != null){
        resultado[campo]=false;
        //Repetciones
        if(campo==camposMarca[2] && marca[campo]>=meta[campo]){
          resultado[campo]=true;
        }
        //Peso
        if(campo==camposMarca[3] && marca[campo]>=meta[campo]){
          resultado[campo]=true;
        }
        //Tiempo
        if(campo==camposMarca[4]){
          String tiempoMeta=meta[campo];
          String tiempoMarca=marca[campo];

          List<int> tiempoMetaList=tiempoMeta.split(':').map((e) => int.parse(e)).toList();
          List<int> tiempoMarcaList=tiempoMarca.split(':').map((e) => int.parse(e)).toList();

          Duration tiempoMetaDuracion=Duration(minutes: tiempoMetaList[0], seconds: tiempoMetaList[1]);
          Duration tiempoMarcaDuracion=Duration(minutes: tiempoMarcaList[0], seconds: tiempoMarcaList[1]);

          if(tiempoMarcaDuracion>=tiempoMetaDuracion){
            resultado[campo]=true;
          }
        }
        //Distancia
        if(campo==camposMarca[5] && marca[campo]>=meta[campo]){
          resultado[campo]=true;
        }
      }
    }

    return resultado;
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
          await Navigator.push(context, MaterialPageRoute(builder: (builder)=>RellenaMarca(ejercicio: ejercicio, tipo: _ejerciciosTipo[ejercicio]!, descanso: _descanso)));

        marcas[ejercicio]!.add(marca);

        exit = await Navigator.push(context, MaterialPageRoute(builder: (builder)=>EntreSeries(ejercicio: ejercicio)));
      }
    }

    Map<String,Map<String,bool>> metasSuperadas={};

    //Por cada ejercicio miramos las marcas
    for(var ejercicio in marcas.keys){
      final meta = await BDLocal.instance.getMetaActual(ejercicio);
      Map<String,bool> resultadoEjercicio={};
      for(var marca in marcas[ejercicio]!){
        await BDLocal.instance.insertMarca(marca);
        Map<String,bool> res = _comprobarMeta(meta, marca);
        res.removeWhere((key,value)=>value==false);
        resultadoEjercicio.addAll(res);
      }
      metasSuperadas[ejercicio]=resultadoEjercicio;
    }


    return true;
  }
}