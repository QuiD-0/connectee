import 'dart:convert';

import 'package:connectee/model/post.dart';
import 'package:connectee/screen/write_diary.dart';
import 'package:connectee/vars.dart';
import 'package:connectee/widget/home/RecCard/rec_card_header.dart';
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
  int page=2;
  List _data = [];
  Map<int, List<dynamic>> myEmotion = {};

  @override
  void initState() {
    // TODO: implement initState
    _getId().then((res) {
      // 해당그룹 글 가져오기
      _fetchGroupDiarys();
      // 내 이모션 리스트 가져오기
      _fetchMyEmotion();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          widget.group['title'],
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
            _fetchGroupDiarys();
            _refreshController.refreshCompleted();
          },
          enablePullUp: true,
          onLoading: () async{
            await http
                .get(Uri.parse(
                'http://52.79.146.213:5000/diaries/fetch?userId=$userId&page=$page&limit=10'))
                .then((res) {
              if (res.statusCode == 200) {
                String jsonString = res.body;
                List posts = jsonDecode(jsonString);
                for (int i = 0; i < posts.length; i++) {
                  var post = posts[i];
                  Diary diaryToAdd = Diary.fromMap(post);
                  setState(() {
                    _data.add(diaryToAdd);
                  });
                }
                setState(() {
                  page++;
                });
              }
            });
            _refreshController.loadComplete();
          },
          child: ListView.builder(
            itemCount: _data.length + 1,
            itemBuilder: (c, index) {
              var post;
              if(index!=_data.length){
                post=_data[index];
              }
              //아무글이 없을경우
              if (_data.length == 0) {
                return Padding(
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
                              child: Container(
                                width: 100,
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      widget.group['img'],
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
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
                                      widget.group['title'],
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
                                          '100+ ',
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
                                          '  (${widget.group['NOP'].toString()}/100)',
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
                                          '그룹 설명 설명그룹 룹 설명그룹 설명그룹 설명',
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
                              groupName: widget.group['title'],
                            );
                          }));
                        },
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          color: Color(0xff2D2D2D),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Container(
                              height: 115,
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
                      Column(
                        children: [
                          Container(
                              width: double.infinity,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Color(0xff2d2d2d),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(13),
                                    bottomRight: Radius.circular(13)),
                              )),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }
              if (index == 0) {
                //글이 있을경우 최상단
                return Padding(
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
                              child: Container(
                                width: 100,
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      widget.group['img'],
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
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
                                      widget.group['title'],
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
                                          '100+ ',
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
                                          '  (${widget.group['NOP'].toString()}/100)',
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
                                          '그룹 설명 설명그룹 룹 설명그룹 설명그룹 설명',
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
                              groupName: widget.group['title'],
                            );
                          }));
                        },
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          color: Color(0xff2D2D2D),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Container(
                              height: 115,
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
                      Column(
                        children: [
                          //카드
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xff3d3d3d),
                                ),
                                child: Container(
                                  width: 360,
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
                                      RecCardHeader(
                                        data: post,
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
                                                  myEmotion[post.diaryId],groupName: widget.group['title'],),
                                              fullscreenDialog: true,
                                            ),
                                          );
                                          if (res[0] != null) {
                                            if (prevEmotion == null) {
                                              setState(() {
                                                _data[index].emotionCount += 1;
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
                                            print('클릭 업데이트');//아무것도 안하고 나온경우
                                            _clickTest(post.diaryId);
                                          }
                                          if (prevEmotion != null && res[0] == null) {
                                            setState(() {
                                              myEmotion.remove(post.diaryId);
                                              _data[index].emotionCount -= 1;
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
                                                  : Container(
                                                padding: EdgeInsets.only(
                                                    top: 5, bottom: 10),
                                                child:
                                                //       Image.network(
                                                //   post.linkImg,
                                                //   width: 300,
                                                //   height: 300,
                                                //   fit: BoxFit.cover,
                                                // ),
                                                FadeInImage.assetNetwork(
                                                  placeholder:
                                                  'assets/loading.gif',
                                                  image: post.linkImg,
                                                  width: 300,
                                                  height: 300,
                                                  fit: BoxFit.cover,
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
                                                var prevEmotion =
                                                myEmotion[post.diaryId];
                                                var res = await Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (BuildContext context) =>
                                                    new DiaryDetail(
                                                        post: post,
                                                        myEmotion: myEmotion[
                                                        post.diaryId]),
                                                    fullscreenDialog: true,
                                                  ),
                                                );
                                                if (res[0] != null) {
                                                  if (prevEmotion == null) {
                                                    setState(() {
                                                      _data[index].emotionCount += 1;
                                                      myEmotion[post.diaryId] = [
                                                        res[0],
                                                        res[1],
                                                        res[2],
                                                      ];
                                                    });
                                                  } else {
                                                    setState(() {
                                                      myEmotion[post.diaryId] = [
                                                        res[0],
                                                        res[1],
                                                        res[2],
                                                      ];
                                                    });
                                                  }
                                                }
                                                if (prevEmotion != null &&
                                                    res[0] == null) {
                                                  setState(() {
                                                    myEmotion.remove(post.diaryId);
                                                    _data[index].emotionCount -= 1;
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
                              Container(
                                height: 15,
                                width: 360,
                                decoration: BoxDecoration(color: Color(0xff2d2d2d)),
                              )
                            ],
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
                );
              }
              if (index == _data.length) {
                //최하단
                return Column(
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
                );
              }

              //카드
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      color: Colors.white,
                    ),
                    Container(
                      width: double.infinity,
                      height: 20,
                      color: Color(0xff2d2d2d),
                    ),
                  ],
                ),
              );
            },
          ),
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

  _clickTest(diaryId)async{
    var body={
      "accessType": "string",
      "diaryId": diaryId,
      "userId": int.parse(userId)
    };
    await http
        .post(Uri.parse(
        'http://52.79.146.213:5000/clicks/update'),body: json.encode(body))
        .then((res) {
      print(res.body);
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
        'http://52.79.146.213:5000/diaries/fetch?userId=$userId&page=1&limit=5'))
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
        setState(() {
          page++;
        });
      } else {
        print('error');
        print(res.body);
      }
    });
  }
}
