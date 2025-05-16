import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import '../widgetsPersonalizados/BarraTexto.dart';
import '../widgetsPersonalizados/BotonBool.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../funcionesAux.dart';
import '../../ConexionBDLocal.dart';

class AniadirEjercicio extends StatefulWidget{
  const AniadirEjercicio({super.key});

  @override
  AniadirEjercicioState createState()=> AniadirEjercicioState();
}

class AniadirEjercicioState extends State<AniadirEjercicio>{

  final TextEditingController contNomEjercicio = TextEditingController();
  final TextEditingController descEjercicio = TextEditingController();

  bool _repeticiones=false, _peso=false, _tiempo=false, _distancia=false;
  
  @override
  Widget build(BuildContext context) {

    final BarraTexto barraNombreEjer=BarraTexto(controller: contNomEjercicio, textoHint: "Nombre");
    final BarraTexto barraDesc=BarraTexto(controller: descEjercicio, textoHint: "Descripcion", maxLineas: 8);

    BotonBool repBot=BotonBool(miBool: _repeticiones, texto: "Repeticiones", cambio: (value) {_repeticiones=value;});
    BotonBool pesoBot=BotonBool(miBool: _peso, texto: "Peso", cambio: (value){_peso=value;});
    BotonBool tiemBot=BotonBool(miBool: _tiempo, texto: "Tiempo", cambio: (value){_tiempo=value;});
    BotonBool distBot=BotonBool(miBool: _distancia, texto: "Distancia", cambio: (value){_distancia=value;});

    final EdgeInsets padding=EdgeInsets.all(5);

    final double fuenteTitulo=25.sp;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH), 
          child: TituloConSalida(titulo: "Crear ejercicio")
      ),
      body: Container(
        alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Column(
              spacing: 2.h,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(padding: padding,child: Text("Nombre",style: TextStyle(fontSize: fuenteTitulo))),
                Container(padding: padding,child: barraNombreEjer),
                Container(padding: padding, child: Text("Parámetros", style: TextStyle(fontSize: fuenteTitulo))),
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    repBot,pesoBot,tiemBot,distBot
                  ],
                ),
                Padding(padding: padding,child: barraDesc),
                Spacer(),
                Container(
                  height: 10.h,
                    padding: padding,
                    child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(Colores.naranja)
                        ),
                        onPressed: (){
                          int codTipo;
                          String desc, nombre;

                          if(contNomEjercicio.value.text.isNotEmpty){
                            nombre=contNomEjercicio.value.text;
                            if(descEjercicio.value.text.isNotEmpty){
                              desc=descEjercicio.value.text;
                              if(_repeticiones || _tiempo || _distancia || _peso){
                                String byte="";

                                byte += (_repeticiones ? '1' : '0');
                                byte += (_peso ? '1' : '0');
                                byte += (_tiempo ? '1' : '0');
                                byte += (_distancia ? '1' : '0');
                                byte += '0000';

                                codTipo=int.parse(byte,radix: 2);

                                Map<String,dynamic> datos={
                                  BDLocal.instance.camposEjercicios[0] :  nombre,
                                  BDLocal.instance.camposEjercicios[1] :  codTipo,
                                  BDLocal.instance.camposEjercicios[2] :  desc
                                };

                                BDLocal.instance.insertEjercicios(datos).then((value){
                                  if(value.isEmpty){
                                    mensaje(context, "Fallo al guardar el ejercicio", error: true);
                                  }
                                });
                                Navigator.pop(context);
                              }else{
                                print("$_repeticiones $_tiempo $_distancia $_peso");
                                mensaje(context, "Selecciona al menos un tipo de parámetro", error: true);
                              }
                            }else{
                              mensaje(context, "Rellene la descripción", error: true);
                            }
                          }else{
                            mensaje(context, "Rellena el nombre del ejercicio", error: true);
                          }
                        },
                        child: Text("Guardar", style: TextStyle(fontSize: 23.sp, color: Colores.blanco))
                    )
                )
              ],
            ),
          )
      ),
    );
  }
}