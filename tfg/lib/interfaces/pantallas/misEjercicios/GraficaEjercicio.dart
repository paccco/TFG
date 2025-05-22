import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GraficaEjercicio extends StatefulWidget{

  final String ejercicio;

  const GraficaEjercicio({super.key, required this.ejercicio});

  @override
  _GraficaEjercicioState createState() => _GraficaEjercicioState();
}

class _GraficaEjercicioState extends State<GraficaEjercicio>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colores.grisClaro,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(titulo: widget.ejercicio)
      ),
      body: SizedBox(
        height: 40.h,
        child: LineChart(
            duration: Duration(milliseconds: 150),
            curve: Curves.linear,
            LineChartData(

            ),
          ),
      ),
    );
  }
}