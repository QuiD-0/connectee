import 'package:connectee/widget/home/DetailCard/detail_contents.dart';
import 'package:connectee/widget/home/DetailCard/reaction_buttons.dart';
import 'package:connectee/widget/home/RecCard/rec_card_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 뒤로가기로 반응 상태 넘기기
class DiaryDetail extends StatelessWidget {
  final data;

  const DiaryDetail({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '추천 다이어리',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          backgroundColor: Colors.black,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
            onPressed: () => Navigator.of(context).pop(),
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
                      RecCardHeader(),
                      DetailContents(
                        data: data,
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        // 수정하기
                        child: ReactionButtons(data:data,visible: true,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ));
  }
}
