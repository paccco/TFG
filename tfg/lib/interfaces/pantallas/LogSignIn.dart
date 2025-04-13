import 'package:flutter/material.dart';
import 'package:tfg/interfaces/pantallas/LogIn.dart';
import 'package:tfg/interfaces/pantallas/Signin.dart';
import '../widgetsPersonalizados/TituloSimple.dart';
import '../constantes.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LogSignIn extends StatelessWidget{
  const LogSignIn({super.key});

  Widget _hacerBoton(String texto, void Function() func){
    return Container(
      height: 10.h,
        width: 70.w,
        color: Colores.azul,
        child: TextButton(
            onPressed: func,
            child: Text(texto,style: TextStyle(color: Colores.blanco,fontSize: 25.sp))
        )
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colores.grisClaro,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(Tamanios.appBarH),
            child: TituloSimple(titulo: "EjercictaTec")
        ),
      body: Container(
        color: Colores.grisClaro,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 80,
          children: [
            _hacerBoton("Iniciar sesion",(){Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));}),
            _hacerBoton("Crear cuenta",(){Navigator.push(context, MaterialPageRoute(builder: (context)=> Singin1()));})
          ],
        ),
      ),
    );
  }
}