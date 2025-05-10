import 'package:flutter/material.dart';
import 'package:tfg/interfaces/pantallas/plantillas/ListaBusquedaAniadir.dart';
import 'AniadirEjercicio.dart';
import './DatosEjercicios.dart';
import '../../ConexionBDLocal.dart';

class ListaEjercicios extends StatefulWidget{
  const ListaEjercicios({super.key});

  @override
  ListaEjerciciosState createState()=> ListaEjerciciosState();
}

class ListaEjerciciosState extends State<ListaEjercicios>{
  Future<List<String>> _fetchEjercicios() async{
    return await BDLocal.instance.getNombreEjercicios();
  }

  void _cargarEjercicio(BuildContext context,String nombre)async{
    final res = await Navigator.push(context, MaterialPageRoute(builder: (context)=>DatosEjercicios(titulo: nombre)));

    if(res=='SI'){
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ListaEjercicios()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListaBusquedaAniadir(
        aniadir: (context)=>Navigator.push(context, MaterialPageRoute(builder: (context)=>AniadirEjercicio())),
        cargarContenido: _fetchEjercicios,
        cargarElemento: _cargarEjercicio,
        titulo: "Mis ejercicios"
    );
  }
}