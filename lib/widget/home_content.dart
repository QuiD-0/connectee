import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'home/RecCard/rec_card.dart';
import 'home/main_postDiary.dart';
import 'home/recommend_header.dart';
import 'home/tabelCalendar.dart';

class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class Post {
  int id;
  String name;
  int age;

  Post(this.id, this.name, this.age);

  Post.formMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        age = map['age'];
}

class _HomeContentState extends State<HomeContent> {
  List _data = [];
  int page = 1;
  ScrollController _Scroll = ScrollController();
  int id;

  @override
  void initState() {
    _data = [
      Post(1, 'asd', 12),
      Post(2, 'asd', 12),
      Post(3, 'asd', 12)
    ];
     // _fetchData();
    _Scroll.addListener(() {
      if (_Scroll.position.pixels >= _Scroll.position.maxScrollExtent) {
        _fetchData();
      }
    });
    _getId();
    super.initState();
  }

  _getId() async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt('userId');
    });
  }

  void dispose() {
    _Scroll.dispose();
    super.dispose();
  }

  Future _fetchData() async {
    int limit = 15;
    await http
        .get(Uri.parse("http://18.216.47.35:3000/?page=$page&limit=$limit"))
        .then((res) {
      if (res.statusCode == 200) {
        String jsonString = res.body;
        List posts = jsonDecode(jsonString);
        for (int i = 0; i < posts.length; i++) {
          var post = posts[i];
          Post postToAdd = Post(post["id"], post["name"], post["age"]);
          setState(() {
            _data.add(postToAdd);
          });
        }
        setState(() {
          page++;
        });
      } else {
        print('error');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 14.0,bottom: 13),
          child: Calendar(),
        ),
        PostDiary(),
        RecommendHeader(),
        ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            controller: _Scroll,
            itemCount: _data.length + 1,
            itemBuilder: (context, index) {
              if (index == _data.length) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(child: CircularProgressIndicator()),
                  //로딩 아이콘 의뢰 ?? -> 시간 남으면.
                );
              }
              Post post = _data[index];
              return Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xff3d3d3d),
                      ),
                      child: RecommendCard(data: post), // 추천 카드
                    ),
                    Container(
                      height: 15,
                      width: 360,
                      decoration: BoxDecoration(color: Color(0xff2d2d2d)),
                    )
                  ],
                ),
              );
            })
      ],
    ));
  }
}
