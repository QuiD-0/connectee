import 'dart:convert';
import 'package:connectee/vars.dart';
import 'package:connectee/widget/diary/othersDiary.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentList extends StatefulWidget {
  final diary;
  const CommentList({Key key, this.diary}) : super(key: key);

  @override
  _CommentListState createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  List comments = [];
  String userId;

  @override
  void initState() {
    // TODO: implement initState
    _getCommentList();
    _getId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.diary.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              for (var comment in comments)
                GestureDetector(
                  onTap: () {
                    if(comment['userId']==int.parse(userId)){

                    }
                    else{
                      Navigator.of(context).push(CupertinoPageRoute(
                          builder: (context) =>
                          new OtherDiary(someonesId:comment['userId'])));
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Color(0xff3d3d3d),
                          borderRadius: BorderRadius.circular(13)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${comment['User']['nickname']}님이 ${engToKor[comment['emotionType']]}의 감정을 표시했어요!',
                            style: TextStyle(color: Colors.white,fontSize: 12),
                          ),
                          SizedBox(width: 20,),
                          Image.asset(
                            'assets/emotions/${comment['emotionType']}.png',
                            width: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          ),
        ));
  }

  _getCommentList() async {
    await http
        .get(Uri.parse(
            'http://52.79.146.213:5000/comments/diary?diaryId=${widget.diary.diaryId}'))
        .then((res) {
      if (res.statusCode == 200) {
        var result = json.decode(res.body);
        for (int i = 0; i < result.length; i++) {
          setState(() {
            comments.add(result[i]);
          });
        }
      } else {
        print('error');
      }
    });
  }

  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }
}
