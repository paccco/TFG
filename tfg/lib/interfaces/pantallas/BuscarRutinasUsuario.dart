import 'package:flutter/material.dart';
import 'package:tfg/interfaces/pantallas/plantillas/ListaBusqueda.dart';

class BuscarRutinasUsuario extends StatefulWidget{

  final bool modo;

  const BuscarRutinasUsuario({super.key, required this.modo});

  @override
  BuscarRutinasUsuarioState createState() => BuscarRutinasUsuarioState();
}

class BuscarRutinasUsuarioState extends State<BuscarRutinasUsuario>{

  Future<List<String>> _cargarContenidoRutina() async{
    return [];
  }

  @override
  Widget build(BuildContext context) {

    String titulo = widget.modo ? "Buscar rutinas por usuario" : "Buscar rutinas por nombre";

    return Placeholder();

    /*return ListaBusqueda(
        titulo: titulo,
        cargarContenido: cargarContenido,
        cargarElemento: cargarElemento
    );*/
  }
}