import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WriteDiary extends StatefulWidget {
  const WriteDiary({Key key}) : super(key: key);

  @override
  _WriteDiaryState createState() => _WriteDiaryState();
}

class _WriteDiaryState extends State<WriteDiary> {
  String type = "0";
  Map<String, String> types = {
    "0": "일기",
    "1": "여행",
    "2": "영화",
    "3": "도서",
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {},
      child: Scaffold(
          appBar: AppBar(
            leading: new IconButton(
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
            actions: [
              GestureDetector(
                onTap: () {
                  print('send');
                  Navigator.of(context).pop();
                },
                child: Center(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    '완료',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )),
              )
            ],
            centerTitle: true,
            title: Container(
              decoration: BoxDecoration(
                  color: Color(0xff3d3d3d),
                  borderRadius: BorderRadius.circular(30)),
              width: 80,
              height: 30,
              padding: EdgeInsets.only(left: 10),
              child: PopupMenuButton<String>(
                offset: Offset(18, 40),
                shape: ShapeBorder.lerp(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${types[type]}",
                      style: TextStyle(fontSize: 15),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
                onSelected: (String value) {
                  setState(() {
                    type = value;
                  });
                },
                color: Color(0xff2d2d2d),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: "0",
                      child: Center(
                          child: Text(
                        "일기",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    PopupMenuItem(
                      value: "1",
                      child: Center(
                          child: Text(
                        "여행",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    PopupMenuItem(
                      value: "2",
                      child: Center(
                          child: Text(
                        "영화",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                    PopupMenuItem(
                      value: "3",
                      child: Center(
                          child: Text(
                        "도서",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ];
                },
              ),
            ),
          ),
          body: type == "0" || type == "1" // 일기, 여행 다이어리
              ? Container(
                  color: Color(0xff3D3D3D),
                )
              // 영화, 도서 다이어리
              : Container(color: Color(0xff3D3D3D))),
    );
  }
}
