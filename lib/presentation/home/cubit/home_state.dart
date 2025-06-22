class HomeState {
  final String? email;
  final bool isLoading;
  final String? error;

  HomeState({this.email, this.isLoading = false, this.error});

  HomeState copyWith({String? email, bool? isLoading, String? error}) {
    return HomeState(
      email: email ?? this.email,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
