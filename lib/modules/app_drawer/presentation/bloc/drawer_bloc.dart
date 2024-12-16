import 'package:blog/modules/app_drawer/domain/usecases/delete_user_data_usecase.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_event.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_state.dart';
import 'package:blog/shared/domain/usecases/get_user_email_usecase.dart';
import 'package:blog/shared/domain/usecases/get_username_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  final GetUsernameUseCase _getUsernameUseCase;
  final GetUserEmailUseCase _getUserEmailUseCase;
  final DeleteUserDataUseCase _deleteUserDataUseCase;

  DrawerBloc({
    required GetUsernameUseCase getUsernameUseCase,
    required GetUserEmailUseCase getUserEmailUseCase,
    required DeleteUserDataUseCase deleteUserDataUseCase,
  })  : _getUsernameUseCase = getUsernameUseCase,
        _getUserEmailUseCase = getUserEmailUseCase,
        _deleteUserDataUseCase = deleteUserDataUseCase,
        super(DrawerInitial()) {
    on<DrawerInitialized>(_onDrawerInitialized);
    on<DeleteTokenRequested>(_onDeleteTokenRequested);
  }
  Future<void> _onDrawerInitialized(
    DrawerInitialized event,
    Emitter<DrawerState> emit,
  ) async {
    emit(DrawerLoading());

    try {
      final userName = await _getUsernameUseCase.call();

      final userEmail = await _getUserEmailUseCase.call();

      emit(DrawerDataLoaded(userName: userName!, userEmail: userEmail!));
    } catch (e) {
      emit(DrawerFailure('Erro ao carregar dados do usuário'));
    }
  }

  Future<void> _onDeleteTokenRequested(
      DeleteTokenRequested event, Emitter<DrawerState> emit) async {
    emit(DeleteTokenInProgress());
    try {
      await _deleteUserDataUseCase();
      emit(DeleteTokenSuccess());
    } catch (e) {
      emit(DeleteTokenFailure('Erro ao deletar token'));
    }
  }
}
