import 'package:flutter/material.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/constantes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/EntreSeries.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/EntrrenamientoListarEjericicos.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/FinEntrenamiento.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/RealizandoEjercicio.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/RellenaMarca.dart';
import 'package:tfg/interfaces/pantallas/plantillas/PantallasEntrenamiento.dart';

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

  Map<String,double> _comprobarMeta(Map<String,dynamic> meta, Map<String,dynamic> marca){

    final camposMarca=BDLocal.camposMarca;
    Map<String,double> resultado={};

    for (var campo in meta.keys) {
      if(meta[campo] != null && marca[campo] != null){
        resultado[campo]=0;
        //Repetciones
        if(campo==camposMarca[2] && marca[campo]>=meta[campo]){
          resultado[campo]=meta[campo]*1.0;
        }
        //Peso
        if(campo==camposMarca[3] && marca[campo]*100>=meta[campo]){
          resultado[campo]=meta[campo]*1.0;
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
            resultado[campo]=tiempoMetaDuracion.inSeconds.toDouble();
          }
        }
        //Distancia
        if(campo==camposMarca[5] && marca[campo]*100>=meta[campo]){
          resultado[campo]=meta[campo]*1.0;
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

    Navigator.push(context, MaterialPageRoute(builder: (builder)=>FinEntrenamiento()));

    Map<String,Map<String,double>> metasSuperadas={};

    //Por cada ejercicio miramos las marcas
    for(var ejercicio in marcas.keys){
      final meta = await BDLocal.instance.getMetaActual(ejercicio);
      Map<String,double> resultadoEjercicio={};
      for(var marca in marcas[ejercicio]!){
        await BDLocal.instance.insertMarca(marca);
        print(meta);
        Map<String,double> res = _comprobarMeta(meta, marca);
        print(res);
        res.removeWhere((key,value)=>value==0);
        resultadoEjercicio.addAll(res);
      }

      metasSuperadas[ejercicio]=resultadoEjercicio;
    }

    for(var ejercicio in metasSuperadas.keys){
      if(metasSuperadas[ejercicio]!.isNotEmpty){
        List<Widget> aux=[
          Text("¡Enhorabuena!", style: TextStyle(fontSize: 27.5.sp)),
          Text("Has superado metas", style: TextStyle(fontSize: 19.sp)),
          Icon(Icons.access_alarms, size: 40.sp, color: Colores.verde)
        ];
        metasSuperadas[ejercicio]!.forEach((key,value){
          final auxValor=value/100;
          final estiloTexto=TextStyle(fontSize: 18.sp,color: Colores.negro);

          if(key=='tiempo'){
            final minutos=value~/60, segundos=(value%60).toInt();
            aux.add(Text("$key superada, tu meta era $minutos min y $segundos seg", style: estiloTexto));
          }else if(key=='repeticiones'){
            aux.add(Text("$key superada, tu meta era $value", style: estiloTexto));
          }else{
            aux.add(Text("$key superada, tu meta era $auxValor", style: estiloTexto));
          }
        });
        final pantalla=PantallasEntrenamiento(
            titulo: "Meta superada",
            hijos: aux,
            boton: true,
            textoBoton: "Finalizar",
        );
        await Navigator.push(context, MaterialPageRoute(builder: (builder)=>pantalla));
      }
    }

    return true;
  }
}