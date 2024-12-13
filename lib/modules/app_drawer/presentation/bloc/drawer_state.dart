abstract class DrawerState {}

class DrawerInitial extends DrawerState {}

class DeleteTokenInProgress extends DrawerState {}

class DeleteTokenSuccess extends DrawerState {}

class DeleteTokenFailure extends DrawerState {
  final String errorMessage;
  DeleteTokenFailure(this.errorMessage);
}
