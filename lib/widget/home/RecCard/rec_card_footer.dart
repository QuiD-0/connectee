import 'package:connectee/widget/home/DetailCard/reaction_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecCardFooter extends StatefulWidget {
  final data;
  const RecCardFooter({Key key, this.data}) : super(key: key);
  @override
  _RecCardFooterState createState() => _RecCardFooterState();
}
// 데이터 받아오기 -> 2가지 데이터
// 1. diary의 감정 카운터 : 0일경우 or 아닐경우 체크
// 2. user 감정댓글 리스트 - 리스트에 있을경우 or 없을경우
class _RecCardFooterState extends State<RecCardFooter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 15, 20, 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [ReactionButtons(data: widget.data,visible: false,), SendEmotionBtn(data: widget.data,)],
      ),
    );
  }
}


class SendEmotionBtn extends StatelessWidget {
  final data;
  const SendEmotionBtn({Key key,this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){print('tap send btn ${data.id}');},
      child: Container(
        width: 90,
        height: 25,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.white,width: 1.5)
        ),
        child: Center(
          child: Text(
            '감정 보내기 >',
            style: TextStyle(color: Colors.white,fontSize: 12),
          ),
        ),
      ),
    );
  }
}
