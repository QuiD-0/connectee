import 'package:flutter/material.dart';

class ReactionButtons extends StatefulWidget {
  const ReactionButtons({Key key}) : super(key: key);

  @override
  _ReactionButtonsState createState() => _ReactionButtonsState();
}

class _ReactionButtonsState extends State<ReactionButtons> {
  int selectedEmotion;

  @override
  void initState() {
    // TODO: implement initState
    //사용자 좋아요 정보 받아오기
    super.initState();
  }

  void changeEmotion(emotion) {
    if (emotion == selectedEmotion) {
      setState(() {
        selectedEmotion = null;
        print(selectedEmotion);
      });
    } else {
      setState(() {
        selectedEmotion = emotion;
        print(selectedEmotion);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  changeEmotion(1);
                },
                child: Container(
                  width: 40,
                  height: 60,
                  margin: EdgeInsets.all(5),
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [],
          )
        ],
      ),
    );
  }
}
