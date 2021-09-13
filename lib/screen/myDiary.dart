import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:connectee/model/post.dart';
import 'package:connectee/widget/home/CalDetail/myDiaryHeader.dart';
import 'package:connectee/widget/home/CalDetail/mydiaryDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyDiary extends StatefulWidget {
  final back;

  const MyDiary({Key key, this.back}) : super(key: key);

  @override
  _MyDiaryState createState() => _MyDiaryState();
}

class _MyDiaryState extends State<MyDiary> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List _data = [
    Diary.fromMap({
      "id": 22,
      "title": "이쁜 하늘",
      "content": "매일 이런 날씨면 좋겟다",
      "emotionType": "surprised",
      "emotionLevel": 5,
      "private": 0,
      "weather": null,
      "category": "diary",
      "categoryScore": null,
      "createdAt": "2021-09-12T22:04:09.452Z",
      "updatedAt": "2021-09-12T22:04:09.572Z",
      "deletedAt": null,
      "userId": 1,
      "movieId": null,
      "bookId": null,
      "train": false,
      "FTVector": "[ 0.07930864 -0.13277662  0.18714295  0.0611374  -0.10511176 -0.2563751\n  0.1362925   0.05879297  0.14633304  0.1039238  -0.21439154 -0.03212082\n  0.21975231  0.09757462 -0.18519069  0.22017968 -0.2159352   0.23821585\n -0.31008035 -0.11176975 -0.22413716 -0.34892857 -0.18236616  0.04763281\n  0.21652508 -0.09015366  0.07634337  0.30142602  0.21586272  0.02983756]",
      "interest": "날씨,하늘",
      "LDAVector": "[(0, 0.05178676), (1, 0.051796485), (2, 0.05178706), (3, 0.051787145), (4, 0.051787052), (5, 0.05178707), (6, 0.051787864), (7, 0.05178711), (8, 0.5339065), (9, 0.05178697)]",
      "isMyDiary": true,
      "Images": [
        {
          "id": 2,
          "originalName": "image_picker4166048543844957850.jpg",
          "location": "https://sw-connectee-s3.s3.ap-northeast-2.amazonaws.com/original/image_picker4166048543844957850.jpg",
          "size": 3663721,
          "createdAt": "2021-09-12T22:04:09.593Z",
          "updatedAt": "2021-09-12T22:04:09.593Z",
          "deletedAt": null,
          "diaryId": 22
        }
      ],
      "BookApi": null,
      "MovieApi": null,
      "Comments": [],
      "User": {
        "id": 1,
        "snsId": "1822802345",
        "provider": "kakao",
        "email": "wodnd101@naver.com",
        "nickname": "이재웅",
        "interest": "날씨,하루,오늘,설정,서버",
        "createdAt": "2021-09-07T01:37:53.707Z",
        "updatedAt": "2021-09-12T22:03:42.000Z",
        "deletedAt": null
      },
      "maxEmotion": null
    }),
    Diary.fromMap({
      "id": 21,
      "title": "영화 영화",
      "content": "보고싶다",
      "emotionType": "happy",
      "emotionLevel": 4,
      "private": 0,
      "weather": null,
      "category": "movie",
      "categoryScore": null,
      "createdAt": "2021-09-12T21:42:40.567Z",
      "updatedAt": "2021-09-12T21:42:40.661Z",
      "deletedAt": null,
      "userId": 1,
      "movieId": 1,
      "bookId": null,
      "train": false,
      "FTVector": "[-8.93709287e-02  4.55319807e-02  4.07666862e-02 -2.46889535e-02\n  1.90205183e-02  1.36115536e-01  6.32665679e-02  4.42459643e-01\n  1.95865214e-01 -9.08108503e-02  1.77156436e-03 -1.77739441e-01\n -3.65066640e-02 -2.00524062e-01  1.56549644e-02  6.44933358e-02\n  2.15869591e-01  6.25528246e-02  4.13581878e-01 -1.22825496e-01\n  2.35106289e-01  2.54637022e-02  5.71883954e-02  3.53091151e-01\n  2.84556125e-04  6.07549213e-02 -7.67135918e-02 -2.76137330e-02\n  4.48129714e-01 -1.14802592e-01]",
      "interest": null,
      "LDAVector": "[(0, 0.035811923), (1, 0.035811927), (2, 0.035812188), (3, 0.035811946), (4, 0.035811946), (5, 0.03581195), (6, 0.035811946), (7, 0.035811946), (8, 0.6776921), (9, 0.0358121)]",
      "isMyDiary": true,
      "Images": [],
      "BookApi": null,
      "MovieApi": {
        "id": 1,
        "movie": "스파이더맨: 노 웨이 홈",
        "director": "존 왓츠",
        "actors": "톰 홀랜드, 젠데이아 콜먼, 제이콥 배덜런, 베네딕트 컴버배치, 알프리드 몰리나, 존 파브로, 마리사 토메이",
        "playDate": "2021-01-01T00:00:00.000Z",
        "imgLink": "https://ssl.pstatic.net/imgmovie/mdi/mit110/2080/208077_P01_105043.jpg",
        "rating": 5,
        "createdAt": "2021-09-12T21:42:40.551Z",
        "updatedAt": "2021-09-12T21:42:40.551Z",
        "deletedAt": null
      },
      "Comments": [],
      "User": {
        "id": 1,
        "snsId": "1822802345",
        "provider": "kakao",
        "email": "wodnd101@naver.com",
        "nickname": "이재웅",
        "interest": "마음,나가,하루,오늘",
        "createdAt": "2021-09-07T01:37:53.707Z",
        "updatedAt": "2021-09-12T21:41:41.000Z",
        "deletedAt": null
      },
      "maxEmotion": null
    }),
    Diary.fromMap({
      "id": 20,
      "title": "책책",
      "content": "굿굿",
      "emotionType": "sad",
      "emotionLevel": 4,
      "private": 0,
      "weather": null,
      "category": "book",
      "categoryScore": null,
      "createdAt": "2021-09-12T21:22:44.598Z",
      "updatedAt": "2021-09-12T21:22:44.661Z",
      "deletedAt": null,
      "userId": 1,
      "movieId": null,
      "bookId": 1,
      "train": false,
      "FTVector": "[]",
      "interest": null,
      "LDAVector": "[(0, 0.1), (1, 0.1), (2, 0.1), (3, 0.1), (4, 0.1), (5, 0.1), (6, 0.1), (7, 0.1), (8, 0.1), (9, 0.1)]",
      "isMyDiary": true,
      "Images": [],
      "BookApi": {
        "id": 1,
        "book": "오늘 밤, 세계에서 이 사랑이 사라진다 해도 (매일 기억을 잃는 너와 두 번 다시 돌아갈 수 없는 사랑을 했다)",
        "author": "이치조 미사키",
        "publisher": "모모",
        "publishDate": "2021-06-21T00:00:00.000Z",
        "imgLink": "https://bookthumb-phinf.pstatic.net/cover/206/578/20657805.jpg?type=m1&udate=20210724",
        "rating": 4,
        "createdAt": "2021-09-12T21:22:44.581Z",
        "updatedAt": "2021-09-12T21:22:44.581Z",
        "deletedAt": null
      },
      "MovieApi": null,
      "Comments": [],
      "User": {
        "id": 1,
        "snsId": "1822802345",
        "provider": "kakao",
        "email": "wodnd101@naver.com",
        "nickname": "이재웅",
        "interest": "마음,나가,하루,오늘",
        "createdAt": "2021-09-07T01:37:53.707Z",
        "updatedAt": "2021-09-12T21:21:35.000Z",
        "deletedAt": null
      },
      "maxEmotion": null
    }),
    Diary.fromMap({
      "id": 18,
      "title": "refresh test",
      "content": "plz ",
      "emotionType": "sad",
      "emotionLevel": 4,
      "private": 0,
      "weather": null,
      "category": "diary",
      "categoryScore": null,
      "createdAt": "2021-09-12T01:56:14.218Z",
      "updatedAt": "2021-09-12T02:09:22.934Z",
      "deletedAt": null,
      "userId": 1,
      "movieId": null,
      "bookId": null,
      "train": true,
      "FTVector": "[]",
      "interest": null,
      "LDAVector":
          "[(0, 0.1), (1, 0.1), (2, 0.1), (3, 0.1), (4, 0.1), (5, 0.1), (6, 0.1), (7, 0.1), (8, 0.1), (9, 0.1)]",
      "isMyDiary": true,
      "Images": [],
      "BookApi": null,
      "MovieApi": null,
      "Comments": [],
      "User": {
        "id": 1,
        "snsId": "1822802345",
        "provider": "kakao",
        "email": "wodnd101@naver.com",
        "nickname": "이재웅",
        "interest": "마음,나가,하루,오늘",
        "createdAt": "2021-09-07T01:37:53.707Z",
        "updatedAt": "2021-09-12T03:27:38.000Z",
        "deletedAt": null
      }
    }),
    Diary.fromMap({
        "id": 17,
        "title": "코로나 언제끝날까",
        "content": "빨리 끝나면 좋겟다 ㅠㅠ",
        "emotionType": "sad",
        "emotionLevel": 4,
        "private": 0,
        "weather": null,
        "category": "diary",
        "categoryScore": null,
        "createdAt": "2021-08-12T01:51:16.182Z",
        "updatedAt": "2021-09-12T01:51:40.402Z",
        "deletedAt": null,
        "userId": 1,
        "movieId": null,
        "bookId": null,
        "train": true,
        "FTVector":
            "[-0.30431056 -0.16904986 -0.27980176 -0.06978452 -0.10139641 -0.09898415\n -0.20940782  0.03719494 -0.1243876   0.15883754  0.01748861  0.08735073\n  0.30142078 -0.35055625  0.01748873 -0.13669474 -0.01869111 -0.17241402\n -0.2243572   0.16535085  0.1044124  -0.14617948 -0.22707067 -0.07166664\n  0.14911655  0.06380609 -0.05396429  0.22655573  0.40509465  0.0871901 ]",
        "interest": null,
        "LDAVector":
            "[(0, 0.099998996), (1, 0.09999935), (2, 0.10000017), (3, 0.10000031), (4, 0.10000036), (5, 0.10000044), (6, 0.10000028), (7, 0.10000027), (8, 0.09999983), (9, 0.09999998)]",
        "isMyDiary": true,
        "Images": [],
        "BookApi": null,
        "MovieApi": null,
        "Comments": [],
        "User": {
          "id": 1,
          "snsId": "1822802345",
          "provider": "kakao",
          "email": "wodnd101@naver.com",
          "nickname": "이재웅",
          "interest": "마음,나가,하루,오늘",
          "createdAt": "2021-09-07T01:37:53.707Z",
          "updatedAt": "2021-09-12T03:27:38.000Z",
          "deletedAt": null
        }
      }),
    Diary.fromMap({
      "id": 16,
      "title": "안녕",
      "content": "요즘 날씨가 너무 좋네",
      "emotionType": "happy",
      "emotionLevel": 4,
      "private": 0,
      "weather": null,
      "category": "diary",
      "categoryScore": null,
      "createdAt": "2020-09-09T23:13:21.428Z",
      "updatedAt": "2021-09-09T23:16:14.620Z",
      "deletedAt": null,
      "userId": 1,
      "movieId": null,
      "bookId": null,
      "train": true,
      "FTVector":
      "[ 0.05188418 -0.1647434   0.08239437 -0.13845861 -0.09109246 -0.2520581\n  0.11716633  0.02929643  0.03344409  0.15160733 -0.22094262  0.05938878\n  0.19418834  0.09834186 -0.1106594   0.16409233 -0.18116386  0.15960538\n -0.35472658  0.07070341 -0.19672343 -0.32143942 -0.13095134  0.03703565\n  0.24843271  0.07788776  0.01921168  0.39771625  0.33990288  0.05708492]",
      "interest": null,
      "LDAVector":
      "[(0, 0.052077804), (1, 0.05208793), (2, 0.05207787), (3, 0.05207793), (4, 0.052077826), (5, 0.052077826), (6, 0.052078683), (7, 0.0520779), (8, 0.53128844), (9, 0.05207782)]",
      "isMyDiary": true,
      "Images": [],
      "BookApi": null,
      "MovieApi": null,
      "Comments": [],
      "User": {
        "id": 1,
        "snsId": "1822802345",
        "provider": "kakao",
        "email": "wodnd101@naver.com",
        "nickname": "이재웅",
        "interest": "마음,나가,하루,오늘",
        "createdAt": "2021-09-07T01:37:53.707Z",
        "updatedAt": "2021-09-12T03:27:38.000Z",
        "deletedAt": null
      }
    }),
    Diary.fromMap({
      "id": 13,
      "title": "서버 시간설정",
      "content": "서버 시간이랑 db시간설정을 한번 알아봐야할것 같네요!\n이번 멘토링때 한번 물어모는걸로...",
      "emotionType": "sad",
      "emotionLevel": 4,
      "private": 0,
      "weather": null,
      "category": "diary",
      "categoryScore": null,
      "createdAt": "2020-09-08T01:52:49.241Z",
      "updatedAt": "2021-09-08T02:09:22.905Z",
      "deletedAt": null,
      "userId": 1,
      "movieId": null,
      "bookId": null,
      "train": true,
      "FTVector":
      "[ 0.00918199 -0.14051837 -0.29528826 -0.07465594 -0.04173316  0.0741323\n -0.39194757  0.35659683 -0.09072872 -0.22055842 -0.18387769 -0.0399732\n -0.00428838  0.18204908  0.21979803  0.0315048   0.16419837 -0.05845897\n  0.35297906  0.03687278 -0.04215148  0.00148574  0.2221244  -0.06585093\n  0.24870251  0.128082    0.1494484  -0.28508982 -0.04857695 -0.16915669]",
      "interest": "설정,서버",
      "LDAVector":
      "[(0, 0.0999928), (1, 0.099990174), (2, 0.09999365), (3, 0.099994116), (4, 0.09999427), (5, 0.099994555), (6, 0.10001778), (7, 0.09999399), (8, 0.10003568), (9, 0.099992976)]",
      "isMyDiary": true,
      "Images": [],
      "BookApi": null,
      "MovieApi": null,
      "Comments": [
        {
          "id": 1,
          "emotionType": "sad",
          "emotionLevel": 2,
          "userEmotionType": "happy",
          "userEmotionLevel": 3,
          "accessType": 1,
          "createdAt": "2021-09-09T22:20:21.728Z",
          "updatedAt": "2021-09-09T22:20:21.728Z",
          "deletedAt": null,
          "userId": 4,
          "diaryId": 13
        }
      ],
      "User": {
        "id": 1,
        "snsId": "1822802345",
        "provider": "kakao",
        "email": "wodnd101@naver.com",
        "nickname": "이재웅",
        "interest": "마음,나가,하루,오늘",
        "createdAt": "2021-09-07T01:37:53.707Z",
        "updatedAt": "2021-09-12T03:27:38.000Z",
        "deletedAt": null
      }
    }),
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
              });
              _refreshController.refreshCompleted();
            },
            enablePullUp: true,
            onLoading: () async {
              setState(() {
                month=0;
                year=0;
              });
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
                    ? Text(
                        '다이어리가 없습니다.',
                        style: TextStyle(color: Colors.white),
                      )
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
                      //     : Padding(
                      //       padding: const EdgeInsets.fromLTRB(10,0,10,0),
                      //       child: Column(
                      //         children: [
                      //           Container(
                      //   color: Color(0xff3D3D3D),
                      //   child: Column(
                      //           children: [
                      //             MyDiaryHeader(
                      //               post: diary,
                      //             ),
                      //             GestureDetector(
                      //               // 리액션 상태 변경
                      //               onTap: () {
                      //                 Navigator.push(
                      //                   context,
                      //                   CupertinoPageRoute(
                      //                     builder: (BuildContext context) =>
                      //                     new MyDiaryDetail(
                      //                       post: diary,edit: true,),
                      //                     fullscreenDialog: true,
                      //                   ),
                      //                 );
                      //               },
                      //               child: Container(
                      //                 width: 331,
                      //                 padding: EdgeInsets.fromLTRB(
                      //                     20, 10, 20, 15),
                      //                 decoration: BoxDecoration(
                      //                   color: Colors.white,
                      //                   borderRadius:
                      //                   BorderRadius.circular(10),
                      //                 ),
                      //                 child: Column(
                      //                   crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //                   children: [
                      //                     //이미지가 있는경우
                      //                     diary.category == 'diary' ||
                      //                         diary.category == 'trip'
                      //                         ? diary.Images.isNotEmpty
                      //                         ? Container(
                      //                       padding:
                      //                       EdgeInsets.only(
                      //                           top: 5,
                      //                           bottom: 10),
                      //                       child: FadeInImage
                      //                           .assetNetwork(
                      //                         placeholder:
                      //                         'assets/loading300.gif',
                      //                         image:
                      //                         diary.Images[0],
                      //                         width: 300,
                      //                         height: 300,
                      //                         fit: BoxFit.cover,
                      //                       ),
                      //                     )
                      //                         : Container()
                      //                     //영화, 책 이미지 부분
                      //                         : Container(
                      //                       padding: EdgeInsets.only(
                      //                           top: 5, bottom: 10),
                      //                       child: FadeInImage
                      //                           .assetNetwork(
                      //                         placeholder:
                      //                         'assets/loading300.gif',
                      //                         image: diary.linkImg,
                      //                         width: 300,
                      //                         height: 300,
                      //                         fit: BoxFit.cover,
                      //                       ),
                      //                     ),
                      //                     Text(
                      //                       diary.content,
                      //                       overflow: TextOverflow.ellipsis,
                      //                       maxLines: 5,
                      //                       softWrap: false,
                      //                       style: TextStyle(
                      //                           color: Colors.black,
                      //                           height: 2,
                      //                           fontSize: 13),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //             Container(
                      //               margin:
                      //               EdgeInsets.fromLTRB(20, 15, 20, 15),
                      //               child: Row(
                      //                 mainAxisAlignment:
                      //                 MainAxisAlignment.spaceBetween,
                      //                 children: [
                      //                   Container(
                      //                       child: Row(
                      //                         children: [
                      //                           Padding(
                      //                             padding:
                      //                             const EdgeInsets.only(
                      //                                 right: 10.0),
                      //                             child:
                      //                             diary.maxEmotion != null
                      //                                 ? Image.asset(
                      //                               'assets/emotions/${diary.maxEmotion}.png',
                      //                               width: 25,
                      //                             )
                      //                                 : Container(),
                      //                           ),
                      //                           Text(
                      //                             '${diary.emotionCount}명',
                      //                             style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: 10,
                      //                                 fontWeight:
                      //                                 FontWeight.bold),
                      //                           ),
                      //                           Text(
                      //                             '의 커넥티가 감정을 표현했어요!',
                      //                             style: TextStyle(
                      //                                 color: Colors.white,
                      //                                 fontSize: 10),
                      //                           ),
                      //                         ],
                      //                       )),
                      //                   GestureDetector(
                      //                     onTap: () {
                      //                       Navigator.push(
                      //                         context,
                      //                         CupertinoPageRoute(
                      //                           builder: (BuildContext
                      //                           context) =>
                      //                           new MyDiaryDetail(
                      //                             post: diary,edit: true,),
                      //                         ),
                      //                       );
                      //                     },
                      //                     child: Container(
                      //                       width: 90,
                      //                       height: 25,
                      //                       decoration: BoxDecoration(
                      //                           borderRadius:
                      //                           BorderRadius.circular(
                      //                               30),
                      //                           border: Border.all(
                      //                               color: Colors.white,
                      //                               width: 1.5)),
                      //                       child: Center(
                      //                         child: Text(
                      //                           '자세히 보기 >',
                      //                           style: TextStyle(
                      //                               color: Colors.white,
                      //                               fontSize: 12),
                      //                         ),
                      //                       ),
                      //                     ),
                      //                   )
                      //                 ],
                      //               ),
                      //             )
                      //           ],
                      //   ),
                      // ),
                      //           Container(width: double.infinity,color: Color(0xff2D2D2D),height: 15,),
                      //         ],
                      //       ),
                      //     ),
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
}
