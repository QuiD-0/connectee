import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screen/group.dart';
import 'screen/home_screen.dart';
import 'screen/write_diary.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: NoGlowScrollBehavior(),
      debugShowCheckedModeBanner: false,
      title: 'Connectee',
      theme: ThemeData(
        fontFamily: "GmarketSans",
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          brightness:Brightness.dark,
            backgroundColor: Colors.black,),
        brightness: Brightness.light,
      ),
      home: WillPopScope(
        child: HomePage(),
        onWillPop: () {},
      ),
    );
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
            icon: Image.asset(
              'assets/icons/add.png',
              width: 20,
            ),
            activeIcon: Image.asset(
              'assets/icons/add_on.png',
              width: 20,
            ),
            label: 'CONNECT',
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
            return CupertinoTabView(builder: (context) {
              return CupertinoPageScaffold(
                child: WriteDiary(),
              );
            });
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
