import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupSearch extends StatefulWidget {
  const GroupSearch({Key key}) : super(key: key);

  @override
  _GroupSearchState createState() => _GroupSearchState();
}

class _GroupSearchState extends State<GroupSearch> {
  var txt = TextEditingController();
  bool visibleRecent;
  List searchData = [];
  int total = null;
  List<String> recent = [];

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
              Navigator.of(context).pop();
            },
          ),
          centerTitle: true,
          title: Text(
            "검색",
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
                          onSubmitted: (value) {
                            //검색어 저장
                            _saveList(txt.text);
                            //최근 검색어 끄기
                            setState(() {
                              visibleRecent = false;
                            });
                            //api통신

                          },
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
                          //최근 검색어 끄기
                          setState(() {
                            visibleRecent = false;
                          });
                          //api통신 그룹 검색
                          //_getGroupData(txt.text);
                        },
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                        )),
                  ],
                ),
              ),
              // 최근 검색어
              visibleRecent && recent.isNotEmpty
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
                        Wrap(
                          alignment: WrapAlignment.start,
                          children: recent.reversed
                              .map((item) =>
                              GestureDetector(
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
                      return Text('test',style: TextStyle(color: Colors.white),);
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

  _delete(String item) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        recent.remove(item);
      });
      await prefs.setStringList("recent", recent);

  }

  _deleteAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        recent = [];
      });
      await prefs.setStringList("recent", recent);

  }
}