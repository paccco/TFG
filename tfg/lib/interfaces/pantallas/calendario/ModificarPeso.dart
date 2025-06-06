import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/funcionesAux.dart';
import 'package:tfg/interfaces/pantallas/plantillas/PantallasEntrenamiento.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/BarraTexto.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../ConexionBDLocal.dart';

class ModificarPeso extends StatefulWidget{

  final DateTime fecha;

  const ModificarPeso({super.key, required this.fecha});

  @override
  State<ModificarPeso> createState() => _ModificarPesoState();
}

class _ModificarPesoState extends State<ModificarPeso>{

  final TextEditingController _pesoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: "Modificar peso")
      ),
      body: Container(
        margin: EdgeInsets.all(2.h),
        alignment: Alignment.center,
        child: Column(
          spacing: 2.h,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BarraTexto(controller: _pesoController, tipoInput: TextInputType.numberWithOptions(decimal: true)),
            InkWell(
              onTap: () async{
                final pesoStr = _pesoController.value.text;

                if(regexPeso.hasMatch(pesoStr)){
                  await BDLocal.instance.insertPesaje(widget.fecha, pesoStr);
                  final peso = gestorDeComas(pesoStr);

                  final pesoObj=await BDLocal.instance.getPesoObjetivo();
                  if(pesoObj!=0){
                    String felicitacion="";
                    if(pesoObj>0){
                      //Cuando el peso objetivo es mayor que cero, el usuario quiere subir peso
                      if(pesoObj.abs()<=peso){
                        await BDLocal.instance.insertMetaPeso('0',0);
                        felicitacion="Tu meta era de subir a ${pesoObj.abs()/100}kg";
                      }
                    } else{
                      //Sino quiere bajar de peso
                      if(pesoObj.abs()>=peso){
                        await BDLocal.instance.insertMetaPeso('0',0);
                        felicitacion="Tu meta era de bajar a ${pesoObj.abs()/100}kg";
                      }
                    }

                    if(felicitacion.isNotEmpty){
                      await Navigator.push(context, MaterialPageRoute(builder: (builder)=>PantallasEntrenamiento(
                          titulo: "",
                          hijos: [
                            Text("¡Enhorabuena!", style: TextStyle(fontSize: 30.sp)),
                            Text("Has cumplido tu meta de peso", style: TextStyle(fontSize: 20.sp)),
                            Text(felicitacion, style: TextStyle(fontSize: 20.sp)),
                            Icon(Icons.check_circle, size: 50.sp, color: Colores.verde)
                          ],
                        boton: true,
                        textoBoton: "Salir",
                      )));
                    }
                  }

                  mensaje(context, "Peso guardado");

                  //Comprobar si ha cumplido meta de peso

                  Navigator.pop(context);
                }else{
                  mensaje(context, "Numero positivo con un decimal máximo", error: true);
                }
              },
              child: Container(
                padding: EdgeInsets.all(2.h),
                alignment: Alignment.center,
                height: 10.h,
                color: Colores.naranja,
                child: Text("Guardar", style: TextStyle(fontSize: 20.sp, color: Colores.blanco)),
              ),
            )
          ],
        ),
      ),
    );
  }
}