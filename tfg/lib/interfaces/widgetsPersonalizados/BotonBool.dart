import 'package:flutter/material.dart';
import '../constantes.dart';

class BotonBool extends StatefulWidget{
  final bool miBool;
  final ValueChanged<bool> cambio;
  final String texto;

  const BotonBool({super.key,required this.miBool, required this.texto, required this.cambio});

  @override
  BotonBoolState createState() => BotonBoolState();
}

class BotonBoolState extends State<BotonBool>{

  bool miBoolLocal=false;
  Color colorBoton=Colores.naranja;

  @override
  void initState() {
    super.initState();
    miBoolLocal=widget.miBool;
    _setColor();
  }

  void _setColor(){
    if(miBoolLocal) {
      colorBoton=Colores.azul;
    } else {
      colorBoton=Colores.naranja;
    }
  }

  @override
  Widget build(BuildContext context){
    return Container(
        color: colorBoton,
        child: TextButton(
            onPressed: (){
              miBoolLocal=!miBoolLocal;
              widget.cambio(miBoolLocal);
              _setColor();
              setState(() {});
            },
            child: Text(widget.texto, style: TextStyle(color: Colores.blanco))
        )
    );
  }
}