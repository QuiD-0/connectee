import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MakeGroup extends StatefulWidget {
  const MakeGroup({Key key}) : super(key: key);

  @override
  _MakeGroupState createState() => _MakeGroupState();
}

class _MakeGroupState extends State<MakeGroup> {
  List topics = ['취미', '여행', '공부', '운동', '맛집', '영화', '사랑', '책', '애완동물', '고민'];
  File _image;
  List selectTopics = [];
  List finalSelectTopics = [];
  String private; // open, close
  String userId;
  TextEditingController name = TextEditingController();
  TextEditingController desc = TextEditingController();
  TextEditingController NOP = TextEditingController();
  bool topicVisible = false;
  bool privateVisible = false;
  TextEditingController pass = TextEditingController();
  TextEditingController check = TextEditingController(); //패스워드 확인용
  @override
  void initState() {
    // TODO: implement initState
    _getId();
    NOP.text = "1";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '그룹만들기',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Colors.white,
            ),
            onPressed: () async {
              var res = await _onBackPress();
              res == true ? Navigator.of(context).pop() : null;
            },
          ),
          actions: [
            GestureDetector(
              onTap: () {
                _postData();
              },
              child: Container(
                alignment: Alignment.center,
                width: 80,
                height: 40,
                child: Text(
                  '완료',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10,10,10,30),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Color(0xff2D2D2D),
                    borderRadius: BorderRadius.circular(13)),
                child: Column(
                  children: [
                    //그룹 대표 사진
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      child: GestureDetector(
                          onTap: () async {
                            var status = Platform.isIOS
                                ? await Permission.photos.request()
                                : await Permission.storage.request();
                            if (status.isGranted) {
                              final ImagePicker _picker = ImagePicker();
                              XFile image = await _picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (image == null) {
                                setState(() {
                                  _image = null;
                                });
                              }

                              File croppedFile = await ImageCropper.cropImage(
                                cropStyle: CropStyle.circle,
                                sourcePath: File(image.path).path,
                                aspectRatioPresets: [
                                  CropAspectRatioPreset.square,
                                ],
                                androidUiSettings: AndroidUiSettings(
                                    hideBottomControls: true,
                                    activeControlsWidgetColor: Colors.black,
                                    toolbarTitle: 'Edit Image',
                                    toolbarColor: Colors.black,
                                    toolbarWidgetColor: Colors.white,
                                    initAspectRatio: CropAspectRatioPreset.square,
                                    lockAspectRatio: true),
                                iosUiSettings: IOSUiSettings(
                                  minimumAspectRatio: 1.0,
                                ),
                              );
                              setState(() {
                                _image = croppedFile;
                              });
                            } else {
                              openAppSettings();
                            }
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(0xffFF9082),
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0x32000000),
                                    offset: Offset.zero,
                                    blurRadius: 10,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: _image == null
                                ? Container()
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      File(_image.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          )),
                    ),
                    Text(
                      '그룹 대표 사진 바꾸기',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    //디바이더
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Color(0xff4D4D4D),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    //그룹 내용 세팅
                    Container(
                      child: Column(
                        children: [
                          //그룹명
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 35,
                                  child: Text(
                                    '그룹명',
                                    textAlign: TextAlign.start,
                                    style: textStyle,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 35,
                                      width: 250,
                                      child: TextField(
                                        controller: name,
                                        maxLength: 12,
                                        cursorColor: Colors.white,
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.white),
                                        decoration: InputDecoration(
                                          counterText: '',
                                          filled: true,
                                          fillColor: Color(0xff565656),
                                          hintText: '그룹명을 입력해주세요',
                                          hintStyle: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xffD0D0D0)),
                                          contentPadding: const EdgeInsets.only(
                                              left: 10.0, bottom: 13, top: 0),
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
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 10, left: 2),
                                      child: Text(
                                        '최대 12자까지 입력이 가능합니다',
                                        style: descStyle,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          //그룹 설명
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 85,
                                  child: Text(
                                    '그룹 설명',
                                    textAlign: TextAlign.start,
                                    style: textStyle,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 85,
                                      width: 250,
                                      child: TextField(
                                        controller: desc,
                                        maxLength: 54,
                                        maxLines: 3,
                                        cursorColor: Colors.white,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            height: 1.8),
                                        decoration: InputDecoration(
                                          counterText: '',
                                          filled: true,
                                          fillColor: Color(0xff565656),
                                          hintText: '그룹에 대한 간단한 설명을 입력해주세요',
                                          hintStyle: TextStyle(
                                              fontSize: 13,
                                              color: Color(0xffD0D0D0)),
                                          contentPadding: const EdgeInsets.only(
                                              left: 10.0, bottom: 15, top: 0),
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
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 10, left: 2),
                                      child: Text(
                                        '최대 54자까지 입력이 가능합니다',
                                        style: descStyle,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          //인원수
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 35,
                                  child: Text(
                                    '인원수',
                                    textAlign: TextAlign.start,
                                    style: textStyle,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: NOP.text.isNotEmpty
                                              ? GestureDetector(
                                                  onTap: () {
                                                    int.parse(NOP.text) > 1
                                                        ? changeNOP('-')
                                                        : null;
                                                  },
                                                  child: Icon(
                                                    Icons.remove_circle,
                                                    color: int.parse(NOP.text) > 1
                                                        ? Colors.white
                                                        : Color(0xff565656),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      NOP.text = '1';
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.remove_circle,
                                                    color: Color(0xff565656),
                                                  ),
                                                ),
                                        ),
                                        Container(
                                          height: 35,
                                          width: 50,
                                          child: TextField(
                                            onEditingComplete: () {
                                              if (NOP.text.isEmpty) {
                                                setState(() {
                                                  NOP.text = "1";
                                                });
                                              }
                                            },
                                            onChanged: (res) {
                                              if (NOP.text.isNotEmpty) {
                                                int n = int.parse(NOP.text);
                                                if (n < 1) {
                                                  setState(() {
                                                    NOP.text = "1";
                                                  });
                                                }
                                                if (n > 100) {
                                                  setState(() {
                                                    NOP.text = "100";
                                                  });
                                                }
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            controller: NOP,
                                            maxLength: 3,
                                            maxLines: 1,
                                            showCursor: false,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                height: 1.8),
                                            decoration: InputDecoration(
                                              counterText: '',
                                              filled: true,
                                              fillColor: Color(0xff565656),
                                              contentPadding:
                                                  const EdgeInsets.only(
                                                      bottom: 20),
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
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: NOP.text.isNotEmpty
                                              ? GestureDetector(
                                                  onTap: () {
                                                    int.parse(NOP.text) < 100
                                                        ? changeNOP('+')
                                                        : null;
                                                  },
                                                  child: Icon(
                                                    Icons.add_circle,
                                                    color:
                                                        int.parse(NOP.text) < 100
                                                            ? Colors.white
                                                            : Color(0xff565656),
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      NOP.text = '1';
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.add_circle,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(top: 10, left: 2),
                                      child: Text(
                                        '최대 100명까지 가능합니다',
                                        style: descStyle,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          //그룹 주제
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  child: Text(
                                    '그룹 주제',
                                    textAlign: TextAlign.start,
                                    style: textStyle,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      topicVisible = !topicVisible;
                                      selectTopics = [];
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      finalSelectTopics.isNotEmpty
                                          ? Wrap(
                                              children: [
                                                for (var i in finalSelectTopics)
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30)),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 5, 10, 5),
                                                      child: Text(
                                                        i,
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            )
                                          : Text(
                                              '주제선택',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xffd0d0d0)),
                                            ),
                                      Icon(
                                        topicVisible
                                            ? Icons.arrow_drop_up_sharp
                                            : Icons.arrow_drop_down_sharp,
                                        color: Color(0xffd0d0d0),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //그룹 주제 선택 박스
                          Visibility(
                            visible: topicVisible,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      width: 250,
                                      height: 165,
                                      decoration: BoxDecoration(
                                          color: Color(0xff565656),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Column(
                                        children: [
                                          Wrap(
                                            alignment: WrapAlignment.start,
                                            children: [
                                              for (var i in topics)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5),
                                                  child: selectTopics.contains(i)
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            _setTopic(i);
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .white),
                                                                color:
                                                                    Colors.white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30)),
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    10, 5, 10, 5),
                                                            child: Text(
                                                              i,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            _setTopic(i);
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .white,
                                                                    width: 1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30)),
                                                            padding: EdgeInsets
                                                                .fromLTRB(
                                                                    10, 5, 10, 5),
                                                            child: Text(
                                                              i,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ),
                                                )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    topicVisible = false;
                                                  });
                                                },
                                                child: Container(
                                                  width: 43,
                                                  height: 25,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '취소',
                                                    style: TextStyle(
                                                        color: Color(0xff2D2D2D)),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xff9d9d9d),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    finalSelectTopics =
                                                        selectTopics;
                                                    topicVisible = false;
                                                  });
                                                },
                                                child: Container(
                                                  width: 43,
                                                  height: 25,
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    '확인',
                                                    style: TextStyle(
                                                        color: Color(0xff2D2D2D)),
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xff9d9d9d),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          //공개 비공개
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  child: Text(
                                    '공개 여부',
                                    textAlign: TextAlign.start,
                                    style: textStyle,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      privateVisible = !privateVisible;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      private!=null
                                          ? private=='open'?
                                          Text('공개', style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12),
                                                ):Text('비공개',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 12),)
                                          : Text(
                                              '공개 여부 선택',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xffd0d0d0)),
                                            ),
                                      Icon(
                                        topicVisible
                                            ? Icons.arrow_drop_up_sharp
                                            : Icons.arrow_drop_down_sharp,
                                        color: Color(0xffd0d0d0),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //공개 비공개 선택창
                          Visibility(
                            visible: privateVisible,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                  ),
                                  Container(
                                      padding: EdgeInsets.all(10),
                                      width: 250,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Color(0xff565656),
                                          borderRadius: BorderRadius.circular(5)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                private='open';
                                                privateVisible=false;
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    child: Text('공개',style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),),
                                                  ),
                                                  Text('비밀번호 없이 누구나 입장할 수 있어요',style: TextStyle(color: Color(0xffd0d0d0),fontSize: 9),)
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              setState(() {
                                                private='close';
                                                privateVisible=false;
                                              });
                                            },
                                            child: Container(
                                              height: 40,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 60,
                                                    child: Text('비공개',style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.bold),),
                                                  ),
                                                  Text('비밀번호를 아는 사람만 입장할 수 있어요',style: TextStyle(color: Color(0xffd0d0d0),fontSize: 9),)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ))
                                ],
                              ),
                            ),
                          ),
                          //비밀번호 입력창
                          private=='close' && privateVisible==false? Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                ),
                                Container(
                                    width: 250,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 40,
                                          child: TextField(
                                            controller: pass,
                                            maxLength: 6,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            cursorColor: Colors.white,
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white),
                                            decoration: InputDecoration(
                                              counterText: '',
                                              filled: true,
                                              fillColor: Color(0xff565656),
                                              hintText: '비밀번호를 설정해주세요',
                                              hintStyle: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xffD0D0D0)),

                                              contentPadding: const EdgeInsets.only(
                                                  left: 10.0, bottom: 10, top: 0),
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
                                        ),
                                        SizedBox(height: 10,),
                                        Container(
                                          height: 40,
                                          child: TextField(
                                            controller: check,
                                            maxLength: 6,
                                            cursorColor: Colors.white,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            style: TextStyle(
                                                fontSize: 12, color: Colors.white),
                                            decoration: InputDecoration(
                                              counterText: '',
                                              filled: true,
                                              fillColor: Color(0xff565656),
                                              hintText: '비밀번호를 확인해주세요',
                                              hintStyle: TextStyle(
                                                  fontSize: 13,
                                                  color: Color(0xffD0D0D0)),
                                              contentPadding: const EdgeInsets.only(
                                                  left: 10.0, bottom: 10, top: 0),
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
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.only(top: 10, left: 2),
                                          child: Text(
                                            '숫자만 입력 가능합니다 (최대 6글자 입력가능)',
                                            style: descStyle,
                                          ),
                                        ),
                                      ],
                                    ))
                              ],
                            ),
                          ):Container(),
                        ],
                      ),
                    ),
                    //마지막 빈공간
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  var descStyle = TextStyle(
    color: Colors.white,
    fontSize: 9,
  );
  var textStyle =
      TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  changeNOP(String s) {
    int n = int.parse(NOP.text);
    switch (s) {
      case '-':
        setState(() {
          NOP.text = (n - 1).toString();
        });
        break;
      case '+':
        setState(() {
          NOP.text = (n + 1).toString();
        });
        break;
    }
  }

  void _setTopic(i) {
    if (selectTopics.contains(i)) {
      setState(() {
        selectTopics.remove(i);
      });
    } else {
      if (selectTopics.length < 2) {
        setState(() {
          selectTopics.add(i);
        });
      }
    }
  }

  void _postData() async{
    //그룹명 체크
    if(validate()==true){
      //데이터 보내기
      showLoaderDialog(context);
      var request = new http.MultipartRequest(
        "POST",
        Uri.parse('http://52.79.146.213:5000/groups/create'),
      );
      request.fields['title'] = name.text;
      request.fields['OwnerId'] = userId;
      request.fields['description'] = desc.text;
      request.fields['limitMembers'] = NOP.text.toString();
      request.fields['private'] = private=="open"?"false":"true";
      request.fields['password'] = pass.text;
      request.fields['theme'] = finalSelectTopics.join(",");
      if (_image != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', _image.path));
      }
      var res = await request.send();
      var respStr = await http.Response.fromStream(res);
      var resJson = json.decode(respStr.body);
      print(resJson);
      if (resJson["success"] == true) {
        _toast('그룹생성이 완료되었습니다.');
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else{
        _toast('다시 시도해 주세요');
        Navigator.of(context).pop();
      }

    }
  }

  bool validate() {
    if(name.text==''){
      _toast('그룹명을 입력해주세요');
      return false;
    }
    if(desc.text==''){
      _toast('그룹 설명을 입력해주세요');
      return false;
    }
    if(finalSelectTopics.isEmpty){
      _toast('주제를 선택해주세요');
      return false;
    }
    if(private==null){
      _toast('공개여부를 선택해주세요');
      return false;
    }
    if(private=='close'){
      if(pass.text!=check.text){
        _toast('비밀번호를 확인해주세요');
        return false;
      }else if(pass.text==''){
        _toast('비밀번호를 입력해주세요');
        return false;
      }
    }
    return true;
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
  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      backgroundColor: Colors.white24,
      insetPadding: EdgeInsets.symmetric(horizontal: 150),
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.all(
              Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          return Container(
            height: 50,
            child: Center(child: CircularProgressIndicator(),),
          );
        },
      ),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  Future<bool> _onBackPress(){
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color(0x99000000),
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(20, 40, 20, 10),
            elevation: 0,
            backgroundColor: Color(0xff3D3D3D),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text(
              '뒤로가시겟습니까?',
              textAlign: TextAlign.center,
            ),
            titleTextStyle: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontFamily: 'GmarketSans',
                fontWeight: FontWeight.bold),
            content: Text(
              '작성한 내용는\n저장되지 않습니다',
              textAlign: TextAlign.center,
            ),
            contentTextStyle: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontFamily: 'GmarketSans'),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FlatButton(
                    onPressed: () => Navigator.pop(context,false),
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
      },
    );
  }
}
