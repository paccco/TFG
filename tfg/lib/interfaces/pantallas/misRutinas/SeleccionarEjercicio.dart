import 'package:flutter/material.dart';
import '../plantillas/ListaBusqueda.dart';
import '../../../ConexionBDLocal.dart';
import '../../../funcionesAux.dart';

class SeleccionarEjercicio extends StatefulWidget{
  final String rutina;

  const SeleccionarEjercicio({super.key, required this.rutina});

  @override
  _SeleccionarEjercicioState createState() => _SeleccionarEjercicioState();
}

class _SeleccionarEjercicioState extends State<SeleccionarEjercicio>{

  Future<List<String>> _cargarContenido() async{
    final out = await BDLocal.instance.getNombreEjercicios();

    setState(() {});
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return ListaBusqueda(
        titulo: "Selecciona un ejercicio",
        cargarContenido: _cargarContenido,
        cargarElemento: (context, nombre) async{
          final aux = BDLocal.instance;
          final res = await aux.aniadirEjerRutina(widget.rutina, [nombre]);

          if(res){
            Navigator.pop(context);
          }else{
            mensaje(context, "No se ha podido añadir el ejercicio");
          }
        }
    );
  }
}