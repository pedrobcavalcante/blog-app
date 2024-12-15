import 'package:blog/shared/data/datasource/firebase_auth_datasource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late FirebaseAuthDatasourceImpl datasource;
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    datasource = FirebaseAuthDatasourceImpl(firebaseAuth: mockFirebaseAuth);
  });

  group('FirebaseAuthDatasourceImpl Tests', () {
    const email = 'test@example.com';
    const password = 'password123';
    final mockUserCredential = MockUserCredential();

    test('should return UserCredential when login is successful', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenAnswer((_) async => mockUserCredential);

      final result =
          await datasource.loginWithEmailAndPassword(email, password);

      expect(result, equals(mockUserCredential));
      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).called(1);
    });

    test('should throw an exception when login fails', () async {
      when(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).thenThrow(FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found for that email.',
      ));

      expect(() => datasource.loginWithEmailAndPassword(email, password),
          throwsA(isA<FirebaseAuthException>()));

      verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          )).called(1);
    });
  });
}
