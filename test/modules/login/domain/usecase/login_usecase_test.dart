import 'package:blog/modules/login/domain/usecase/login_usecase.dart';
import 'package:blog/shared/domain/datasource/firebase_auth_datasource.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuthDatasource extends Mock
    implements FirebaseAuthDatasource {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late LoginUseCase useCase;
  late MockFirebaseAuthDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockFirebaseAuthDatasource();
    useCase = LoginUseCase(datasource: mockDatasource);
  });

  group('LoginUseCase Tests', () {
    test('should return UserCredential when login is successful', () async {
      final params =
          LoginParams(email: 'test@example.com', password: 'password123');
      final mockUserCredential = MockUserCredential();

      when(() => mockDatasource.loginWithEmailAndPassword(
            params.email,
            params.password,
          )).thenAnswer((_) async => mockUserCredential);

      final result = await useCase.call(params);

      expect(result, isA<UserCredential>());
      expect(result, equals(mockUserCredential));
      verify(() => mockDatasource.loginWithEmailAndPassword(
            params.email,
            params.password,
          )).called(1);
    });

    test('should throw an exception when login fails', () async {
      final params =
          LoginParams(email: 'test@example.com', password: 'password123');

      when(() => mockDatasource.loginWithEmailAndPassword(
            params.email,
            params.password,
          )).thenThrow(Exception('Login failed'));

      expect(() => useCase.call(params), throwsA(isA<Exception>()));

      verify(() => mockDatasource.loginWithEmailAndPassword(
            params.email,
            params.password,
          )).called(1);
    });
  });
}
