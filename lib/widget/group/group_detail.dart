import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupDetail extends StatefulWidget {
  final group;

  const GroupDetail({Key key, this.group}) : super(key: key);

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String userId;
  List _data = [];
  Map<int, List<dynamic>> myEmotion = {};

  @override
  void initState() {
    // TODO: implement initState
    _getId().then((res) {
      // 해당그룹 글 가져오기
      // 내 이모션 리스트 가져오기
    });
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
        title: Text(
          widget.group['title'],
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SmartRefresher(
          header: MaterialClassicHeader(
            color: Colors.white,
            backgroundColor: Color(0xff3d3d3d),
          ),
          footer: ClassicFooter(
            canLoadingText: '',
            loadingText: '',
            idleText: '',
          ),
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: () {
            setState(() {
              //내그룹리스트 새로 받아오기
              _data.add(1);
            });
            _refreshController.refreshCompleted();
          },
          enablePullUp: true,
          onLoading: () {
            setState(() {
              _data.addAll({1, 2, 3, 4, 5});
            });
            _refreshController.loadComplete();
          },
          child: ListView.builder(
            itemCount: _data.length + 1,
            itemBuilder: (c, i) {
              //아무글이 없을경우
              if (_data.length == 0) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        height: 180,
                        child: Text(
                          '그룹명',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xff2D2D2D),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(13),
                              topRight: Radius.circular(13)),
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Color(0xff4D4D4D),
                      ),
                      Container(
                        height: 150,
                        width: double.infinity,
                        color: Color(0xff2D2D2D),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10,20,10,20),
                          child: Container(
                            height: 115,
                            color: Color(0xff3D3D3D),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                              width: double.infinity,
                              height: 25,
                              decoration: BoxDecoration(
                                color: Color(0xff2d2d2d),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(13),
                                    bottomRight: Radius.circular(13)),
                              )),
                          SizedBox(
                            height: 20,
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }
              if (i == 0) {
                //글이 있을경우 최상단
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        width: double.infinity,
                        height: 55,
                        child: Text(
                          '나의 그룹 목록',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xff2D2D2D),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(13),
                              topRight: Radius.circular(13)),
                        ),
                      ),
                      //카드 바꾸기
                      Column(
                        children: [
                          Container(
                            height: 100,
                            color: Colors.white,
                          ),
                          Container(
                            width: double.infinity,
                            height: 20,
                            color: Color(0xff2d2d2d),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              if (i == _data.length) {
                //최하단
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                          width: double.infinity,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Color(0xff2d2d2d),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(13),
                                bottomRight: Radius.circular(13)),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                );
              }

              //카드
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      color: Colors.white,
                    ),
                    Container(
                      width: double.infinity,
                      height: 20,
                      color: Color(0xff2d2d2d),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
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
