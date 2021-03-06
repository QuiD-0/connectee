import 'package:flutter/material.dart';
import 'image_slider.dart';

class DetailContents extends StatefulWidget {
  final data;

  const DetailContents({Key key, this.data}) : super(key: key);

  @override
  _DetailContentsState createState() => _DetailContentsState();
}

class _DetailContentsState extends State<DetailContents> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 330,
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        decoration: BoxDecoration(
            color: Color(0xffffffff), borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.data.Images.isNotEmpty
                ? ImageSlider(
                    data: widget.data,
                    images: widget.data.Images,
                  )
                // 영호, 책 이미지 부분
                : widget.data.linkImg != 'none'
                    ? Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 5, bottom: 10),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/loading300.gif',
                            image: widget.data.linkImg,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Container(),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              constraints: BoxConstraints(minWidth: 300),
              child: Text(
                widget.data.content,
                style: TextStyle(color: Colors.black, fontSize: 13, height: 2),
              ),
            )
          ],
        ));
  }
}
