import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/pantallas/calendario/ModificarMacros.dart';
import '../plantillas/OpcionesDia.dart';
import '../../../ConexionBDLocal.dart';
import '../../../funcionesAux.dart';
import 'ModificarPeso.dart';

class OpcionesPeso extends StatelessWidget{
  final DateTime fecha;
  final bool esHoy;

  const OpcionesPeso({super.key, required this.fecha, required this.esHoy});

  Widget _hacerBoton(Function() func, String texto){
    return InkWell(
      onTap: func,
      child: Container(
        padding: EdgeInsets.all(2.h),
        alignment: Alignment.center,
        height: 10.h,
        color: Colores.naranja,
        child: Text(texto, style: TextStyle(fontSize: 24.sp, color: Colores.blanco)),
      ),
    );
  }

  Future<Widget> _cargarDatos(BuildContext context) async{
    final datos=await BDLocal.instance.getPesaje(fecha);

    final camposPesajes=BDLocal.instance.camposPesajes;
    final estiloTexto = TextStyle(fontSize: 22.sp, color: Colores.negro);

    late final List<Widget> auxSuperior;
    late final String peso;

    if(datos[camposPesajes[1]]==null){
      peso = 'Sin asignar';
    }else{
      peso = '${datos[camposPesajes[1]]!/10} kg';
    }

    final Widget textoSuperior=Text('Peso: $peso', style: estiloTexto);

    if(esHoy){
      auxSuperior = [
        textoSuperior,
        _hacerBoton(
            ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ModificarPeso(fecha: fecha))),
            "Modificar Peso")
      ];
    }else{
      auxSuperior = [
        textoSuperior
      ];
    }

    final Widget hijosSuperior=Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 2.h,
      children: auxSuperior
    );

    late final List<Widget> auxInferior;
    late final String grasa, hueso, musculo;

    if(datos[camposPesajes[2]]==null){
      grasa = 'Sin asignar';
    }else{
      grasa = '${datos[camposPesajes[2]]} %';
    }

    if(datos[camposPesajes[3]]==null){
      hueso = 'Sin asignar';
    }else{
      hueso = '${datos[camposPesajes[3]]} %';
    }

    if(datos[camposPesajes[4]]==null){
      musculo = 'Sin asignar';
    }else{
      musculo = '${datos[camposPesajes[4]]} %';
    }

    final Widget textoInferior=Text(''
        '''
        Grasa: $grasa
        Hueso: $hueso
        Músculo: $musculo
        ''',
        style: estiloTexto
    );

    if(esHoy){
      auxInferior = [
        textoInferior,
        _hacerBoton(
                ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>ModificarMacros(fecha: fecha))),
            "Modificar Macros"
        )
      ];
    }else{
      auxInferior = [
        textoInferior
      ];
    }

    final Widget hijosInferior=Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 2.h,
        children: auxInferior
    );

    return OpcionesDia(
        hijosSuperior: hijosSuperior,
        hijosInferior: hijosInferior,
        fechaTitulo: fecha
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _cargarDatos(context),
        builder: (builder, snapshot){
          if(snapshot.hasData){
            return snapshot.data!;
          }else if(snapshot.hasError){
            return Text("Error ${snapshot.error}");
          }else{
            return const Center(child: CircularProgressIndicator());
          }
        }
    );
  }
}