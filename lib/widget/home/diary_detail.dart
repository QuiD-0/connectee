import 'package:flutter/material.dart';

class DiaryDetail extends StatelessWidget {
  final data;
  const DiaryDetail({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('추천 다이어리'),
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Text('${data.id} test'),
    );
  }
}
