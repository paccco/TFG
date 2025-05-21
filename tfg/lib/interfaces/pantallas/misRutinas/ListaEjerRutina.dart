import 'package:flutter/material.dart';
import 'package:tfg/interfaces/pantallas/misRutinas/SeleccionarEjercicio.dart';
import '../../../ConexionBDLocal.dart';
import '../plantillas/ListaAniadir.dart';


class ListaEjerRutina extends StatefulWidget {

  final String titulo;

  const ListaEjerRutina({super.key, required this.titulo});

  @override
  _ListaEjerRutinaState createState() => _ListaEjerRutinaState();
}

class _ListaEjerRutinaState extends State<ListaEjerRutina>{

  List<String> _contenido=[];
  String _seleccionado="";

  Future<List<String>> _cargarEjericios() async{
    final out = await BDLocal.instance.getEjerciciosRutina(widget.titulo);

    print(out);

    setState(() {
      _contenido = List.from(out);
    });

    return out;
  }

  void _aniadir(BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context)=>SeleccionarEjercicio(rutina: widget.titulo)));
  }

  void _intercambiar(BuildContext context, String nombre) async{
    if(_seleccionado.isEmpty){
      _seleccionado=nombre;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Seleccionado $nombre, vuelve a pulsar en $nombre para deseleccionar")));
    }else if(_seleccionado==nombre){
      _seleccionado="";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deseleccionado $nombre")));
    } else{
      int indice1=_contenido.indexOf(_seleccionado),
          indice2=_contenido.indexOf(nombre);
      String aux=_contenido[indice1];
      _contenido[indice1]=_contenido[indice2];
      _contenido[indice2]=aux;
      _seleccionado="";
      BDLocal.instance.modEjerRutina(widget.titulo, _contenido);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListaAniadir(
        aniadir: _aniadir,
        cargarContenido: _cargarEjericios,
        sePuedeBorrar: true,
        borrarElemento: (context, nombre) async{
          final aux = BDLocal.instance;
          
          _contenido.remove(nombre);

          aux.modEjerRutina(widget.titulo, _contenido);
        },
        cargarElemento: _intercambiar,
        titulo: widget.titulo
    );
  }
}