import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;


class Event {
  final String emotionType;

  Event({@required this.emotionType});



  Event.formMap(String map)
      : emotionType = map;
}

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<DateTime, List<Event>> selectedEvents = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  List<String> dowList = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    _fetchEvent();
    super.initState();
  }

  Future _fetchEvent() async {
    //데이터 받아오기
    await http
        .get(Uri.parse("http://3.34.131.217:5000/diaries?userId=1"))
        .then((res) {
      if (res.statusCode == 200) {
        String jsonString = res.body;
        List data = jsonDecode(jsonString);
        for (var i = 0; i < data.length; i++) {
          Event a = Event.formMap(data[i]["emotionType"]);
          DateTime day=DateTime.parse(data[i]["createdAt"]);
          setState(() {
            selectedEvents[DateTime.utc(day.year,day.month,day.day)] = [a];
          });
        }
      }

    });
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13.0),
        color: Color(0xff2D2D2D),
      ),
      child: Column(
        children: [
          TableCalendar(
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            calendarFormat: format,
            onFormatChanged: (CalendarFormat _format) {
              setState(() {
                format = _format;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.sunday,
            daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, date, event) {
                // 컬러 리스트 만든뒤 리팩토링
                if (event.emotionType == "happy" ||event.emotionType == "angry"  ) {
                  return Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.lightBlueAccent,
                    ),
                  );
                } else {
                  return Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.redAccent,
                    ),
                  );
                }
              },
              dowBuilder: (context, date) {
                return Center(
                  child: Text(
                    dowList[date.weekday - 1].toString(),
                    style: TextStyle(
                      color: Color(0xffABABAB),
                      fontSize: 11,
                    ),
                  ),
                );
              },
            ),

            eventLoader: _getEventsfromDay,

            //To style the Calendar
            calendarStyle: CalendarStyle(
              outsideDaysVisible: true,
              outsideTextStyle: TextStyle(
                  color: Color(0xaaABABAB),
                  fontSize: 18,
                  fontWeight: FontWeight.normal),
              outsideDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              markersAlignment: Alignment(0.5, 0),
              markersAnchor: 4.2,
              canMarkersOverflow: true,
              isTodayHighlighted: true,
              markersMaxCount: 1,
              selectedDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              selectedTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.normal),
              todayTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.normal),
              todayDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              defaultDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
              holidayTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.normal),
              weekendTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.normal),
              defaultTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.normal),
              weekendDecoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            headerStyle: HeaderStyle(
              leftChevronIcon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 24,
              ),
              leftChevronVisible: true,
              leftChevronMargin: EdgeInsets.only(left: 10,right: 5),
              leftChevronPadding: EdgeInsets.all(0),
              rightChevronPadding: EdgeInsets.only(right: 3),
              rightChevronIcon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 24,
              ),
              rightChevronVisible: true,
              formatButtonVisible: false,
              titleCentered: false,
              formatButtonShowsNext: false,
              headerMargin: EdgeInsets.fromLTRB(14, 14, 0, 0),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            daysOfWeekHeight: 38,
          ),
          /*
          ..._getEventsfromDay(selectedDay).map(
            (Event event) => ListTile(
              title: Text(
                event.title,
              ),
            ),
          ),
          */
        ],
      ),
    );
  }
}
