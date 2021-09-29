import 'dart:convert';
import 'package:connectee/screen/write_diary.dart';
import 'package:connectee/widget/home/RecCard/rec_card_header.dart';
import 'package:connectee/widget/home/diary_detail.dart';
import 'package:intl/intl.dart';
import 'package:connectee/model/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../vars.dart';

class GroupOtherDiary extends StatefulWidget {
  final someonesId;
  final group;
  const GroupOtherDiary({Key key, this.someonesId,this.group}) : super(key: key);

  @override
  _GroupOtherDiaryState createState() => _GroupOtherDiaryState();
}

class _GroupOtherDiaryState extends State<GroupOtherDiary> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Map<int, List<dynamic>> myEmotion = {};
  String userId;
  String token;
  bool master = false;
  List _data=[];
  var userInfo = {
    "id": 0,
    "snsId": "",
    "provider": "",
    "email": "",
    "nickname": "User",
    "interest": "",
    "createdAt": "",
    "updatedAt": "",
    "deletedAt": null,
    'intro': "",
    "diaryCount": 0,
    'commentCount': 0,
    'imageUrl': null,
  };
  int month = 0;
  int year = 0;
  int page=1;
  @override
  void initState() {
    // TODO: implement initState
    //사용자 받아오기
    _getId().then((res) {
      //내가 쓴 댓글 받아오기
      _fetchMyEmotion();
      //사용자 정보
      _getUserInfo(widget.someonesId);
      //사용자 다이어리
      _getOthersDiary();
      isMaster();
      print(widget.group.password);
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
          '다이어리',
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
                month = 0;
                year = 0;
                _data=[];
              });
              _getOthersDiary();
              _refreshController.refreshCompleted();
            },
            enablePullUp: true,
            onLoading: () async {
              setState(() {
                page+=1;
                month = 0;
                year = 0;
              });
              _getOthersDiary();
              _refreshController.loadComplete();
            },
            child: ListView(
              children: [
                //사용자 정보
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    children: [
                      //사용자 정보
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        width: double.infinity,
                        height: 170,
                        child: Row(
                          children: [
                            //사용자 이미지
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: userInfo['imageUrl'] != null
                                  ? Container(
                                      width: 100,
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            userInfo['imageUrl'],
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 100,
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Container(
                                            height: 100,
                                            width: 100,
                                            color: Color(0xffFF9082),
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          width: 150,
                                          child: Text(
                                            userInfo['nickname'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        master?GestureDetector(
                                          onTap: () async{
                                            var res = await showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              barrierColor: Color(0x99000000),
                                              builder: (context) =>
                                                  AlertDialog(
                                                    titlePadding: EdgeInsets.fromLTRB(
                                                        20, 40, 20, 10),
                                                    elevation: 0,
                                                    backgroundColor: Color(0xff3D3D3D),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(10.0)),
                                                    title: Text(
                                                      '차단하기',
                                                      textAlign: TextAlign.center,
                                                    ),
                                                    titleTextStyle: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontFamily: 'GmarketSans',
                                                        fontWeight: FontWeight.bold),
                                                    content: Text('해당 사용자를\n차단하시겟습니까?',textAlign: TextAlign.center,),
                                                    contentTextStyle: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontFamily: 'GmarketSans'),
                                                    actions: <Widget>[
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment
                                                            .spaceAround,
                                                        children: [
                                                          FlatButton(
                                                            onPressed: () =>
                                                                Navigator.pop(context, false),
                                                            child: Text('취소',
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors.white,
                                                                    fontFamily: 'GmarketSans')),
                                                          ),
                                                          FlatButton(
                                                            onPressed: () =>
                                                                Navigator.pop(context, true),
                                                            child: Text('확인',
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    color: Colors.white,
                                                                    fontFamily: 'GmarketSans')),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                            );
                                            if (res==true) {
                                              _blockSomeone();
                                            }else{

                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.fromLTRB(10,5,10,5),
                                            decoration: BoxDecoration(
                                              color: Color(0xff3D3D3D),
                                              borderRadius: BorderRadius.circular(30),
                                            ),
                                            child: Text('차단',style: TextStyle(color: Colors.white,fontSize: 12),),
                                          ),
                                        ):Container(),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          '${userInfo['diaryCount']}+ ',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          ' diary',
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
                                        Text(
                                          '${userInfo['commentCount']}+',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          ' connect',
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
                                          '${userInfo['diaryCount']}+개의 다이어리를 작성하고,\n${userInfo['commentCount'].toString()}번의 감정을 표현했어요!',
                                          style: TextStyle(
                                              color: Color(0xffD0D0D0),
                                              fontSize: 10,
                                              height: 1.5),
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
                      //한마디
                      Container(
                        width: double.infinity,
                        height: 100,
                        alignment: Alignment.topLeft,
                        color: Color(0xff2D2D2D),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userInfo['nickname']}님의 한 마디!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              userInfo['intro'] != ''
                                  ? Text(
                                      '${userInfo['desc']}',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          height: 2),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    )
                                  : Text(
                                      '아직 한 마디가 없어요.',
                                      style: TextStyle(
                                          color: Color(0xffD0D0D0),
                                          fontSize: 12,
                                          height: 2),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Color(0xff4D4D4D),
                      ),
                      Container(
                        height: 60,
                        width: double.infinity,
                        color: Color(0xff2d2d2d),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            '${userInfo['nickname']}님의 다이어리',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // 다이어리 내용
                // _data.length == 0
                //     ? Text(
                //         '다이어리가 없습니다.',
                //         style: TextStyle(color: Colors.white),
                //       )
                //     : Container(),
                for (var diary in _data)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: Column(
                          children: [
                            _monthCheck(diary)
                                ? Container(
                                    height: 30,
                                    width: double.infinity,
                                    color: Color(0xff2d2d2d),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20.0, 0, 10, 0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          height: 20,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Center(
                                            child: Text(
                                              '${DateFormat('yyyy.MM').format(DateTime.parse(diary.createdAt)).toString()}',
                                              style: TextStyle(
                                                  color: Color(0xff2D2D2D),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
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
                                    RecCardHeader(
                                      data: diary,
                                    ),
                                    GestureDetector(
                                      // 리액션 상태 변경
                                      onTap: () async {
                                        var prevEmotion =
                                            myEmotion[diary.diaryId];
                                        var res = await Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (BuildContext context) =>
                                                new DiaryDetail(
                                              post: diary,
                                              myEmotion:
                                                  myEmotion[diary.diaryId],
                                              groupName: null,
                                            ),
                                            fullscreenDialog: true,
                                          ),
                                        );
                                        if (res[0] != null) {
                                          if (prevEmotion == null) {
                                            setState(() {
                                              diary.emotionCount += 1;
                                              myEmotion[diary.diaryId] = [
                                                res[0],
                                                res[1],
                                                res[2],
                                              ];
                                              prevEmotion =
                                                  myEmotion[diary.diaryId];
                                            });
                                          } else {
                                            setState(() {
                                              myEmotion[diary.diaryId] = [
                                                res[0],
                                                res[1],
                                                res[2],
                                              ];
                                              prevEmotion =
                                                  myEmotion[diary.diaryId];
                                            });
                                          }
                                        }
                                        if (prevEmotion == null &&
                                            res[0] == null) {
                                          //아무것도 안하고 나온경우
                                        }
                                        if (prevEmotion != null &&
                                            res[0] == null) {
                                          setState(() {
                                            myEmotion.remove(diary.diaryId);
                                            diary.emotionCount -= 1;
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //이미지가 있는경우
                                            diary.category == 'diary' ||
                                                    diary.category == 'trip'
                                                ? diary.Images.isNotEmpty
                                                    ? Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 5,
                                                                bottom: 10),
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder:
                                                              'assets/loading300.gif',
                                                          image:
                                                              diary.Images[0],
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
                                                          FadeInImage
                                                              .assetNetwork(
                                                        placeholder:
                                                            'assets/loading300.gif',
                                                        image: diary.linkImg,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                ),
                                            Text(
                                              diary.content,
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
                                      margin:
                                          EdgeInsets.fromLTRB(20, 15, 20, 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //내 리액션리스트에 있는지 확인후 출력
                                          Container(
                                            // 내가 표현한 감정 표시
                                            child: Row(
                                              children: [
                                                diary.emotionCount == 0
                                                    ? Text(
                                                        '가장 먼저 감정을 보내보세요!',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10),
                                                      )
                                                    : myEmotion[diary
                                                                .diaryId] ==
                                                            null
                                                        ? Row(
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            10.0),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/emotions/${diary.maxEmotion}.png',
                                                                  width: 25,
                                                                ),
                                                              ),
                                                              Text(
                                                                '${diary.emotionCount}명',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                '의 커넥티가 감정을 표현했어요!',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10),
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
                                                                child:
                                                                    Image.asset(
                                                                  'assets/emotions/${myEmotion[diary.diaryId][0]}.png',
                                                                  width: 25,
                                                                ),
                                                              ),
                                                              Text(
                                                                '${engToKor[myEmotion[diary.diaryId][0]]}',
                                                                style: TextStyle(
                                                                    color: emotionColorList[
                                                                        engToInt[myEmotion[diary.diaryId][0]] -
                                                                            1],
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                '의 감정을 보냈어요!',
                                                                style: TextStyle(
                                                                    color: emotionColorList[
                                                                        engToInt[myEmotion[diary.diaryId][0]] -
                                                                            1],
                                                                    fontSize:
                                                                        10),
                                                              ),
                                                            ],
                                                          )
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              var prevEmotion =
                                                  myEmotion[diary.diaryId];
                                              var res = await Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      new DiaryDetail(
                                                          post: diary,
                                                          myEmotion: myEmotion[
                                                              diary.diaryId]),
                                                  fullscreenDialog: true,
                                                ),
                                              );
                                              if (res[0] != null) {
                                                if (prevEmotion == null) {
                                                  setState(() {
                                                    diary.emotionCount += 1;
                                                    myEmotion[diary.diaryId] = [
                                                      res[0],
                                                      res[1],
                                                      res[2],
                                                    ];
                                                  });
                                                } else {
                                                  setState(() {
                                                    myEmotion[diary.diaryId] = [
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
                                                  myEmotion
                                                      .remove(diary.diaryId);
                                                  diary.emotionCount -= 1;
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
                              width: double.infinity,
                              color: Color(0xff2D2D2D),
                              height: 15,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
              ],
            )),
      ),
    );
  }

  _monthCheck(i) {
    if(_data[0]==i){
      year=DateTime.parse(i.createdAt).year;
      month = DateTime.parse(i.createdAt).month;
      return true;
    }
    if (DateTime.parse(i.createdAt).year != year) {
      year = DateTime.parse(i.createdAt).year;
      month = DateTime.parse(i.createdAt).month;
      return true;
    } else {
      if (DateTime.parse(i.createdAt).month != month) {
        month = DateTime.parse(i.createdAt).month;
        year = DateTime.parse(i.createdAt).year;
        return true;
      } else {
        return false;
      }
    }
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

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      token = prefs.getString('access_token');
    });
  }

  _getUserInfo(someonesId) async{
    await http
        .get(Uri.parse(
        'http://52.79.146.213:5000/users/getOne/$someonesId'),headers: {"Authorization" : "Bearer $token"})
        .then((res) {
      if (res.statusCode == 200) {
        setState(() {
          userInfo=json.decode(res.body);
        });
      } else {
        print('error');
      }
    });
  }
  _getOthersDiary() async{
    await http
        .get(Uri.parse(
        'http://52.79.146.213:5000/diaries/fetch/usersDiary?userId=${widget.someonesId}&page=$page&limit=5'))
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
      } else {
        print('error');
      }
    });
  }

  isMaster() {
    if(widget.group.OwnerId == int.parse(userId)){
      setState(() {
        master = true;
      });
    }else{
      setState(() {
        master = false;
      });
    }

  }

  void _blockSomeone() async{
    var body = {
      "groupId": widget.group.groupId.toString(),
      "userId": widget.someonesId.toString(),
      "password": widget.group.password,
    };
    print(body);
    await http
        .post(Uri.parse(
        'http://52.79.146.213:5000/groups/removeMember'),headers: {"Authorization" : "Bearer $token"},body: json.encode(body))
        .then((res) {
          print(res.body);
      if (res.statusCode == 200) {
        print('1');
      } else {
        print('error');
      }
    });
  }
}
