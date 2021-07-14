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
  @override
  Widget build(BuildContext context) {
    double contentHeight;
    if(widget.data.id%2==1){
      contentHeight=150;
    }else{
      contentHeight=300;
    }
    return Container(
        width: 330,
        padding: EdgeInsets.all(15),
        constraints: BoxConstraints(minHeight: 320),
        decoration: BoxDecoration(
            color: Color(0xffffffff), borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ImageSlider(data:widget.data),
            Container(
                height: contentHeight,
                child: Scrollbar(
                  thickness: 6,
                  radius: Radius.circular(13),
                  controller: _controllerOne,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(right: 10),
                    controller: _controllerOne,
                    scrollDirection: Axis.vertical,
                    child: Text(
                      '데 이 터 데이\n\n\n\n\n\n\n\n\n\n\n\n 터데 이 터 데 이 터데 이 터 데 이 터데 이 터 데 이 터데 이 터 데 이 터데 이 터 데 이 터',
                      style: TextStyle(
                          color: Colors.black, fontSize: 12, height: 2),
                    ),
                  ),
                ))
          ],
        ));
  }
}
