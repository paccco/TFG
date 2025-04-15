import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/pantallas/AniadirEjerRutina.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';

class EjerciciosRutina extends StatefulWidget{
  final String titulo;
  const EjerciciosRutina ({super.key, required this.titulo});

  @override
  EjerciciosRutinaState createState() => EjerciciosRutinaState();
}

class EjerciciosRutinaState extends State<EjerciciosRutina>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: widget.titulo)
      ),
      body: Container(
        color: Colores.grisClaro,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            IconButton(
                onPressed: () async {
                  await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AniadirEjerRutina())
                  );
                },
                icon: Image.asset(
                    'assets/images/aniadir.png',
                    height: Tamanios.botonAniadir,
                    width: Tamanios.botonAniadir
                )
            ),
          ],
        ),
      ),
    );
  }
}