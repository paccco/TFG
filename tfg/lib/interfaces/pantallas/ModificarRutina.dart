import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../widgetsPersonalizados/BarraTexto.dart';
import '../../funcionesAux.dart';
import '../../ConexionBDLocal.dart';

class ModificarRutina extends StatelessWidget{

  final String titulo, descripcion, descanso;

  ModificarRutina({super.key, required this.titulo, required this.descripcion, required this.descanso});

  final TextEditingController contDescripcion=TextEditingController();
  final TextEditingController contDescanso=TextEditingController();

  @override
  Widget build(BuildContext context) {

    final TextStyle estilo=TextStyle(color: Colores.negro,fontSize: 19.sp);

    contDescripcion.text=descripcion;
    contDescanso.text=descanso;

    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: titulo)
      ),
      body: Container(
        margin: EdgeInsets.all(2.h),
        child: Column(
          spacing: 2.h,
          children: [
            Text("Descanso",style: estilo),
            BarraTexto(controller: contDescanso),
            Text("Descripcion",style: estilo),
            BarraTexto(controller: contDescripcion,textoHint: "Descripcion",maxLineas: 5),
            botonPopUp("Guardar", (){
              final descanso=contDescanso.value.text;
              if(validarFormatoHora(descanso)){
                BDLocal.instance.modDescripcionDescansoRutina(titulo, contDescripcion.value.text, descanso);
                Navigator.pop(context);
                Navigator.pop(context);
              }else{
                mensaje(context, "Descanso hh:mm:ss",error: true);
              }
            },
                'assets/images/save.png'
            )
          ],
        ),
      ),
    );
  }
}