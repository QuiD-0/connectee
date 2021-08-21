import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupDetail extends StatefulWidget {
  final group;
  const GroupDetail({Key key, this.group}) : super(key: key);

  @override
  _GroupDetailState createState() => _GroupDetailState();
}

class _GroupDetailState extends State<GroupDetail> {
  String userId;
  @override
  void initState() {
    // TODO: implement initState
    _getId().then((res){
      // 해당그룹 글 가져오기
      // 내 이모션 리스트 가져오기
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.group['title'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
    );
  }
  _getId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
  }
}
