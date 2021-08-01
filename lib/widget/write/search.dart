import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Search extends StatefulWidget {
  final type;

  const Search({Key key, this.type}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}
// 텍스트 에딧 컨트롤러로 바꾸기
// 영화, 독서 최근 검색어 분리 type에 따라
class _SearchState extends State<Search> {
  String searchValue;
  bool visibleRecent;
  List searchData = [];
  List<String> recent = [];

  _getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recent = prefs.getStringList('recent') ?? [];
    });
  }

  _saveList(data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (data != '') {
      if (!recent.contains(data)) {
        if (recent.length == 10) {
          recent.removeAt(0);
        }
        recent.add(data.toString());
        await prefs.setStringList("recent", recent);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    searchValue = '';
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
                          onChanged: (text) {
                            if (text == "") {
                              setState(() {
                                visibleRecent = true;
                                searchData = [];
                              });
                            }
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
                          //검색어 저장
                          _saveList(searchValue);
                          print(recent);
                          //최근 검색어 끄기
                          setState(() {
                            visibleRecent = false;
                          });
                          //api통신
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
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        prefs.clear();
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
                              recent.isNotEmpty
                                  ? Wrap(
                                      alignment: WrapAlignment.start,
                                      children: recent.reversed
                                          .map((item) => Container(
                                              margin: EdgeInsets.all(5),
                                              padding: EdgeInsets.fromLTRB(
                                                  13, 5, 10, 5),
                                              decoration: BoxDecoration(
                                                  color: Color(0xff9D9D9D),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          13)),
                                                child: Wrap(
                                                  alignment: WrapAlignment.center,
                                                  children: [
                                                    Text(item),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 3,top: 1),
                                                      child: Icon(Icons.clear_rounded,size: 14,)
                                                    )
                                                  ],
                                                ),
                                              ))
                                          .toList()
                                          .cast<Widget>(),
                                    )
                                  : Text('최근 검색어가 없습니다.',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                            ],
                          ),
                        ),
                      ),
                    )
                  : Container(),
              //검색 결과
              SizedBox(
                height: 10,
              ),
              searchData.isNotEmpty?ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: searchData.length+1,
                  itemBuilder: (context, index) {
                    return Text(
                      "$index",
                      style: TextStyle(color: Colors.white),
                    );
                  }):
                  Container()
            ],
          ),
        ));
  }
}
