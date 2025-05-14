import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import '../../widgetsPersonalizados/TituloConSalida.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OpcionesDia extends StatefulWidget{

  final Widget hijosSuperior, hijosInferior;
  final DateTime fechaTitulo;

  const OpcionesDia({super.key, required this.hijosSuperior, required this.hijosInferior, required this.fechaTitulo});

  @override
  _OpcionesDiaState createState() => _OpcionesDiaState();
}

class _OpcionesDiaState extends State<OpcionesDia>{

  final alturaCaja=35.h;

  late String diaActual;

  @override
  void initState() {
    super.initState();

    final aux=widget.fechaTitulo;
    final mes=meses[aux.month-1];

    diaActual="${aux.day} de $mes del ${aux.year}";
  }

  Widget _hacerCaja(Widget hijo){
    return SizedBox(
      height: alturaCaja,
      child: hijo,
    );   
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: diaActual)
      ),
      body: Container(
        height: 80.h,
        margin: EdgeInsets.all(2.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 2.h,
          children: [
            _hacerCaja(widget.hijosSuperior),
            _hacerCaja(widget.hijosInferior)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colores.azul,
        height: 10.h,
        alignment: Alignment.center,
        child: TextButton(onPressed: (){}, child: Text("Datos",style: TextStyle(fontSize: 25.sp, color: Colores.blanco))),
      )
    );
  }
}