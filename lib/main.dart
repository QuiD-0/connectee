import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screen/group.dart';
import 'screen/home_screen.dart';
import 'screen/write_diary.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int userId;

  @override
  void initState() {
    // TODO: implement initState
    // _getId();
    userId = null;
    super.initState();
  }

  _getId() async {
    //토큰 리프레시확인하기
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userId');
    });
  }

  @override
  Widget build(BuildContext context) {
    KakaoContext.clientId = "f90217e80d59b2b247b80059e64a9fa4";
    KakaoContext.javascriptClientId = "39fa8ae2800478812dfc8289b612c7d3";

    return MaterialApp(
        scrollBehavior: NoGlowScrollBehavior(),
        debugShowCheckedModeBanner: false,
        title: 'Connectee',
        theme: ThemeData(
          fontFamily: "GmarketSans",
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            brightness: Brightness.dark,
            backgroundColor: Colors.black,
          ),
          brightness: Brightness.light,
        ),
        home: WillPopScope(
          // 개발완료후 수정
          child: userId != null
              ? HomePage()
              : SafeArea(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 500,
                        ),
                        FlatButton(
                          child: Text('kakao auth',
                              style: TextStyle(fontSize: 16)),
                          onPressed: () async {
                            try {
                              final installed = await isKakaoTalkInstalled();
                              installed
                                  ? await UserApi.instance.loginWithKakaoTalk()
                                  : await UserApi.instance
                                      .loginWithKakaoAccount();
                              dynamic token =
                                  await AccessTokenStore.instance.fromStore();
                              if (token.refreshToken == null) {
                                print('token error');
                              } else {
                                User user = await UserApi.instance.me();
                                //서버로 토큰 전송하기 성공시 로그인 -- 추가하기
                                final prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setInt('userId', user.id);
                                var data = {
                                  "password": token.accessToken.toString(),
                                  "username": user.id.toString(),
                                };
                                var res = await http.post(
                                    Uri.parse(
                                        "http://52.79.146.213:5000/users/login"),
                                    body: data);
                                print(res.body);
                                print(data);
                                setState(() {
                                  //_getId();
                                  userId = user.id;
                                });
                              }
                              // perform actions after login
                            } catch (e) {
                              print('error on login: $e');
                            }
                          },
                          color: Colors.green,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
          onWillPop: () {},
        ));
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        border: Border.all(width: 55),
        activeColor: Colors.white,
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/home.png',
              width: 20,
            ),
            activeIcon: Image.asset(
              'assets/icons/home_on.png',
              width: 20,
            ),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/group.png',
              width: 20,
            ),
            activeIcon: Image.asset(
              'assets/icons/group_on.png',
              width: 20,
            ),
            label: 'GROUP',
          ),
          BottomNavigationBarItem(
            icon: GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        new WriteDiary(groupName: null),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Image.asset(
                'assets/icons/add.png',
                width: 100,
                height: 20,
                fit: BoxFit.fitHeight,
              ),
            ),
            title: GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).push(
                    new CupertinoPageRoute(
                      builder: (BuildContext context) =>
                          new WriteDiary(groupName: null),
                      fullscreenDialog: true,
                    ),
                  );
                },
                child: Text('CONNECT')),
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/diary.png',
              width: 20,
            ),
            activeIcon: Image.asset(
              'assets/icons/diary_on.png',
              width: 20,
            ),
            label: 'DIARY',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/icons/my.png',
              width: 20,
            ),
            activeIcon: Image.asset(
              'assets/icons/my_on.png',
              width: 20,
            ),
            label: 'MY',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomeScreen(),
              );
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: GroupScreen(),
              );
            });
          case 2:
            return Container();
          case 3:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Container(),
              );
            });
          case 4:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: Container(),
              );
            });
          default:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: HomeScreen(),
              );
            });
        }
      },
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
