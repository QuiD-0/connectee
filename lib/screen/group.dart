import 'package:connectee/widget/group/group_search.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key key}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
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
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(builder: (context) {
                  return GroupSearch();
                }));
                //검색창으로 이동
              },
            ),
          ],
        ),
        body: TabBarView(
          physics: AlwaysScrollableScrollPhysics(),
          children: <Widget>[
            SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: false,
              onRefresh: () {
                setState(() {
                  //내그룹리스트 새로 받아오기
                  myGroup.add(1);
                });
                _refreshController.refreshCompleted();
              },
              child: ListView.builder(
                itemBuilder: (c, i) {
                  //그룹이 없을경우
                  if (myGroup.length == 0) {
                    return Container(
                        width: double.infinity,
                        height: 500,
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
                        ));
                  }
                  if (i == myGroup.length) {
                    //마지막+1 인경우
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Container(
                              width: double.infinity,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Color(0xff2d2d2d),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(13),
                                    bottomRight: Radius.circular(13)),
                              )),
                        ),
                        SizedBox(height: 20,)
                      ],
                    );
                  } else {
                    if (i == 0) {
                      //항상 맨위에있는 위젯
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                            child: GestureDetector(
                              onTap: () {
                                print('tab');
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 115,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_box_outlined,
                                      color: Colors.white,
                                    ),
                                    Text(
                                      '새로운 그룹 만들기',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Color(0xff2D2D2D),
                                    borderRadius: BorderRadius.circular(13)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(20),
                                  width: double.infinity,
                                  height: 55,
                                  child: Text(
                                    '나의 그룹 목록',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xff2D2D2D),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(13),
                                        topRight: Radius.circular(13)),
                                  ),
                                ),
                                Column(
                                  children: [
                                    //그룹 내역
                                    Container(
                                      width: double.infinity,
                                      height: 115,
                                      color: Color(0xff3d3d3d),
                                      child: Text(i.toString()),
                                    ),
                                    //디바이더
                                    Container(
                                      width: double.infinity,
                                      height: 20,
                                      color: Color(0xff2d2d2d),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Column(
                          children: [
                            //그룹 내역
                            Container(
                              width: double.infinity,
                              height: 115,
                              color: Color(0xff3d3d3d),
                              child: Text(i.toString()),
                            ),
                            //디바이더
                            Container(
                              width: double.infinity,
                              height: 20,
                              color: Color(0xff2d2d2d),
                            ),
                          ],
                        ),
                      );
                    }
                  }
                },
                itemCount: myGroup.length + 1,
              ),
            ),
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

  _onRefresh() async {
    // monitor network fetch
    return await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
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
