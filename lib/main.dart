import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:connectee/screen/myDiary.dart';
import 'package:connectee/screen/myPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sk_onboarding_screen/sk_onboarding_model.dart';
import 'screen/group.dart';
import 'screen/home_screen.dart';
import 'screen/write_diary.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sk_onboarding_screen/sk_onboarding_screen.dart';
import 'package:lottie/lottie.dart';

bool firstLogin = false;

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
    _getPrefs().then((res) {
      _getToken();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    KakaoContext.clientId = "f90217e80d59b2b247b80059e64a9fa4";
    KakaoContext.javascriptClientId = "39fa8ae2800478812dfc8289b612c7d3";
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
        home: AnimatedSplashScreen(
          //splash: Lottie.asset('assets/77378-sunset.json'),
          splash: 'assets/splash.png',
          splashIconSize: 150,
          backgroundColor: Color(0xff2D2D2D),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.fade,
          nextScreen: CheckLogin(
            id: userId,
          ),
        ));
  }

  _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    var data;
    if (kakaoId != null) {
      data = {
        "password": kakaoId.toString(),
        "username": "kakao",
      };
    } else {
      data = {
        "password": appleId.toString(),
        "username": "apple",
      };
    }
    print(data);
    var res = await http.post(Uri.parse("http://52.79.146.213:5000/auth/login"),
        body: data);
    var result = json.decode(res.body);
    print(result);
    if (result["success"] == true) {
      var token = JwtDecoder.decode(result['access_token']);
      prefs.setString('userId', token['sub'].toString());
      prefs.setString('access_token', result['access_token']);
      setState(() {
        userId = token['sub'].toString();
        if (result["isNewUser"] == true) {
          firstLogin = true;
        }
      });
    } else {
      userId = null;
    }
  }

  _getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    kakaoId = prefs.getString('kakao')??null;
    appleId = prefs.getString('apple')??null;
  }
}

class CheckLogin extends StatefulWidget {
  final id;

  const CheckLogin({Key key, this.id}) : super(key: key);

  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  String userId;

  @override
  void initState() {
    userId = widget.id;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: userId != null
          ? HomePage()
          //Oauth page
          : Container(
              height: MediaQuery.of(context).size.height,
              color: Color(0xff2D2D2D),
              child: Stack(alignment: Alignment.center, children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/splash.png',
                      width: 207,
                    ),
                  ],
                ),
                //카카오 로그인
                Positioned(
                  top: MediaQuery.of(context).size.height / 2 + 150,
                  child: GestureDetector(
                      onTap: () async {
                        try {
                          final installed = await isKakaoTalkInstalled();
                          installed
                              ? await UserApi.instance.loginWithKakaoTalk()
                              : await UserApi.instance.loginWithKakaoAccount();
                          dynamic token =
                              await AccessTokenStore.instance.fromStore();
                          if (token.refreshToken == null) {
                            print('token error');
                          } else {
                            final prefs = await SharedPreferences.getInstance();
                            var data = {
                              "password": token.accessToken.toString(),
                              "username": "kakao",
                            };
                            prefs.setString('kakao', token.accessToken);
                            var res = await http.post(
                                Uri.parse(
                                    "http://52.79.146.213:5000/auth/login"),
                                body: data);
                            var result = json.decode(res.body);
                            print(result);
                            if (result["success"] == true) {
                              var token =
                                  JwtDecoder.decode(result['access_token']);
                              prefs.setString(
                                  'userId', token['sub'].toString());
                              prefs.setString(
                                  'access_token', result['access_token']);
                              setState(() {
                                userId = prefs.getString('userId');
                                if (result["isNewUser"] == true) {
                                  firstLogin = true;
                                }
                              });
                            }
                          }
                          // perform actions after login
                        } catch (e) {
                          print('error on login: $e');
                        }
                      },
                      child: Image.asset(
                        'assets/kakao_login.png',
                        width: 320,
                      )),
                ),
                //애플 로그인
                Positioned(
                  top: MediaQuery.of(context).size.height / 2 + 210,
                  child: GestureDetector(
                    onTap: () async {
                      final credential =
                          await SignInWithApple.getAppleIDCredential(
                        scopes: [
                          AppleIDAuthorizationScopes.email,
                          AppleIDAuthorizationScopes.fullName,
                        ],
                        webAuthenticationOptions: WebAuthenticationOptions(
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
                          'apple', credential.identityToken.toString());
                      var res = await http.post(
                          Uri.parse("http://52.79.146.213:5000/auth/login"),
                          body: data);
                      var result = json.decode(res.body);
                      print(result);
                      if (result["success"] == true) {
                        var token = JwtDecoder.decode(result['access_token']);
                        prefs.setString('userId', token['sub'].toString());
                        prefs.setString('access_token', result['access_token']);
                        setState(() {
                          userId = prefs.getString('userId');
                          if (result["isNewUser"] == true) {
                            firstLogin = true;
                          }
                        });
                      }
                    },
                    child: Image.asset('assets/apple_login.png', width: 320),
                  ),
                )
              ]),
            ),
      onWillPop: () async {
        return false;
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool firstStart = false;
  TextEditingController name = TextEditingController();
  TextEditingController desc = TextEditingController();
  File _image;
  String userId;
  String token;

  final pages = [
    SkOnboardingModel(
        title: 'Choose your item',
        description:
            'Easily find your grocery items and you will get delivery in wide range',
        titleColor: Colors.white,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/splash.png'),
    SkOnboardingModel(
        title: 'Pick Up or Delivery',
        description: 'We make ordering fast',
        titleColor: Colors.white,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/splash.png'),
    SkOnboardingModel(
        title: 'Pay quick and easy',
        description: 'Pay for order using credit or debit card',
        titleColor: Colors.white,
        descripColor: const Color(0xFF929794),
        imagePath: 'assets/splash.png'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    _checkFirst();
    _getId();
    _setAccessType();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      // firstStart
      //   ? SKOnboardingScreen(
      //       bgColor: Color(0xff2d2d2d),
      //       themeColor: const Color(0xFFFF9082),
      //       pages: pages,
      //       skipClicked: (value) {
      //         _changeFirst();
      //       },
      //       getStartedClicked: (value) {
      //         _changeFirst();
      //       },
      //     )
      //   :
    firstLogin
            ? Scaffold(
                appBar: AppBar(
                  title: Text(
                    '프로필 설정',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  centerTitle: true,
                  actions: [
                    GestureDetector(
                      onTap: () {
                        _updateUserInfo();
                        setState(() {
                          firstLogin=false;
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 80,
                        height: 40,
                        child: Text(
                          '완료',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0xff2D2D2D),
                            borderRadius: BorderRadius.circular(13)),
                        child: Column(
                          children: [
                            //그룹 대표 사진
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 20),
                              child: GestureDetector(
                                  onTap: () async {
                                    var status = Platform.isIOS
                                        ? await Permission.photos.request()
                                        : await Permission.storage.request();
                                    if (status.isGranted) {
                                      final ImagePicker _picker = ImagePicker();
                                      XFile image = await _picker.pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      if (image == null) {
                                        setState(() {
                                          _image = null;
                                        });
                                      }

                                      File croppedFile =
                                          await ImageCropper.cropImage(
                                        cropStyle: CropStyle.circle,
                                        sourcePath: File(image.path).path,
                                        aspectRatioPresets: [
                                          CropAspectRatioPreset.square,
                                        ],
                                        androidUiSettings: AndroidUiSettings(
                                            hideBottomControls: true,
                                            activeControlsWidgetColor:
                                                Colors.black,
                                            toolbarTitle: 'Fit Image',
                                            toolbarColor: Colors.black,
                                            toolbarWidgetColor: Colors.white,
                                            initAspectRatio:
                                                CropAspectRatioPreset.square,
                                            lockAspectRatio: true),
                                        iosUiSettings: IOSUiSettings(
                                          minimumAspectRatio: 1.0,
                                        ),
                                      );
                                      setState(() {
                                        _image = croppedFile;
                                      });
                                    } else {
                                      openAppSettings();
                                    }
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Color(0xffFF9082),
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0x32000000),
                                            offset: Offset.zero,
                                            blurRadius: 10,
                                            spreadRadius: 0)
                                      ],
                                    ),
                                    child: _image == null
                                        ? Container()
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: Image.file(
                                              File(_image.path),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  )),
                            ),
                            Text(
                              '프로필 사진 바꾸기',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            //디바이더
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: Color(0xff4D4D4D),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 0, 20, 20),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 35,
                                          child: Text(
                                            '이름',
                                            textAlign: TextAlign.start,
                                            style: textStyle,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 35,
                                              width: 250,
                                              child: TextField(
                                                controller: name,
                                                maxLength: 12,
                                                cursorColor: Colors.white,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                                decoration: InputDecoration(
                                                  counterText: '',
                                                  filled: true,
                                                  fillColor: Color(0xff565656),
                                                  hintText: '이름을 입력해주세요',
                                                  hintStyle: TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0xffD0D0D0)),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          bottom: 13,
                                                          top: 0),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide(width: 0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide(width: 0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Padding(
                                            //   padding:
                                            //       const EdgeInsets.only(top: 10, left: 2),
                                            //   child: Text(
                                            //     '최대 12자까지 입력이 가능합니다',
                                            //     style: descStyle,
                                            //   ),
                                            // ),
                                            SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  //그룹 설명
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 0, 20, 20),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 80,
                                          height: 85,
                                          child: Text(
                                            '한 마디',
                                            textAlign: TextAlign.start,
                                            style: textStyle,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 250,
                                              child: TextField(
                                                controller: desc,
                                                maxLength: 54,
                                                maxLines: 3,
                                                cursorColor: Colors.white,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    height: 1.8),
                                                decoration: InputDecoration(
                                                  counterText: '',
                                                  filled: true,
                                                  fillColor: Color(0xff565656),
                                                  hintText:
                                                      '아직 한 마디가 없어요. 친구들에게 보여줄 한 마디를 작성해주세요!',
                                                  hintStyle: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xffD0D0D0)),
                                                  contentPadding:
                                                      const EdgeInsets.only(
                                                          left: 10.0,
                                                          bottom: 15,
                                                          top: 0),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide(width: 0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide:
                                                        BorderSide(width: 0),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  errorText:
                                                      desc.text.length > 40
                                                          ? '최대 40자까지 입력이 가능합니다'
                                                          : '',
                                                  errorStyle: TextStyle(
                                                      color: Color(0xffFF9082),
                                                      fontSize: 9),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(width: 0),
                                                  ),
                                                  focusedErrorBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        BorderSide(width: 0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            //마지막 빈공간
                            SizedBox(
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : CupertinoTabScaffold(
                tabBar: CupertinoTabBar(
                  onTap: (index) {
                    if (index == 2) {
                      Navigator.of(context, rootNavigator: true).push(
                        new CupertinoPageRoute(
                          builder: (BuildContext context) => new WriteDiary(),
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

  var descStyle = TextStyle(
    color: Colors.white,
    fontSize: 9,
  );
  var textStyle =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  _updateUserInfo() async {
    var request = new http.MultipartRequest(
      "PATCH",
      Uri.parse('http://52.79.146.213:5000/users/update'),
    );
    request.headers['Authorization'] = "Bearer $token";
    request.fields['nickname'] = name.text;
    request.fields['intro'] = desc.text;
    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _image.path));
    }
    request.send();
  }

  _checkFirst() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstStart = prefs.getBool("first") ?? true;
    });
  }

  _changeFirst() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstStart = false;
    });
    prefs.setBool("first", false);
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      token = prefs.getString('access_token');
    });
  }

  void _setAccessType() async{
    final prefs = await SharedPreferences.getInstance();
    var num=Random().nextInt(2);
    if(num==0){
      prefs.setInt("access", 0);
    }else{
      prefs.setInt("access", 1);
    }
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
