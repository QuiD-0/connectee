import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  final type;

  const Search({Key key, this.type}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchValue;

  @override
  void initState() {
    // TODO: implement initState
    searchValue = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              size: 16,
              color: Colors.white,
            ),
            onPressed: () {
              //취소 팝업 보이기
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            widget.type == "movie" ? '영화검색' : "도서검색",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              //검색창
              Container(
                height: 48,
                margin: EdgeInsets.only(left: 10, right: 10),
                decoration: BoxDecoration(
                    color: Color(0xff2d2d2d),
                    borderRadius: BorderRadius.circular(13)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 300,
                        child: TextField(
                          onChanged: (text) {
                            setState(() {
                              searchValue = text;
                            });
                          },
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          cursorColor: Colors.white,
                        )),
                    IconButton(
                        splashColor: Colors.transparent,
                        onPressed: () {
                          print("$searchValue");
                        },
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        )),

                  ],
                ),
              ),
              // 최근 검색어

              //검색 결과
            ],
          ),
        ));
  }
}
