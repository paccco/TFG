import 'package:flutter/material.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/interfaces/widgetsPersonalizados/TituloConSalida.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Grafica extends StatefulWidget{

  final String ejercicio;
  final String medida;
  final Future<Map<String,Map<String,dynamic>>> Function(String) fetchContenido;

  const Grafica({super.key, required this.ejercicio, required this.fetchContenido, required this.medida});

  @override
  _GraficaState createState() => _GraficaState();
}

class _GraficaState extends State<Grafica>{

  Future<Widget> _fetchContenido() async{
    final datos = await widget.fetchContenido(widget.ejercicio);

    final fechas = datos.keys.map((s) => DateTime.parse(s.trim())).toList();

    if(fechas.isNotEmpty){
      final fechaMin = fechas.reduce((a, b) => a.isBefore(b) ? a : b);


      List<FlSpot> generarSpots(String keyMedida) {
        return datos.entries.map((entry) {
          final fecha = DateTime.parse(entry.key);
          final x = fecha.difference(fechaMin).inDays.toDouble();
          final y = entry.value[keyMedida] ?? 0;
          return FlSpot(x, y);
        }).toList();
      }

      final medida = widget.medida;

      return LineChart(
        LineChartData(
          minX: 0,
          maxX: datos.length.toDouble(),
          minY: 0,
          maxY: datos.values
              .map((e) => e[medida] ?? 0)
              .reduce((a, b) => a > b ? a : b) * 1.1,
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: generarSpots(medida),
              isCurved: true,
              barWidth: 3,
              dotData: FlDotData(show: true),
              color: Colors.blue,
            )
          ],
        ),
      );
    }else{
      return Center(
        child: Text("No hay datos para mostrar",style: TextStyle(fontSize: 30.sp, color: Colores.negro),),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Tamanios.appBarH),
          child: TituloConSalida(
            titulo: "",
          )
      ),
      body: SizedBox(
        height: 40.h,
        child: FutureBuilder(
            future: _fetchContenido(),
            builder: (builder, snapshot){
              if(snapshot.hasData){
                return snapshot.data!;
              }else if(snapshot.hasError){
                return Text("Error, ${snapshot.error}");
              }
              return CircularProgressIndicator();
            }
        ),
      ),
    );
  }
}