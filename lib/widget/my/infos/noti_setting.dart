import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Notify extends StatefulWidget {
  const Notify({Key key}) : super(key: key);

  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  bool status =false;

  @override
  void initState() {
    // TODO: implement initState
    _getNotiVal();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '알림 기능',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
              color: Color(0xff2d2d2d),
              borderRadius: BorderRadius.circular(13)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 20, 20, 10),
                child: Text(
                  '알림 기능',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 10, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '감정표현을 받았을 때 알림을 드려요!',
                      style: TextStyle(fontSize: 12, color: Color(0xffD0D0D0)),
                    ),
                    FlutterSwitch(
                      activeColor: Color(0xffff9082),
                      width: 51.0,
                      height: 31.0,
                      valueFontSize: 0.0,
                      toggleSize: 30.0,
                      value: status,
                      borderRadius: 30.0,
                      padding: 1.0,
                      showOnOff: true,
                      onToggle: (val) {
                        setState(() {
                          status = val;
                        });
                        _setNotiVal(val);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getNotiVal() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      status = prefs.getBool('status')??false;
    });
  }

  _setNotiVal(bool val) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('status', val);
    if(val==true){
      _dailyAtTimeNotification();
    }
    else{
      await FlutterLocalNotificationsPlugin().cancel(0);
      print("cancel");
    }
  }
  Future _dailyAtTimeNotification() async {
    final notiTitle = 'title';
    final notiDesc = 'description';

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final result = await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    var android = AndroidNotificationDetails(
        '0', 'connectee',
        channelDescription: '오늘의 감정을 기록해 보세요!');
    var ios = IOSNotificationDetails();
    var detail = NotificationDetails(android: android, iOS: ios);

    if (true) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.deleteNotificationChannelGroup('0');

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // id는 unique해야합니다. int값
        notiTitle,
        notiDesc,
        _setNotiTime(),
        detail,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  tz.TZDateTime _setNotiTime() {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        21, 00);
    print(scheduledDate);
    return scheduledDate;
  }
}

//https://www.python2.net/questions-566513.htm
