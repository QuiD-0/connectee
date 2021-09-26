import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstProfile extends StatefulWidget {
  const FirstProfile({Key key}) : super(key: key);

  @override
  _FirstProfileState createState() => _FirstProfileState();
}

class _FirstProfileState extends State<FirstProfile> {
  var user;
  String userId;
  String token;
  TextEditingController name= TextEditingController();
  TextEditingController desc= TextEditingController();
  File _image;

  @override
  void initState() {
    // TODO: implement initState
    _getId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '프로필 설정',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              _updateUserInfo();
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
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
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
                    '프로필 사진 바꾸기',
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
                  Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 35,
                                child: Text(
                                  '이름',
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
                                        hintText: '이름을 입력해주세요',
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
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.only(top: 10, left: 2),
                                  //   child: Text(
                                  //     '최대 12자까지 입력이 가능합니다',
                                  //     style: descStyle,
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: 20,
                                  )
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
                                  '한 마디',
                                  textAlign: TextAlign.start,
                                  style: textStyle,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 100,
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
                                        hintText:
                                        '아직 한 마디가 없어요. 친구들에게 보여줄 한 마디를 작성해주세요!',
                                        hintStyle: TextStyle(
                                            fontSize: 12,
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
                                        errorText: desc.text.length > 40
                                            ? '최대 40자까지 입력이 가능합니다'
                                            : '',
                                        errorStyle: TextStyle(
                                            color: Color(0xffFF9082),
                                            fontSize: 9),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 0),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(width: 0),
                                        ),
                                      ),
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
    );
  }

  var descStyle = TextStyle(
    color: Colors.white,
    fontSize: 9,
  );
  var textStyle =
  TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold);

  _updateUserInfo() async {
    var request = new http.MultipartRequest(
      "PATCH",
      Uri.parse('http://52.79.146.213:5000/users/update'),
    );
    request.headers['Authorization'] = "Bearer $token";
    request.fields['nickname'] = name.text;
    request.fields['intro'] = desc.text;
    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _image.path));
    }
    var res = await request.send();
    var respStr = await http.Response.fromStream(res);
    var resJson = json.decode(respStr.body);
    print(resJson);
    if (resJson['result'] == true) {
      Navigator.of(context).pop(true);
    }
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      token = prefs.getString('access_token');
    });
  }
}
