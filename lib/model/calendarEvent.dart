import 'package:flutter/foundation.dart';

class Event {
  final String emotionType;
  final bool isMain;

  Event({@required this.emotionType, this.isMain});

  Event.formMap(Map<String, dynamic> map)
      : emotionType = map["emotionType"],
        isMain = true;

}
