import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';

import '../plantillas/Grafica.dart';

class EligeParametro extends StatelessWidget{

  final String _ejercicio;
  final List<String> _parametros;

  const EligeParametro({super.key, required String ejercicio, required List<String> parametros}) :
        _parametros=parametros, _ejercicio=ejercicio;

  Widget _boton(String texto, void Function() func){
    return InkWell(
      onTap: func,
      child: Container(
        color: Colores.naranja,
        padding: EdgeInsets.all(1.h),
        alignment: Alignment.center,
        child: Text(texto,style: TextStyle(color: Colores.blanco, fontSize: 24.sp)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> aux =
        List.generate(
            _parametros.length,
                (index) => _boton(_parametros[index], ()=>
                    Navigator.push(context, MaterialPageRoute(builder: (builder)=>
                        Grafica(ejercicio: _ejercicio, medida: _parametros[index],fetchContenido: BDLocal.instance.getMediaMarca,)))));

    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: "")
      ),
      body: Container(
        margin: EdgeInsets.all(2.h),
        child: Column(
          spacing: 2.h,
          children: aux,
        ),
      ),
    );
  }
}