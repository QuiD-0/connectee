import 'package:flutter/material.dart';

class OpenSource extends StatelessWidget {
  const OpenSource({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '오픈소스 라이선스',
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
