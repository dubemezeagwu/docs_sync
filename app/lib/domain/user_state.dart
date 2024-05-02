import 'models/user_model.dart';

class UserState {
  final bool loading;
  final User? user;

  UserState({required this.loading, this.user});

  UserState.loading() : loading = true, user = null;

  UserState.loaded(this.user) : loading = false;

  UserState.error() : loading = false, user = null;
}
