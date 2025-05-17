import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraTexto.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloSimple.dart';
import 'package:tfg/funcionesAux.dart';
import '../../ConexionBDLocal.dart';

class RellenaMarca extends StatefulWidget{

  final String ejercicio;
  final String tipo;

  const RellenaMarca({super.key,  required this.ejercicio, required this.tipo});

  @override
  State<RellenaMarca> createState() => _RellenaMarcaState();
}

class _RellenaMarcaState extends State<RellenaMarca>{

  late final TextEditingController repeC, pesoC, distC, tiempoC;
  List<Widget> cajasTexto=[];

  @override
  void initState() {
    super.initState();

    final String tipo=widget.tipo;

    if(tipo[0]=='1'){
      repeC=TextEditingController();
      cajasTexto.add(
        BarraTexto(controller: repeC, textoHint: "REPETICIONES",tipoInput: TextInputType.number)
      );
    }
    if(tipo[1]=='1'){
      tiempoC=TextEditingController();
      cajasTexto.add(
          BarraTexto(controller: tiempoC, textoHint: "TIEMPO",tipoInput: TextInputType.number)
      );
    }
    if(tipo[2]=='1'){
      pesoC=TextEditingController();
      cajasTexto.add(
          BarraTexto(controller: pesoC, textoHint: "PESO",tipoInput: TextInputType.numberWithOptions(decimal: true))
      );
    }
    if(tipo[3]=='1'){
      distC=TextEditingController();
      cajasTexto.add(
          BarraTexto(controller: distC, textoHint: "DISTANCIA", tipoInput: TextInputType.number)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH), 
          child: TituloSimple(titulo: "Marcas")
      ),
      body: Container(
        margin: EdgeInsets.all(2.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 2.h,
          children: cajasTexto,
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          Map<String,dynamic> aux={};

          if(repeC.value.text.isNotEmpty){
            try{
              aux['repeticiones']=int.parse(repeC.value.text);
            }catch(exception){
              mensaje(context, "Repeticiones: Usa un numero positivo sin comas",error: true);
            }
          }
          if(tiempoC.value.text.isNotEmpty){
            final horaVal = tiempoC.value.text;
            if(validarFormatoHora(horaVal)) {
              aux['tiempo'] = horaVal;
            }else{
              aux['tiempo'] = false;
            }
          }
          if(pesoC.value.text.isNotEmpty){
            try{
              aux['peso']=double.parse(pesoC.value.text);
            }catch(exception){
              mensaje(context, "Peso: Usa un numero con punto", error: true);
            }
          }
          if(distC.value.text.isNotEmpty){
            try{
              aux['distancia']=double.parse(distC.value.text);
            }catch(execption){
              mensaje(context, "Distancia: Usa un numero con punto", error: true);
            }
          }

          if(aux.values.contains(false)){
            mensaje(context, "Formato de hora erróneo: hh:mm:ss", error: true);
          } else if(aux.isNotEmpty){
            await BDLocal.instance.modMeta(widget.ejercicio,aux);
            //Cambiar de pantalla
          }else{
            mensaje(context, "Rellena los campos", error: true);
          }
        },
        child: Container(
          padding: EdgeInsets.all(2.h),
          alignment: Alignment.center,
          color: Colores.naranja,
          height: 12.5.h,
          child: Text("Guardar",style: TextStyle(fontSize: 28.sp,color: Colores.blanco),),
        ),
      ),
    );
  }
}