import 'package:flutter/material.dart';

class Rules extends StatelessWidget {
  const Rules({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '다이어리 이용 규칙',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            size: 16,
          ),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
