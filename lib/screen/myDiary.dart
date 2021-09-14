import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:connectee/model/post.dart';
import 'package:connectee/widget/home/CalDetail/myDiaryHeader.dart';
import 'package:connectee/widget/home/CalDetail/mydiaryDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyDiary extends StatefulWidget {
  final back;

  const MyDiary({Key key, this.back}) : super(key: key);

  @override
  _MyDiaryState createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int page=1;
  String userId;
  String token;
  List _data = [

  ];
  var userInfo = {
    "id": 1,
    "snsId": "1822802345",
    "provider": "kakao",
    "email": "wodnd101@naver.com",
    "nickname": "이재웅",
    "interest": "마음,나가,하루,오늘",
    "createdAt": "2021-09-07T01:37:53.707Z",
    "updatedAt": "2021-09-12T01:13:44.000Z",
    "deletedAt": null,
    'desc': "",
    "diaryCount": 2,
    'commentCount': 5,
    'profileImage': null,
  };
  int month = 0;
  int year=0;

  @override
  void initState() {
    // TODO: implement initState
   page=1;
    _getId().then((res){
      //사용자정보

      //내 다이어리
      _getMyDiary();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.back != null
            ? IconButton(
                icon: new Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : null,
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
                month=0;
                year=0;
                page=1;
                _data=[];
              });
              _getMyDiary();
              _refreshController.refreshCompleted();
            },
            enablePullUp: true,
            onLoading: () async {
              setState(() {
                month=0;
                year=0;
                page+=1;
              });
              _getMyDiary();
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
                              child: userInfo['profileImage'] != null
                                  ? Container(
                                      width: 100,
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.network(
                                            userInfo['profileImage'],
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
                                    Text(
                                      userInfo['nickname'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
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
                              userInfo['desc'] != ''
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
                                      '아직 한 마디가 없어요. \n친구들에게 보여줄 한 마디를 작성해 주세요!',
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
                _data.length == 0
                    ? Container()
                    : Container(),
                for (var diary in _data)
                  Column(
                    children: [
                      Padding(
                            padding: const EdgeInsets.fromLTRB(10,0,10,0),
                            child: Column(
                                children: [
                                  _monthCheck(diary)
                                      ? Container(
                                    height: 30,
                                    width: double.infinity,
                                    color: Color(0xff2d2d2d),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20.0,0,10,0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          height: 20,
                                          width: 70,
                                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),
                                          child: Center(
                                            child: Text(
                                              '${DateFormat('yyyy.MM').format(DateTime.parse(diary.createdAt)).toString()}',
                                              style: TextStyle(color: Color(0xff2D2D2D),fontWeight: FontWeight.bold,fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ):Container(),
                                  Container(
                                    color: Color(0xff3D3D3D),
                                    child: Column(
                                      children: [
                                        MyDiaryHeader(
                                          post: diary,
                                        ),
                                        GestureDetector(
                                          // 리액션 상태 변경
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                builder: (BuildContext context) =>
                                                    new MyDiaryDetail(
                                                        post: diary,edit: true,),
                                                fullscreenDialog: true,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            width: 331,
                                            padding: EdgeInsets.fromLTRB(
                                                20, 10, 20, 15),
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
                                                    : Container(
                                                        padding: EdgeInsets.only(
                                                            top: 5, bottom: 10),
                                                        child: FadeInImage
                                                            .assetNetwork(
                                                          placeholder:
                                                              'assets/loading300.gif',
                                                          image: diary.linkImg,
                                                          width: 300,
                                                          height: 300,
                                                          fit: BoxFit.cover,
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
                                              Container(
                                                  child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0),
                                                    child:
                                                        diary.maxEmotion != null
                                                            ? Image.asset(
                                                                'assets/emotions/${diary.maxEmotion}.png',
                                                                width: 25,
                                                              )
                                                            : Container(),
                                                  ),
                                                  Text(
                                                    '${diary.emotionCount}명',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    '의 커넥티가 감정을 표현했어요!',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10),
                                                  ),
                                                ],
                                              )),
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                      new MyDiaryDetail(
                                                        post: diary,edit: true,),
                                                      fullscreenDialog: true,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  width: 90,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      border: Border.all(
                                                          color: Colors.white,
                                                          width: 1.5)),
                                                  child: Center(
                                                    child: Text(
                                                      '자세히 보기 >',
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
                                  Container(width: double.infinity,color: Color(0xff2D2D2D),height: 15,),
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
    if (DateTime.parse(i.createdAt).year != year){
      year=DateTime.parse(i.createdAt).year;
      month = DateTime.parse(i.createdAt).month;
      return true;
    }else{
      if (DateTime.parse(i.createdAt).month != month) {
        month = DateTime.parse(i.createdAt).month;
        year=DateTime.parse(i.createdAt).year;
        return true;
      } else {
        return false;
      }
    }
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      token = prefs.getString('access_token');
    });
  }

  _getMyDiary() async{
    await http
        .get(Uri.parse(
        'http://52.79.146.213:5000/diaries/fetch/myDiary?page=$page&limit=5'),headers: {"Authorization" : "Bearer $token"})
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
}
