import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:connectee/vars.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:connectee/widget/write/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditDiary extends StatefulWidget {
  final post;
  const EditDiary({Key key,this.post}) : super(key: key);

  @override
  _EditDiaryState createState() => _EditDiaryState();
}

class _EditDiaryState extends State<EditDiary> {
  GlobalKey<FormBuilderState> fbkey = GlobalKey<FormBuilderState>();

  String userId;
  String type = "diary"; //default
  Map<String, String> types = {
    "diary": "일기",
    "trip": "여행",
    "movie": "영화",
    "book": "도서",
  };
  int finalEmotion;
  int emotionValue;
  int selectEmotion;
  String isPublic = "open";
  List<XFile> _image=[];
  List initImage;

  //영화
  String movieName = '';
  String director = '';
  String actors = '';
  String playDate = '';

  //책
  String bookName = '';
  String author = '';
  String publisher = '';
  String publishDate = '';

  //영화,책 공통
  String imgLink = '';
  double rating = 0;

  @override
  void initState() {
    // TODO: implement initState
    _getId();
    initValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String group = widget.post.group;
    var post = widget.post;
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
          backgroundColor: Color(0xff3d3d3d),
          appBar: AppBar(
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
                  if (emotionValue != null) {
                    if (!fbkey.currentState.validate()) {
                      if (fbkey.currentState.fields['title'].value == null) {
                        _toast('제목을 입력해주세요');
                      } else {
                        _toast('내용을 입력해 주세요');
                      }
                      return;
                    }
                    fbkey.currentState.save();
                    if (type == "movie" && movieName == '') {
                      _toast('영화를 선택해 주세요');
                    } else if (type == "book" && bookName == '') {
                      _toast('책을 선택해 주세요');
                    } else {
                      editDiary(group);
                    }
                  } else {
                    _toast('감정을 선택해 주세요');
                  }
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
                    //영화, 도서, 사진 선택값 초기화
                    movieName = '';
                    director = '';
                    actors = '';
                    playDate = '';
                    bookName = '';
                    author = '';
                    publisher = '';
                    publishDate = '';
                    imgLink = '';
                    _image = [];
                    rating = 0.0;
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
                  height: 230,
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
                                  finalEmotion = null;
                                  emotionValue = null;
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
                          child: finalEmotion == null
                              ? Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                                color: Color(0xff5d5d5d),
                                borderRadius: BorderRadius.circular(50)),
                          )
                              : Image.asset(
                            'assets/emotions/${intToEng[finalEmotion]}_big.png',
                            width: 90,
                          ),
                        ),
                      ),
                      finalEmotion != null
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '오늘은 ',
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
                      ),
                      //공개 비공개 설정, 그룹이 있을경우에는 그룹 이름 출력
                      group == null
                          ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                '개인',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              width: 71,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Color(0xff2d2d2d),
                                  borderRadius:
                                  BorderRadius.circular(30)),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            PopupMenuButton<String>(
                              offset: Offset(18, 40),
                              shape: ShapeBorder.lerp(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(20.0)),
                                  RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(20.0)),
                                  0),
                              child: Container(
                                alignment: Alignment.center,
                                width: 80,
                                height: 30,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(30),
                                    border:
                                    Border.all(color: Colors.white)),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      isPublic == "open" ? "공개" : "비공개",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              onSelected: (String value) {
                                setState(() {
                                  isPublic = value;
                                });
                              },
                              color: Color(0xff2d2d2d),
                              itemBuilder: (BuildContext context) {
                                return [
                                  PopupMenuItem(
                                    value: "open",
                                    child: Center(
                                        child: Text(
                                          "공개",
                                          style:
                                          TextStyle(color: Colors.white),
                                        )),
                                  ),
                                  PopupMenuItem(
                                    value: "close",
                                    child: Center(
                                        child: Text(
                                          "비공개",
                                          style:
                                          TextStyle(color: Colors.white),
                                        )),
                                  ),
                                ];
                              },
                            ),
                          ],
                        ),
                      )
                          : Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Color(0xff2d2d2d)),
                            child: Padding(
                              padding:
                              const EdgeInsets.fromLTRB(18, 7, 18, 7),
                              child: Text(
                                '$group',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                // 디바이더
                Container(
                  color: Color(0xff2D2D2D),
                  height: 2,
                ),
                Container(
                  padding:
                  EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 20),
                  child: FormBuilder(
                      key: fbkey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 250,
                                height: 50,
                                child: FormBuilderTextField(
                                  initialValue: post.title,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  name: 'title',
                                  maxLength: 19,
                                  validator: FormBuilderValidators.required(
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
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Text(
                                  '${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          type == "diary" || type == "trip" // 일기, 여행 다이어리
                              ? Padding(
                            padding: const EdgeInsets.only(top: 8),
                            //image picker + permission 확인
                            child: GestureDetector(
                                onTap: () async {
                                  var status = Platform.isIOS
                                      ? await Permission.photos.request()
                                      : await Permission.storage
                                      .request();
                                  if (status.isGranted) {
                                    final ImagePicker _picker =
                                    ImagePicker();
                                    List<XFile> images =
                                    await _picker.pickMultiImage();
                                    if (images==null) {
                                      setState(() {
                                        _image = [];
                                        initImage = [];
                                      });
                                    } else {
                                      if (images.length > 5) {
                                        _toast("사진은 최대 5장까지 선택가능합니다.");
                                        setState(() {
                                          _image = [];
                                          initImage = [];
                                        });
                                      } else {
                                        setState(() {
                                          _image = images;
                                          initImage = [];
                                        });
                                      }
                                    }
                                  } else {
                                    openAppSettings();
                                  }
                                },
                                child: Container(
                                  height: 340,
                                  width: 340,
                                  decoration: BoxDecoration(
                                    color: Color(0xff565656),
                                    borderRadius:
                                    BorderRadius.circular(13),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color(0x32000000),
                                          offset: Offset.zero,
                                          blurRadius: 10,
                                          spreadRadius: 0)
                                    ],
                                  ),
                                  child: initImage.isEmpty && _image.isEmpty
                                      ? Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                          'assets/icons/pic_add.png'),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        "사진을 넣어 주세요",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color:
                                            Color(0xffd0d0d0)),
                                      ),
                                    ],
                                  )
                                      : ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(13),
                                    child: Stack(
                                      alignment: Alignment.topRight,
                                      children: [
                                        initImage.isEmpty?Image.file(
                                          File(_image[0].path),
                                          width: 340,
                                          height: 340,
                                          fit: BoxFit.cover,
                                        ):Image.network(initImage[0],
                                          width: 340,
                                          height: 340,
                                          fit: BoxFit.cover,),
                                        Padding(
                                          padding:
                                          const EdgeInsets.all(
                                              10.0),
                                          child: Container(
                                            padding:
                                            EdgeInsets.fromLTRB(
                                                10.0, 5, 10, 5),
                                            decoration: BoxDecoration(
                                                color: Color(
                                                    0xff2d2d2d),
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    30)),
                                            child: Text(
                                              '대표',
                                              style: TextStyle(
                                                  color:
                                                  Colors.white),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          )
                          //영화 & 책
                              : Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              //영화 선택
                              type == "movie"
                                  ? Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          //영화 이미지
                                          GestureDetector(
                                            onTap: () async {
                                              final result =
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Search(
                                                            type:
                                                            type)),
                                              );
                                              print(result);
                                              if (result == null) {
                                                setState(() {
                                                  movieName = '';
                                                  director = '';
                                                  actors = '';
                                                  playDate = '';
                                                  imgLink = '';
                                                });
                                              } else {
                                                setState(() {
                                                  movieName = result[0];
                                                  director = result[2];
                                                  actors = result[3];
                                                  playDate = result[4];
                                                  imgLink = result[1];
                                                });
                                              }
                                            },
                                            child: imgLink == ''
                                                ? Container(
                                              height: 150,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  color: Color(
                                                      0xff565656),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      13)),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  Image.asset(
                                                      'assets/icons/pic_add.png'),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "영화를 선택해주세요",
                                                    style: TextStyle(
                                                        fontSize:
                                                        12,
                                                        color: Color(
                                                            0xffd0d0d0)),
                                                  ),
                                                ],
                                              ),
                                            )
                                                : imgLink != 'none'
                                                ? ClipRRect(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  13),
                                              child: Image
                                                  .network(
                                                '$imgLink',
                                                width: 150,
                                                height: 150,
                                                fit: BoxFit
                                                    .cover,
                                              ),
                                            )
                                                : Container(
                                              height: 150,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  color: Color(
                                                      0xff565656),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      13)),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  Text(
                                                    "이미지가 없습니다",
                                                    style: TextStyle(
                                                        fontSize:
                                                        12,
                                                        color:
                                                        Color(0xffd0d0d0)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          //영화 정보
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 20),
                                            width: 200,
                                            height: 150,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  movieName == ''
                                                      ? '[제목]'
                                                      : '[$movieName]',
                                                  style: TextStyle(
                                                      color:
                                                      Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                  maxLines: 1,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  child: Text(
                                                    '감독: $director',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors
                                                            .white),
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      "배우:",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .white),
                                                    ),
                                                    Container(
                                                      width: 110,
                                                      height: 50,
                                                      child: Text(
                                                        ' $actors',
                                                        style: TextStyle(
                                                            fontSize:
                                                            12,
                                                            color: Colors
                                                                .white),
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '개봉: $playDate',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                      Colors.white),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      //star rating 위젯
                                      Container()
                                    ],
                                  ))
                              //독서 선택
                                  : Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          //도서 이미지
                                          GestureDetector(
                                            onTap: () async {
                                              final result =
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Search(
                                                            type:
                                                            type)),
                                              );
                                              print(result);
                                              if (result == null) {
                                                setState(() {
                                                  bookName = '';
                                                  author = '';
                                                  publishDate = '';
                                                  publisher = '';
                                                  imgLink = '';
                                                });
                                              } else {
                                                setState(() {
                                                  //추가
                                                  bookName = result[0];
                                                  author = result[2];
                                                  publishDate =
                                                  result[4];
                                                  publisher = result[3];
                                                  imgLink = result[1];
                                                });
                                              }
                                            },
                                            child: imgLink == ''
                                                ? Container(
                                              height: 150,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  color: Color(
                                                      0xff565656),
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      13)),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  Image.asset(
                                                      'assets/icons/pic_add.png'),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "책을 선택해주세요",
                                                    style: TextStyle(
                                                        fontSize:
                                                        12,
                                                        color: Color(
                                                            0xffd0d0d0)),
                                                  ),
                                                ],
                                              ),
                                            )
                                                : imgLink != 'none'
                                                ? ClipRRect(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  13),
                                              child: Image
                                                  .network(
                                                '$imgLink',
                                                width: 150,
                                                height: 150,
                                                fit: BoxFit
                                                    .cover,
                                              ),
                                            )
                                                : Container(
                                              height: 150,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                  color: Color(
                                                      0xff565656),
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      13)),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center,
                                                children: [
                                                  Text(
                                                    "이미지가 없습니다",
                                                    style: TextStyle(
                                                        fontSize:
                                                        12,
                                                        color:
                                                        Color(0xffd0d0d0)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          //영화 정보
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 20),
                                            width: 200,
                                            height: 150,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  bookName == ''
                                                      ? '[제목]'
                                                      : '[$bookName]',
                                                  style: TextStyle(
                                                      color:
                                                      Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                  maxLines: 2,
                                                  overflow: TextOverflow
                                                      .ellipsis,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Container(
                                                  height: 30,
                                                  child: Text(
                                                    '저자: $author',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors
                                                            .white),
                                                    overflow:
                                                    TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: [
                                                    Text(
                                                      "출판:",
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors
                                                              .white),
                                                    ),
                                                    Container(
                                                      width: 110,
                                                      height: 30,
                                                      child: Text(
                                                        ' $publisher',
                                                        style: TextStyle(
                                                            fontSize:
                                                            12,
                                                            color: Colors
                                                                .white),
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  '출간: $publishDate',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                      Colors.white),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      //star rating 위젯
                                      Container()
                                    ],
                                  )),
                              SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0),
                                      child: Text(
                                        '평점',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16),
                                      ),
                                    ),
                                    SmoothStarRating(
                                        allowHalfRating: false,
                                        onRated: (v) {
                                          setState(() {
                                            rating = v;
                                          });
                                        },
                                        starCount: 5,
                                        rating: rating,
                                        size: 40.0,
                                        isReadOnly: false,
                                        color: Colors.white,
                                        borderColor: Color(0xff565656),
                                        defaultIconData:
                                        Icons.star_rate_sharp,
                                        filledIconData:
                                        Icons.star_rate_sharp,
                                        spacing: 15.0),
                                  ],
                                ),
                              )
                            ],
                          ),
                          FormBuilderTextField(
                            initialValue: post.content,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            name: 'content',
                            validator: FormBuilderValidators.required(context,
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
                              errorStyle: TextStyle(fontSize: 0, height: 0),
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
                ),
                GestureDetector(
                  onTap: () async{
                    var res = await _checkDelete();
                    res == true ? _deleteDiary() : null;
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 311,
                    height: 48,
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(30)),
                    child: Text('다이어리 삭제',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ),
                SizedBox(height: 50,),
              ],
            ),
          )),
    );
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }

  editDiary(group) async {
    final inputValues = fbkey.currentState.value;
    showLoaderDialog(context);
    //실제 url
    var request = new http.MultipartRequest(
      "PATCH",
      Uri.parse('http://52.79.146.213:5000/diaries/${widget.post.diaryId}'),
    );

    //기본 필드값
    request.fields['title'] = inputValues['title'];
    request.fields['content'] = inputValues['content'];
    request.fields['private'] = isPublic == "open" ? 'false' : 'true';
    request.fields['category'] = type;
    request.fields['emotionType'] = engEmotionList[finalEmotion - 1];
    request.fields['emotionLevel'] = emotionValue.toString();
    request.fields['userId'] = userId;

    // 일기,여행-> 이미지 선택
    if (_image != null) {
      for (var i = 0; i < _image.length; i++) {
        request.files
            .add(await http.MultipartFile.fromPath('image$i', _image[i].path));
      }
    }
    // //영화 필드
    // request.fields['movie'] = movieName;
    // request.fields['director'] = director;
    // request.fields['actors'] = actors;
    // request.fields['playDate'] = playDate;
    //
    // //도서 필드
    // request.fields['book'] = bookName;
    // request.fields['author'] = author;
    // request.fields['publisher'] = publisher;
    // request.fields['publishDate'] = publishDate;

    //영화, 책 공통
    //request.fields['imgLink'] = imgLink;
    request.fields['categoryScore'] = rating.toString();

    var res = await request.send();
    var respStr = await http.Response.fromStream(res);
    var resJson = json.decode(respStr.body);
    print(resJson);
    if (resJson["result"] == true) {
      _toast('수정완료');
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    } else {
      _toast('다시 시도해 주세요');
      Navigator.of(context).pop();
    }
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
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          for (var i in [1, 2, 3, 4, 5, 6, 7])
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectEmotion = i;
                                        });
                                      },
                                      child: Image.asset(
                                          'assets/emotions/${intToEng[i]}_big.png',
                                          width: 60)),
                                  SizedBox(height: 15),
                                  Text(
                                    engToKor[intToEng[i]],
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  )
                                ],
                              ),
                            ),
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
                          'assets/emotions/${intToEng[selectEmotion]}_big.png',
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
                            for (var i in [1, 2, 3, 4, 5])
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pop([selectEmotion, i]);
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      // 이모티콘 표정 적용
                                      child: Image.asset(
                                          'assets/emotions/${selectEmotion}.png'),
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          color: detailColorList[
                                          selectEmotion - 1][i - 1],
                                          borderRadius:
                                          BorderRadius.circular(50)),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      i.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  ],
                                ),
                              )
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ));
        });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white24,
      insetPadding: EdgeInsets.symmetric(horizontal: 150),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      content: Builder(
        builder: (context) {
          return Container(
            height: 50,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
    showDialog(
      useRootNavigator: false,
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<bool> _onBackPress() {
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
          '수정을 종료하시겟습니까?',
          textAlign: TextAlign.center,
        ),
        titleTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: 'GmarketSans',
            fontWeight: FontWeight.bold),
        content: Text(
          '수정중인 일기는\n저장되지 않습니다',
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

  void initValues() {
    type = widget.post.category;
    finalEmotion = engToInt[widget.post.emotionType];
    emotionValue = widget.post.emotionLevel;
    selectEmotion = engToInt[widget.post.emotionType];
    isPublic = widget.post.private==0?'open':'close';
    initImage = getImage(widget.post);
    //영화
    if(widget.post.movie!=null){
      movieName = widget.post.movie['movie'];
      director =widget.post.movie['director'];
      actors = widget.post.movie['actors'];
      playDate = DateFormat('yyyy.MM.dd').format(DateTime.parse(widget.post.movie['playDate'])).toString();
      imgLink = widget.post.linkImg;
      rating = double.parse(widget.post.rating.toString());
    }

    //책
    if(widget.post.book!=null){
      bookName = widget.post.book['book'];
      author = widget.post.book['author'];
      publisher = widget.post.book['publisher'];
      publishDate = DateFormat('yyyy.MM.dd').format(DateTime.parse(widget.post.book['publishDate'])).toString();
      imgLink = widget.post.linkImg;
      rating = double.parse(widget.post.rating.toString());
    }

  }

  List getImage(post) {
    if(post.category =='diary' || post.category=='trip'){
      return widget.post.Images;
    }else{
      return [];
    }
  }

  _checkDelete() {
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
          '정말 삭제하시겟습니까?',
          textAlign: TextAlign.center,
        ),
        titleTextStyle: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontFamily: 'GmarketSans',
            fontWeight: FontWeight.bold),
        // content: Text(
        //   '수정중인 일기는\n저장되지 않습니다',
        //   textAlign: TextAlign.center,
        // ),
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

  _deleteDiary() async{
    await http.delete(Uri.parse('http://52.79.146.213:5000/diaries/${widget.post.diaryId}')).then((value){
      Navigator.of(context).pop();
      _toast('삭제완료');
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
List emotionList = ["화남", "놀람", "기쁨", "슬픔", "역겨움", "공포", "중립"];

List engEmotionList = [
  "angry",
  "surprised",
  "happy",
  "sad",
  "disgusted",
  "terrified",
  "neutral"
];
