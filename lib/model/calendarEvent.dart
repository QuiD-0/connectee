import 'package:flutter/foundation.dart';

class Event {
  final String emotionType;
  int id;

  Event({@required this.emotionType});

  Event.formMap(Map<String, dynamic> map)
      : emotionType = map["mainEmotionType"],
        id = map['id'];
}
