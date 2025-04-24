import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/API.dart';
import 'package:tfg/interfaces/PopUps/DialogosError.dart';
import 'package:tfg/interfaces/pantallas/LogSignIn.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraTexto.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import '../../constantes.dart';

class Singin1 extends StatefulWidget {
  const Singin1({super.key});

  @override
  Singin1State createState() => Singin1State();
}

class Singin1State extends State<Singin1>{
  final TextEditingController _userC= TextEditingController(),
      _passC=TextEditingController(),
      _passC2=TextEditingController();

  @override
  Widget build(BuildContext context) {

    TextStyle estiloTexto=TextStyle(color: Colores.negro,fontSize: 22.sp);

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
            Text("Nombre usuario",style: estiloTexto),
            BarraTexto(controller: _userC),
            Text("Contraseña",style: estiloTexto),
            BarraTexto(controller: _passC),
            Text("Repite Contraseña",style: estiloTexto),
            BarraTexto(controller: _passC2)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colores.azul,
        child: TextButton(
            onPressed: () async{
              final usuario = _userC.value.text;
              final passwd = _passC.value.text;
              final passwd2 = _passC2.value.text;

                if(usuario.isNotEmpty && passwd.isNotEmpty && passwd2.isNotEmpty){
                  if(passwd.compareTo(passwd2)==0){

                    final aux=await existeUser(usuario);

                    if(aux==1){
                      mensaje(context, "Ya existe es usuario");
                    }else if(aux==-1){
                      mensaje(context, "Error en el servidor");
                    }else{
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Singin2(usuario: usuario,passwd: passwd)));
                    }
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

  final String passwd, usuario;

  const Singin2({super.key, required this.passwd, required this.usuario});

  @override
  Singin2State createState() => Singin2State();
}

class Singin2State extends State<Singin2>{
  String? generoSeleccionado = 'Prefiero no decirlo';
  final List<String> generos = ['Hombre', 'Mujer', 'Prefiero no decirlo'];
  final TextEditingController peC=TextEditingController(),
      alC=TextEditingController();


  @override
  Widget build(BuildContext context) {

    TextStyle estiloTexto=TextStyle(color: Colores.negro,fontSize: 20.sp);

    DateTime fechaN=DateTime.now();
    String fechaFormato="";

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
            Container(
              color: Colores.azul,
              child: TextButton(
                  onPressed: () async {
                    fechaN = await showDatePicker(
                        context: context,
                        firstDate: DateTime(1940,1,1),
                        lastDate: DateTime.now()
                    ) ?? fechaN;

                    final aux=fechaN.toString();
                    fechaFormato=aux.split(' ').first;
                  },
                  child: Text("Seleccionar",style: TextStyle(color: Colores.blanco),)
              ),
            ),
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
            onPressed: () async{
              final peso = peC.value.text;
              final altura = alC.value.text;

              if(fechaN!=DateTime.now() && peso.isNotEmpty && altura.isNotEmpty){
                final regexPeso = RegExp(r'^\d{1,3}\.\d$'); // ej. 72.5, 100.0
                final regexAlt = RegExp(r'^[1-9][0-9]{1,2}$'); // desde 10 hasta 999 cm

                if(regexAlt.hasMatch(altura)&&regexPeso.hasMatch(peso)){
                  storage.write(key: 'peso', value: peso);
                  storage.write(key: 'altura', value: altura);
                  storage.write(key: 'fechaN', value: fechaFormato);

                  final aux = await singin(widget.usuario, widget.passwd);
                  if(aux){
                    mensaje(context, "Error al insertar usuario");
                  }else{
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LogSignIn()),
                          (route) => false,
                    );
                    mensaje(context, "Cuenta creada correctamente");
                  }
                }else{
                  mensajeError(context, "Altura en cm sin decimales, peso solo con un decimal");
                }

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