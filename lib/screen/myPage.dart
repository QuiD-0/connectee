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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () async{
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
    );
  }

}
