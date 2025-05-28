import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/funcionesAux.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraNavegacion.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MarcasEntrenamiento extends StatefulWidget{
  final DateTime fecha;
  final String rutina;
  final List<Map<String,dynamic>> marcas;

  const MarcasEntrenamiento({super.key, required this.fecha ,required this.rutina, required this.marcas});

  @override
  _MarcasEntrenamientoState createState() => _MarcasEntrenamientoState();
}

class _MarcasEntrenamientoState extends State<MarcasEntrenamiento>{

  int indexEjercicio=0, indexSerie=0;
  Map<String,List<Map<String,dynamic>>> marcas={};
  late List<String> indiceStr;
  List<Widget> _visible=[];
  final int elementosVisibles=2;

  @override
  void initState() {
    super.initState();

    final marcasDesordenadas=widget.marcas;

    marcasDesordenadas.forEach((marca){
      final String ejercicio=marca[BDLocal.camposMarca[7]];

      Map<String,dynamic> marcaLimpia=Map.from(marca);
      marcaLimpia.remove(BDLocal.camposMarca[7]);
      marcaLimpia.remove(BDLocal.camposMarca[6]);

      if(marcas.containsKey(ejercicio)){
        marcas[ejercicio]!.add(marcaLimpia);
      }else{
        marcas[ejercicio]=[marcaLimpia];
      }
    });

    indiceStr=marcas.keys.toList(growable: false);
    actualizarVisible();
  }


  void navegar(bool siguiente){
    if(siguiente){
      if(indiceStr.length>indexEjercicio+1){
        indexEjercicio++;
        indexSerie=0;
      }
    }else{
      if(indexEjercicio-1>=0){
        indexEjercicio--;
        indexSerie=0;
      }
    }

    actualizarVisible();
  }

  Widget _cajaSerie(Map<String,dynamic> marca){
    List<Widget> hijos=[];

    marca.forEach((key, value) {
      if(value!=null){
        hijos.add(
          Text("$key: $value",style: TextStyle(color: Colores.negro, fontSize: 20.sp))
        );
      }
    });

    return Column(
      spacing: 1.h,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: hijos,
    );
}
  
  void actualizarVisible(){

    _visible.clear();

    List<Widget> aux=[Text("${indiceStr[indexEjercicio]}",style: TextStyle(color: Colores.negro, fontSize: 35.sp),)];

    final marcasEjercicio=marcas[indiceStr[indexEjercicio]];
    indexSerie=indexSerie%marcasEjercicio!.length;
    final int indexUltimoElemento=(marcasEjercicio.length > indexSerie+elementosVisibles) ? indexSerie+elementosVisibles : marcasEjercicio.length;

    final seriesVisibles = marcasEjercicio.sublist(indexSerie,indexUltimoElemento);

    int cont=indexSerie+1;
    seriesVisibles.forEach((marca){
      aux.add(Text("Serie $cont", style: TextStyle(fontSize: 25.sp),));
      cont++;
      aux.add(_cajaSerie(marca));
    });

    setState(() {
      _visible=aux;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: stringDate(widget.fecha))
      ),
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(2.h),
        child: InkWell(
          onTap: (){
            indexSerie++;
            actualizarVisible();
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 3.h,
              children: _visible,
            ),
          ),
        ),
      ),
      bottomNavigationBar: BarraNavegacion(navegar: navegar),
    );
  }
}