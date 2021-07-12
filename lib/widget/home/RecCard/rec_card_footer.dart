import 'package:flutter/material.dart';

class RecCardFooter extends StatefulWidget {
  final data;
  const RecCardFooter({Key key, this.data}) : super(key: key);
  @override
  _RecCardFooterState createState() => _RecCardFooterState();
}

class _RecCardFooterState extends State<RecCardFooter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 15, 0, 0),
      child: Row(
        children: [EmotionCount(), SendEmotionBtn(data: widget.data,)],
      ),
    );
  }
}

class EmotionCount extends StatelessWidget {
  const EmotionCount({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '99',
          style: TextStyle(
              color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
        ),
        Text(
          '명의 커넥티가 감정을 표현했어요!',
          style: TextStyle(color: Colors.white, fontSize: 9),
        ),
      ],
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
        margin: EdgeInsets.only(left: 90),
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
