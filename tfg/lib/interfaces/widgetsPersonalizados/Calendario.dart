import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tfg/constantes.dart';

class Calendario extends StatefulWidget{

  final ValueChanged<DateTime> onValueChanged;
  const Calendario({super.key, required this.onValueChanged});

  @override
  _calendarioState createState() => _calendarioState();
}

class _calendarioState extends State<Calendario>{

  DateTime _focusedDay=DateTime.now();
  DateTime? _selectedDay=DateTime.now();

  Future<Widget> _calendario(context) async{
    final DateTime hoy=DateTime.now();
    final String aux = await storage.read(key: 'fechaCreacion') ??'';
    final DateTime primerDia = DateTime.parse(aux);
    final DateTime ultimoDia = hoy.add(Duration(days: 31));

    return TableCalendar(
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
           widget.onValueChanged(_selectedDay ?? DateTime.now());
         });
        }
      },
      calendarFormat: CalendarFormat.twoWeeks,
      locale: 'es_ES',
        focusedDay: _focusedDay,
        firstDay: primerDia,
        lastDay: ultimoDia
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