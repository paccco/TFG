import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/interfaces/PopUps/DialogosError.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraTexto.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import '../constantes.dart';

class Singin1 extends StatelessWidget{
  const Singin1({super.key});

  @override
  Widget build(BuildContext context) {

    TextStyle estiloTexto=TextStyle(color: Colores.negro,fontSize: 22.sp);
    TextEditingController userC= TextEditingController(),
        passC=TextEditingController(),
        passC2=TextEditingController();

    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: "EjercitaTec")
      ),
      body: Container(
        margin: EdgeInsets.all(5.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Text("Nombre usuario",style: estiloTexto),
            BarraTexto(controller: userC),
            Text("Contraseña",style: estiloTexto),
            BarraTexto(controller: passC),
            Text("Repite Contraseña",style: estiloTexto),
            BarraTexto(controller: passC2)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colores.azul,
        child: TextButton(
            onPressed: (){
              final usuario = userC.value.text;
              final passwd = passC.value.text;
              final passwd2 = passC2.value.text;

                if(usuario.isNotEmpty && passwd.isNotEmpty && passwd2.isNotEmpty){
                  //Añadir comprobacion de si existe el usuario
                  if(passwd.compareTo(passwd2)==0){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Singin2()));
                  }else{
                    mensajeError(context, "Las contraseñas no coinciden");
                  }
                }else{
                  mensajeError(context, "Rellena todos los campos");
                }
              },
            child: Text("Seguir",style: TextStyle(color: Colores.blanco,fontSize: 31.sp),)
        ),
      ),
    );
  }
}

class Singin2 extends StatefulWidget {
  const Singin2({super.key});

  @override
  Singin2State createState() => Singin2State();
}

class Singin2State extends State<Singin2>{

  String? generoSeleccionado = 'Prefiero no decirlo';
  final List<String> generos = ['Hombre', 'Mujer', 'Prefiero no decirlo'];

  @override
  Widget build(BuildContext context) {

    TextStyle estiloTexto=TextStyle(color: Colores.negro,fontSize: 20.sp);
    TextEditingController feC= TextEditingController(),
        peC=TextEditingController(),
        alC=TextEditingController();

    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: "EjercitaTec")
      ),
      body: Container(
        margin: EdgeInsets.all(5.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 10,
          children: [
            Text("Fecha Nacimiento",style: estiloTexto),
            BarraTexto(controller: feC),
            Text("Género",style: estiloTexto),
            DropdownButton<String>(
              value: generoSeleccionado,
                items: generos.map((valor){
                  return DropdownMenuItem<String>(
                    value: valor,
                      child: Text(valor)
                  );
                }).toList(),
                onChanged: (String? nuevaOp){
                  setState(() {
                    generoSeleccionado=nuevaOp;
                  });
                }
            ),
            Text("Peso en KG",style: estiloTexto),
            BarraTexto(controller: peC,tipoInput: TextInputType.numberWithOptions(decimal: true)),
            Text("Altura en cm",style: estiloTexto),
            BarraTexto(controller: alC, tipoInput: TextInputType.number)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colores.azul,
        child: TextButton(
            onPressed: (){
              final fecha = feC.value.text;
              final peso = peC.value.text;
              final altura = alC.value.text;

              if(fecha.isNotEmpty && peso.isNotEmpty && altura.isNotEmpty){
                //Cargar menu principal y comprobaciones
              }else{
                mensajeError(context, "Rellena los campos");
              }
            },
            child: Text("Crear usuario",style: TextStyle(color: Colores.blanco,fontSize: 31.sp))
        ),
      ),
    );
  }
}