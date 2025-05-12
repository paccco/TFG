import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import '../widgetsPersonalizados/BarraTexto.dart';
import '../../funcionesAux.dart';
import 'ListaEjerRutina.dart';
import '../../ConexionBDLocal.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AniadirRutina extends StatefulWidget{
  const AniadirRutina({super.key});

  @override
  _AniadirRutinaState createState() => _AniadirRutinaState();
}

class _AniadirRutinaState extends State<AniadirRutina>{

  final TextEditingController contNom=TextEditingController();
  final TextEditingController contDescanso=TextEditingController();
  final TextEditingController contDescripcion=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: "Añadir rutina")
      ),
      body: Container(
        margin: EdgeInsets.all(2.h),
        child: Column(
          spacing: 2.h,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BarraTexto(controller: contNom,textoHint: "Nombre",),
            BarraTexto(controller: contDescanso,textoHint: "Descanso: hh:mm:ss",tipoInput: TextInputType.datetime),
            BarraTexto(controller: contDescripcion,textoHint: "Descripcion",maxLineas: 5,),
            Container(
                color: Colores.naranja,
                child: TextButton(
                    onPressed: () async {
                      final nombre = contNom.value.text;
                      final descanso = contDescanso.value.text;
                      final descripcion = contDescripcion.value.text;

                      if(validarFormatoHora(descanso)){
                        final aux=await BDLocal.instance.insertRutina(nombre,descripcion,descanso);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ListaEjerRutina(titulo: aux)));
                      }else{
                        mensaje(context, "Descanso hh:mm:ss", error: true);
                      }
                    },
                    child: Text("Seguir", style: TextStyle(color: Colores.blanco, fontSize: 20.sp))
                )
            )
        ],
      ),
    )
    );
  }
}