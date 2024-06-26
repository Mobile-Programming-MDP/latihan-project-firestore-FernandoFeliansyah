import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String? id;
  final String title;
  final String description;
  String? imageUrl;
  String? lat;
  String? lng;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Note({
    this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.lat,
    this.lng,
    this.createdAt,
    this.updatedAt,
  });

  factory Note.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'],
      description: data['description'],
      imageUrl: data['image_url'],
      lat: data['lat'],
      lng: data['lng'],
      createdAt: data['created_at'] as Timestamp,
      updatedAt: data['updated_at'] as Timestamp,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'description': description,
      'image_url' : imageUrl,
      'lat' : lat,
      'lng' : lng,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
