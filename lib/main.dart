import 'dart:convert';
import 'package:connectee/screen/myDiary.dart';
import 'package:connectee/screen/myPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screen/group.dart';
import 'screen/home_screen.dart';
import 'screen/write_diary.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() {
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String userId;
  String kakaoId;
  String appleId;

  @override
  void initState() {
    // TODO: implement initState
    _getPrefs().then((res){
      _getToken();
    });
    super.initState();
  }

  // _getId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     userId = prefs.getString('userId');
  //   });
  // }

  // _tokenCheck() async {
  //   //카카오 토큰 리프레시확인하기
  //   if (userId != null) {
  //     final prefs = await SharedPreferences.getInstance();
  //     dynamic token = await AccessTokenStore.instance.fromStore();
  //     User user = await UserApi.instance.me();
  //     var data = {
  //       "password": token.accessToken.toString(),
  //       "username": user.id.toString(),
  //     };
  //     var res = await http
  //         .post(Uri.parse("http://52.79.146.213:5000/auth/login"), body: data);
  //     var result = json.decode(res.body);
  //     if (result["success"] == true) {
  //       var token=JwtDecoder.decode(result['access_token']);
  //       prefs.setString(
  //           'userId',
  //           token['sub'].toString());
  //       prefs.setString(
  //           'access_token',
  //           result['access_token']);
  //       setState(() {
  //         userId = prefs.getString('userId');
  //       });
  //     }
  //   }
  // }

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
              //Oauth page
              : SafeArea(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 500,
                        ),
                        Container(
                          width: 250,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(9),
                              color: Colors.yellow),
                          child: GestureDetector(
                              onTap: () async {
                                try {
                                  final installed =
                                      await isKakaoTalkInstalled();
                                  installed
                                      ? await UserApi.instance
                                          .loginWithKakaoTalk()
                                      : await UserApi.instance
                                          .loginWithKakaoAccount();
                                  dynamic token = await AccessTokenStore
                                      .instance
                                      .fromStore();
                                  if (token.refreshToken == null) {
                                    print('token error');
                                  } else {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    var data = {
                                      "password": token.accessToken.toString(),
                                      "username": "kakao",
                                    };
                                    prefs.setString(
                                        'kakao',
                                        token.accessToken.toString());
                                    var res = await http.post(
                                        Uri.parse(
                                            "http://52.79.146.213:5000/auth/login"),
                                        body: data);
                                    var result = json.decode(res.body);
                                    print(result);
                                    if (result["success"] == true) {
                                      var token=JwtDecoder.decode(result['access_token']);
                                      prefs.setString(
                                          'userId',
                                          token['sub'].toString());
                                      prefs.setString(
                                          'access_token',
                                          result['access_token']);
                                      setState(() {
                                        userId = prefs.getString('userId');
                                      });
                                    }
                                  }
                                  // perform actions after login
                                } catch (e) {
                                  print('error on login: $e');
                                }
                              },
                              child: Center(
                                child: Text(
                                  'Sign in with kakao',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.none),
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Platform.isIOS
                        //     ?
                        Container(
                          width: 250,
                          child: SignInWithAppleButton(
                            onPressed: () async {
                              final credential =
                                  await SignInWithApple.getAppleIDCredential(
                                scopes: [
                                  AppleIDAuthorizationScopes.email,
                                  AppleIDAuthorizationScopes.fullName,
                                ],
                                webAuthenticationOptions:
                                    WebAuthenticationOptions(
                                  clientId: "com.swMaestro.connectee",
                                  redirectUri: Uri.parse(
                                      "https://plausible-tangy-shoulder.glitch.me/callbacks/sign_in_with_apple"),
                                ),
                              );
                              var data = {
                                "password": credential.identityToken.toString(),
                                "username": "apple",
                              };
                              final prefs = await SharedPreferences.getInstance();
                              prefs.setString(
                                  'apple',
                                  credential.identityToken.toString());
                              var res = await http.post(
                                  Uri.parse(
                                      "http://52.79.146.213:5000/auth/login"),
                                  body: data);
                              var result = json.decode(res.body);
                              print(result);
                              if (result["success"] == true) {
                                var token=JwtDecoder.decode(result['access_token']);
                                prefs.setString(
                                    'userId',
                                    token['sub'].toString());
                                prefs.setString(
                                    'access_token',
                                    result['access_token']);
                                setState(() {
                                  userId = prefs.getString('userId');
                                });
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
          onWillPop: () {},
        ));
  }

  void _getToken() async{
    final prefs =
    await SharedPreferences.getInstance();
    var data;
    if (kakaoId!=null){
      data = {
        "password": kakaoId,
        "username": "kakao",
      };
    }else{
      data = {
        "password": appleId,
        "username": "apple",
      };
    }
    var res = await http.post(
        Uri.parse(
            "http://52.79.146.213:5000/auth/login"),
        body: data);
    var result = json.decode(res.body);
    print(data);
    print(result);
    if (result["success"] == true) {
      var token=JwtDecoder.decode(result['access_token']);
      prefs.setString(
          'userId',
          token['sub'].toString());
      prefs.setString(
          'access_token',
          result['access_token']);
      setState(() {
        userId = prefs.getString('userId');
      });
    }

  }

  _getPrefs() async{
    final prefs =
    await SharedPreferences.getInstance();
    kakaoId = prefs.getString('kakao');
    appleId = prefs.getString('apple');
  }


}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        onTap: (index) {
          if (index == 2) {
            Navigator.of(context, rootNavigator: true).push(
              new CupertinoPageRoute(
                builder: (BuildContext context) =>
                    new WriteDiary(),
                fullscreenDialog: true,
              ),
            );
          }
        },
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
              child: Container(
                color: Colors.black,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    Image.asset(
                      'assets/icons/add.png',
                      width: double.infinity,
                      height: 20,
                      fit: BoxFit.fitHeight,
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      'CONNECT',
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              ),
            ),
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
          case 3:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: MyDiary(),
              );
            });
          case 4:
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: MyPage(),
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
