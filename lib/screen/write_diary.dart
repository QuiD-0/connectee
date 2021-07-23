import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

List emotionList = ["화남", "놀람", "기쁨", "슬픔", "역겨움", "공포", "중립"];

class WriteDiary extends StatefulWidget {
  const WriteDiary({Key key}) : super(key: key);

  @override
  _WriteDiaryState createState() => _WriteDiaryState();
}

class _WriteDiaryState extends State<WriteDiary> {
  GlobalKey<FormBuilderState> fbkey = GlobalKey<FormBuilderState>();
  String type = "diary"; //default
  Map<String, String> types = {
    "diary": "일기",
    "trip": "여행",
    "movie": "영화",
    "book": "도서",
  };
  List images = [];
  int finalEmotion;
  int emotionValue;
  int selectEmotion;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
          backgroundColor: Color(0xff3d3d3d),
          appBar: AppBar(
            leading: new IconButton(
              icon: new Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: Colors.white,
              ),
              onPressed: () {
                //취소 팝업 보이기
                Navigator.of(context).pop();
              },
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  if (!fbkey.currentState.validate()) {
                    //토스트 보내기
                    print('error');
                    return;
                  }
                  fbkey.currentState.save();
                  final inputValues = fbkey.currentState.value;
                  // json 추가 방법 - 사용자 정보, 감정 값등 추가하기
                  final finalValues = {
                    ...inputValues,
                    'type': type,
                    'emotion': 'happy'
                  };
                  print(finalValues);
                  //data 보내기

                  //작성완료 알림- 스낵바?

                  //Navigator.of(context).pop();
                },
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '완료',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )),
              )
            ],
            centerTitle: true,
            title: Container(
              decoration: BoxDecoration(
                  color: Color(0xff3d3d3d),
                  borderRadius: BorderRadius.circular(30)),
              width: 80,
              height: 30,
              padding: EdgeInsets.only(left: 10),
              child: PopupMenuButton<String>(
                offset: Offset(18, 40),
                shape: ShapeBorder.lerp(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${types[type]}",
                      style: TextStyle(fontSize: 15),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
                onSelected: (String value) {
                  setState(() {
                    type = value;
                  });
                },
                color: Color(0xff2d2d2d),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: "diary",
                      child: Center(
                          child: Text(
                        "일기",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    PopupMenuItem(
                      value: "trip",
                      child: Center(
                          child: Text(
                        "여행",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    PopupMenuItem(
                      value: "movie",
                      child: Center(
                          child: Text(
                        "영화",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    PopupMenuItem(
                      value: "book",
                      child: Center(
                          child: Text(
                        "도서",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ];
                },
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // 오늘의 감정 표시 위젯
                Container(
                  height: 250,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 25, bottom: 20),
                        child: GestureDetector(
                          onTap: () async {
                            var bottomSheet = showModalBottomSheet(
                                useRootNavigator: true,
                                isDismissible: true,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13.0)),
                                backgroundColor: Color(0xff2d2d2d),
                                context: context,
                                builder: (context) => Container(
                                      child: emotionSelector(),
                                    ));
                            // Detect when it closes
                            await bottomSheet.then((onValue) {
                              if (onValue == null) {
                                setState(() {
                                  finalEmotion=null;
                                  emotionValue=null;
                                });
                                print('cancel');
                              } else {
                                setState(() {
                                  finalEmotion = onValue[0];
                                  emotionValue = onValue[1];
                                });
                              }
                              print("value: $onValue");
                            });
                          },
                          child: finalEmotion==null ?Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                                color: Color(0xff5d5d5d),
                                borderRadius: BorderRadius.circular(50)),
                          ):Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                                color: detailColorList[finalEmotion-1][emotionValue-1],
                                borderRadius: BorderRadius.circular(50)),
                          )
                        ),
                      ),
                      finalEmotion != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '오늘은',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  '${emotionList[finalEmotion - 1]}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          : Text(
                              '감정을 선택해주세요!',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            )
                      //공개 비공개 설정
                    ],
                  ),
                ),
                // 디바이더
                Container(
                  color: Color(0xff2D2D2D),
                  height: 2,
                ),
                type == "diary" || type == "trip" // 일기, 여행 다이어리
                    ? Container(
                        padding: EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 20),
                        child: FormBuilder(
                            key: fbkey,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      height: 50,
                                      child: FormBuilderTextField(
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                        name: 'title',
                                        maxLength: 19,
                                        validator:
                                            FormBuilderValidators.required(
                                                context,
                                                errorText: '필수 입력'),
                                        cursorColor: Color(0xffD0D0D0),
                                        decoration: InputDecoration(
                                          errorStyle:
                                              TextStyle(fontSize: 0, height: 0),
                                          counterText: '',
                                          focusColor: Color(0xffd0d0d0),
                                          labelText: '제목을 입력해주세요',
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.never,
                                          labelStyle: TextStyle(
                                              color: Color(0xffD0D0D0),
                                              fontWeight: FontWeight.bold),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Text(
                                        '${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                //image picker + permission 확인
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Container(
                                    height: 340,
                                    width: 340,
                                    decoration: BoxDecoration(
                                      color: Color(0xff565656),
                                      borderRadius: BorderRadius.circular(13),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color(0x32000000),
                                            offset: Offset.zero,
                                            blurRadius: 10,
                                            spreadRadius: 0)
                                      ],
                                    ),
                                  ),
                                ),
                                FormBuilderTextField(
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                  name: 'context',
                                  validator: FormBuilderValidators.required(
                                      context,
                                      errorText: ''),
                                  cursorColor: Color(0xffD0D0D0),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  maxLength: 800,
                                  decoration: InputDecoration(
                                    counterStyle: TextStyle(
                                        color: Color(0xffffffff), height: 0),
                                    focusColor: Color(0xffd0d0d0),
                                    labelText: '내용을 입력해주세요',
                                    errorStyle:
                                        TextStyle(fontSize: 0, height: 0),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    labelStyle: TextStyle(
                                      color: Color(0xffD0D0D0),
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                ),
                              ],
                            )),
                      )
                    // 영화, 도서 다이어리
                    : Container(
                        color: Color(0xff3D3D3D),
                      ),
              ],
            ),
          )),
    );
  }

  Widget emotionSelector() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
          height: 400,
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
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '오늘의 감정',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '은 어떠셧나요?',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    )
                  ],
                ),
              ),
              // pop 이후에 selectEmotion -> null로 바꾸기
              selectEmotion == null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectEmotion = 1;
                                          });
                                        },
                                        child: Image.asset(
                                            'assets/emotions/emotion_1.png')),
                                    SizedBox(height: 15),
                                    Text(
                                      '화남',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectEmotion = 2;
                                          });
                                        },
                                        child: Image.asset(
                                            'assets/emotions/emotion_2.png')),
                                    SizedBox(height: 15),
                                    Text(
                                      '놀람',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectEmotion = 3;
                                          });
                                        },
                                        child: Image.asset(
                                            'assets/emotions/emotion_3.png')),
                                    SizedBox(height: 15),
                                    Text(
                                      '기쁨',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectEmotion = 4;
                                          });
                                        },
                                        child: Image.asset(
                                            'assets/emotions/emotion_4.png')),
                                    SizedBox(height: 15),
                                    Text(
                                      '슬픔',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectEmotion = 5;
                                          });
                                        },
                                        child: Image.asset(
                                            'assets/emotions/emotion_5.png')),
                                    SizedBox(height: 15),
                                    Text(
                                      '역겨움',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectEmotion = 6;
                                          });
                                        },
                                        child: Image.asset(
                                            'assets/emotions/emotion_6.png')),
                                    SizedBox(height: 15),
                                    Text(
                                      '공포',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    )
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectEmotion = 7;
                                          });
                                        },
                                        child: Image.asset(
                                            'assets/emotions/emotion_7.png')),
                                    SizedBox(height: 15),
                                    Text(
                                      '중립',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              selectEmotion = null;
                            });
                          },
                          child: Image.asset(
                            'assets/emotions/emotion_${selectEmotion}.png',
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          '${emotionList[selectEmotion - 1]}의 정도를 나타내보세요!',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop([selectEmotion, 1]);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      // 이모티콘 표정 적용
                                      // child: Image.asset('assets/emotions/emotion_2_on.png'),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color:
                                              detailColorList[selectEmotion - 1]
                                                  [0],
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '1',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop([selectEmotion, 2]);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      // 이모티콘 표정 적용
                                      // child: Image.asset('assets/emotions/emotion_2_on.png'),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color:
                                              detailColorList[selectEmotion - 1]
                                                  [1],
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '2',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop([selectEmotion, 3]);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      // 이모티콘 표정 적용
                                      // child: Image.asset('assets/emotions/emotion_2_on.png'),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color:
                                              detailColorList[selectEmotion - 1]
                                                  [2],
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '3',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop([selectEmotion, 4]);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      // 이모티콘 표정 적용
                                      // child: Image.asset('assets/emotions/emotion_2_on.png'),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color:
                                              detailColorList[selectEmotion - 1]
                                                  [3],
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '4',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop([selectEmotion, 5]);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      // 이모티콘 표정 적용
                                      // child: Image.asset('assets/emotions/emotion_2_on.png'),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color:
                                              detailColorList[selectEmotion - 1]
                                                  [4],
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      '5',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
            ],
          ));
    });
  }
}

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
