import 'dart:convert';
import 'package:connectee/widget/my_diary/othersDiary.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String userId;
  String token;

  @override
  void initState() {
    // TODO: implement initState
    _getId();
    super.initState();
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      token = prefs.getString('access_token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.clear();
            await AccessTokenStore.instance.clear();
            Phoenix.rebirth(context);
          },
          child: Center(
            child: Container(
              width: 100,
              height: 40,
              child: Center(child: Text('로그아웃')),
              color: Colors.redAccent,
            ),
          ),
        ),
        SizedBox(height:20),
        GestureDetector(
          onTap: () async {
            await http.get(Uri.parse('http://52.79.146.213:5000/users/getOne/1'),
                headers: {"Authorization": "Bearer $token"}).then((value) {
                  print(value.body);
              if (value.statusCode == 200) {
                String jsonString = value.body;
                var result = json.decode(jsonString);
                print(result);
              }
            });
          },
          child: Center(
            child: Container(
              width: 100,
              height: 40,
              child: Center(child: Text('테스트 버튼')),
              color: Colors.redAccent,
            ),
          ),
        ),
        SizedBox(height: 20,),
        GestureDetector(
          onTap: ()  {
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return OtherDiary(userId: 2,);
            }));
          },
          child: Center(
            child: Container(
              width: 100,
              height: 40,
              child: Center(child: Text('다른사람 다이어리 보기')),
              color: Colors.redAccent,
            ),
          ),
        ),
      ],
    ));
  }
}
