import 'dart:convert';
import 'package:connectee/model/groupModel.dart';
import 'package:connectee/widget/group/group_detail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupSearch extends StatefulWidget {
  const GroupSearch({Key key}) : super(key: key);

  @override
  _GroupSearchState createState() => _GroupSearchState();
}

class _GroupSearchState extends State<GroupSearch> {
  var txt = TextEditingController();
  bool visibleRecent;
  List searchData = [];
  List<String> recent = [];

  @override
  void initState() {
    // TODO: implement initState
    visibleRecent = true;
    _getList();
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
          centerTitle: true,
          title: Text(
            "검색",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              //검색창
              Container(
                height: 48,
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Color(0xff2d2d2d),
                    borderRadius: BorderRadius.circular(13)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 15),
                        width: 300,
                        child: TextField(
                          controller: txt,
                          onSubmitted: (value) {
                            if (txt.text != '') {
                              _saveList(txt.text);
                              //최근 검색어 끄기
                              setState(() {
                                visibleRecent = false;
                              });
                              //api통신, 빈칸이면 보내기 X
                              _searchGroup(txt.text);
                            }
                          },
                          onChanged: (text) {
                            if (text == "") {
                              setState(() {
                                visibleRecent = true;
                                searchData = [];
                              });
                            }
                          },
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.white,
                        )),
                    IconButton(
                        splashColor: Colors.transparent,
                        onPressed: () {
                          //검색어 저장
                          if (txt.text != '') {
                            _saveList(txt.text);
                            //최근 검색어 끄기
                            setState(() {
                              visibleRecent = false;
                            });
                            //api통신, 빈칸이면 보내기 X
                            _searchGroup(txt.text);
                          }
                        },
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              // 최근 검색어
              visibleRecent && recent.isNotEmpty
                  ? Padding(
                padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                child: Container(
                  constraints: BoxConstraints(minHeight: 100),
                  decoration: BoxDecoration(
                    color: Color(0xff2d2d2d),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '최근 검색어',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                              decoration: BoxDecoration(
                                  color: Color(0xff4d4d4d),
                                  borderRadius:
                                  BorderRadius.circular(30)),
                              child: GestureDetector(
                                onTap: () async {
                                  _deleteAll();
                                  _getList();
                                },
                                child: Text('전체삭제',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12)),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          children: recent.reversed
                              .map((item) =>
                              GestureDetector(
                                onTap: () {
                                  print(item);
                                  txt.text = item;
                                  txt
                                    ..selection =
                                    TextSelection.fromPosition(
                                      TextPosition(
                                          offset: txt.text.length),
                                    );
                                },
                                child: Container(
                                  margin: EdgeInsets.all(5),
                                  padding: EdgeInsets.fromLTRB(
                                      13, 5, 10, 5),
                                  decoration: BoxDecoration(
                                      color: Color(0xff9D9D9D),
                                      borderRadius:
                                      BorderRadius.circular(13)),
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    children: [
                                      Text(item),
                                      Padding(
                                          padding:
                                          const EdgeInsets.only(
                                              left: 3, top: 1),
                                          child: GestureDetector(
                                            onTap: () {
                                              _delete(item);
                                            },
                                            child: Icon(
                                              Icons.clear_rounded,
                                              size: 14,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ))
                              .toList()
                              .cast<Widget>(),
                        )
                      ],
                    ),
                  ),
                ),
              )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              //검색 결과
              visibleRecent == false
                  ? ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: searchData.length + 1,
                  itemBuilder: (context, index) {
                    if (searchData.length != 0 && index == 0) {
                      return Container(
                        alignment: Alignment.center,
                        height: 70,
                        child: Text(
                          '${txt.text} 검색 결과 ${searchData.length}건',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      );
                    } else if (searchData.length == 0 && index == 0) {
                      return Container(
                        alignment: Alignment.bottomCenter,
                        height: 300,
                        child: Text(
                          '검색결과가 없습니다.',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      );
                    } else {
                      //검색결과 카드
                      var group = searchData[index - 1];
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            //비번방 OR 공개방
                            var bottomSheet = showModalBottomSheet(
                                useRootNavigator: true,
                                isDismissible: true,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(13.0)),
                                backgroundColor: Color(0xff2d2d2d),
                                context: context,
                                builder: (context) =>
                                    Container(
                                      child: ConnectSheet(group),
                                    ));
                            bottomSheet.then((value) {
                              if (value == true) {
                                //그룹 체크인 완료후 디테일 페이지로 가기
                                Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                  return GroupDetail(group: Group.fromMap(group));
                                }));
                              }
                            });
                          },
                          child: Container(
                            width: double.infinity,
                            height: 115,
                            decoration: BoxDecoration(
                                color: Color(0xff3d3d3d),
                                borderRadius: BorderRadius.circular(13)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //그룹 이미지
                                group['imageUrl'] != null
                                    ? Container(
                                  width: 120,
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(50),
                                      child: Image.network(
                                        group['imageUrl'],
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                                    : Container(
                                  width: 120,
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(50),
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
                                  width: 250,
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
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
                                                color: Colors.white,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            group['private'] ? '비공개' : '공개',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
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
                                                for (var i
                                                in group['themes'])
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets
                                                        .only(
                                                        right: 10),
                                                    child: Container(
                                                      padding: EdgeInsets
                                                          .fromLTRB(
                                                          11, 3, 11, 3),
                                                      decoration: BoxDecoration(
                                                          color:
                                                          Colors.white,
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              30)),
                                                      child: Text(
                                                        "#${i['name']}",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            fontWeight:
                                                            FontWeight
                                                                .bold),
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
                      );
                    }
                  })
                  : Container()
            ],
          ),
        ));
  }
  _searchGroup(text) async {
    var data= {'searchName': text.toString()};
    setState(() {
      searchData=[];
    });
    await http.post(Uri.parse(
        'http://52.79.146.213:5000/groups/search'),
        body: json.encode(data),headers: {'Content-Type':'application/json'}).then((value) {
      if (value.statusCode == 201) {
        String jsonString = value.body;
        var result = json.decode(jsonString);
        for (var i in result) {
          setState(() {
            searchData.add(i);
          });
        }
      }
    });
  }

  _getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recent = prefs.getStringList('recent') ?? [];
    });
  }

  _saveList(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (data != '') {
      if (!recent.contains(data)) {
        if (recent.length == 10) {
          recent.removeAt(0);
        }
        recent.add(data.toString());
        await prefs.setStringList("recent", recent);
      }
    }
  }

  _delete(String item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      recent.remove(item);
    });
    await prefs.setStringList("recent", recent);
  }

  _deleteAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      recent = [];
    });
    await prefs.setStringList("recent", recent);
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
                  Container(
                    width: 120,
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: group['imageUrl'] != null
                            ? Image.network(
                          group['imageUrl'],
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        )
                            : Container(
                          color: Color(0xffFF9082),
                          width: 100,
                          height: 100,
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
                          print('성공');
                          Navigator.pop(context, true);
                        } else {
                          print('실패');
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


}
