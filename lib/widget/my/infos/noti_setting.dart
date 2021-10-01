import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Notify extends StatefulWidget {
  const Notify({Key key}) : super(key: key);

  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  bool status =true;

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
  }
}

//https://www.python2.net/questions-566513.htm
