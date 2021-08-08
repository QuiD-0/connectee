import 'package:connectee/model/post.dart';
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

class _HomeContentState extends State<HomeContent> {
  var _globalkey = GlobalKey();
  List _data = [];
  int page = 1;
  ScrollController _Scroll = ScrollController();
  String userId;

  @override
  void initState() {
    _getId().then((res){
      _fetchData();
      //내가 쓴 댓글 받아오기
    });
    _Scroll.addListener(() {
      if (_Scroll.position.pixels >= _Scroll.position.maxScrollExtent) {
        _fetchData();
      }
    });
    super.initState();
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
                                        new DiaryDetail(post: post),
                                    fullscreenDialog: true,
                                  ),
                                );
                                print(res);
                                // 상태 변경
                                // 리액션 리스트에 추가
                                // 감정 보내기 버튼에도 복붙하기
                              },
                              child: Container(
                                width: 331,
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    //이미지가 있는경우
                                    post.Images.isNotEmpty
                                        ? Container(
                                            padding: EdgeInsets.only(
                                                top: 5, bottom: 10),
                                            child: Image.network(
                                              post.Images[0],
                                              width: 300,
                                              height: 300,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(),
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
                                      print('tap send btn ${post.diaryId}');
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


  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  void dispose() {
    _Scroll.dispose();
    super.dispose();
  }

  Future _fetchData() async {
    await http
        .get(Uri.parse('http://52.79.146.213:5000/diaries/fetch?userId=$userId&page=$page&limit=5'))
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
    print('done');
  }

}
