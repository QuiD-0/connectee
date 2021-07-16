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
            builder: (BuildContext context) => new DiaryDetail(data: data),
            fullscreenDialog: true,
          ),
        );
      },
      child: Container(
        width: 331,
        padding: EdgeInsets.fromLTRB(20,10,20,15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            data.id%2==1?Container(
              padding: EdgeInsets.only(top: 5,bottom: 10),
              child: Image.network(
                'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
              width: 300,height: 300,fit: BoxFit.cover,),
            ):Container(),
            Text(
              '미데 이 터더미 데이 터더 미데 이터더미데이asd터더미데이asd터더미데이asd터더미데이asd',
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              softWrap: false,
              style: TextStyle(color: Colors.black, height: 2, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
