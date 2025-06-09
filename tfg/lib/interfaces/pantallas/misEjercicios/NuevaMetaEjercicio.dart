import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../ConexionBDLocal.dart';
import '../../../funcionesAux.dart';

class NuevaMetaEjercicio extends StatefulWidget{

  final String titulo;
  final bool repeticiones, peso, distancia, tiempo;

  const NuevaMetaEjercicio({super.key, required this.titulo, required this.repeticiones, required this.peso, required this.distancia, required this.tiempo});
  
  @override
  _NuevaMetaEjercicioState createState() => _NuevaMetaEjercicioState();
}

class _NuevaMetaEjercicioState extends State<NuevaMetaEjercicio>{

  TextEditingController rpc = TextEditingController(),
                        tc = TextEditingController(),
                        psc = TextEditingController(),
                        dtc = TextEditingController();
  List<Widget> miColumn=List.empty(growable: true);

  Widget _nuevaMetaNum(TextEditingController controller, String label,{bool decimal=false, bool tiempo=false}){
    TextInputType aux;

    if(tiempo){
      aux=TextInputType.datetime;
    }else{
      aux=TextInputType.numberWithOptions(decimal: decimal);
    }

    return TextFormField(
      keyboardType: aux,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colores.azul,
          labelText: label
      ),
      controller: controller,
    );
  }

  Widget _hacerBoton(String texto,void Function() onPres){

    final TextStyle estiloBotones=TextStyle(color: Colores.blanco,fontSize: 21.sp);

    return Container(
        width: 30.w,
        color: Colores.naranja,
        child: TextButton(
            onPressed: onPres,
            child: Text(texto,style: estiloBotones)
        )
    );
  }

  @override
  Widget build(BuildContext context) {

    final estiloTitulos=TextStyle(fontSize: 20.sp, color: Colores.negro);
    miColumn.clear();

    if(widget.repeticiones){
      miColumn.addAll(
        [Text("Repeticiones", style: estiloTitulos),
          _nuevaMetaNum(rpc, "REPETICIONES")]
      );
    }
    if(widget.tiempo){
      miColumn.addAll(
        [
          Text("Tiempo", style: estiloTitulos),
          _nuevaMetaNum(tc, "TIEMPO",tiempo: true)
        ]
      );
    }
    if(widget.peso){
      miColumn.addAll(
          [
            Text("Peso", style: estiloTitulos),
            _nuevaMetaNum(psc, "PESO", decimal: true)
          ]
      );
    }
    if(widget.distancia){
      miColumn.addAll(
          [
            Text("Distancia", style: estiloTitulos),
            _nuevaMetaNum(dtc, "DISTANCIA", decimal: true)
          ]
      );
    }

    miColumn.add(_hacerBoton("Guardar", () async {
      Map<String,dynamic> aux={};
      bool error=false;
      final campos=BDLocal.camposMarca;

      if(widget.repeticiones && rpc.value.text.isNotEmpty){
        try{
          final repeticiones=campos[2];
          aux[repeticiones]=int.parse(rpc.value.text);
        }catch(exception){
          error=true;
          mensaje(context, "Repeticiones: Usa un numero positivo sin comas",error: true);
        }
      }
      if(widget.tiempo && tc.value.text.isNotEmpty){
        final horaVal = tc.value.text;
        if(validarFormatoHora(horaVal)) {
          aux[campos[4]] = horaVal;
        }else{
          aux[campos[4]] = false;
        }
      }
      if(widget.peso && psc.value.text.isNotEmpty){
        try{
          final peso=campos[3];
          aux[peso]=double.parse(psc.value.text.replaceAll(',', '.'));
        }catch(exception){
          error=true;
          print(exception);
          mensaje(context, "Peso: Usa un numero con un decimal", error: true);
        }
      }
      if(widget.distancia && dtc.value.text.isNotEmpty){
        try{
          final distancia=campos[5];
          aux[distancia]=double.parse(dtc.value.text.replaceAll(',', '.'));
          print(distancia);
        }catch(execption){
          error=true;
          mensaje(context, "Distancia: Usa un numero con un decimal", error: true);
        }
      }

      if(aux.values.contains(false)){
        mensaje(context, "Formato de hora erróneo: mm:ss", error: true);
      }else if(aux.isNotEmpty && !error){
        await BDLocal.instance.modMeta(widget.titulo,aux);
        Navigator.pop(context);
        Navigator.pop(context);
      }else{
        print(aux);
        mensaje(context, "Rellena los campos", error: true);
      }
    }));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH), 
          child: TituloConSalida(titulo: "Nueva meta")
      ),
      body: Container(
        margin: EdgeInsets.all(2.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 2.h,
          children: miColumn,
        ),
      ),
    );
  }
}