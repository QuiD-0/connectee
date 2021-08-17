import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key key}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  String userId;
  List myGroup = [];

  @override
  void initState() {
    // TODO: implement initState
    _getId().then((res) {
      //내그룹 받아오기
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '그룹',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          //탭바
          bottom: DecoratedTabBar(
            tabBar: TabBar(
              indicatorColor: Colors.white,
              labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: "GmarketSans"),
              tabs: <Widget>[
                Tab(
                  text: '나의 그룹',
                ),
                Tab(
                  text: '추천 그룹',
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xff3D3D3D),
                  width: 1.5,
                ),
              ),
            ),
          ),
          //그룹 여부에 따라 없어지기
          leading: myGroup.isEmpty
              ? IconButton(
                  icon: new Icon(
                    Icons.add_box_outlined,
                    size: 22,
                  ),
                  // 내 리액션 뒤로 넘기기
                  onPressed: () async {
                    print("tabbed");
                    //그룹 생성 후 사라짐
                    //그룹 생성 버튼
                  },
                )
              : null,
          actions: [
            IconButton(
              icon: new Icon(
                Icons.search,
                size: 22,
              ),
              onPressed: () {
                print("search");
                //검색창으로 이동
              },
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            myGroup.isEmpty
                ? Container(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100)),
                          ),
                          Image.asset('assets/emotions/sad_big.png'),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '추가된 그룹이 없어요\n 그룹을 찾아볼까요?',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            height: 1.5),
                      ),
                    ],
                  ))
                : SingleChildScrollView(),
            Center(
              child: Text(
                "recommand group",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }
}

class DecoratedTabBar extends StatelessWidget implements PreferredSizeWidget {
  DecoratedTabBar({@required this.tabBar, @required this.decoration});

  final TabBar tabBar;
  final BoxDecoration decoration;

  @override
  Size get preferredSize => tabBar.preferredSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Container(decoration: decoration)),
        tabBar,
      ],
    );
  }
}
