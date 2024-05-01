import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  final String email;
  final String name;
  final String profilePicture;
  final String uid;

  User({
    required this.email,
    required this.name,
    required this.profilePicture,
    required this.uid,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'name': name,
      'profilePicture': profilePicture,
      'uid': uid,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      name: map['name'] as String,
      profilePicture: map['profilePicture'] as String,
      uid: map['_id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  User copyWith({
    String? email,
    String? name,
    String? profilePicture,
    String? uid,
  }) {
    return User(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePicture: profilePicture ?? this.profilePicture,
      uid: uid ?? this.uid,
    );
  }
}
