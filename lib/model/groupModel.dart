class Group {
  int groupId;
  String name;
  String description;
  int limitMembers;
  bool private;
  String password;
  int OwnerId;
  String imageUrl;
  int groupUserCount;
  List themes;

  Group.fromMap(Map<String, dynamic> map)
      :groupId=map['id'],
        name=map['title'],
        description=map['description'],
        limitMembers=map['limitMembers'],
        private=map['private'],
        password=map['password'],
        OwnerId=map['OwnerId'],
        imageUrl=map['imageUrl'],
        groupUserCount=map['groupUserCount'],
        themes=[
          // for(var i in map['themes']){
          //   i['name']
          // }
        ];
}
