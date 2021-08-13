import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalDetail extends StatefulWidget {
  final date;
  final emotion;

  const CalDetail({Key key, this.date, this.emotion}) : super(key: key);

  @override
  _CalDetailState createState() => _CalDetailState();
}

class _CalDetailState extends State<CalDetail> {
  String mainEmotion;
  List Emotions;
  List Diarys;

  @override
  void initState() {
    // TODO: implement initState
    mainEmotion = widget.emotion;
    //페치 받기
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.date.toString().split(' ')[0].replaceAll('-', '.')}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
            // 내 리액션 뒤로 넘기기
            onPressed: () async {
              //대표감정 보내기
              Navigator.of(context).pop([widget.date, mainEmotion]);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff2d2d2d),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(13),
                        topRight: Radius.circular(13)),
                  ),
                  constraints: BoxConstraints(minHeight: 200),
                  child:  Column(
                    children: [
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          '${widget.date.month}월 ${widget.date.day}일의 대표감정',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ),
                      Image.asset('assets/emotions/${mainEmotion}_big.png'),

                    ],
                  ),
                ),
                ),
            ],
          ),
        ));
  }
}
