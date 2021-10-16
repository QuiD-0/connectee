class Group {
  int groupId;
  String title;
  String description;
  int limitMembers;
  bool private;
  String password;
  int OwnerId;
  String imageUrl;
  int groupUserCount;
  List topic;

  Group.fromMap(Map<String, dynamic> map)
      :groupId=map['id'],
        title=map['title'],
        description=map['description'],
        limitMembers=map['limitMembers'],
        private=map['private'],
        password=map['password'],
        OwnerId=map['OwnerId'],
        imageUrl=map['imageUrl'],
        groupUserCount=map['groupUserCount'],
        topic=getThemes(map);

  static getThemes(map) {
    var topics=[];
      for(var i in map['GroupThemes']){
        topics.add(themes[i['ThemeId']-1]);
      }
      return topics;
  }
}

List themes=['취미','여행','공부','운동','맛집','영화','사랑','책','애완동물','고민'];