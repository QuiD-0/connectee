import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
final data;
  const ImageSlider({Key key,this.data}) : super(key: key);

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  @override
  Widget build(BuildContext context) {
    if (widget.data.id%2==1) {
      return Container(
        height: 300,
      );
    }
    else{
      return Container();
    }
  }
}
