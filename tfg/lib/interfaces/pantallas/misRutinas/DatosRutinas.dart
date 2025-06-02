import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import '../Confirmacion.dart';
import '../../../API.dart';
import '../../../funcionesAux.dart';
import '../../../ConexionBDLocal.dart';
import 'ListaEjerRutina.dart';
import 'ModificarRutina.dart';

class DatosRutinas extends StatelessWidget{

  final String titulo;
  final Map<String,dynamic> rutina;
  final List<String> campos;

  const DatosRutinas({super.key, required this.titulo, required this.rutina, required this.campos});

  @override
  Widget build(BuildContext context) {

    String descanso = rutina[campos[3]];
    TextStyle estilo=TextStyle(color: Colores.negro,fontSize: 22.sp);

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
            Text("Descanso $descanso",style: estilo),
            botonPopUp("Compartir", () async{
              bool decision=false;
              decision=await Navigator.push(context, MaterialPageRoute(builder: (context)=>Confirmacion()));

              if(decision){
                final res=await subirRutina(titulo);
                switch(res){
                  case -2: mensaje(context, "La rutina ha de contener ejercicios para poder compartirse", error: true);
                  case -3: mensaje(context, "Error al verificar token", error: true);
                  default: mensaje(context, "Rutina subida correctamente");
                }
              }
            }, 'assets/images/subir.png'),
            botonPopUp("Modificar", () async {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ModificarRutina(titulo: titulo, descripcion: rutina[campos[1]], descanso: rutina[campos[3]])));
            },'assets/images/mod.png'),
            botonPopUp(
                "Ejercicios",
                    (){Navigator.push(context, MaterialPageRoute(builder: (context)=>ListaEjerRutina(titulo: titulo)));},
                'assets/images/ejercicio.png'
            ),
            botonPopUp("Eliminar", () async {

              bool decision=false;
              decision = await Navigator.push(context, MaterialPageRoute(builder: (context)=>Confirmacion()));

              if(decision){
                await BDLocal.instance.borrarRutina(titulo);
                Navigator.pop(context);
              }
            },'assets/images/papelera.png')
          ],
        ),
      ),
    );
  }
}