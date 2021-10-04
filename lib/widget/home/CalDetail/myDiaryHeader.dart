import 'package:connectee/widget/home/RecCard/rec_card_header.dart';
import 'package:flutter/material.dart';

class MyDiaryHeader extends StatelessWidget {
  final post;

  const MyDiaryHeader({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Emotion(data: post),
        SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 12,
                    child: Text(
                      post.createdAt.split('T')[0].replaceAll('-', '.'),
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 12,
                    color: Colors.white,
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  ),
                  Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          post.group.isEmpty ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '개인',
                                style: TextStyle(fontSize: 12, color: Colors.white),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(
                                width: 1,
                                height: 12,
                                color: Colors.white,
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                              ),
                            ],
                          ):Text(
                            post.group[0]['title'],
                            style: TextStyle(fontSize: 12, color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),

                        ],
                      )),
                  post.group.isEmpty ?Text(post.private == 1 ? '비공개' : '공개',
                      style: TextStyle(
                          fontSize: 12, color: Colors.white)):Container(),
                ],
              ),
            ],
          ),
        ),
        DiaryType(data: post)
      ],
    );
  }
}
