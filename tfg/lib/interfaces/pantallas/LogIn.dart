import 'package:flutter/material.dart';
import 'package:tfg/interfaces/PopUps/DialogosError.dart';
import 'package:tfg/interfaces/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraTexto.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Login extends StatelessWidget{
  const Login({super.key});

  @override
  Widget build(BuildContext context){

    TextEditingController nomC=TextEditingController(), passC=TextEditingController();
    final TextStyle estiloTexto=TextStyle(color: Colores.negro,fontSize: 25.sp);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: "EjercictaTec")
      ),
      body: Container(
        margin: EdgeInsets.all(5.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 40,
          children: [
            Text("Nombre",style: estiloTexto,),
            BarraTexto(controller: nomC),
            Text("Contraseña", style: estiloTexto),
            BarraTexto(controller: passC,),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colores.azul,
        child: TextButton(
            onPressed: (){
              final nombre = nomC.value.text;
              final passwd = passC.value.text;

              if(nombre.isNotEmpty && passwd.isNotEmpty){
                //comprobar
              }else{
                mensajeError(context, "Rellena los campos");
              }
            },
            child: Text("Iniciar sesion",style: TextStyle(color: Colores.blanco,fontSize: 31.sp),)
        ),
      ),
      
    );
  }
}