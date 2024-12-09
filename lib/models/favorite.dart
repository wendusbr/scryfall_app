import 'package:cloud_firestore/cloud_firestore.dart';

class Favorite {
  String card_id;
  String card_image;
  Timestamp created_at;
  String user_id;

  Favorite(
      {required this.card_id,
      required this.card_image,
      required this.created_at,
      required this.user_id});

  Favorite.fromJson(Map<String, Object?> json)
      : this(
            card_id: json['card_id']! as String,
            card_image: json['card_image']! as String,
            created_at: json['created_at']! as Timestamp,
            user_id: json['user_id']! as String);

  Favorite copyWith(
      {String? card_id, String? card_image, Timestamp? created_at, String? user_id}) {
    return Favorite(
        card_id: card_id ?? this.card_id,
        card_image: card_image ?? this.card_image,
        created_at: created_at ?? this.created_at,
        user_id: user_id ?? this.user_id);
  }

  Map<String, Object?> toJson() {
    return {
      'card_id': card_id,
      'card_image': card_image,
      'created_at': created_at,
      'user_id': user_id
    };
  }
}
