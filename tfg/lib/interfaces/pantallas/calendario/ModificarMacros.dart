import 'package:flutter/material.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/funcionesAux.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraTexto.dart';
import '../../widgetsPersonalizados/TituloConSalida.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ModificarMacros extends StatefulWidget{

  final DateTime fecha;

  const ModificarMacros({super.key, required this.fecha});

  @override
  State<ModificarMacros> createState() => _ModificarMacrosState();
}

class _ModificarMacrosState extends State<ModificarMacros>{
  
  final TextEditingController 
      grasaC = TextEditingController(), 
      huesoC = TextEditingController() , 
      musculoC = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: "Modificar macros")
      ),
      body: Container(
        margin: EdgeInsets.all(2.h),
        alignment: Alignment.center,
        child: Column(
          spacing: 2.h,
          children: [
            BarraTexto(controller: grasaC, textoHint: "Grasa",tipoInput: TextInputType.number,),
            BarraTexto(controller: huesoC, textoHint: "Hueso",tipoInput: TextInputType.number,),
            BarraTexto(controller: musculoC, textoHint: "Musculo",tipoInput: TextInputType.number,),
            InkWell(
              onTap: () async {
                final grasaStr=grasaC.value.text,
                      huesoStr=huesoC.value.text,
                      musculoStr=musculoC.value.text;

                if(!grasaStr.contains(comasPuntos) && !huesoStr.contains(comasPuntos) && !musculoStr.contains(comasPuntos)){
                  if(grasaStr.isNotEmpty && huesoStr.isNotEmpty && musculoStr.isNotEmpty){
                    if(grasaStr.length<=2 && huesoStr.length<=2 && musculoStr.length<=2){
                      final int grasa=int.parse(grasaStr),
                          hueso=int.parse(huesoStr),
                          musculo=int.parse(musculoStr);

                      if((grasa+hueso+musculo)==100){
                        await BDLocal.instance.setMacros(widget.fecha, grasa, hueso, musculo);
                        mensaje(context, "Macros subidas correctamente");
                      }else{
                          mensaje(context, "Los porcentajes no son correctos, no suman 100",error: true);
                      }
                    }else{
                      mensaje(context, "Los valores deben tener máximo 2 dígitos", error: true);
                    }
                  }else{
                    mensaje(context, "Rellena los campos", error: true);
                  }
                }else{
                  mensaje(context, "Los valores no pueden contener comas o puntos", error: true);
                }
              },
              child: Container(
                color: Colores.naranja,
                height: 10.h,
                padding: EdgeInsets.all(2.h),
                alignment: Alignment.center,
                child: Text("Guardar", style: TextStyle(fontSize: 20.sp, color: Colores.blanco)),
              ),
            )
          ],
        ),
      )
    );
  }
}