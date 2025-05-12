import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../widgetsPersonalizados/BarraTexto.dart';
import '../../funcionesAux.dart';
import '../../ConexionBDLocal.dart';

class ModificarRutina extends StatefulWidget{

  final String titulo, descripcion, descanso;

  const ModificarRutina({super.key, required this.titulo, required this.descripcion, required this.descanso});

  @override
  _ModificarRutinaState createState() => _ModificarRutinaState();
}

class _ModificarRutinaState extends State<ModificarRutina>{
  final TextEditingController contDescripcion=TextEditingController();
  final TextEditingController contDescanso=TextEditingController();
  final TextEditingController contNombre=TextEditingController();

  @override
  void initState() {
    super.initState();

    contDescripcion.text=widget.descripcion;
    contDescanso.text=widget.descanso;
    contNombre.text=widget.titulo;
  }

  @override
  Widget build(BuildContext context) {

    String titulo=widget.titulo;
    final TextStyle estilo=TextStyle(color: Colores.negro,fontSize: 19.sp);

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            Text("Nombre", style:  estilo),
            BarraTexto(controller: contNombre),
            Text("Descanso",style: estilo),
            BarraTexto(controller: contDescanso),
            Text("Descripcion",style: estilo),
            BarraTexto(controller: contDescripcion,textoHint: "Descripcion",maxLineas: 5),
            botonPopUp("Guardar", () async{
              final descanso=contDescanso.value.text;
              final nombre=contNombre.value.text;
              if(validarFormatoHora(descanso)){

                int aux=0;

                if(titulo.compareTo(nombre)==0){
                  aux = await BDLocal.instance.modRutina(titulo, contDescripcion.value.text, descanso);
                }else{
                  aux = await BDLocal.instance.modRutina(titulo, contDescripcion.value.text, descanso, nombreNuevo: nombre);
                }
                if(aux!=0){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  mensaje(context, "Rutina modificada");
                }else{
                  mensaje(context, "Error al modificar la rutina", error: true);
                }
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