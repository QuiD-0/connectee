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
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeEmotion(1);
                    },
                    child: selectedEmotion !=1 ?Image.asset(
                      'assets/emotions/emotion_1.png',width: 60,
                    ):Image.asset(
                      'assets/emotions/emotion_1_on.png',width: 60,
                    ),
                  ),
                  Text('화남',style: TextStyle(color: Colors.white,fontSize: 11,height: 0.7),),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeEmotion(2);
                    },
                    child: selectedEmotion !=2 ?Image.asset(
                      'assets/emotions/emotion_2.png',width: 60,
                    ):Image.asset(
                      'assets/emotions/emotion_2_on.png',width: 60,
                    ),
                  ),
                  Text('놀람',style: TextStyle(color: Colors.white,fontSize: 11,height: 0.7),),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeEmotion(3);
                    },
                    child: selectedEmotion !=3 ?Image.asset(
                      'assets/emotions/emotion_3.png',width: 60,
                    ):Image.asset(
                      'assets/emotions/emotion_3_on.png',width: 60,
                    ),
                  ),
                  Text('기쁨',style: TextStyle(color: Colors.white,fontSize: 11,height: 0.7),),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeEmotion(4);
                    },
                    child: selectedEmotion !=4 ?Image.asset(
                      'assets/emotions/emotion_4.png',width: 60,
                    ):Image.asset(
                      'assets/emotions/emotion_4_on.png',width: 60,
                    ),
                  ),
                  Text('슬픔',style: TextStyle(color: Colors.white,fontSize: 11,height: 0.7),),
                ],
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeEmotion(5);
                    },
                    child: selectedEmotion !=5 ?Image.asset(
                      'assets/emotions/emotion_5.png',width: 60,
                    ):Image.asset(
                      'assets/emotions/emotion_5_on.png',width: 60,
                    ),
                  ),
                  Text('역겨움',style: TextStyle(color: Colors.white,fontSize: 11,height: 0.7),),
                ],
              ),

            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Column(
              children: [
                GestureDetector(
                  onTap: () {
                    changeEmotion(6);
                  },
                  child: selectedEmotion !=6 ?Image.asset(
                    'assets/emotions/emotion_6.png',width: 60,
                  ):Image.asset(
                    'assets/emotions/emotion_6_on.png',width: 60,
                  ),
                ),
                Text('공포',style: TextStyle(color: Colors.white,fontSize: 11,height: 0.7),),
              ],
            ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      changeEmotion(7);
                    },
                    child: selectedEmotion !=7 ?Image.asset(
                      'assets/emotions/emotion_7.png',width: 60,
                    ):Image.asset(
                      'assets/emotions/emotion_7_on.png',width: 60,
                    ),
                  ),
                  Text('중립',style: TextStyle(color: Colors.white,fontSize: 11,height: 0.7),),
                ],
              ),],
          )
        ],
      ),
    );
  }
}
