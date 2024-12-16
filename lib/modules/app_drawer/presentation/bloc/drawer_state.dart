abstract class DrawerState {}

class DrawerInitial extends DrawerState {}

class DeleteTokenInProgress extends DrawerState {}

class DeleteTokenSuccess extends DrawerState {}

class DeleteTokenFailure extends DrawerState {
  final String errorMessage;
  DeleteTokenFailure(this.errorMessage);
}

class DrawerLoading extends DrawerState {}

class DrawerDataLoaded extends DrawerState {
  final String userName;
  final String userEmail;

  DrawerDataLoaded({required this.userName, required this.userEmail});
}

class DrawerFailure extends DrawerState {
  final String message;

  DrawerFailure(this.message);
}
