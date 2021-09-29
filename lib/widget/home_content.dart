import 'package:connectee/model/post.dart';
import 'package:connectee/screen/write_diary.dart';
import 'package:connectee/vars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home/RecCard/rec_card_header.dart';
import 'home/diary_detail.dart';
import 'home/recommend_header.dart';
import 'home/tabelCalendar.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List _data = [];
  Map<int, List<dynamic>> myEmotion = {};
  int page = 1;
  ScrollController _Scroll = ScrollController();
  String userId;
  int access;

  @override
  void initState() {
    _getId().then((res) {
      _fetchData();
      _fetchMyEmotion();
      //엑세스 타입 정하기
    });
    _Scroll.addListener(() {
      if (_Scroll.position.pixels == _Scroll.position.maxScrollExtent) {
        _fetchData();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: _Scroll,
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0, bottom: 13),
              child: Calendar(),
            ),
            GestureDetector(
              onTap: () async {
                await Navigator.of(context, rootNavigator: true).push(
                  new CupertinoPageRoute(
                    builder: (BuildContext context) => new WriteDiary(),
                    fullscreenDialog: true,
                  ),
                );
              },
              child: Container(
                width: 360,
                height: 150,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 3),
                decoration: BoxDecoration(
                    color: Color(0xff2D2D2D),
                    borderRadius: BorderRadius.circular(13)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/emoji.png',
                      width: 200,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '오늘 다이어리 \n어떠세요?',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '오늘의 감정\n기록하러가기',
                              style: TextStyle(
                                  color: Color(0xffababab), height: 1.5),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xffababab),
                              size: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ),
            RecommendHeader(),
            ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  // if (index == _data.length) {
                  //   return Padding(
                  //     padding: const EdgeInsets.all(12.0),
                  //     child: Center(
                  //       child: CircularProgressIndicator(),
                  //     ),
                  //   );
                  // }
                  Diary post = _data[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Column(
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
                                          myEmotion: myEmotion[post.diaryId],
                                          groupName: null,
                                        ),
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
                                    if (prevEmotion == null && res[0] == null) {
                                      //아무것도 안하고 나온경우
                                      //print('클릭 업데이트');
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
                                                    child: FadeInImage
                                                        .assetNetwork(
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
                  );
                })
          ],
        ));
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      access = prefs.getInt("access");
      userId = prefs.getString('userId');
    });
  }

  void dispose() {
    _Scroll.dispose();
    super.dispose();
  }

  Future _fetchData() async {
    String uri;
    //api 수정 후 변경하기 (access ==0)
    if (true){
      //최신
      uri = 'http://52.79.146.213:5000/diaries/fetch?userId=$userId&page=$page&limit=5';
    }else{
      //추천
      uri = 'http://52.79.146.213:5000/diaries/recommandedDiary/$userId';
    }
    await http
        .get(Uri.parse(
        uri))
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
      } else {
        print('error');
      }
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

  _clickTest(diaryId) async {
    String day = DateTime.now().year.toString() +
        '-' +
        DateTime.now().month.toString() +
        '-' +
        DateTime.now().day.toString();
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString(day);
    String emotion;
    String value;

    if (data == null) {
      emotion = null;
      value = null;
    } else {
      emotion = data.split(',')[0];
      value = data.split(',')[1];
    }
    var body = {
      "accessType": access, //변경 예정
      "diaryId": diaryId,
      "userId": int.parse(userId),
      "emotionType": "$emotion",
      "emotionLevel": value,
    };
    await http
        .post(Uri.parse('http://52.79.146.213:5000/clicks/update'),
            headers: {"Content-Type": "application/json"},
            body: json.encode(body))
        .then((res) {});
  }
}
