import 'package:flutter/material.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloSalidaBorrar.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../ConexionBDLocal.dart';
import '../constantes.dart';

class DatosEjercicios extends StatelessWidget{

  final String titulo;

  const DatosEjercicios ({super.key, required this.titulo});

  Widget descripcionMod(TextEditingController controller, BuildContext context){
    return FutureBuilder(
        future: BDLocal.instance.getDescripcionEjer(titulo),
        builder: (context,snapshot){
          if(snapshot.hasData){
            controller.text=snapshot.data ?? '';
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
          }else if(snapshot.hasError){
            return Center(child: Text("ERROR",style: TextStyle(fontSize: 40.sp),));
          }

          return CircularProgressIndicator();
        }
    );
  }

  Future<String> construyeMarcaMeta(bool modo) async{

    String out="";
    Map<String,dynamic> datos={};

    if(modo){
      out="Marca actual: ";
      datos = await BDLocal.instance.getMarcaActual(titulo);
    }else{
      out="Meta actual: ";
      datos = await BDLocal.instance.getMetaActual(titulo);
    }

    datos.forEach((key,valor){
      if(key!='unidades'){
        out+="$key $valor ";
      }else{
        if(valor){
          out+=" km";
        }else{
          out+=" m";
        }
      }
    });

    if(modo){
      out+="\nValoracion: 4.5 / 5";
    }else{
      out+="\nSin cumplir";
    }

    return out;
  }

  Widget hacerBoton(String texto,void Function() onPres){

    final TextStyle estiloBotones=TextStyle(color: Colores.blanco,fontSize: 21.sp);

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
  Widget build(BuildContext context){

    TextEditingController controladorDesc=TextEditingController();
    Widget descripcion=descripcionMod(controladorDesc,context);

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
                    FutureBuilder<String>(
                      future: construyeMarcaMeta(true),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return containerWrap(CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return containerWrap(Text("Error: ${snapshot.error}"));
                        } else if (snapshot.hasData) {
                          return containerWrap(Text(snapshot.data ?? ''));
                        }
                        return containerWrap(Text('No hay datos'));
                      }
                    ),
                    containerWrap(hacerBoton("Graficar según tiempo",(){})),
                    FutureBuilder<String>(
                        future: construyeMarcaMeta(false),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return containerWrap(CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return containerWrap(Text("Error: ${snapshot.error}"));
                          } else if (snapshot.hasData) {
                            return containerWrap(Text(snapshot.data ?? ''));
                          }
                          return containerWrap(Text('No hay datos'));
                        }
                    ),
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