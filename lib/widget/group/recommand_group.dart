import 'dart:convert';

import 'package:connectee/model/groupModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'group_detail.dart';

class RecommandGroup extends StatefulWidget {
  const RecommandGroup({Key key}) : super(key: key);

  @override
  _RecommandGroupState createState() => _RecommandGroupState();
}

class _RecommandGroupState extends State<RecommandGroup> {
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  List recGroup = [];
  String userId;
  String token;
  String nickname;

  List themes=['취미','여행','공부','운동','맛집','영화','사랑','책','애완동물','고민'];

  @override
  void initState() {
    // TODO: implement initState
    _getId().then((res) {
      //사용자 닉네임 받아오기
      _getUserNickname();
      //추천그룹 리스트 받아오기
      _getRecGroup();
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
                        builder: (context) =>
                            Container(
                              child: ConnectSheet(group),
                            ));
                    bottomSheet.then((value) {
                      if (value == true) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return GroupDetail(group: Group.fromMap(group));
                        }));
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
                        group['imageUrl'] != null ? Container(
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
                        ) : Container(
                          width: 120,
                          child: Center(
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(
                                  50),
                              child: Container(
                                height: 80,
                                width: 80,
                                color: Color(0xffFF9082),
                              ),
                            ),
                          ),
                        ),
                        //그룹 정보
                        Container(
                          width: 230,
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
                                        for (var i in group['GroupThemes'])
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
                                                "#${themes[i['ThemeId']-1]}",
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
      token = prefs.getString('access_token');
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
    TextEditingController pw = TextEditingController();
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
                  group['imageUrl'] != null ? Container(
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
                  ) : Container(
                    width: 120,
                    child: Center(
                      child: ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                            50),
                        child: Container(
                          height: 80,
                          width: 80,
                          color: Color(0xffFF9082),
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
                      for (var i in group['GroupThemes'])
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(11, 3, 11, 3),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "${themes[i['ThemeId']-1]}",
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
                        '${group['groupDiaryCount']}+ ',
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
                        '  (${group['groupUserCount']
                            .toString()}/${group['limitMembers'].toString()})',
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
                    onTap: () async {
                      //그룹 참가
                      if (group['password'] == '') {
                        _joinGroup(group['id'],pw.text);
                        Navigator.pop(context, true);
                      } else {
                        //비밀번호 확인창
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
                                  '비밀번호를 입력해주세요!',
                                  textAlign: TextAlign.center,
                                ),
                                titleTextStyle: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontFamily: 'GmarketSans',
                                    fontWeight: FontWeight.bold),
                                content: TextField(
                                  obscureText: true,
                                  obscuringCharacter: '●',
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    WhitelistingTextInputFormatter
                                        .digitsOnly
                                  ],
                                  controller: pw,
                                  maxLength: 6,
                                  maxLines: 1,
                                  showCursor: false,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff3D3D3D),
                                      height: 1.8),
                                  decoration: InputDecoration(
                                    hintText: '비밀번호를 입력해주세요',
                                    counterText: '',
                                    filled: true,
                                    fillColor: Color(0xff9d9d9d),
                                    contentPadding:
                                    const EdgeInsets.only(
                                        left: 20, bottom: 7),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(width: 0),
                                      borderRadius:
                                      BorderRadius.circular(5),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(width: 0),
                                      borderRadius:
                                      BorderRadius.circular(5),
                                    ),
                                  ),
                                ),
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
                                            Navigator.pop(context, ''),
                                        child: Text('취소',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontFamily: 'GmarketSans')),
                                      ),
                                      FlatButton(
                                        onPressed: () =>
                                            Navigator.pop(context, pw.text),
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
                        if (group['password'] == res) {
                          _joinGroup(group['id'],pw.text);
                          Navigator.pop(context, true);
                        } else {
                          _toast('비밀번호가 다릅니다');
                        }
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: 311,
                      height: 48,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        'CONNECT!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  void _getUserNickname() async {
    await http.get(
        Uri.parse('http://52.79.146.213:5000/users/myInfo'), headers: {
      "Authorization": "Bearer $token"
    }).then((value) {
      if (value.statusCode == 200) {
        String jsonString = value.body;
        var result = json.decode(jsonString);
        setState(() {
          nickname = result['nickname'];
        });
      }
    });
  }

  void _getRecGroup() async {
    await http.get(Uri.parse(
        'http://52.79.146.213:5000/groups/recommand?accessType=timeline'),
        headers: {"Authorization": "Bearer $token"}).then((value) {
          print(value);
      if (value.statusCode == 200) {
        String jsonString = value.body;
        var result = json.decode(jsonString);
        for (var i in result) {
          setState(() {
            recGroup.add(i);
          });
        }
      }
    });
  }

  _joinGroup(id, pw) async {
    var data = {
      "groupId": id,
      "userId": userId,
      "password": pw
    };
    await http.post(Uri.parse('http://52.79.146.213:5000/groups/addMember'),
        headers: {"Content-Type": "application/json"}, body: json.encode(data)).then((res){
          var result = json.decode(res.body);
          if(result['success']==true){
           print("성공");
          }
    });
  }


}
