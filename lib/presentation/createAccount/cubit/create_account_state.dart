abstract class CreateAccountState {}

class CreateAccountInitial extends CreateAccountState {}

class CreateAccountLoading extends CreateAccountState {}

class CreateAccountSuccess extends CreateAccountState {
  final String message;
  CreateAccountSuccess(this.message);
}

class CreateAccountError extends CreateAccountState {
  final String message;
  CreateAccountError(this.message);
}
