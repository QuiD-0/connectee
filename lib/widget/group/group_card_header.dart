import 'package:connectee/widget/diary/group_other_diary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupRecCardHeader extends StatelessWidget {
  final data;
  final group;
  const GroupRecCardHeader({Key key, this.data,this.group}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [Emotion(data:data), NameAndTitle(data:data,group:group), DiaryType(data:data)],
    );
  }
}

class Emotion extends StatelessWidget {
  final data;
  const Emotion({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          //감정에 따른 이모티콘
          CircleAvatar(
            backgroundImage: AssetImage('assets/emotions/${data.emotionType}.png'),
            radius: 27,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 40),
            child: Container(
              child: Center(
                  child: Text(data.emotionLevel.toString(),
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

class NameAndTitle extends StatefulWidget {
  final data;
  final group;
  const NameAndTitle({Key key, this.data,this.group}) : super(key: key);

  @override
  _NameAndTitleState createState() => _NameAndTitleState();
}

class _NameAndTitleState extends State<NameAndTitle> {
  String userId;

  @override
  void initState() {
    // TODO: implement initState
    _getId();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: (){
                  if(widget.data.userId==int.parse(userId)){

                  }
                  else{
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) =>
                        new GroupOtherDiary(someonesId:widget.data.userId,group:widget.group)));
                  }
                },
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 110),
                  child: Text(
                    widget.data.nickname,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Colors.white,),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: false,
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 15,
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
              ),
              Container(
                height: 15,
                child: Text(
                  widget.data.createdAt.split('T')[0].replaceAll('-','.'),
                  style: TextStyle(fontSize: 12,color: Colors.white),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.data.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.white,),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            softWrap: false,
          )
        ],
      ),
    );
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }
}

class DiaryType extends StatelessWidget {
  final data;
  const DiaryType({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String,String> categoryToKor = {'diary':'일기','trip':'여행','movie':'영화','book':'도서'};
    return Container(
      margin: EdgeInsets.only(left: 10, top: 25), // 물어보기
      decoration: BoxDecoration(
          color: Color(0xdd2d2d2d), borderRadius: BorderRadius.circular(30)),
      width: 43,
      height: 25,
      child: Center(
          child: Text(
            categoryToKor['${data.category}'],
            style: TextStyle(color: Colors.white, fontSize: 12,),
          )),
    );
  }
}
