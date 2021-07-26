import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screen/group.dart';
import 'screen/home_screen.dart';
import 'screen/write_diary.dart';
import 'package:kakao_flutter_sdk/all.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

//shared prefferrnce에 저장후 처음 실행시 불러오기 -> 로그아웃하면 지우기
  int userId;

  @override
  void initState() {
    // TODO: implement initState
    userId=null;
    super.initState();
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
          child:userId != null?HomePage():SafeArea(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 500,
                        ),
                        FlatButton(
                          child: Text('kakao auth $userId',
                              style: TextStyle(fontSize: 16)),
                          onPressed: () async {
                            try {
                              final installed = await isKakaoTalkInstalled();
                              installed
                                  ? await UserApi.instance.loginWithKakaoTalk()
                                  : await UserApi.instance
                                      .loginWithKakaoAccount();
                              // perform actions after login
                            } catch (e) {
                              print('error on login: $e');
                            }
                            User user = await UserApi.instance.me();
                            print(user);
                            setState(() {
                              userId=user.id;
                            });
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
