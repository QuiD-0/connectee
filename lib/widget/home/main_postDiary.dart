import 'package:connectee/screen/write_diary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostDiary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          new CupertinoPageRoute(
            builder: (BuildContext context) => new WriteDiary(groupName: '커넥티'),
            fullscreenDialog: true,
          ),
        );
      },
      child: Container(
        width: 360,
        height: 150,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
            color: Color(0xff2D2D2D), borderRadius: BorderRadius.circular(13)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/emoji.png',
              width: 170,
              height: 100,
            ),
            SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '오늘 다이어리 \n어떠세요?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.5,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '오늘의 감정\n기록하러가기',
                      style: TextStyle(color: Color(0xffababab), height: 1.5),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xffababab),
                      size: 12,
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
