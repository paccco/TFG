import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tfg/ConexionBDLocal.dart';
import 'package:tfg/constantes.dart';
import 'package:tfg/funcionesAux.dart';

class Calendario extends StatefulWidget{

  final ValueChanged<List<dynamic>> onValueChanged;
  const Calendario({super.key, required this.onValueChanged});

  @override
  _calendarioState createState() => _calendarioState();
}

class _calendarioState extends State<Calendario>{

  final DateTime _hoy=DateTime.now();
  Map<String,List<String>> _eventos={};
  DateTime _focusedDay=DateTime.now();
  DateTime? _selectedDay=DateTime.now();
  late DateTime _primerDia;
  late DateTime _ultimoDia;
  Map<String,String> _entrenamientos={};

  Future<void> _actualizarEntrenamientos() async{
    _entrenamientos=await BDLocal.instance.getEntrenamientos(_primerDia, _ultimoDia);
  }

  Future<Widget> _calendario(context) async{
    _eventos.clear();
    final String aux = await storage.read(key: 'fechaCreacion') ??'';
    _primerDia = DateTime.parse(aux);
    _ultimoDia=_hoy.add(Duration(days: 31));
    _actualizarEntrenamientos();

    _entrenamientos.forEach((key,value){
      _eventos[key]=[value];
    });

    return TableCalendar(
      onPageChanged: (primeraFecha){
        _focusedDay=primeraFecha;
        final DateTime ultimaFecha=primeraFecha.add(Duration(days: 14));
        _primerDia=primeraFecha;
        _ultimoDia=ultimaFecha;
        _actualizarEntrenamientos();
      },
      eventLoader: (dia){
        return _eventos[stringDate(dia)] ?? [];
      },
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: CalendarStyle(

      ),
      calendarBuilders: CalendarBuilders(

      ),
      selectedDayPredicate: (day){
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay,focusedDay){
        if(selectedDay!=_selectedDay){
         setState(() {
           _selectedDay=selectedDay;
           widget.onValueChanged([_selectedDay ?? DateTime.now(), _entrenamientos[stringDate(_selectedDay ?? _hoy)] ?? '']);
         });
        }
      },
      calendarFormat: CalendarFormat.twoWeeks,
      locale: 'es_ES',
        focusedDay: _focusedDay,
        firstDay: _primerDia,
        lastDay: _ultimoDia
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _calendario(context),
        builder: (context, snapshot){
          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }else if(snapshot.hasError){
            return Text("ERROR");
          }else{
            return snapshot.data!;
          }
        }
    );
  }
}