import 'dart:convert';
import 'package:connectee/screen/write_diary.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:connectee/vars.dart';
import 'package:connectee/widget/home/DetailCard/detail_contents.dart';
import 'package:connectee/widget/home/RecCard/rec_card_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DiaryDetail extends StatefulWidget {
  final post;
  final myEmotion;
  final groupName;

  const DiaryDetail({Key key, this.post, this.myEmotion, this.groupName})
      : super(key: key);

  @override
  _DiaryDetailState createState() => _DiaryDetailState();
}

class _DiaryDetailState extends State<DiaryDetail> {
  int selectedEmotion;
  int emotionValue;
  String prevEmotion;
  int prevEmotionValue;
  String userId;
  int myCommentId;
  int access;
  var data;

  @override
  void initState() {
    if (widget.myEmotion != null) {
      selectedEmotion = engToInt[widget.myEmotion[0]];
      emotionValue = widget.myEmotion[1];
      prevEmotion = widget.myEmotion[0];
      prevEmotionValue = widget.myEmotion[1];
      myCommentId = widget.myEmotion[2];
    }
    _getId();
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var post = widget.post;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName ?? '추천 다이어리',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
          // 내 리액션 뒤로 넘기기
          onPressed: () async {
            _postEmotion();
            Navigator.of(context)
                .pop([intToEng[selectedEmotion], emotionValue, myCommentId]);
          },
        ),
        actions: [
          int.parse(userId)!=widget.post.userId?IconButton(
            icon: new Icon(
              Icons.flag_rounded,
              size: 22,
            ),
            onPressed: () async{
              var res =await _report();
              if (res){
                report_user(widget.post.userId);
              }
            },
          ):Container(),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 360,
                decoration: BoxDecoration(
                    color: Color(0xff3d3d3d),
                    borderRadius: BorderRadius.circular(13)),
                child: Column(
                  children: [
                    RecCardHeader(
                      data: post,
                    ),
                    DetailContents(
                      data: post,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //내 리액션리스트에 있는지 확인후 출력
                                Container(
                                  height: 30,
                                  // 내가 표현한 감정 표시
                                  child: Row(
                                    children: [
                                      post.emotionCount == 0 &&
                                              selectedEmotion == null
                                          ? Text(
                                              '가장 먼저 감정을 보내보세요!',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            )
                                          : selectedEmotion == null
                                              ? Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10.0),
                                                      child: post.maxEmotion !=
                                                              null
                                                          ? Image.asset(
                                                              'assets/emotions/${post.maxEmotion}.png',
                                                              width: 25,
                                                            )
                                                          : Container(),
                                                    ),
                                                    Text(
                                                      '${post.emotionCount.toString()}명',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '의 커넥티가 감정을 표현했어요!',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10.0),
                                                      child: Image.asset(
                                                        'assets/emotions/${intToEng[selectedEmotion]}.png',
                                                        width: 25,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${emotionList[selectedEmotion - 1]}',
                                                      style: TextStyle(
                                                          color: emotionColorList[
                                                              selectedEmotion -
                                                                  1],
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      '의 감정을 보냈어요!',
                                                      style: TextStyle(
                                                          color: emotionColorList[
                                                              selectedEmotion -
                                                                  1],
                                                          fontSize: 12),
                                                    ),
                                                  ],
                                                )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                              height: 170,
                              width: 250,
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  for (var i in [1, 2, 3, 4, 5, 6, 7])
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                              onTap: () async {
                                                if (selectedEmotion == i &&
                                                    emotionValue != null) {
                                                  changeEmotion(i, null);
                                                } else {
                                                  var bottomSheet =
                                                      showModalBottomSheet(
                                                          useRootNavigator:
                                                              true,
                                                          isDismissible: true,
                                                          isScrollControlled:
                                                              true,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          13.0)),
                                                          backgroundColor:
                                                              Color(0xff2d2d2d),
                                                          context: context,
                                                          builder: (context) =>
                                                              Container(
                                                                child:
                                                                    ValueSelector(
                                                                        emotion:
                                                                            i),
                                                              ));
                                                  // Detect when it closes
                                                  await bottomSheet
                                                      .then((onValue) {
                                                    changeEmotion(i, onValue);
                                                  });
                                                }
                                              },
                                              child: Container(
                                                width: 45,
                                                height: 45,
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    selectedEmotion != i ||
                                                            emotionValue == null
                                                        ? Image.asset(
                                                            'assets/emotions/emotion_$i.png',
                                                            width: 40,
                                                          )
                                                        : Image.asset(
                                                            'assets/emotions/emotion_${i}_on.png',
                                                            width: 45,
                                                          ),
                                                    Image.asset(
                                                      'assets/emotions/$i.png',
                                                      width: 24,
                                                    ),
                                                  ],
                                                ),
                                              )),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            engToKor[intToEng[i]],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _report() {
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color(0x99000000),
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.fromLTRB(20, 40, 20, 10),
        elevation: 0,
        backgroundColor: Color(0xff3D3D3D),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        title: Text(
          '신고하기',
          textAlign: TextAlign.center,
        ),
        titleTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: 'GmarketSans',
            fontWeight: FontWeight.bold),
        content: Text(
          '해당 사용자를 신고하시겟습니까?',
          textAlign: TextAlign.center,
        ),
        contentTextStyle: TextStyle(
            fontSize: 16, color: Colors.white, fontFamily: 'GmarketSans'),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FlatButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('취소',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'GmarketSans')),
              ),
              FlatButton(
                onPressed: () => Navigator.pop(context, true),
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
  }
  _getMainEmotion() {
    if (data == null) {
      return [null, null];
    } else {
      String emotion = data.split(',')[0];
      String value = data.split(',')[1];
      return [emotion, value];
    }
  }

  void _postEmotion() {
    if (prevEmotion == null) {
      if (selectedEmotion != null) {
        //댓글을 새로 다는경우
        create();
      } else {
        //댓글 아무것도 안하는경우
        null;
      }
    } else if (prevEmotion != null) {
      if (selectedEmotion != null) {
        //댓글 수정하는경우
        if (prevEmotion == selectedEmotion) {
          if (prevEmotionValue == emotionValue) {
            //감정, 수치 그대로
            null;
          } else {
            //감정은 그대로 수치만 변경
            update();
          }
        } else {
          //다른감정으로 수정
          update();
        }
      } else {
        //댓글 삭제하는경우
        delete();
      }
    }
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      access = prefs.getInt("access");
    });
  }

  void create() async {
    var data = _getMainEmotion();
    var body = {
      "userEmotionType": data[0],
      "userEmotionLevel": data[1],
      "accessType": access,
      "emotionType": intToEng[selectedEmotion],
      "emotionLevel": emotionValue,
      "userId": int.parse(userId),
      "diaryId": widget.post.diaryId,
    };
    await http
        .post(Uri.parse('http://52.79.146.213:5000/comments'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body))
        .then((res) {
      print(res.body);
    });
  }

  void update() async {
    var data = _getMainEmotion();
    var body = {
      "userEmotionType": data[0],
      "userEmotionLevel": data[1],
      "accessType": access,
      "emotionType": intToEng[selectedEmotion],
      "emotionLevel": emotionValue,
      "userId": int.parse(userId),
      "diaryId": widget.post.diaryId,
    };
    await http
        .patch(Uri.parse('http://52.79.146.213:5000/comments/$myCommentId'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(body))
        .then((res) {
      // print(res.body);
    });
  }

  void delete() async {
    await http
        .delete(Uri.parse('http://52.79.146.213:5000/comments/$myCommentId'))
        .then((res) {
      //print(res.body);
    });
  }

  void changeEmotion(emotion, value) {
    if (value != null) {
      if (emotion == selectedEmotion) {
        setState(() {
          selectedEmotion = null;
          emotionValue = null;
        });
      } else {
        setState(() {
          selectedEmotion = emotion;
          emotionValue = value;
        });
      }
    } else {
      if (emotion == selectedEmotion) {
        setState(() {
          selectedEmotion = null;
          emotionValue = null;
        });
      } else {
        //print('cancel');
      }
    }
    //
  }

  void _getData() async {
    String day = DateTime.now().year.toString() +
        '-' +
        DateTime.now().month.toString() +
        '-' +
        DateTime.now().day.toString();
    var prefs = await SharedPreferences.getInstance();
    data = prefs.getString(day);
  }

  report_user(reportId) async{
    var body = {
      "fromUser": userId,
      "toUser": reportId,
    };
    await http
        .patch(Uri.parse('http://52.79.146.213:5000/users/report'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body))
        .then((res) {
      _toast("신고가 완료되었습니다");
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
}

class ValueSelector extends StatelessWidget {
  final emotion;

  const ValueSelector({Key key, this.emotion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Column(
        children: [
          Container(
            width: 65,
            height: 5,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${emotionList[emotion - 1]}',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  '의 감정을 보내시나요?',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/emotions/${intToEng[emotion]}_big.png',
          ),
          Container(
            margin: EdgeInsets.only(top: 35, bottom: 15),
            child: Text(
              '${emotionList[emotion - 1]}의 정도를 나타내보세요!',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(10),
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              children: [
                for (var i in [1, 2, 3, 4, 5])
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop(i);
                    },
                    child: Column(
                      children: [
                        Container(
                          // 이모티콘 표정 적용
                          child: Image.asset('assets/emotions/$emotion.png'),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              color: detailColorList[emotion - 1][i - 1],
                              borderRadius: BorderRadius.circular(50)),
                        ),
                        SizedBox(height: 5),
                        Text(
                          i.toString(),
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
