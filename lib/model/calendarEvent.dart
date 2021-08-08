import 'package:flutter/foundation.dart';
class Event {
  final String emotionType;
  Event({@required this.emotionType});
  Event.formMap(String map) : emotionType = map;
}