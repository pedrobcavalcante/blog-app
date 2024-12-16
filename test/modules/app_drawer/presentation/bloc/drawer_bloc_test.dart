import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_bloc.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_event.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_state.dart';
import 'package:blog/shared/domain/usecases/get_user_email_usecase.dart';
import 'package:blog/shared/domain/usecases/get_username_usecase.dart';
import 'package:blog/modules/app_drawer/domain/usecases/delete_user_data_usecase.dart';

class MockGetUsernameUseCase extends Mock implements GetUsernameUseCase {}

class MockGetUserEmailUseCase extends Mock implements GetUserEmailUseCase {}

class MockDeleteUserDataUseCase extends Mock implements DeleteUserDataUseCase {}

void main() {
  late MockGetUsernameUseCase mockGetUsernameUseCase;
  late MockGetUserEmailUseCase mockGetUserEmailUseCase;
  late MockDeleteUserDataUseCase mockDeleteUserDataUseCase;
  late DrawerBloc drawerBloc;

  setUp(() {
    mockGetUsernameUseCase = MockGetUsernameUseCase();
    mockGetUserEmailUseCase = MockGetUserEmailUseCase();
    mockDeleteUserDataUseCase = MockDeleteUserDataUseCase();
    drawerBloc = DrawerBloc(
      getUsernameUseCase: mockGetUsernameUseCase,
      getUserEmailUseCase: mockGetUserEmailUseCase,
      deleteUserDataUseCase: mockDeleteUserDataUseCase,
    );
  });

  group('DrawerBloc', () {
    test(
        'emits DrawerDataLoaded when DrawerInitialized is added and data is loaded successfully',
        () async {
      when(() => mockGetUsernameUseCase.call())
          .thenAnswer((_) async => 'JohnDoe');
      when(() => mockGetUserEmailUseCase.call())
          .thenAnswer((_) async => 'johndoe@example.com');

      final expectedStates = [
        isA<DrawerLoading>(),
        isA<DrawerDataLoaded>(),
      ];

      expectLater(
        drawerBloc.stream,
        emitsInOrder(expectedStates),
      );

      drawerBloc.add(DrawerInitialized());
    });

    test(
        'emits DrawerFailure when DrawerInitialized is added and an error occurs',
        () async {
      when(() => mockGetUsernameUseCase.call()).thenThrow(Exception('Error'));
      when(() => mockGetUserEmailUseCase.call()).thenThrow(Exception('Error'));

      final expectedStates = [
        isA<DrawerLoading>(),
        isA<DrawerFailure>(),
      ];

      expectLater(
        drawerBloc.stream,
        emitsInOrder(expectedStates),
      );

      drawerBloc.add(DrawerInitialized());
    });

    test(
        'emits DeleteTokenSuccess when DeleteTokenRequested is added and deletion is successful',
        () async {
      when(() => mockDeleteUserDataUseCase())
          .thenAnswer((_) async => Future.value());

      final expectedStates = [
        isA<DeleteTokenInProgress>(),
        isA<DeleteTokenSuccess>(),
      ];

      expectLater(
        drawerBloc.stream,
        emitsInOrder(expectedStates),
      );

      drawerBloc.add(DeleteTokenRequested());
    });

    test(
        'emits DeleteTokenFailure when DeleteTokenRequested is added and deletion fails',
        () async {
      when(() => mockDeleteUserDataUseCase()).thenThrow(Exception('Error'));

      final expectedStates = [
        isA<DeleteTokenInProgress>(),
        isA<DeleteTokenFailure>(),
      ];

      expectLater(
        drawerBloc.stream,
        emitsInOrder(expectedStates),
      );

      drawerBloc.add(DeleteTokenRequested());
    });
  });
}
