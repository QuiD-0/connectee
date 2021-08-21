import 'package:connectee/widget/home/CalDetail/myDiaryHeader.dart';
import 'package:connectee/widget/home/DetailCard/detail_contents.dart';
import 'package:connectee/widget/home/RecCard/rec_card_header.dart';
import 'package:flutter/material.dart';

class MyDiaryDetail extends StatefulWidget {
  final post;

  const MyDiaryDetail({Key key, this.post}) : super(key: key);

  @override
  _MyDiaryDetailState createState() => _MyDiaryDetailState();
}

class _MyDiaryDetailState extends State<MyDiaryDetail> {
  @override
  Widget build(BuildContext context) {
    var post = widget.post;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '다이어리',
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
            onPressed: () {
              Navigator.of(context).pop();
              // db 데이터 쏘기
            },
          ),
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
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          child: Text(
                            '개인  |  공개',//바꾸기
                            textAlign: TextAlign.end,
                            style: TextStyle(color: Colors.white,fontSize: 12),
                          ),
                          width: double.infinity,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ));
  }
}
