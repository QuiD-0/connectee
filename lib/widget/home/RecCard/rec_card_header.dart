import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecCardHeader extends StatelessWidget {
  final data;
  const RecCardHeader({Key key, this.data}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Emotion(), NameAndTitle(), DiaryType()],
    );
  }
}

class Emotion extends StatelessWidget {
  const Emotion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/astronaut.jpg'),
            radius: 27,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 40),
            child: Container(
              child: Center(
                  child: Text('1',
                      style: TextStyle(
                        color: Color(0xffFF9082),
                      ))),
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class NameAndTitle extends StatelessWidget {
  const NameAndTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 110),
                child: Text(
                  '이름',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
              Container(
                width: 1,
                height: 15,
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              ),
              Text(
                '2020.07.11',
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '오늘 나의 일상',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          )
        ],
      ),
    );
  }
}

class DiaryType extends StatelessWidget {
  const DiaryType({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10),
      decoration: BoxDecoration(
          color: Color(0xdd2d2d2d), borderRadius: BorderRadius.circular(30)),
      width: 43,
      height: 25,
      child: Center(
          child: Text(
        '일기',
        style: TextStyle(color: Colors.white, fontSize: 12),
      )),
    );
  }
}
