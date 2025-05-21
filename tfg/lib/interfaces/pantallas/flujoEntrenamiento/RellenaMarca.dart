import 'dart:async';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraTexto.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloSimple.dart';
import 'package:tfg/funcionesAux.dart';
import '../../../ConexionBDLocal.dart';

/**
 * En esta clase no me interesa usar la plantilla
 */

class RellenaMarca extends StatefulWidget{

  final String ejercicio;
  final String tipo;
  final String descanso;

  const RellenaMarca({super.key,  required this.ejercicio, required this.tipo, required this.descanso});

  @override
  State<RellenaMarca> createState() => _RellenaMarcaState();
}

class _RellenaMarcaState extends State<RellenaMarca>{

  TextEditingController? _repeC, _pesoC, _distC, _tiempoC;
  List<Widget> _cajasTexto=[];
  List<int> _digitosDescanso=[];
  Timer? _timer;
  String _tiempoRestante="";
  bool _finDescanso=false;

  @override
  void initState() {
    super.initState();
    _digitosDescanso=widget.descanso.split(":").map((e) => int.parse(e)).toList();

    final String tipo=widget.tipo;

    if(tipo[0]=='1'){
      _repeC=TextEditingController();
      _cajasTexto.add(
        BarraTexto(controller: _repeC!, textoHint: "REPETICIONES",tipoInput: TextInputType.number)
      );
    }
    if(tipo[1]=='1'){
      _pesoC=TextEditingController();
      _cajasTexto.add(
          BarraTexto(controller: _pesoC!, textoHint: "PESO",tipoInput: TextInputType.numberWithOptions(decimal: true))
      );
    }
    if(tipo[2]=='1'){
      _tiempoC=TextEditingController();
      _cajasTexto.add(
          BarraTexto(controller: _tiempoC!, textoHint: "TIEMPO")
      );
    }
    if(tipo[3]=='1'){
      _distC=TextEditingController();
      _cajasTexto.add(
          BarraTexto(controller: _distC!, textoHint: "DISTANCIA", tipoInput: TextInputType.number)
      );
    }

    _iniciarCuentaAtras();
  }

  void _durationStr(Duration duration){
    final int aux = duration.inSeconds;
    _tiempoRestante = "${aux ~/ 60} : ${aux % 60}";
  }

  void _iniciarCuentaAtras(){
    DateTime objetivo=DateTime.now().add(Duration(minutes: _digitosDescanso[0], seconds: _digitosDescanso[1]));

    _timer?.cancel();
    Duration duracion = objetivo.difference(DateTime.now());
    if (duracion.isNegative){ duracion = Duration.zero;}

    _durationStr(duracion);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final ahora = DateTime.now();
      final resta = objetivo.difference(ahora);
      if (resta.isNegative) {
        timer.cancel();
        setState(() {
          duracion = Duration.zero;
        });
        _finDescanso=true;
      } else {
        setState(() {
          duracion = resta;
        });
      }
      _durationStr(duracion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor: Colores.grisClaro,
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(Tamanios.appBarH),
              child: TituloSimple(titulo: "Marcas")
          ),
          body: Container(
            margin: EdgeInsets.all(2.h),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 2.h,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 1.h,
                    children: _cajasTexto,
                  ),
                  Text("Descanso: $_tiempoRestante", style: TextStyle(fontSize: 24.sp))
                ]
            ),
          ),
          bottomNavigationBar: InkWell(
            onTap: () async {
              Map<String,dynamic> aux={};
              final camposMarca=BDLocal.camposMarca;

              if(_repeC!=null && _repeC!.value.text.isNotEmpty){
                try{
                  aux[camposMarca[2]]=int.parse(_repeC!.value.text);
                }catch(exception){
                  mensaje(context, "Repeticiones: Usa un numero positivo sin comas",error: true);
                }
              }
              if(_tiempoC!=null && _tiempoC!.value.text.isNotEmpty){
                final horaVal = _tiempoC!.value.text;
                if(validarFormatoHora(horaVal)) {
                  aux[camposMarca[4]] = horaVal;
                }else{
                  aux[camposMarca[4]] = false;
                }
              }
              if(_pesoC!=null && _pesoC!.value.text.isNotEmpty){
                try{
                  aux[camposMarca[3]]=double.parse(_pesoC!.value.text);
                }catch(exception){
                  mensaje(context, "Peso: Usa un numero con punto", error: true);
                }
              }
              if(_distC!=null && _distC!.value.text.isNotEmpty){
                try{
                  aux[camposMarca[5]]=double.parse(_distC!.value.text);
                }catch(execption){
                  mensaje(context, "Distancia: Usa un numero con punto", error: true);
                }
              }

              if(aux.values.contains(false)){
                mensaje(context, "Formato de hora erróneo: mm:ss", error: true);
              } else if(aux.isNotEmpty){
                if(_finDescanso){
                  aux[camposMarca[0]]=stringDate(DateTime.now());
                  aux[camposMarca[7]]=widget.ejercicio;
                  Navigator.pop(context, aux);
                }else{
                  mensaje(context, "Espera a que acabe el descanso",error: true);
                }
                //Cambiar de pantalla
              }else{
                mensaje(context, "Rellena los campos", error: true);
              }
            },
            child: Container(
              padding: EdgeInsets.all(2.h),
              alignment: Alignment.center,
              color: Colores.naranja,
              height: 12.5.h,
              child: Text("Guardar",style: TextStyle(fontSize: 28.sp,color: Colores.blanco),),
            ),
          ),
        )
    );
  }

  @override
  void dispose() {
    _repeC?.dispose();
    _pesoC?.dispose();
    _distC?.dispose();
    _tiempoC?.dispose();
    super.dispose();
  }

}