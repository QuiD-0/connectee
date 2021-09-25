import 'package:connectee/widget/my/edit_profile.dart';
import 'package:connectee/widget/diary/othersDiary.dart';
import 'package:connectee/widget/my/infos/noti_setting.dart';
import 'package:connectee/widget/my/infos/open_source.dart';
import 'package:connectee/widget/my/infos/private.dart';
import 'package:connectee/widget/my/infos/rules.dart';
import 'package:connectee/widget/my/infos/service.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class MyPage extends StatefulWidget {
  const MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String userId;
  String token;
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
    "diaryCount": 100,
    'commentCount': 100,
    'profileImage':
        'https://images.unsplash.com/photo-1632265345980-acae0fe74e12?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1974&q=80',
  };

  @override
  void initState() {
    // TODO: implement initState
    _getId().then((res) {});
    super.initState();
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      token = prefs.getString('access_token');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'MY',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                //사용자 카드
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
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
                            //사용자 정보
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          width: 160,
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
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(CupertinoPageRoute(
                                              builder: (BuildContext context) =>
                                                  new EditProfile(),
                                              fullscreenDialog: true,
                                            ));
                                          },
                                          child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 5, 10, 5),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff3D3D3D),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Text(
                                                '수정',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        )
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
                        decoration: BoxDecoration(
                          color: Color(0xff2D2D2D),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(13),
                              bottomLeft: Radius.circular(13)),
                        ),
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
                      )
                    ],
                  ),
                ),
                //앱설정
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xff2d2d2d),
                        borderRadius: BorderRadius.circular(13)),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            '앱설정',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Color(0xff4D4D4D),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                              builder: (BuildContext context) => new Notify(),
                              fullscreenDialog: true,
                            ));
                          },
                          child: Container(
                            color: Color(0xff2d2d2d),
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '알람 기능',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Color(0xff4D4D4D),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                              builder: (BuildContext context) => new Rules(),
                              fullscreenDialog: true,
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff2d2d2d),
                                borderRadius: BorderRadius.circular(13)),
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '다이어리 이용 규칙',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //이용안내
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xff2d2d2d),
                        borderRadius: BorderRadius.circular(13)),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            '이용안내',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Color(0xff4D4D4D),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                              builder: (BuildContext context) => new Service(),
                              fullscreenDialog: true,
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff2d2d2d),
                                borderRadius: BorderRadius.circular(13)),
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '서비스 이용약관',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Color(0xff4D4D4D),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                              builder: (BuildContext context) => new Private(),
                              fullscreenDialog: true,
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff2d2d2d),
                                borderRadius: BorderRadius.circular(13)),
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '개인정보 처리방침',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 1,
                          width: double.infinity,
                          color: Color(0xff4D4D4D),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(CupertinoPageRoute(
                              builder: (BuildContext context) =>
                                  new OpenSource(),
                              fullscreenDialog: true,
                            ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff2d2d2d),
                                borderRadius: BorderRadius.circular(13)),
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '오픈소스 라이선스',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                //임시버튼
                GestureDetector(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    await AccessTokenStore.instance.clear();
                    Phoenix.rebirth(context);
                  },
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 40,
                      child: Center(child: Text('로그아웃')),
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// 앱 재실행
// GestureDetector(
//               onTap: () async {
//                 final prefs = await SharedPreferences.getInstance();
//                 prefs.clear();
//                 await AccessTokenStore.instance.clear();
//                 Phoenix.rebirth(context);
//               },
//               child: Center(
//                 child: Container(
//                   width: 100,
//                   height: 40,
//                   child: Center(child: Text('로그아웃')),
//                   color: Colors.redAccent,
//                 ),
//               ),
//             )
