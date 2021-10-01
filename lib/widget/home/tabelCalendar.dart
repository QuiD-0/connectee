import 'dart:convert';
import 'package:connectee/model/calendarEvent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'CalDetail/cal_detail.dart';


class Calendar extends StatefulWidget {
  const Calendar({Key key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();

}

class _CalendarState extends State<Calendar> {
  Map<DateTime, List<Event>> selectedEvents = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay;
  DateTime focusedDay = DateTime.now();
  List<String> dowList = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];
  TextEditingController _eventController = TextEditingController();
  String userId;

  @override
  void initState() {
    if (DateTime.now().day == 1) {
      selectedDay = DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);
    } else {
      selectedDay = DateTime.utc(
          DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
    }
    _getId().then((res) {
      fetchEvent();
    });
    super.initState();
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
            onDaySelected: (DateTime selectDay, DateTime focusDay) async {
              //fetchEvent();
              if (selectedEvents[selectDay] != null) {
                var res = await Navigator.of(context).push(
                  new CupertinoPageRoute(
                    builder: (BuildContext context) => CalDetail(
                        date: selectDay,
                        emotion: selectedEvents[selectDay][0].emotionType,
                        id: selectedEvents[selectDay][0].id),
                    fullscreenDialog: true,
                  ),
                );
                //db 업데이트
                patchMainEmotion(res);
                //메인감정 업데이트
                DateTime now = DateTime.now();
                DateTime date = DateTime.utc(now.year, now.month, now.day);
                if(selectDay==date){
                  if (res[3]!=selectedEvents[selectDay][0].emotionType){
                    _changeMainEmotion(res);
                  }
                }
                //스테이트 변경
                setState(() {
                  Event a =
                      Event.formMap({"mainEmotionType": res[1], "id": res[2]});
                  selectedEvents[DateTime.utc(
                      res[0].year, res[0].month, res[0].day)] = [a];
                });
              }
              DateTime day = DateTime.now();
              if (DateTime.utc(day.year, day.month, day.day) != selectDay) {
                setState(() {
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                });
              }
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, date, event) {
                // 컬러 리스트 만든뒤 리팩토링 스위치문 사용
                var color;
                switch (event.emotionType) {
                  case "happy":
                    color = Color(0xffFFD275);
                    break;
                  case "angry":
                    color = Color(0xffFF9082);
                    break;
                  case "surprised":
                    color = Color(0xffFD7F8B);
                    break;
                  case "sad":
                    color = Color(0xff7DDEF6);
                    break;
                  case "disgusted":
                    color = Color(0xff79D3BA);
                    break;
                  case "terrified":
                    color = Color(0xffAE81A2);
                    break;
                  case "neutral":
                    color = Color(0xffAAB2BD);
                    break;
                }
                return Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: color,
                  ),
                );
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
                // color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(30.0),
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
              leftChevronMargin: EdgeInsets.only(left: 10, right: 5),
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
        ],
      ),
    );
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  Future fetchEvent() async {
    //데이터 받아오기
    await http
        .get(Uri.parse("http://52.79.146.213:5000/daily-infos/findAll/$userId"))
        .then((res) {
      if (res.statusCode == 200) {
        String jsonString = res.body;
        List data = jsonDecode(jsonString);
        for (var i = 0; i < data.length; i++) {
          Event a = Event.formMap(data[i]);
          DateTime day = DateTime.parse(data[i]["date"]);
          setState(() {
            selectedEvents[DateTime.utc(day.year, day.month, day.day)] = [a];
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

  void patchMainEmotion(res) async {
    var body = {
      "date": "${res[0].toString().split(' ')[0]}",
      "mainEmotionType": "${res[1]}",
      "userId": userId
    };
    await http
        .patch(Uri.parse('http://52.79.146.213:5000/daily-infos/$userId'),
            body: body).then((res){
    });
  }

  void _changeMainEmotion(res) async{
    String day = DateTime.now().year.toString() +
        '-' +
        DateTime.now().month.toString() +
        '-' +
        DateTime.now().day.toString();
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(day,"${res[1]},${res[3]}");
    print(prefs.getString(day));
  }
}
