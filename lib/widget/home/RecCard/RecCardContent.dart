import 'package:connectee/widget/home/diary_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';


class RecCardContent extends StatelessWidget {
  final data;
  const RecCardContent({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          new CupertinoPageRoute(
            builder: (BuildContext context) => new DiaryDetail(data:data),
            fullscreenDialog: true,
          ),
        );
      },
      child:Container(
        width: 331,
        padding: EdgeInsets.fromLTRB(16,16,16,20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          '미데 이 터더미 데이 터더 미데 이 터더미데이',
          overflow: TextOverflow.ellipsis,
          maxLines: 5,
          softWrap: false,
          style: TextStyle(color: Colors.black, height: 1.8, fontSize: 13),
        ),
      ),
    );
  }
}
