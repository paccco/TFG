import 'package:flutter/material.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/interfaces/pantallas/plantillas/ListaBusqueda.dart';

class SeleccionarRutina extends StatefulWidget{
  const SeleccionarRutina({super.key});

  @override
  _seleccionarRutinaState createState() => _seleccionarRutinaState();
}

class _seleccionarRutinaState extends State<SeleccionarRutina>{

  @override
  Widget build(BuildContext context) {
    return ListaBusqueda(
        titulo: "Selecciona rutina",
        cargarContenido: BDLocal.instance.getNombresRutinas,
        cargarElemento: (context, nombre)=>Navigator.pop(context,nombre)
    );
  }
}