import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/constantes.dart';

class BarraNavegacion extends StatelessWidget{

  final ValueChanged<bool> navegar;

  const BarraNavegacion({super.key, required this.navegar});

  @override
  Widget build(BuildContext context){

    final double tamBotones=20.w;

    return Container(
      height: tamBotones,
      color: Colores.grisClaro,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
          width: tamBotones,
          height: tamBotones,
          color: Colores.azul,
          child: IconButton(
              onPressed: (){navegar(false);},
              icon: Image.asset('assets/images/flechaIzq.png')
          )
        ),
          Spacer(),
          Container(
              width: tamBotones,
              height: tamBotones,
              color: Colores.azul,
              child: IconButton(
                  onPressed: (){navegar(true);},
                  icon: Image.asset('assets/images/flechaDer.png')
              )
          ),
        ],
      ),
    );
  }
}