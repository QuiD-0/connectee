import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'home/RecCard/rec_card_header.dart';
import 'home/diary_detail.dart';
import 'home/main_postDiary.dart';
import 'home/recommend_header.dart';
import 'home/tabelCalendar.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}
// 파일을 합치고 더보기 스캐폴드에서 뒤로가기시 스테이트 수정하기..?
class Post {
  int id;
  String name;
  int age;

  Post(this.id, this.name, this.age);

  Post.formMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        age = map['age'];
}

class _HomeContentState extends State<HomeContent> {
  List _data = [];
  int page = 1;
  ScrollController _Scroll = ScrollController();
  int id;
  // 내가 단 리액션 리스트
  // post ID
  // emotion
  //

  @override
  void initState() {
    _data = [Post(1, 'asd', 12), Post(2, 'asd', 12), Post(3, 'asd', 12)];
    // _fetchData();
    _Scroll.addListener(() {
      if (_Scroll.position.pixels >= _Scroll.position.maxScrollExtent) {
        _fetchData();
      }
    });
    _getId();
    super.initState();
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('userId');
    });
  }

  void dispose() {
    _Scroll.dispose();
    super.dispose();
  }

  Future _fetchData() async {
    int limit = 15;
    await http
        .get(Uri.parse("http://18.216.47.35:3000/?page=$page&limit=$limit"))
        .then((res) {
      if (res.statusCode == 200) {
        String jsonString = res.body;
        List posts = jsonDecode(jsonString);
        for (int i = 0; i < posts.length; i++) {
          var post = posts[i];
          Post postToAdd = Post(post["id"], post["name"], post["age"]);
          setState(() {
            _data.add(postToAdd);
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 14.0, bottom: 13),
          child: Calendar(),
        ),
        PostDiary(),
        RecommendHeader(),
        ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            controller: _Scroll,
            itemCount: _data.length + 1,
            itemBuilder: (context, index) {
              if (index == _data.length) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(child: CircularProgressIndicator()),
                  //로딩 아이콘 의뢰 ?? -> 시간 남으면.
                );
              }
              Post post = _data[index];
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
                        decoration:
                            BoxDecoration(color: Color(0xff3d3d3d), boxShadow: [
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
                                var res = await Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (BuildContext context) =>
                                        new DiaryDetail(data: post),
                                    fullscreenDialog: true,
                                  ),
                                );
                                print(res);
                                //상태 변경
                              },
                              child: Container(
                                width: 331,
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    post.id % 2 == 1
                                        ? Container(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 10),
                                            child: Image.network(
                                              'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
                                              width: 300,
                                              height: 300,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(),
                                    Text(
                                      '미데 이 터더미 데이 터더 미데 이터더미데이asd터더미데이asd터더미데이asd터더미데이asd',
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
                                  // Container(
                                  //   // 내가 표현한 감정 표시
                                  //   child: Row(
                                  //     children: [
                                  //       postCount == 0
                                  //           ? Text(
                                  //               '가장 먼저 감정을 보내보세요!',
                                  //               style: TextStyle(
                                  //                   color: Colors.white,
                                  //                   fontSize: 12),
                                  //             )
                                  //       //if (postID in myemotionList)
                                  //       // myEmotionList[postID]
                                  //       // else post.emotionCount명
                                  //           : selectedEmotion == null
                                  //               ? Row(
                                  //                   children: [
                                  //                     Text(
                                  //                       '$postCount명',
                                  //                       style: TextStyle(
                                  //                           color: Colors.white,
                                  //                           fontSize: 12,
                                  //                           fontWeight:
                                  //                               FontWeight
                                  //                                   .bold),
                                  //                     ),
                                  //                     Text(
                                  //                       '의 커넥티가 감정을 표현했어요!',
                                  //                       style: TextStyle(
                                  //                           color: Colors.white,
                                  //                           fontSize: 12),
                                  //                     ),
                                  //                   ],
                                  //                 )
                                  //               : Container(
                                  //                   child: Text(
                                  //                     '${emotionList[selectedEmotion - 1]}의 감정을 보냈어요!',
                                  //                     style: TextStyle(
                                  //                         fontSize: 12,
                                  //                         color: Colors.white),
                                  //                   ),
                                  //                 ),
                                  //     ],
                                  //   ),
                                  // ),
                                  GestureDetector(
                                    onTap: () {
                                      print('tap send btn ${post.id}');
                                    },
                                    child: Container(
                                      width: 90,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          border: Border.all(
                                              color: Colors.white, width: 1.5)),
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
}
