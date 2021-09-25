import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  final user;
  const EditProfile({Key key,this.user}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var user;
  @override
  void initState() {
    // TODO: implement initState
    user=widget.user;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '프로필 수정',
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
        actions: [
          GestureDetector(
            onTap: (){
              print('작성');
            },
            child:Container(
              alignment: Alignment.center,
              width: 80,
              height: 40,
              child: Text(
                '완료',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
