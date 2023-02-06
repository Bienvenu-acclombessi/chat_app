class UserModel {
  final String nom;
  final String prenom;
  final String uid;
  final String email;
  final String? profileImageUrl;
  final bool? active;
  final int? lastSeen;

  UserModel({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.uid,
     this.profileImageUrl,
     this.active,
     this.lastSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'uid': uid,
      'profileImageUrl': profileImageUrl,
      'active': active,
      'lastSeen': lastSeen
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      active: map['active'] ?? false,
      lastSeen: map['lastSeen'] ?? 0,
    );
  }
}
