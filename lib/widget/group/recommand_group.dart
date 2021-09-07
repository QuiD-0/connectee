import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RecommandGroup extends StatefulWidget {
  const RecommandGroup({Key key}) : super(key: key);

  @override
  _RecommandGroupState createState() => _RecommandGroupState();
}

class _RecommandGroupState extends State<RecommandGroup> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List recGroup = [
    {
      "id": 7,
      "title": "테스트그룹",
      "description": "그룹 설명",
      "limitMembers": 10,
      "private": false,
      "password": "1234",
      "OwnerId": 2,
      "createdAt": "2021-08-29T05:27:02.441Z",
      "updatedAt": "2021-08-29T05:27:02.441Z",
      "deletedAt": null,
      "imageUrl": "https://sw-connectee-s3.s3.ap-northeast-2.amazonaws.com/original/image_cropper_1630215202837.jpg",
      "GroupUsers": [
        {
          "GroupId": 7,
          "UserId": 2,
          "createdAt": "2021-08-29T05:27:02.476Z",
          "updatedAt": "2021-08-29T05:27:02.476Z",
          "deletedAt": null
        }
      ],
      "groupUserCount": 1,
      "themes": [
        {
          "id": 2,
          "name": "여행",
          "createdAt": "2021-08-23T04:30:07.031Z",
          "updatedAt": "2021-08-23T04:30:07.031Z",
          "deletedAt": null
        },
        {
          "id": 4,
          "name": "운동",
          "createdAt": "2021-08-23T04:30:07.069Z",
          "updatedAt": "2021-08-23T04:30:07.069Z",
          "deletedAt": null
        }
      ]
    },
  ];
  String userId;
  String token;
  String nickname;

  @override
  void initState() {
    // TODO: implement initState
    _getId().then((res) {
      //사용자 닉네임 받아오기
      _getUserNickname();
      //추천그룹 리스트 받아오기
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: MaterialClassicHeader(
        color: Colors.white,
        backgroundColor: Color(0xff3d3d3d),
      ),
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: () {
        setState(() {
          //추천 그룹리스트 새로 받아오기

        });
        _refreshController.refreshCompleted();
      },
      child: ListView(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
        children: [
          //헤더
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, left: 16),
              child: Text(
                '$nickname님에게 추천해요!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            width: 360,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(13), topRight: Radius.circular(13)),
              color: Color(0xff2d2d2d),
            ),
          ),
          //추천 리스트
          for (var group in recGroup)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    //바텀 시트로 연결
                    var bottomSheet = showModalBottomSheet(
                        useRootNavigator: true,
                        isDismissible: true,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13.0)),
                        backgroundColor: Color(0xff2d2d2d),
                        context: context,
                        builder: (context) => Container(
                              child: ConnectSheet(group),
                            ));
                    bottomSheet.then((value) {
                      if (value==true){
                        //그룹 체크인 완료후 디테일 페이지로 가기
                        _toast('참여완료!');
                      }
                    });
                  },
                  //그룹 카드
                  child: Container(
                    width: double.infinity,
                    height: 115,
                    color: Color(0xff3d3d3d),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //그룹 이미지
                        Container(
                          width: 120,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                group['imageUrl'],
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        //그룹 정보
                        Container(
                          width: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //그룹이름
                              Container(
                                width: 200,
                                child: Text(
                                  group['title'],
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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
                                    '   (${group['groupUserCount']}/${group['limitMembers']})  |  ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  Text(
                                    group['private'] ? '비공개' : '공개',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              //그룹 토픽
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 200,
                                    child: Row(
                                      children: [
                                        for (var i in group['themes'])
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  11, 3, 11, 3),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: Text(
                                                "#${i['name']}",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Color(0xff2d2d2d),
                ),
              ],
            ),
          //하단
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
            ),
            width: 360,
            height: 10,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(13),
                  bottomRight: Radius.circular(13)),
              color: Color(0xff2d2d2d),
            ),
          ),
        ],
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

  _toast(msg) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

  Widget ConnectSheet(group) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
          height: 450,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  height: 5,
                  width: 65,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: 120,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      group['imageUrl'],
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  width: 250,
                  alignment: Alignment.center,
                  child: Text(
                    group['title'],
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i in group['themes'])
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        padding: EdgeInsets.fromLTRB(11, 3, 11, 3),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30)),
                        child: Text(
                          "#${i['name']}",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Text(
                    '   |   ',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  Image.asset(
                    'assets/icons/user.png',
                    height: 14,
                    width: 12,
                    fit: BoxFit.contain,
                  ),
                  Text(
                    '  (${group['groupUserCount'].toString()}/${group['limitMembers'].toString()})',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(30),
                  child: Container(
                    height: 50,
                    child: Text(
                      group['description'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white, fontSize: 12, height: 1.7),
                    ),
                  )),
              GestureDetector(
                onTap: (){
                  //그룹 참가
                  Navigator.pop(context,true);
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 311,
                  height: 48,
                  decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),
                  child: Text('CONNECT!',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                ),
              )
            ],
          ));
    });
  }

  void _getUserNickname() async{
    await http.get(Uri.parse('http://52.79.146.213:5000/users/myInfo'),headers: {
      "Authorization": "Bearer $token"
    } ).then((value){
      if (value.statusCode == 200) {
        String jsonString = value.body;
        var result = json.decode(jsonString);
        setState(() {
          nickname=result['nickname'];
        });
      }
    });
  }


}
