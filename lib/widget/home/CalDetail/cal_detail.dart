import 'dart:convert';
import 'package:connectee/model/post.dart';
import 'package:connectee/screen/write_diary.dart';
import 'package:connectee/vars.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalDetail extends StatefulWidget {
  final date;
  final emotion;

  const CalDetail({Key key, this.date, this.emotion}) : super(key: key);

  @override
  _CalDetailState createState() => _CalDetailState();
}

class _CalDetailState extends State<CalDetail> {
  String mainEmotion;
  List emotions = [];
  List diarys = [];
  String userId;

  @override
  void initState() {
    // TODO: implement initState
    mainEmotion = widget.emotion;
    _getId().then((res) {
      _fetchDiary();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.date.toString().split(' ')[0].replaceAll('-', '.')}",
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
            onPressed: () async {
              Navigator.of(context).pop([widget.date, mainEmotion]);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff2d2d2d),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13)),
                  ),
                  constraints: BoxConstraints(minHeight: 200),
                  child: Column(children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        '${widget.date.month}월 ${widget.date.day}일의 대표감정',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    Image.asset('assets/emotions/${mainEmotion}_big.png'),
                    emotions.length != 1
                        ? GestureDetector(
                            onTap: () async {
                              var bottomSheet = showModalBottomSheet(
                                  useRootNavigator: true,
                                  isDismissible: true,
                                  isScrollControlled: true,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(13.0)),
                                  backgroundColor: Color(0xff2d2d2d),
                                  context: context,
                                  builder: (context) => Container(
                                        child: ValueSelector(
                                          emotions: emotions,
                                          mainEmotion: mainEmotion,
                                        ),
                                      ));
                              await bottomSheet.then((onValue) {
                                if (onValue != null) {
                                  setState(() {
                                    mainEmotion = onValue;
                                  });
                                }
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Color(0xff3d3d3d),
                                    borderRadius: BorderRadius.circular(13)),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 25, bottom: 25),
                                  child: Text('대표감정 수정하기',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white)),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 15,
                    ),
                  ]),
                ),
                Container(
                  height: 1,
                  color: Color(0xff4D4D4D),
                ),
                ListView.separated(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: diarys.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == diarys.length) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 10),
                        height: 10,
                        decoration: BoxDecoration(
                          color: Color(0xff2d2d2d),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(13),
                              bottomRight: Radius.circular(13)),
                        ),
                      );
                    } else {
                      return Container(
                        height: 50,
                        width: double.infinity,
                        color: Colors.white,
                        child: Text('diaryId: ${diarys[index].diaryId}'),
                      );
                    }
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Container(
                    height: 20,
                    color: Color(0xff2D2D2D),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void _fetchDiary() async {
    await http
        .get(Uri.parse(
            'http://52.79.146.213:5000/diaries/fetch?userId=1&page=1&limit=5'))
        .then((res) {
      if (res.statusCode == 200) {
        String jsonString = res.body;
        List data = jsonDecode(jsonString);
        for (int i = 0; i < data.length; i++) {
          var post = data[i];
          Diary diaryToAdd = Diary.fromMap(post);
          setState(() {
            diarys.add(diaryToAdd);
          });
        }
      }
      _getEmotions();
    });
  }

  void _getEmotions() {
    for (var i = 0; i < diarys.length; i++) {
      if (!emotions.contains(diarys[i].emotionType)) {
        setState(() {
          emotions.add(diarys[i].emotionType);
        });
      }
    }
    if (emotions.length > 1) {
      _sortEmotion();
    }
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  void _sortEmotion() {
    List vals = [];
    for (var i = 0; i < emotions.length; i++) {
      vals.add(engToInt[emotions[i]]);
    }
    vals.sort();
    emotions = [];

    for (var i = 0; i < vals.length; i++) {
      setState(() {
        emotions.add(intToEng[vals[i]]);
      });
    }
  }
}

class ValueSelector extends StatelessWidget {
  final emotions;
  final mainEmotion;

  const ValueSelector({Key key, this.emotions, this.mainEmotion})
      : super(key: key);

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
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '대표 감정',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                Text(
                  '을 수정하시겠습니까?',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 230,
              alignment: Alignment.topCenter,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  for (var i in emotions)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 20, 10, 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(i);
                        },
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              // 이모티콘 표정 적용
                              child: i != mainEmotion
                                  ? Image.asset(
                                      'assets/emotions/${i}_big.png',
                                      width: 66,
                                      fit: BoxFit.fitWidth,
                                    )
                                  : Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Color(0xff2d2d2d),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                              width: 1,
                                              color: emotionColorList[
                                                  engToInt[i] - 1],
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/emotions/${i}.png',
                                          width: 59,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ],
                                    ),
                              width: 66,
                              height: 66,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            SizedBox(height: 10),
                            Text(
                              engToKor[i],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Text(
            '대표 감정은 캘린더에 표시됩니다',
            style: TextStyle(color: Colors.white, fontSize: 9),
          )
        ],
      ),
    );
  }
}
