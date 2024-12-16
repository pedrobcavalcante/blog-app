import 'package:blog/modules/app_drawer/domain/usecases/delete_token_usecase.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_bloc.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_event.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDeleteTokenUseCase extends Mock implements DeleteTokenUseCase {}

void main() {
  late DrawerBloc drawerBloc;
  late MockDeleteTokenUseCase mockDeleteTokenUseCase;

  setUp(() {
    mockDeleteTokenUseCase = MockDeleteTokenUseCase();
    drawerBloc = DrawerBloc(mockDeleteTokenUseCase);
  });

  tearDown(() {
    drawerBloc.close();
  });

  group('DrawerBloc Tests', () {
    blocTest<DrawerBloc, DrawerState>(
      'emits [DeleteTokenInProgress, DeleteTokenSuccess] when DeleteTokenRequested succeeds',
      build: () {
        when(() => mockDeleteTokenUseCase.call())
            .thenAnswer((_) async => Future.value());
        return drawerBloc;
      },
      act: (bloc) => bloc.add(DeleteTokenRequested()),
      expect: () => [
        isA<DeleteTokenInProgress>(),
        isA<DeleteTokenSuccess>(),
      ],
      verify: (_) {
        verify(() => mockDeleteTokenUseCase.call()).called(1);
      },
    );

    blocTest<DrawerBloc, DrawerState>(
      'emits [DeleteTokenInProgress, DeleteTokenFailure] when DeleteTokenRequested fails',
      build: () {
        when(() => mockDeleteTokenUseCase.call())
            .thenThrow(Exception('Erro ao deletar token'));
        return drawerBloc;
      },
      act: (bloc) => bloc.add(DeleteTokenRequested()),
      expect: () => [
        isA<DeleteTokenInProgress>(),
        isA<DeleteTokenFailure>(),
      ],
      verify: (_) {
        verify(() => mockDeleteTokenUseCase.call()).called(1);
      },
    );
  });
}
