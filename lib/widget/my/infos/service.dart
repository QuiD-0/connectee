import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class Service extends StatelessWidget {
  const Service({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: "https://pool-periodical-7cf.notion.site/c1cf417ad112405493b69476894de17a",
      appBar: new AppBar(
        title: Text(
          '서비스 이용약관',
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
