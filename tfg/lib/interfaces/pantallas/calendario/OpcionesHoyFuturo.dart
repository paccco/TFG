import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/FlujoEntrenamiento.dart';
import 'package:tfg/funcionesAux.dart';
import 'package:tfg/interfaces/pantallas/flujoEntrenamiento/EntrrenamientoListarEjericicos.dart';
import 'package:tfg/interfaces/pantallas/calendario/SeleccionarRutina.dart';
import '../plantillas/OpcionesDia.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/constantes.dart';

class OpcionesHoyFuturo extends StatefulWidget{

  final DateTime diaSeleccionado;
  final String rutina;

  const OpcionesHoyFuturo({super.key, required this.diaSeleccionado, required this.rutina, });

  @override
  _OpcionesHoyFuturoState createState() => _OpcionesHoyFuturoState();
}

class _OpcionesHoyFuturoState extends State<OpcionesHoyFuturo>{
  
  final TextStyle estiloTexto=TextStyle(fontSize: 22.sp, color: Colores.negro);
  
  late Widget _superior, _inferior;

  Widget _hacerBoton(String texto, void Function() func, {Color color=Colores.azul}){
    return InkWell(
      onTap: func,
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

    List<Widget> aux=[
      _hacerBoton("Cambiar rutina",() async{
        final String? res = await Navigator.push(context, MaterialPageRoute(builder: (builder)=>SeleccionarRutina()));

        if(res!="" && res!=null){
          final bool sinError=await BDLocal.instance.insertEntrenamiento(widget.diaSeleccionado, res);

          if(sinError){
            Navigator.pop(context,true);
            mensaje(context, "Rutina cambiada");
          }else{
            mensaje(context, "Error al caqmbiar rutina", error: true);
          }
        }
      }),
      _hacerBoton("Descanso",() async{
        await BDLocal.instance.borrarEntremiento(widget.diaSeleccionado);
        Navigator.pop(context);
      })
    ];

    if(isSameDay(widget.diaSeleccionado, DateTime.now())){
      aux.add(_hacerBoton("Empezar entrenamiento",() async {

        final entrenamiento=await FlujoEntrenamiento.crear(widget.rutina);

        final bool res=await entrenamiento.ejecutar(context);

        if(!res){
          mensaje(context, "Esta rutina no tiene ejercicios", error: true);
        }else{
          Navigator.pop(context);
          Navigator.pop(context);
        }

      },color: Colores.naranja),);
    }

    _inferior=Column(
      spacing: 2.h,
      children: aux,
    );
  }

  @override
  Widget build(BuildContext context) {
    return OpcionesDia(
        hijosSuperior: _superior,
        hijosInferior: _inferior,
        fechaTitulo: widget.diaSeleccionado
    );
  }
}