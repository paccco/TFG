import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloSalidaBorrar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../ConexionBDLocal.dart';
import '../constantes.dart';

class DatosEjercicios extends StatelessWidget{

  final String titulo;

  const DatosEjercicios ({super.key, required this.titulo});

  Widget descripcionMod(TextEditingController controller, BuildContext context){
    return Container(
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
                filled: true,
                fillColor: Colores.azul,
                border: OutlineInputBorder()
            ),
            maxLines: 5,
            controller: controller,
            textAlign: TextAlign.justify,
          ),
          Container(
            margin: EdgeInsets.all(5),
              child: hacerBoton("Guardar",() async{

                String mensaje="";
                bool aux = await BDLocal.instance.modDescripcionEjer(controller.value.text, titulo);

                if(!aux){
                  mensaje="Fallo al modificar descripcion";
                }else{
                  mensaje="Descripcion modificada con exito";
                }

                showDialog(context: context, builder: (BuildContext context){
                  return AlertDialog(title: Text(mensaje));
                });
              })
          )
        ],
      ),
    );
  }

  Widget hacerBoton(String texto,void Function() onPres){

    final TextStyle estiloBotones=TextStyle(color: Colores.blanco,fontSize: 19.sp);

    return Container(
        color: Colores.naranja,
        child: TextButton(
            onPressed: onPres,
            child: Text(texto,style: estiloBotones)
        )
    );
  }

  Widget containerWrap(Widget content){
    return Container(width: 37.w,margin: EdgeInsets.all(10),child: content);
  }

  @override
  Widget build(BuildContext context) {

    TextEditingController controladorDesc=TextEditingController();
    Widget descripcion=descripcionMod(controladorDesc,context);
    TextStyle estiloTexto=TextStyle(color: Colores.negro, fontSize: 18.sp);

    BDLocal.instance.get(titulo).then((value){
      controladorDesc.text=value;
    });

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalidaBorrar(titulo: titulo)
      ),
      body: Container(
        alignment: Alignment.center,
        color: Colores.grisClaro,
        child: Padding(
          padding: EdgeInsets.all(15),
            child: Column(
              spacing: 20,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                descripcion,
                Wrap(
                  spacing: 12,
                  children: [
                    containerWrap(Text("Marca Actual:7.4 repeticiones x 6 kg\nValoración actual: 4.5 / 5",style: estiloTexto)),
                    containerWrap(hacerBoton("Graficar según tiempo",(){})),
                    containerWrap(Text("Meta Actual:8 repeticiones x 6 kg\nSin cumplir",style: estiloTexto)),
                    containerWrap(hacerBoton("Establecer meta",(){}))
                  ],
                )
              ],
            ),
        ),
      ),
    );
  }
}