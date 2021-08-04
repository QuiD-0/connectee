import 'dart:convert';
import 'package:html/parser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectee/secret.dart';

class Search extends StatefulWidget {
  final type;

  const Search({Key key, this.type}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

// 영화, 독서 최근 검색어 분리 type에 따라
class _SearchState extends State<Search> {
  var txt = TextEditingController();
  bool visibleRecent;
  List searchData = [];
  int total = null;
  List<String> movieRecent = [];
  List<String> bookRecent = [];

  @override
  void initState() {
    // TODO: implement initState
    visibleRecent = true;
    _getList();
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 15),
                        width: 300,
                        child: TextField(
                          controller: txt,
                          onChanged: (text) {
                            if (text == "") {
                              setState(() {
                                visibleRecent = true;
                                searchData = [];
                              });
                            }
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
                          //검색어 저장
                          _saveList(txt.text);
                          print(movieRecent);
                          //최근 검색어 끄기
                          setState(() {
                            visibleRecent = false;
                          });
                          //api통신
                          widget.type == "movie"
                              ? _getMovieData(txt.text)
                              : _getBookData(txt.text);
                        },
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              // 최근 검색어
              visibleRecent
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(10, 25, 10, 0),
                      child: Container(
                        constraints: BoxConstraints(minHeight: 100),
                        decoration: BoxDecoration(
                          color: Color(0xff2d2d2d),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '최근 검색어',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    padding: EdgeInsets.fromLTRB(12, 5, 12, 5),
                                    decoration: BoxDecoration(
                                        color: Color(0xff4d4d4d),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: GestureDetector(
                                      onTap: () async {
                                        _deleteAll();
                                        _getList();
                                      },
                                      child: Text('전체삭제',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              widget.type == "movie"
                                  ? movieRecent.isNotEmpty
                                      ? Wrap(
                                          alignment: WrapAlignment.start,
                                          children: movieRecent.reversed
                                              .map((item) => GestureDetector(
                                                    onTap: () {
                                                      print(item);
                                                      txt.text = item;
                                                      txt
                                                        ..selection =
                                                            TextSelection
                                                                .fromPosition(
                                                          TextPosition(
                                                              offset: txt
                                                                  .text.length),
                                                        );
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.all(5),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              13, 5, 10, 5),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff9D9D9D),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      13)),
                                                      child: Wrap(
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          Text(item),
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 3,
                                                                      top: 1),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  _delete(item);
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .clear_rounded,
                                                                  size: 14,
                                                                ),
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                              .toList()
                                              .cast<Widget>(),
                                        )
                                      : Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Text('최근 검색어가 없습니다.',
                                              style: TextStyle(
                                                color: Color(0xffcdcdcd),
                                              ),),
                                        ),
                                      )
                                  : bookRecent.isNotEmpty
                                      ? Wrap(
                                          alignment: WrapAlignment.start,
                                          children: bookRecent.reversed
                                              .map((item) => GestureDetector(
                                                    onTap: () {
                                                      print(item);
                                                      txt.text = item;
                                                      txt
                                                        ..selection =
                                                            TextSelection
                                                                .fromPosition(
                                                          TextPosition(
                                                              offset: txt
                                                                  .text.length),
                                                        );
                                                    },
                                                    child: Container(
                                                      margin: EdgeInsets.all(5),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              13, 5, 10, 5),
                                                      decoration: BoxDecoration(
                                                          color:
                                                              Color(0xff9D9D9D),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      13)),
                                                      child: Wrap(
                                                        alignment: WrapAlignment
                                                            .center,
                                                        children: [
                                                          Text(item),
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 3,
                                                                      top: 1),
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  _delete(item);
                                                                },
                                                                child: Icon(
                                                                  Icons
                                                                      .clear_rounded,
                                                                  size: 14,
                                                                ),
                                                              ))
                                                        ],
                                                      ),
                                                    ),
                                                  ))
                                              .toList()
                                              .cast<Widget>(),
                                        )
                                      : Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text('최근 검색어가 없습니다.',
                                    style: TextStyle(
                                      color: Color(0xffcdcdcd),
                                    ),),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              //검색 결과
              visibleRecent == false
                  ? ListView.builder(
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: searchData.length + 1,
                      itemBuilder: (context, index) {
                        if (total != 0 && index == 0) {
                          return Container(
                            alignment: Alignment.center,
                            height: 70,
                            child: Text(
                              '${txt.text} 검색 결과 $total건',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          );
                        } else if (total == 0 && index == 0) {
                          return Container(
                            alignment: Alignment.bottomCenter,
                            height: 300,
                            child: Text(
                              '검색결과가 없습니다.',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                              decoration: BoxDecoration(
                                  color: Color(0xff3d3d3d),
                                  borderRadius: BorderRadius.circular(13)),
                              height: 114,
                              child: widget.type == "movie"
                                  ? Row(
                                      children: [
                                        searchData[index - 1]['image'] != "none"
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                child: Image.network(
                                                  searchData[index - 1]
                                                      ['image'],
                                                  width: 82,
                                                  height: 82,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Container(
                                                alignment: Alignment.center,
                                                width: 82,
                                                height: 82,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff4d4d4d),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13)),
                                                child: Text(
                                                  '이미지가\n없습니다',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                              ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                    width: 175,
                                                    child: Text(
                                                      searchData[index - 1]
                                                          ['title'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop([
                                                      searchData[index - 1]
                                                          ['title'],
                                                      searchData[index - 1]
                                                          ['image'],
                                                      searchData[index - 1]
                                                          ['director'],
                                                      searchData[index - 1]
                                                          ['actor'],
                                                      searchData[index - 1]
                                                          ['playDate'],
                                                    ]);
                                                  },
                                                  child: Container(
                                                    width: 70,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff2d2d2d),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '선택',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 240,
                                              child: Text(
                                                '감독: ${searchData[index - 1]['director']}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                width: 240,
                                                child: Text(
                                                  '배우: ${searchData[index - 1]['actor']}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                          ],
                                        )
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        searchData[index - 1]['image'] != "none"
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(13),
                                                child: Image.network(
                                                  searchData[index - 1]
                                                      ['image'],
                                                  width: 82,
                                                  height: 82,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Container(
                                                alignment: Alignment.center,
                                                width: 82,
                                                height: 82,
                                                decoration: BoxDecoration(
                                                    color: Color(0xff4d4d4d),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13)),
                                                child: Text(
                                                  '이미지가\n없습니다',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10),
                                                ),
                                              ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                    width: 175,
                                                    child: Text(
                                                      searchData[index - 1]
                                                          ['title'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )),
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pop([
                                                      searchData[index - 1]
                                                          ['title'],
                                                      searchData[index - 1]
                                                          ['image'],
                                                      searchData[index - 1]
                                                          ['author'],
                                                      searchData[index - 1]
                                                          ['publisher'],
                                                      searchData[index - 1]
                                                          ['pubDate'],
                                                    ]);
                                                  },
                                                  child: Container(
                                                    width: 70,
                                                    height: 30,
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff2d2d2d),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '선택',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 240,
                                              child: Text(
                                                '저자: ${searchData[index - 1]['author']}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                                width: 240,
                                                child: Text(
                                                  '출판: ${searchData[index - 1]['publisher']}',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                            ),
                          );
                        }
                      })
                  : Container()
            ],
          ),
        ));
  }

  _getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.type == "movie"
          ? movieRecent = prefs.getStringList('movieRecent') ?? []
          : bookRecent = prefs.getStringList('bookRecent') ?? [];
    });
  }

  _saveList(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (data != '') {
      if (widget.type == "movie") {
        if (!movieRecent.contains(data)) {
          if (movieRecent.length == 10) {
            movieRecent.removeAt(0);
          }
          movieRecent.add(data.toString());
          await prefs.setStringList("movieRecent", movieRecent);
        }
      } else {
        if (!bookRecent.contains(data)) {
          if (bookRecent.length == 10) {
            bookRecent.removeAt(0);
          }
          bookRecent.add(data.toString());
          await prefs.setStringList("bookRecent", bookRecent);
        }
      }
    }
  }

  _delete(String item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.type == "movie") {
      setState(() {
        movieRecent.remove(item);
      });
      await prefs.setStringList("movieRecent", movieRecent);
    } else {
      setState(() {
        bookRecent.remove(item);
      });
      await prefs.setStringList("bookRecent", bookRecent);
    }
  }

  _deleteAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (widget.type == "movie") {
      setState(() {
        movieRecent=[];
      });
      await prefs.setStringList("movieRecent", movieRecent);
    } else {
      setState(() {
        bookRecent=[];
      });
      await prefs.setStringList("bookRecent", bookRecent);
    }
  }

  _getMovieData(String name) async {
    Map<String, String> requestHeaders = {
      'X-Naver-Client-Id': clientId.toString(),
      'X-Naver-Client-Secret': clientSecret.toString(),
    };
    await http
        .get(
            Uri.parse(
                "https://openapi.naver.com/v1/search/movie.json?query=$name"),
            headers: requestHeaders)
        .then((res) {
      if (res.statusCode == 200) {
        var result = json.decode(res.body);
        total = result['total'];
        setState(() {
          searchData.clear();
        });
        for (var i = 0; i < total; i++) {
          searchData.add({
            'title': _parseHtmlString(result['items'][i]['title']),
            'image': result['items'][i]['image'] != ""
                ? result['items'][i]['image']
                : "none",
            "director": _replaceBar(result['items'][i]["director"]),
            "actor": _replaceBar(result['items'][i]["actor"]),
            'playDate': result['items'][i]['pubDate'],
          });
        }
      } else {
        print(res.body);
      }
    });
  }

  _getBookData(String name) async {
    Map<String, String> requestHeaders = {
      'X-Naver-Client-Id': clientId.toString(),
      'X-Naver-Client-Secret': clientSecret.toString(),
    };
    await http
        .get(
            Uri.parse(
                "https://openapi.naver.com/v1/search/book.json?query=$name&display=50"),
            headers: requestHeaders)
        .then((res) {
      if (res.statusCode == 200) {
        var result = json.decode(res.body);
        total = result['total'] <= 50 ? result['total'] : 50;
        setState(() {
          searchData.clear();
        });
        for (var i = 0; i < total; i++) {
          searchData.add({
            'title': _parseHtmlString(result['items'][i]['title']),
            'image': result['items'][i]['image'] != ""
                ? result['items'][i]['image']
                : "none",
            "author": result['items'][i]["author"],
            "publisher": result['items'][i]["publisher"],
            'pubDate': _addDateComma(result['items'][i]['pubdate']),
          });
        }
      } else {
        print(res.body);
      }
    });
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  String _replaceBar(String data) {
    var resultData = data.replaceAll("|", ", ");
    if (resultData.endsWith(" ")) {
      resultData = resultData.substring(0, resultData.length - 2);
    }
    return resultData;
  }

  String _addDateComma(String data) {
    data = data.length == 8
        ? data.substring(0, 4) +
            "." +
            data.substring(4, 6) +
            "." +
            data.substring(6, 8)
        : data.substring(0, 2) +
            "." +
            data.substring(2, 4) +
            "." +
            data.substring(4, 6);
    return data;
  }
}
