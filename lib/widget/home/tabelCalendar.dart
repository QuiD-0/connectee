import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/foundation.dart';

/*
//-> json 받아오기
 List<Map<String,dynamic>> data =[
    {"date":"2021-07-05 00:00:00.000Z","data":{"title":'asd', "id":1, "display":1}},
    {"date":"2021-07-02 00:00:00.000Z","data":{"title":'qwe', "id":2, "display":1}},
    {"date":"2021-06-28 00:00:00.000Z","data":{"title":'zxc', "id":1, "display":1}},
  ];

        */

class Event {
  final String title;
  final int id;
  final int display;

  Event({@required this.title, this.id, this.display});

  String toString() => this.title;

  Event.formMap(Map<String, dynamic> map)
      : title = map['title'],
        id = map['id'],
        display = map['display'];
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

  get http => null;

  @override
  void initState() {
    selectedEvents = {
      DateTime.utc(2021, 7, 5): [
        Event(title: 'asdasd', id: 1, display: 1),
        Event(title: 'dasd', id: 2, display: 0)
      ],
      DateTime.utc(2021, 7, 2): [Event(title: 'asd', id: 2, display: 1)],
      DateTime.utc(2021, 6, 28): [Event(title: 'asd', id: 1, display: 1)],
      DateTime.utc(2021, 6, 22): [Event(title: 'asd', id: 1, display: 1)],
    };
    super.initState();
  }

  // Future _fetchEvent() async {
  //   //데이터 받아오기
  //   await http
  //       .get(Uri.parse("http://18.216.47.35:3000/?page=1&limit=2"))
  //       .then((res) {
  //     if (res.statusCode == 200) {
  //       String jsonString = res.body;
  //       List data = jsonDecode(jsonString);
  //       for (var i = 0; i < data.length; i++) {
  //         Event a = Event.formMap(data[i]["data"]);
  //         selectedEvents[DateTime.parse(data[i]["date"])] = [a];
  //       }
  //     }
  //   });
  // }

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
                if (event.id == 1) {
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
                      fontSize: 12,
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
              leftChevronMargin: EdgeInsets.only(left: 10),
              leftChevronPadding: EdgeInsets.all(0),
              rightChevronPadding: EdgeInsets.only(right: 0),
              rightChevronIcon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 24,
              ),
              rightChevronVisible: true,
              formatButtonVisible: false,
              titleCentered: false,
              formatButtonShowsNext: false,
              headerMargin: EdgeInsets.fromLTRB(14, 14, 14, 0),
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
