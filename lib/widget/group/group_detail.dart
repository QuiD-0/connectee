import 'dart:convert';

import 'package:connectee/model/post.dart';
import 'package:connectee/screen/write_diary.dart';
import 'package:connectee/vars.dart';
import 'package:connectee/widget/group/group_card_header.dart';
import 'package:connectee/widget/home/diary_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GroupDetail extends StatefulWidget {
  final group;
  const GroupDetail({Key key, this.group}) : super(key: key);

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String userId;
  int page=1;
  List _data = [];
  Map<int, List<dynamic>> myEmotion = {};
  int diaryCount;

  @override
  void initState() {
    // TODO: implement initState
    _getId().then((res) {
      // 해당그룹 글 가져오기
      _fetchDiaryInfo(widget.group.groupId);
      _fetchGroupDiarys();
      // 내 이모션 리스트 가져오기
      _fetchMyEmotion();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var group=widget.group;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          group.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SmartRefresher(
          header: MaterialClassicHeader(
            color: Colors.white,
            backgroundColor: Color(0xff3d3d3d),
          ),
          footer: ClassicFooter(
            canLoadingText: '',
            loadingText: '',
            idleText: '',
          ),
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: () {
            setState(() {
              page=1;
            });
            _fetchGroupDiarys();
            _refreshController.refreshCompleted();
          },
          enablePullUp: true,
          onLoading: () async{
            _fetchGroupDiarys();
            _refreshController.loadComplete();
          },
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                children: [
                  //그룹 정보 박스
                  Container(
                    padding: EdgeInsets.all(20),
                    width: double.infinity,
                    height: 190,
                    child: Row(
                      children: [
                        //그룹 이미지
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: group.imageUrl!=null?Container(
                            width: 100,
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.network(
                                  group.imageUrl,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ):Container(width:100,child: Center(
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(50),
                              child: Container(
                                height: 100,
                                width: 100,
                                color: Color(0xffFF9082),
                              ),
                            ),
                          ),),
                        ),
                        //그룹 정보
                        Padding(
                            padding:
                            const EdgeInsets.only(left: 20, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  group.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${diaryCount.toString()}+ ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'diary',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                    Text(
                                      '   |   ',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                    Image.asset(
                                      'assets/icons/user.png',
                                      height: 14,
                                      width: 12,
                                      fit: BoxFit.contain,
                                    ),
                                    Text(
                                      '  (${group.groupUserCount.toString()}/${group.limitMembers.toString()})',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 10),
                                  child: Container(
                                    height: 60,
                                    width: 210,
                                    child: Text(
                                      group.description,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          height: 1.5),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xff2D2D2D),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(13),
                          topRight: Radius.circular(13)),
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Color(0xff4D4D4D),
                  ),
                  //그룹 다이어리 작성버튼
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(builder: (context) {
                        return WriteDiary(
                          groupName: group.title,groupId:group.groupId,
                        );
                      }));
                    },
                    child: Container(
                      height: 170,
                      width: double.infinity,
                      color: Color(0xff2D2D2D),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: Color(0xff3D3D3D),
                          ),
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
                                '그룹 다이어리 작성하기',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  //카드 테스트후 수정
                ],
              ),
            ),
            for(var post in _data) Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  //카드
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff3d3d3d),
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Color(0xff3d3d3d),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xd000000),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            )
                          ]),
                      // 카드 제작
                      child: Column(
                        children: [
                          GroupRecCardHeader(
                            data: post,group:widget.group,
                          ),
                          GestureDetector(
                            // 리액션 상태 변경
                            onTap: () async {
                              var prevEmotion = myEmotion[post.diaryId];
                              var res = await Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (BuildContext context) =>
                                  new DiaryDetail(
                                    post: post,
                                    myEmotion:
                                    myEmotion[post.diaryId],groupName: group.title,),
                                  fullscreenDialog: true,
                                ),
                              );
                              if (res[0] != null) {
                                if (prevEmotion == null) {
                                  setState(() {
                                    post.emotionCount += 1;
                                    myEmotion[post.diaryId] = [
                                      res[0],
                                      res[1],
                                      res[2],
                                    ];
                                    prevEmotion = myEmotion[post.diaryId];
                                  });
                                } else {
                                  setState(() {
                                    myEmotion[post.diaryId] = [
                                      res[0],
                                      res[1],
                                      res[2],
                                    ];
                                    prevEmotion = myEmotion[post.diaryId];
                                  });
                                }
                              }
                              if (prevEmotion==null && res[0]==null){
                                //아무것도 안하고 나온경우
                              }
                              if (prevEmotion != null && res[0] == null) {
                                setState(() {
                                  myEmotion.remove(post.diaryId);
                                  post.emotionCount -= 1;
                                  prevEmotion = null;
                                });
                              }
                            },
                            child: Container(
                              width: 331,
                              padding:
                              EdgeInsets.fromLTRB(20, 10, 20, 15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  //이미지가 있는경우
                                  post.category == 'diary' ||
                                      post.category == 'trip'
                                      ? post.Images.isNotEmpty
                                      ? Container(
                                    padding: EdgeInsets.only(
                                        top: 5, bottom: 10),
                                    child: FadeInImage.assetNetwork(
                                      placeholder:
                                      'assets/loading300.gif',
                                      image: post.Images[0],
                                      width: 300,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                      : Container()
                                  //영화, 책 이미지 부분
                                      : Center(
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 5, bottom: 10),
                                      child:
                                      FadeInImage.assetNetwork(
                                        placeholder:
                                        'assets/loading300.gif',
                                        image: post.linkImg,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    post.content,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 5,
                                    softWrap: false,
                                    style: TextStyle(
                                        color: Colors.black,
                                        height: 2,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                //내 리액션리스트에 있는지 확인후 출력
                                Container(
                                  // 내가 표현한 감정 표시
                                  child: Row(
                                    children: [
                                      post.emotionCount == 0
                                          ? Text(
                                        '가장 먼저 감정을 보내보세요!',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10),
                                      )
                                          : myEmotion[post.diaryId] ==
                                          null
                                          ? Row(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                right:
                                                10.0),
                                            child: Image.asset(
                                              'assets/emotions/${post.maxEmotion}.png',
                                              width: 25,
                                            ),
                                          ),
                                          Text(
                                            '${post.emotionCount}명',
                                            style: TextStyle(
                                                color: Colors
                                                    .white,
                                                fontSize: 10,
                                                fontWeight:
                                                FontWeight
                                                    .bold),
                                          ),
                                          Text(
                                            '의 커넥티가 감정을 표현했어요!',
                                            style: TextStyle(
                                                color: Colors
                                                    .white,
                                                fontSize: 10),
                                          ),
                                        ],
                                      )
                                          : Row(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets
                                                .only(
                                                right:
                                                10.0),
                                            child: Image.asset(
                                              'assets/emotions/${myEmotion[post.diaryId][0]}.png',
                                              width: 25,
                                            ),
                                          ),
                                          Text(
                                            '${engToKor[myEmotion[post.diaryId][0]]}',
                                            style: TextStyle(
                                                color: emotionColorList[
                                                engToInt[myEmotion[post.diaryId]
                                                [
                                                0]] -
                                                    1],
                                                fontSize: 10,
                                                fontWeight:
                                                FontWeight
                                                    .bold),
                                          ),
                                          Text(
                                            '의 감정을 보냈어요!',
                                            style: TextStyle(
                                                color: emotionColorList[
                                                engToInt[myEmotion[post.diaryId]
                                                [
                                                0]] -
                                                    1],
                                                fontSize: 10),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    var prevEmotion = myEmotion[post.diaryId];
                                    var res = await Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (BuildContext context) =>
                                        new DiaryDetail(
                                          post: post,
                                          myEmotion:
                                          myEmotion[post.diaryId],groupName: group.title,),
                                        fullscreenDialog: true,
                                      ),
                                    );
                                    if (res[0] != null) {
                                      if (prevEmotion == null) {
                                        setState(() {
                                          post.emotionCount += 1;
                                          myEmotion[post.diaryId] = [
                                            res[0],
                                            res[1],
                                            res[2],
                                          ];
                                          prevEmotion = myEmotion[post.diaryId];
                                        });
                                      } else {
                                        setState(() {
                                          myEmotion[post.diaryId] = [
                                            res[0],
                                            res[1],
                                            res[2],
                                          ];
                                          prevEmotion = myEmotion[post.diaryId];
                                        });
                                      }
                                    }
                                    if (prevEmotion==null && res[0]==null){
                                      //아무것도 안하고 나온경우
                                    }
                                    if (prevEmotion != null && res[0] == null) {
                                      setState(() {
                                        myEmotion.remove(post.diaryId);
                                        post.emotionCount -= 1;
                                        prevEmotion = null;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 90,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 1.5)),
                                    child: Center(
                                      child: Text(
                                        '감정 보내기 >',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
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
          ],),
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


  void _fetchMyEmotion() async {
    await http
        .get(Uri.parse(
        'http://52.79.146.213:5000/comments/getall?userId=$userId'))
        .then((res) {
      if (res.statusCode == 200) {
        String jsonString = res.body;
        var result = json.decode(jsonString);
        for (var i = 0; i < result.length; i++) {
          setState(() {
            myEmotion[result[i]['diaryId']] = [
              result[i]['emotionType'],
              result[i]['emotionLevel'],
              result[i]['id'],
            ];
          });
        }
      }
    });
  }

  void _fetchGroupDiarys() async{
    await http
        .get(Uri.parse(
        'http://52.79.146.213:5000/diaries/${widget.group.groupId}/group/getAll?page=$page&limit=5'))
        .then((res) {
      if (res.statusCode == 200) {
        setState(() {
          _data=[];
        });
        String jsonString = res.body;
        List posts = jsonDecode(jsonString);
        for (int i = 0; i < posts.length; i++) {
          var post = posts[i];
          Diary diaryToAdd = Diary.fromMap(post);
          setState(() {
            _data.add(diaryToAdd);
          });
        }
      } else {
        print('error');
      }
    });
  }

  void _fetchDiaryInfo(groupId) async{
    await http
        .get(Uri.parse(
        'http://52.79.146.213:5000/groups/$groupId/getOne'))
        .then((res) {
      String jsonString = res.body;
       var info = jsonDecode(jsonString);
      diaryCount=info['groupDiaryCount']??0;
    });

  }
}
