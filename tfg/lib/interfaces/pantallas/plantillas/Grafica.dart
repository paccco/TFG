import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    final datos = await widget.fetchContenido(widget.ejercicio);

    final fechas = datos.keys.map((s) => DateTime.parse(s.trim())).toList();

    if(fechas.isNotEmpty){
      final fechaMin = fechas.reduce((a, b) => a.isBefore(b) ? a : b);
      final fechaMax = fechas.reduce((a, b) => a.isBefore(b) ? b : a);

      List<FlSpot> generarSpots(String keyMedida) {
        return datos.entries.map((entry) {
          final x = DateTime.parse(entry.key.trim()).difference(fechaMin).inDays.toDouble();
          final y = entry.value[keyMedida] ?? 0;
          return FlSpot(x, y);
        }).toList();
      }

      final medida = widget.medida;
      final spots = generarSpots(medida);
      spots.sort((a, b) => a.x.compareTo(b.x));

      return LineChart(
        LineChartData(
          minX: 0,
          maxX: fechaMax.difference(fechaMin).inDays.toDouble(),
          minY: 0,
          //Ponemo en el eje Y el maximo valor de la medida mas un 10% para que estéticamente quede mejor la grafica
          maxY: datos.values
              .map((e) => e[medida] ?? 0)
              .reduce((a, b) => a > b ? a : b) * 1.1,
          titlesData: FlTitlesData(
            rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false)
            ),
            topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false)
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                interval: 1,
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final date = fechaMin.add(Duration(days: value.toInt()));
                  if(fechas.contains(date)){
                    final formattedDate = "${date.day}-${date.month}-${date.year}";
                    return SideTitleWidget(
                        meta: meta,
                        child: Text(formattedDate)
                    );
                  } else{
                      return SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
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
        height: 80.w,
        child: FutureBuilder(
            future: _fetchContenido(),
            builder: (builder, snapshot){
              if(snapshot.hasData){
                return Container(
                  margin: EdgeInsets.all(5.h),
                  child: snapshot.data!,
                );
              }else if(snapshot.hasError){
                return Text("Error, ${snapshot.error}");
              }
              return CircularProgressIndicator();
            }
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }
}