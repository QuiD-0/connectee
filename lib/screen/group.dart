import 'dart:convert';
import 'package:connectee/model/groupModel.dart';
import 'package:http/http.dart' as http;
import 'package:connectee/widget/group/group_detail.dart';
import 'package:connectee/widget/group/group_search.dart';
import 'package:connectee/widget/group/makeGroup.dart';
import 'package:connectee/widget/group/recommand_group.dart';
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
  String token;
  List likedGroup = [];
  List myGroup = [];

  @override
  void initState() {
    // TODO: implement initState
    _getId().then((res) {
      //내그룹, 좋아요한 그룹 받아오기
      _getLikeGroup().then((res){
        _fetchMyGroup();
      });
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
                  onPressed: () async {
                    Navigator.of(context,rootNavigator: true)
                        .push(MaterialPageRoute(builder: (context) {
                      return MakeGroup();
                    }));
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
                Navigator.of(context)
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
              header: MaterialClassicHeader(
                color: Colors.white,
                backgroundColor: Color(0xff3d3d3d),
              ),
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: false,
              onRefresh: () {
                setState(() {
                  //내그룹리스트 새로 받아오기
                  _fetchMyGroup();
                });
                _refreshController.refreshCompleted();
              },
              child: myGroup.length == 0
                  ? ListView(
                      children: [
                        Container(
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
                                          borderRadius:
                                              BorderRadius.circular(100)),
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
                      ],
                    )
                  : ListView(
                      children: [
                        //상단
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 30, 10, 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context,rootNavigator: true).push(
                                      MaterialPageRoute(builder: (context) {
                                    return MakeGroup();
                                  }));
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
                                      SizedBox(
                                        height: 5,
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
                                ],
                              ),
                            )
                          ],
                        ),
                        //카드
                        for (var group in myGroup)
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Column(
                              children: [
                                //그룹 내역
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return GroupDetail(group: group);
                                    }));
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 115,
                                    color: Color(0xff3d3d3d),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //그룹 이미지
                                        group.imageUrl != null
                                            ? Container(
                                                width: 120,
                                                child: Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Image.network(
                                                      group.imageUrl,
                                                      height: 80,
                                                      width: 80,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: 120,
                                                child: Center(
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: Container(
                                                      height: 80,
                                                      width: 80,
                                                      color: Color(0xffFF9082),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                        //그룹 정보
                                        Container(
                                          width: 230,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              //그룹이름
                                              Container(
                                                width: 200,
                                                child: Text(
                                                  group.title,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 11,
                                              ),
                                              //그룹 정보
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/user.png',
                                                    height: 14,
                                                    width: 12,
                                                    fit: BoxFit.contain,
                                                  ),
                                                  Text(
                                                    '  (${group.groupUserCount}/${group.limitMembers})  |  ',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14),
                                                  ),
                                                  Text(
                                                    group.private
                                                        ? '비공개'
                                                        : '공개',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 12,
                                              ),
                                              //그룹 토픽
                                              Container(
                                                width: double.infinity,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          for (var i
                                                          in group.topic)
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10),
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .fromLTRB(
                                                                    11, 3, 11, 3),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                    Colors.white,
                                                                    borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                        30)),
                                                                child: Text(
                                                                  "#$i",
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                                ),
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                    ),
                                                    // 좋아요
                                                    GestureDetector(
                                                      onTap: () {
                                                        _like(group.groupId);
                                                      },
                                                      child:Padding(
                                                        padding: EdgeInsets.only(right: 10),
                                                        child: likedGroup.contains(
                                                            group.groupId)
                                                            ? Image.asset(
                                                          'assets/icons/heart_fill.png',
                                                          height: 18,
                                                          width: 20,
                                                          fit: BoxFit.contain,
                                                        )
                                                            : Image.asset(
                                                          'assets/icons/heart.png',
                                                          height: 18,
                                                          width: 20,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      )
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //디바이더
                                Container(
                                  width: double.infinity,
                                  height: 20,
                                  color: Color(0xff2d2d2d),
                                ),
                              ],
                            ),
                          ),
                        //하단
                        Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
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
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ],
                    ),
            ),
            //추천그룹 탭
            RecommandGroup(),
          ],
        ),
      ),
    );
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      token= prefs.getString('access_token');
    });
  }

  void _like(group) {
    //서버 보내기
    if (likedGroup.contains(group)) {
      //좋아요 취소
      setState(() {
        likedGroup.remove(group);
        _likeUpdate(false,group);
      });
    } else {
      //좋아요 추가
      setState(() {
        likedGroup.add(group);
        _likeUpdate(true,group);
      });
    }
  }

  void _fetchMyGroup() async {
    await http
        .get(Uri.parse('http://52.79.146.213:5000/groups/getAll'),headers: {
      "Authorization": "Bearer $token"
    })
        .then((res) {
      if (res.statusCode == 200) {
        myGroup = [];
        List notSortedGroups=[];
        String jsonString = res.body;
        var result = json.decode(jsonString);
        for (var i = 0; i < result.length; i++) {
          var group = Group.fromMap(result[i]);
          notSortedGroups.add(group);
        }
        groupSort(notSortedGroups);
      }
    });
  }

  _getLikeGroup() async{
    await http
        .get(Uri.parse('http://52.79.146.213:5000/groups/getMyPreferringGroups'),headers: {
      "Authorization": "Bearer $token"
    })
        .then((res) {
      if (res.statusCode == 200) {
        likedGroup = [];
        String jsonString = res.body;
        var result = json.decode(jsonString);
        for (var i = 0; i < result.length; i++) {
          var groupId = result[i]['id'];
          setState(() {
            likedGroup.add(groupId);
          });
        }
      }
    });
    return true;
  }

  _likeUpdate(bool bool,int group) async{
    var url;
    if (bool){
      url = "http://52.79.146.213:5000/groups/addMyPreferringGroup/$group";
    }else{
      url = "http://52.79.146.213:5000/groups/cancelMyPreferringGroups/$group";
    }
    await http
        .patch(Uri.parse(url),headers: {
      "Authorization": "Bearer $token"
    }).then((res){
    });
  }

  void groupSort(notSortedGroups) {
      for(var i in notSortedGroups){
        if (likedGroup.contains(i.groupId)){
          setState(() {
            myGroup.add(i);
          });
        }
      }
      for(var i in notSortedGroups){
        if (!likedGroup.contains(i.groupId)){
          setState(() {
            myGroup.add(i);
          });
        }
      }
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
