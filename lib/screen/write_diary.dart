import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class WriteDiary extends StatefulWidget {
  const WriteDiary({Key key}) : super(key: key);

  @override
  _WriteDiaryState createState() => _WriteDiaryState();
}

class _WriteDiaryState extends State<WriteDiary> {
  GlobalKey<FormBuilderState> fbkey = GlobalKey<FormBuilderState>();

  String type = "diary";
  Map<String, String> types = {
    "diary": "일기",
    "trip": "여행",
    "movie": "영화",
    "book": "도서",
  };
  List images = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
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
                  color: Color(0xff3d3d3d),
                  height: 250,
                ),
                // 디바이더
                Container(
                  color: Color(0xff2D2D2D),
                  height: 2,
                ),
                type == "diary" || type == "trip" // 일기, 여행 다이어리
                    ? Container(
                        padding: EdgeInsets.only(
                            left: 20, top: 10, right: 20, bottom: 5),
                        color: Color(0xff3D3D3D),
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
                                        validator:
                                            FormBuilderValidators.required(
                                                context,
                                                errorText: '필수 입력'),
                                        cursorColor: Color(0xffD0D0D0),
                                        decoration: InputDecoration(
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
                                    Text(
                                      '${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}',
                                      style: TextStyle(
                                        color: Colors.white,
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
                                      errorText: '필수 입력'),
                                  cursorColor: Color(0xffD0D0D0),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    focusColor: Color(0xffd0d0d0),
                                    labelText: '내용을 입력해주세요',
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
}
