// ignore_for_file: subtype_of_sealed_class

import 'package:blog/modules/home/data/datasources/firestore_datasource_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {}

class MockQueryDocumentSnapshot extends Mock
    implements QueryDocumentSnapshot<Map<String, dynamic>> {}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {
  final Map<String, dynamic>? dataResult;
  final bool existsResult;

  MockDocumentSnapshot(this.dataResult, this.existsResult);

  @override
  bool get exists => existsResult;

  @override
  Map<String, dynamic>? data() => dataResult;

  @override
  dynamic operator [](Object? key) => dataResult?[key as String];
}

void main() {
  late FavoriteDatasourceImpl datasource;
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference mockCollection;
  late MockDocumentReference mockDocument;
  late MockQuerySnapshot mockQuerySnapshot;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    datasource = FavoriteDatasourceImpl(firestore: mockFirestore);
    mockCollection = MockCollectionReference();
    mockDocument = MockDocumentReference();
    mockQuerySnapshot = MockQuerySnapshot();

    when(() => mockDocument.set(any(), any()))
        .thenAnswer((_) async => Future<void>.value());
  });
  group('getFavoritePosts', () {
    test('should return a list of favorite posts', () async {
      final mockDoc1 = MockQueryDocumentSnapshot();
      final mockDoc2 = MockQueryDocumentSnapshot();

      when(() => mockFirestore.collection('favorites'))
          .thenReturn(mockCollection);
      when(() => mockCollection.doc('user1')).thenReturn(mockDocument);
      when(() => mockDocument.collection('posts')).thenReturn(mockCollection);
      when(() => mockCollection.get())
          .thenAnswer((_) async => mockQuerySnapshot);

      when(() => mockQuerySnapshot.docs).thenReturn([mockDoc1, mockDoc2]);
      when(() => mockDoc1.id).thenReturn('post1');
      when(() => mockDoc1.data()).thenReturn({'isFavorited': true});
      when(() => mockDoc2.id).thenReturn('post2');
      when(() => mockDoc2.data()).thenReturn({'isFavorited': false});

      final result = await datasource.getFavoritePosts(userId: 'user1');

      expect(result, isA<List<Map<String, dynamic>>>());
      expect(result, [
        {'id': 'post1', 'isFavorited': true},
        {'id': 'post2', 'isFavorited': false},
      ]);
    });
  });
  group('toggleFavoritePost', () {
    test('should toggle favorite post successfully', () async {
      when(() => mockFirestore.collection('favorites'))
          .thenReturn(mockCollection);
      when(() => mockCollection.doc('user1')).thenReturn(mockDocument);
      when(() => mockDocument.collection('posts')).thenReturn(mockCollection);
      when(() => mockCollection.doc('post1')).thenReturn(mockDocument);
      when(() =>
              mockDocument.set({'isFavorited': true}, SetOptions(merge: true)))
          .thenAnswer((_) async {});

      await datasource.toggleFavoritePost(
        userId: 'user1',
        postId: 'post1',
        isFavorited: true,
      );

      verify(() => mockFirestore.collection('favorites')).called(1);
      verify(() => mockCollection.doc('user1')).called(1);
      verify(() => mockDocument.collection('posts')).called(1);
      verify(() => mockCollection.doc('post1')).called(1);
    });

    test('should toggle favorite post to unfavorited', () async {
      when(() => mockFirestore.collection('favorites'))
          .thenReturn(mockCollection);
      when(() => mockCollection.doc('user1')).thenReturn(mockDocument);
      when(() => mockDocument.collection('posts')).thenReturn(mockCollection);
      when(() => mockCollection.doc('post1')).thenReturn(mockDocument);
      when(() =>
              mockDocument.set({'isFavorited': false}, SetOptions(merge: true)))
          .thenAnswer((_) async {});

      await datasource.toggleFavoritePost(
        userId: 'user1',
        postId: 'post1',
        isFavorited: false,
      );

      verify(() => mockFirestore.collection('favorites')).called(1);
      verify(() => mockCollection.doc('user1')).called(1);
      verify(() => mockDocument.collection('posts')).called(1);
      verify(() => mockCollection.doc('post1')).called(1);
    });
  });

  group('isPostFavorited', () {
    test('should return true if the post is favorited', () async {
      when(() => mockFirestore.collection('favorites'))
          .thenReturn(mockCollection);
      when(() => mockCollection.doc('user1')).thenReturn(mockDocument);
      when(() => mockDocument.collection('posts')).thenReturn(mockCollection);
      when(() => mockCollection.doc('post1')).thenReturn(mockDocument);
      when(() => mockDocument.get()).thenAnswer(
        (_) async => MockDocumentSnapshot({'isFavorited': true}, true),
      );

      final result = await datasource.isPostFavorited(
        userId: 'user1',
        postId: 'post1',
      );

      expect(result, true);
    });

    test('should return false if the post is not favorited or does not exist',
        () async {
      when(() => mockFirestore.collection('favorites'))
          .thenReturn(mockCollection);
      when(() => mockCollection.doc('user1')).thenReturn(mockDocument);
      when(() => mockDocument.collection('posts')).thenReturn(mockCollection);
      when(() => mockCollection.doc('post1')).thenReturn(mockDocument);
      when(() => mockDocument.get()).thenAnswer(
        (_) async => MockDocumentSnapshot({'isFavorited': false}, true),
      );

      final result = await datasource.isPostFavorited(
        userId: 'user1',
        postId: 'post1',
      );

      expect(result, false);
    });
  });
}
