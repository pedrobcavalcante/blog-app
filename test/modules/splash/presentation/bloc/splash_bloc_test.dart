import 'package:blog/modules/splash/presentation/bloc/splash_bloc.dart';
import 'package:blog/modules/splash/presentation/bloc/splash_event.dart';
import 'package:blog/modules/splash/presentation/bloc/splash_state.dart';
import 'package:blog/shared/domain/usecases/get_secure_storage_usecase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTokenUseCase extends Mock implements GetTokenUseCase {}

void main() {
  late SplashBloc splashBloc;
  late MockGetTokenUseCase mockGetTokenUseCase;

  setUp(() async {
    mockGetTokenUseCase = MockGetTokenUseCase();
    splashBloc = SplashBloc(getSecureStorageUseCase: mockGetTokenUseCase);

    if (!dotenv.isInitialized) {
      await dotenv.load();
    }
  });

  tearDown(() {
    splashBloc.close();
  });

  group('SplashBloc Tests', () {
    test('should have initial state as SplashInitial', () {
      expect(splashBloc.state, equals(SplashInitial()));
    });

    test('should emit [SplashLoading, SplashAuthenticated] when token exists',
        () async {
      when(() => mockGetTokenUseCase.call(null))
          .thenAnswer((_) async => 'mock_token');

      final expectedStates = [
        SplashLoading(),
        SplashAuthenticated(),
      ];

      expectLater(splashBloc.stream, emitsInOrder(expectedStates));

      splashBloc.add(CheckAuthentication());

      await untilCalled(() => mockGetTokenUseCase.call(null));
      verify(() => mockGetTokenUseCase.call(null)).called(1);
    });

    test(
        'should emit [SplashLoading, SplashUnauthenticated] when token is null',
        () async {
      when(() => mockGetTokenUseCase.call(null)).thenAnswer((_) async => null);

      final expectedStates = [
        SplashLoading(),
        SplashUnauthenticated(),
      ];

      expectLater(splashBloc.stream, emitsInOrder(expectedStates));

      splashBloc.add(CheckAuthentication());

      await untilCalled(() => mockGetTokenUseCase.call(null));
      verify(() => mockGetTokenUseCase.call(null)).called(1);
    });
  });
}
