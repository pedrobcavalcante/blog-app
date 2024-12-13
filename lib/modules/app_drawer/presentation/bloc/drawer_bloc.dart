import 'package:blog/modules/app_drawer/domain/usecases/delete_token_usecase.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_event.dart';
import 'package:blog/modules/app_drawer/presentation/bloc/drawer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerBloc extends Bloc<DeleteTokenEvent, DrawerState> {
  final DeleteTokenUseCase _deleteTokenUseCase;

  DrawerBloc(this._deleteTokenUseCase) : super(DrawerInitial()) {
    on<DeleteTokenRequested>(_onDeleteTokenRequested);
  }

  Future<void> _onDeleteTokenRequested(
      DeleteTokenRequested event, Emitter<DrawerState> emit) async {
    emit(DeleteTokenInProgress());
    try {
      await _deleteTokenUseCase.call();
      emit(DeleteTokenSuccess());
    } catch (e) {
      emit(DeleteTokenFailure('Erro ao deletar token'));
    }
  }
}
