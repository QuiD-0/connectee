import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  final List<String> images;
  final data;

  const ImageSlider({Key key, this.data, this.images}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  List<String> movies;
  List<Widget> imageWidget;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    movies = widget.images;
    imageWidget = movies
        .map((m) => FadeInImage.assetNetwork(
      placeholder:
      'assets/loading300.gif',
      image: m,
      width: 300,
      height: 300,
      fit: BoxFit.cover,
    ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // api 연결 후 이미지가 있을경우로 수정하기
    return Container(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            items: imageWidget,
            options: CarouselOptions(
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                viewportFraction: 1.05,
                aspectRatio: 1,
                enlargeCenterPage: true,
                enableInfiniteScroll: false),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: makeIndicator(imageWidget, _currentPage),
            ),
          )
        ],
      ),
    );
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
