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
      for(var i in map['themes']){
        topics.add(i['name']);
      }
      return topics;
  }
}
