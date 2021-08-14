import 'package:flutter/foundation.dart';

class Event {
  final String emotionType;
  final bool isMain;

  Event({@required this.emotionType, this.isMain});

  Event.formMap(Map<String, dynamic> map)
      : emotionType = map["emotionType"],
  // DB에서 온 값으로 바꾸기
        isMain = true;

}
