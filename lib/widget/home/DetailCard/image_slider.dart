import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class ImageSlider extends StatefulWidget {
  final List<String> movies;
  final data;
  const ImageSlider({Key key,this.data,this.movies}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  List<String> movies;
  List<Widget> images;
  int _currentPage = 0;


  @override
  void initState() {
    super.initState();
    movies = widget.movies;
    images = movies.map((m) => Image.network(m,fit: BoxFit.cover,height: 300,width: 300,)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // api 연결 후 이미지가 있을경우로 수정하기
    if (widget.data.id%2==1) {
      return Container(
        child: Column(
          children: <Widget>[
            CarouselSlider(
              items: images,
              options: CarouselOptions(onPageChanged: (index, reason) {
                setState(() {
                  _currentPage = index;
                });
              },viewportFraction: 1.05,aspectRatio: 1,enlargeCenterPage: true),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: makeIndicator(images, _currentPage),
              ),
            )
          ],
        ),
      );
    }
    else{
      return Container();
    }
  }
}


List<Widget> makeIndicator(List list, int _currentPage) {
  List<Widget> results = [];
  for (var i = 0; i < list.length; i++) {
    results.add(Container(
      width: 6,
      height: 6,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPage == i ? Color(0xff000000) : Color(0xffc4c4c4)),
    ));
  }

  return results;
}
