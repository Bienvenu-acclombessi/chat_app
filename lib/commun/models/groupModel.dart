class GroupModel {
  final String groupName;
  final String groupIcon;
  final String admin;
  final String groupId;
  final String recentMessageSender;
  final List<dynamic> members;
  final String recentMessage;


  GroupModel({
    required this.groupName,
    required this.groupIcon,
    required this.groupId,
    required this.admin,
    required this.members,
    required this.recentMessage,
    required this.recentMessageSender
  });

  Map<String, dynamic> toMap() {
    return {
      "groupName": groupName,
      "groupIcon": groupIcon,
      "admin": admin,
      "members": members,
      "groupId": groupId,
      "recentMessage": recentMessage,
      "recentMessageSender": recentMessageSender,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      groupName: map['groupName'] ?? '',
      groupId: map['groupId'] ?? '',
      groupIcon: map['groupIcon'] ?? '',
       admin: map['admin'] ?? '',
        recentMessage: map['recentMessage'] ?? '',
         recentMessageSender : map['recentMessageSender '] ?? '',
          members: map['members'] ?? [],
    
    );
  }
}
