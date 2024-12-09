import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:scryfall_app/controllers/userController.dart';
import 'package:scryfall_app/models/favorite.dart';

const String FAVORITE_COLLECTION_REF = "favorites";

class DatabaseService {
  final _fireStore = FirebaseFirestore.instance;

  late final CollectionReference _favoritesRef;

  DatabaseService() {
    _favoritesRef = _fireStore
        .collection(FAVORITE_COLLECTION_REF)
        .withConverter<Favorite>(
            fromFirestore: (snapshots, _) =>
                Favorite.fromJson(snapshots.data()!),
            toFirestore: (favorite, _) => favorite.toJson());
  }

  Stream<QuerySnapshot> getFavorites() {
    UserController userController = Get.find();

    return _favoritesRef.where('user_id', isEqualTo: userController.getUserId()).orderBy('created_at', descending: true).snapshots();
  }

  Stream<QuerySnapshot> getFavorite(cardId) {
    UserController userController = Get.find();

    return _favoritesRef.where('user_id', isEqualTo: userController.getUserId()).where('card_id', isEqualTo: cardId).snapshots();
  }

  void addFavorite(Favorite favorite) async {
    _favoritesRef.add(favorite);
  }

  // void updateFavorite(String favoriteId, Favorite favorite) {
  //   _favoritesRef.doc(favoriteId).update(favorite.toJson());
  // }

  void deleteFavorite(String favoriteId) {
    _favoritesRef.doc(favoriteId).delete();
  }
}
