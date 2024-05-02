// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Document {
  final String title;
  final String uid;
  final DateTime createdAt;
  final List content;
  final String id;

  Document({
      required this.title,
      required this.uid,
      required this.createdAt,
      required this.content,
      required this.id});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'uid': uid,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'content': content,
      'id': id,
    };
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      title: map['title'] as String,
      id: map['_id'] as String,
      uid: map['uid'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      content: List.from((map['content'] as List),
      )
    );
  }

  String toJson() => json.encode(toMap());

  factory Document.fromJson(String source) => Document.fromMap(json.decode(source) as Map<String, dynamic>);

  Document copyWith({
    String? title,
    String? uid,
    DateTime? createdAt,
    List? content,
    String? id,
  }) {
    return Document(
      title: title ?? this.title,
      uid: uid ?? this.uid,
      createdAt: createdAt ?? this.createdAt,
      content: content ?? this.content,
      id: id ?? this.id,
    );
  }
}