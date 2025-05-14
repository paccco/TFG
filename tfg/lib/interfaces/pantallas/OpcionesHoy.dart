import 'package:flutter/material.dart';
import 'plantillas/OpcionesDia.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/constantes.dart';

class OpcionesHoy extends StatefulWidget{

  final DateTime hoy;
  final String rutina;

  const OpcionesHoy({super.key, required this.hoy, required this.rutina});

  @override
  _OpcionesHoyState createState() => _OpcionesHoyState();
}

class _OpcionesHoyState extends State<OpcionesHoy>{
  
  final TextStyle estiloTexto=TextStyle(fontSize: 22.sp, color: Colores.negro);
  
  late Widget _superior, _inferior;

  Widget _hacerBoton(String texto, {Color color=Colores.azul}){
    return InkWell(
      onTap: (){},
      child: Container(
        alignment: Alignment.center,
        color: color,
        height: 10.h,
        child: Text(texto, style: TextStyle(fontSize: 20.sp, color: Colores.blanco)),
      ),
    );
  }
  
  @override
  void initState() {
    super.initState();
    _superior=Column(
      spacing: 2.h,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text("Rutina: ",style: estiloTexto,),
        Center(
          child: Text(widget.rutina, style: estiloTexto),
        )
      ],
    );
    _inferior=Column(
      spacing: 2.h,
      children: [
        _hacerBoton("Empezar entrenamiento",color: Colores.naranja),
        _hacerBoton("Cambiar rutina"),
        _hacerBoton("Descanso")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return OpcionesDia(
        hijosSuperior: _superior,
        hijosInferior: _inferior,
        fechaTitulo: widget.hoy
    );
  }
}