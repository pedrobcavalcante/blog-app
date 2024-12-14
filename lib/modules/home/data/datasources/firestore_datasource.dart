import 'package:blog/modules/home/domain/datasources/firestore_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDatasourceImpl implements FirestoreDatasource {
  final FirebaseFirestore _firestore;

  FirestoreDatasourceImpl({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  @override
  Future<List<Map<String, dynamic>>> getFavoritePosts(
      {required String userId}) async {
    final snapshot = await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('posts')
        .get();

    return snapshot.docs
        .map((doc) => {'id': doc.id, 'isFavorited': doc.data()['isFavorited']})
        .toList();
  }

  @override
  Future<void> toggleFavoritePost(
      {required String userId,
      required String postId,
      required bool isFavorited}) async {
    final postRef = _firestore
        .collection('favorites')
        .doc(userId)
        .collection('posts')
        .doc(postId);

    await postRef.set({
      'isFavorited': isFavorited,
    }, SetOptions(merge: true));
  }

  @override
  Future<bool> isPostFavorited(
      {required String userId, required String postId}) async {
    final postDoc = await _firestore
        .collection('favorites')
        .doc(userId)
        .collection('posts')
        .doc(postId)
        .get();

    return postDoc.exists && postDoc['isFavorited'] == true;
  }
}
