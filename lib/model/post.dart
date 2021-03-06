class Diary {
  int diaryId;
  String title;
  String content;
  String emotionType;
  String category;
  String createdAt;
  int userId;
  int emotionLevel;
  List<String> Images;
  String nickname;
  String maxEmotion;
  int emotionCount;
  String linkImg;
  List<dynamic> group;
  int private;
  Map<String,dynamic> book;
  Map<String,dynamic> movie;
  double rating;

  Diary.fromMap(Map<String, dynamic> map)
      : diaryId = map['id'],
        title = map['title'],
        content = map['content'],
        emotionType = map['emotionType'],
        category = map['category'],
        createdAt = map['createdAt'],
        userId = map['userId'],
        nickname = map["User"]['nickname'],
        maxEmotion = map['maxEmotion'],
        emotionLevel = map['emotionLevel'],
        emotionCount = map['Comments'].length,
        group = map['groups']??[],
        private = map['private'],
        // Images=[],
        Images = [
          for (var i = 0; i < map["Images"].length; i++)
            map["Images"][i]["location"]
        ],
        linkImg = getImg(map),
        rating = map['categoryScore']??0,
        book = getBook(map),
        movie = getMovie(map);


  static getImg(Map<String, dynamic> map) {
    if (map['BookApi'] != null) {
      return map['BookApi']["imgLink"];
    }
    else if (map['MovieApi'] != null) {
      return map['MovieApi']["imgLink"];
    }
    else{
      return "none";
    }
  }

  static getBook(Map<String, dynamic> map) {
    if (map['BookApi'] != null) {
      return map['BookApi'];
    }
    else{
      return null;
    }
  }

  static getMovie(Map<String, dynamic> map) {
    if (map['MovieApi'] != null) {
      return map['MovieApi'];
    }else{
      return null;
    }
  }

}
