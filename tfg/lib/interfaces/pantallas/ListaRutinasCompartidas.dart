import 'package:flutter/material.dart';
import 'package:tfg/API.dart';
import 'plantillas/ListaBusquedaConId.dart';
import 'DatosRutinasComp.dart';

class ListaRutinasCompartidas extends StatefulWidget{

  final String usuario;

  const ListaRutinasCompartidas({super.key, required this.usuario});
  @override
  State<ListaRutinasCompartidas> createState() => _ListaRutinasCompartidasState();
}

class _ListaRutinasCompartidasState extends State<ListaRutinasCompartidas>{


  Future<Map<int,String>> _cargarRutinas() async{
    final rutinas=await getRutinaCompDeUser(widget.usuario);

    return rutinas;
  }

  void _cargarInfoRutina(BuildContext context, String nombreRutina, int id) async{

    final rutina=await getRutina(id);
    final ejerciciosRutina=await getEjerciciosRutina(id);

    Navigator.push(context, MaterialPageRoute(builder: (context) => DatosRutinasComp(titulo: nombreRutina, id: id, rutina: rutina, listaEjer: ejerciciosRutina)));
  }

  @override
  Widget build(BuildContext context){
    return ListaBusquedaConId(
        titulo: "Rutinas Compartidas",
        cargarContenido: _cargarRutinas,
        cargarElemento: _cargarInfoRutina
    );
  }

}