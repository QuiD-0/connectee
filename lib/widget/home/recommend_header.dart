import 'package:flutter/material.dart';

class RecommendHeader extends StatelessWidget {
  const RecommendHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 16,left: 16),
          child: Text(
            '추천 다이어리',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        width: 360,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(13), topRight: Radius.circular(13)),
          color: Color(0xff2d2d2d),
        ),
      ),
    );
  }
}
