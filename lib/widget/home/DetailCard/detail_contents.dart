import 'package:flutter/material.dart';
import 'image_slider.dart';

final ScrollController _controllerOne = ScrollController();

//detail 데이터 받아오기 필요

//detail model 만들기

class DetailContents extends StatefulWidget {
  final data;

  const DetailContents({Key key, this.data}) : super(key: key);

  @override
  _DetailContentsState createState() => _DetailContentsState();
}

class _DetailContentsState extends State<DetailContents> {
  //이미지 리스트 받아오기
  List<String> movies = [
    'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
    'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
    'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
    'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    double contentHeight;
    if (widget.data.id % 2 == 1) {
      contentHeight = 150;
    } else {
      contentHeight = 280;
    }
    return Container(
      width: 330,
      padding: EdgeInsets.fromLTRB(20,15,20,15),
      decoration: BoxDecoration(
          color: Color(0xffffffff), borderRadius: BorderRadius.circular(10)),
      child: widget.data.id % 2 == 1
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageSlider(
                  data: widget.data,
                  movies: movies,
                ),
                Container(
                    padding: EdgeInsets.only(bottom: 5),
                    constraints: BoxConstraints( minWidth: 300),
                    child:Text(
                      '데 이 터 데이 터데 이 터 데이 터데 이 이 터데 이 터 데 이터데 이터 데이 터데 이 터 데 이 터',
                      style: TextStyle(
                          color: Colors.black, fontSize: 13, height: 2),
                    ),
                )
              ],
            )
          : Container(
              padding: EdgeInsets.only(bottom: 5),
              constraints: BoxConstraints(minWidth: 300),
              child: Text(
                '데 이 터 데이 터데 이 \n\n\n\n\n\n터 데이\n\n\n\n\n\n \n\n\n\n터데 이\n\n\데 이 터데 이 터\n\ 데 이터데 이 터 데 이 터\n\n데 이 터 데 이 터',
                style:
                TextStyle(color: Colors.black, fontSize: 12, height: 2),
              ),
              ),
    );
  }
}
