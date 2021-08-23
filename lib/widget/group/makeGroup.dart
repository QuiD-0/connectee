import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class MakeGroup extends StatefulWidget {
  const MakeGroup({Key key}) : super(key: key);

  @override
  _MakeGroupState createState() => _MakeGroupState();
}

class _MakeGroupState extends State<MakeGroup> {
  File _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            var res = await showDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Color(0x99000000),
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async => false,
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
                            onPressed: () => Navigator.pop(context),
                            child: Text('취소',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontFamily: 'GmarketSans')),
                          ),
                          FlatButton(
                            onPressed: () => Navigator.pop(context, 'back'),
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
            res == 'back' ? Navigator.of(context).pop() : null;
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Color(0xff2D2D2D),borderRadius: BorderRadius.circular(13)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30,bottom: 20),
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
                  Text('그룹 대표 사진 바꾸기',style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                  SizedBox(height: 30,),
                  //디바이더
                  Container(height: 1,width: double.infinity,color: Color(0xff4D4D4D),),
                  //그룹 내용 세팅

                  //마지막 빈공간
                  SizedBox(height: 40,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
