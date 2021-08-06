import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ReactionButtons extends StatefulWidget {
  final data;
  final visible;

  const ReactionButtons({Key key, this.data, this.visible}) : super(key: key);

  @override
  _ReactionButtonsState createState() => _ReactionButtonsState();
}

class _ReactionButtonsState extends State<ReactionButtons> {
  int selectedEmotion;
  int postCount;
  int emotionValue;

  @override
  void initState() {
    // TODO: implement initState
    //사용자 좋아요 정보 받아오기
    postCount = 0;
    super.initState();
  }

// 수정 하기
  void changeEmotion(emotion, value) {
    //db연결 필요
    if (value != null) {
      if (emotion == selectedEmotion) {
        setState(() {
          selectedEmotion = null;
          postCount = postCount - 1;
          emotionValue = null;
          print(selectedEmotion);
        });
      } else {
        setState(() {
          selectedEmotion = emotion;
          postCount = postCount + 1;
          emotionValue = value;
          print(selectedEmotion);
        });
      }
    } else {
      if (emotion == selectedEmotion) {
        setState(() {
          selectedEmotion = null;
          postCount = postCount - 1;
          emotionValue = null;
          print(selectedEmotion);
        });
      } else {
        print('cancel');
      }
    }
    //
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              postCount == 0
                  ? Text(
                      '가장 먼저 감정을 보내보세요!',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    )
                  : selectedEmotion == null
                      ? Row(
                          children: [
                            Text(
                              '$postCount명',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '의 커넥티가 감정을 표현했어요!',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        )
                      : Container(
                          child: Text(
                            '${emotionList[selectedEmotion - 1]}의 감정을 보냈어요!',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
            ],
          ),
        ),
        widget.visible
            ? Container(
                height: 150,
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 10,),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (selectedEmotion == 1 &&
                                    emotionValue != null) {
                                  changeEmotion(1, null);
                                } else {
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
                                            child: ValueSelector(emotion: 1),
                                          ));
                                  // Detect when it closes
                                  await bottomSheet.then((onValue) {
                                    print("value: $onValue");
                                    changeEmotion(1, onValue);
                                  });
                                }
                              },
                              child:
                                  selectedEmotion != 1 || emotionValue == null
                                      ? Image.asset(
                                          'assets/emotions/emotion_1.png',
                                          width: 40,
                                        )
                                      : Image.asset(
                                          'assets/emotions/emotion_1_on.png',
                                          width: 40,
                                        ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              '화남',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  height: 0.7),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (selectedEmotion == 2 &&
                                    emotionValue != null) {
                                  changeEmotion(2, null);
                                } else {
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
                                            child: ValueSelector(emotion: 2),
                                          ));
                                  // Detect when it closes
                                  await bottomSheet.then((onValue) {
                                    print("value: $onValue");
                                    changeEmotion(2, onValue);
                                  });
                                }
                              },
                              child:
                                  selectedEmotion != 2 || emotionValue == null
                                      ? Image.asset(
                                          'assets/emotions/emotion_2.png',
                                          width: 40,
                                        )
                                      : Image.asset(
                                          'assets/emotions/emotion_2_on.png',
                                          width: 40,
                                        ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              '놀람',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  height: 0.7),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (selectedEmotion == 3 &&
                                    emotionValue != null) {
                                  changeEmotion(3, null);
                                } else {
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
                                            child: ValueSelector(emotion: 3),
                                          ));
                                  // Detect when it closes
                                  await bottomSheet.then((onValue) {
                                    print("value: $onValue");
                                    changeEmotion(3, onValue);
                                  });
                                }
                              },
                              child:
                                  selectedEmotion != 3 || emotionValue == null
                                      ? Image.asset(
                                          'assets/emotions/emotion_3.png',
                                          width: 40,
                                        )
                                      : Image.asset(
                                          'assets/emotions/emotion_3_on.png',
                                          width: 40,
                                        ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              '기쁨',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  height: 0.7),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (selectedEmotion == 4 &&
                                    emotionValue != null) {
                                  changeEmotion(4, null);
                                } else {
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
                                            child: ValueSelector(emotion: 4),
                                          ));
                                  // Detect when it closes
                                  await bottomSheet.then((onValue) {
                                    print("value: $onValue");
                                    changeEmotion(4, onValue);
                                  });
                                }
                              },
                              child:
                                  selectedEmotion != 4 || emotionValue == null
                                      ? Image.asset(
                                          'assets/emotions/emotion_4.png',
                                          width: 40,
                                        )
                                      : Image.asset(
                                          'assets/emotions/emotion_4_on.png',
                                          width: 40,
                                        ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              '슬픔',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  height: 0.7),
                            ),
                          ],
                        ),
                        SizedBox(width: 10,),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(width: 20,),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (selectedEmotion == 5 &&
                                    emotionValue != null) {
                                  changeEmotion(5, null);
                                } else {
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
                                            child: ValueSelector(emotion: 5),
                                          ));
                                  // Detect when it closes
                                  await bottomSheet.then((onValue) {
                                    print("value: $onValue");
                                    changeEmotion(5, onValue);
                                  });
                                }
                              },
                              child:
                                  selectedEmotion != 5 || emotionValue == null
                                      ? Image.asset(
                                          'assets/emotions/emotion_5.png',
                                          width: 40,
                                        )
                                      : Image.asset(
                                          'assets/emotions/emotion_5_on.png',
                                          width: 40,
                                        ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              '역겨움',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  height: 0.7),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (selectedEmotion == 6 &&
                                    emotionValue != null) {
                                  changeEmotion(6, null);
                                } else {
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
                                            child: ValueSelector(emotion: 6),
                                          ));
                                  // Detect when it closes
                                  await bottomSheet.then((onValue) {
                                    print("value: $onValue");
                                    changeEmotion(6, onValue);
                                  });
                                }
                              },
                              child:
                                  selectedEmotion != 6 || emotionValue == null
                                      ? Image.asset(
                                          'assets/emotions/emotion_6.png',
                                          width: 40,
                                        )
                                      : Image.asset(
                                          'assets/emotions/emotion_6_on.png',
                                          width: 40,
                                        ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              '공포',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  height: 0.7),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (selectedEmotion == 7 &&
                                    emotionValue != null) {
                                  changeEmotion(7, null);
                                } else {
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
                                            child: ValueSelector(emotion: 7),
                                          ));
                                  // Detect when it closes
                                  await bottomSheet.then((onValue) {
                                    print("value: $onValue");
                                    changeEmotion(7, onValue);
                                  });
                                }
                              },
                              child:
                                  selectedEmotion != 7 || emotionValue == null
                                      ? Image.asset(
                                          'assets/emotions/emotion_7.png',
                                          width: 40,
                                        )
                                      : Image.asset(
                                          'assets/emotions/emotion_7_on.png',
                                          width: 40,
                                        ),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              '중립',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  height: 0.7),
                            ),
                          ],
                        ),
                        SizedBox(width: 20,),
                      ],
                    )
                  ],
                ),
              )
            : Container(),
      ],
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(30)),
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
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: emotionColorList[emotion - 1],
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 35, bottom: 15),
            child: Text(
              '${emotionList[emotion - 1]}의 정도를 나타내보세요!',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(2);
                  },
                  child: Column(
                    children: [
                      Container(
                        // 이모티콘 표정 적용
                        // child: Image.asset('assets/emotions/emotion_2_on.png'),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: detailColorList[emotion - 1][0],
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '1',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(4);
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: detailColorList[emotion - 1][1],
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '2',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(6);
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: detailColorList[emotion - 1][2],
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '3',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(8);
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: detailColorList[emotion - 1][3],
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '4',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop(10);
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: detailColorList[emotion - 1][4],
                            borderRadius: BorderRadius.circular(50)),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '5',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}



List emotionList = ["화남", "놀람", "기쁨", "슬픔", "역겨움", "공포", "중립"];
List emotionColorList = [
  Color(0xffFF9082),
  Color(0xffFD7F8B),
  Color(0xffFFD275),
  Color(0xff7DDEF6),
  Color(0xff79D3BA),
  Color(0xffAE81A2),
  Color(0xffAAB2BD),
];
List<List> detailColorList = [
  [
    Color(0xffFFE9E6),
    Color(0xffFFE9E6),
    Color(0xffFFBDB4),
    Color(0xffFFA69B),
    Color(0xffFF9082),
  ],
  [
    Color(0xffFFE5E8),
    Color(0xffFECCD1),
    Color(0xffFEB2B9),
    Color(0xffFD99A2),
    Color(0xffFD7F8B),
  ],
  [
    Color(0xffFFF6E3),
    Color(0xffFFEDC8),
    Color(0xffFFE4AC),
    Color(0xffFFDB91),
    Color(0xffFFD275),
  ],
  [
    Color(0xffE5F8FD),
    Color(0xffCBF2FB),
    Color(0xffB1EBFA),
    Color(0xff97E5F8),
    Color(0xff97E5F8),
  ],
  [
    Color(0xffE4F6F1),
    Color(0xffC9EDE3),
    Color(0xffAFE5D6),
    Color(0xff94DCC8),
    Color(0xff79D3BA),
  ],
  [
    Color(0xffEFE6EC),
    Color(0xffDFCDDA),
    Color(0xffCEB3C7),
    Color(0xffBE9AB5),
    Color(0xffAE81A2),
  ],
  [
    Color(0xffEEF0F2),
    Color(0xffDDE0E5),
    Color(0xffCCD1D7),
    Color(0xffBBC1CA),
    Color(0xffAAB2BD),
  ],
];