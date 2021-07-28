import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  final type;

  const Search({Key key, this.type}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${widget.type} 검색'),
      ),
      body:

      GestureDetector(
        onTap: () {
          Navigator.pop(context, ['res', 'asd', 12]);
        },
      ),
    );
  }
}
