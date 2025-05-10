import 'package:flutter/material.dart';
import '../../constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import '../widgetsPersonalizados/BarraTexto.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../ConexionBDLocal.dart';
import '../../funcionesAux.dart';

class ModificarDescrEjercicio extends StatelessWidget{

  final String titulo;

  ModificarDescrEjercicio({super.key, required this.titulo});

  final TextEditingController controller=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: "Modificar descripcion")
      ),
      body: Container(
        margin: EdgeInsets.all(2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 3.h,
          children: [
            Text(titulo, style: TextStyle(fontSize: 25.sp)),
            BarraTexto(controller: controller,maxLineas: 8,),
            Container(
                width: 30.w,
                color: Colores.naranja,
                child: TextButton(
                    onPressed: () async{
                      final aux=await BDLocal.instance.modDescripcionEjer(controller.value.text, titulo);
                      if(aux){
                        mensaje(context, "Se ha modificado correctamente");
                      }else{
                        mensaje(context, "Fallo al modificar", error: true);
                      }
                    },
                    child: Text("Guardar",style: TextStyle(color: Colores.blanco,fontSize: 21.sp))
                )
            )
          ],
        ),
      ),
    );
  }
}