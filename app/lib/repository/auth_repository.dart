// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:docs_sync/domain/app_domain.dart';
import 'package:docs_sync/core/app_core.dart';
import 'package:docs_sync/repository/app_repository.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository()));

final userProvider = StateProvider<User?>((ref) => null);

final appStatusProvider = StateProvider<AppState>((ref) => AppState.idle);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;

  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorageRepository localStorageRepository,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<NetworkResponse<User>> signInWithGoogle() async {
    NetworkResponse<User> data = NetworkResponse(
        status: false, data: null, errorMessage: "Unexpected Error occurred");
    try {
      final GoogleSignInAccount? userAccount = await _googleSignIn.signIn();
      final User newUser = User(
        email: userAccount!.email,
        name: userAccount.displayName!,
        profilePicture: userAccount.photoUrl ?? "",
        uid: "",
      );

      var response = await _client.post(Uri.parse("$host/api/v1/users/signup"),
          body: newUser.toJson(),
          headers: {"Content-Type": "application/json; charset=UTF-8"});

      switch (response.statusCode) {
        case SERVER_OK:
          final user = newUser.copyWith(
            uid: jsonDecode(response.body)["data"]["user"]["_id"],
          );
          data = NetworkResponse(data: user, status: true);
          _localStorageRepository.saveToken(jsonDecode(response.body)["token"]);
          break;
        case SERVER_CREATED:
          final user = newUser.copyWith(
            uid: jsonDecode(response.body)["data"]["user"]["_id"],
          );
          data = NetworkResponse(data: user, status: true);
          _localStorageRepository.saveToken(jsonDecode(response.body)["token"]);
          break;
      }
    } catch (e) {
      data = NetworkResponse(
          status: false, data: null, errorMessage: e.toString());
      throw (e.toString());
    }
    return data;
  }

  Future<NetworkResponse<User>> getUserData() async {
    NetworkResponse<User> data = NetworkResponse(
        status: false, data: null, errorMessage: "Unexpected Error occurred");
    try {
      String? token = await _localStorageRepository.getToken();

      if (token != null) {
        var response =
            await _client.get(Uri.parse("$host/api/v1/users/me"), headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Authorization": "Bearer $token"
        });

        switch (response.statusCode) {
          case SERVER_OK:
            final body = jsonDecode(response.body);
            final userJson = jsonEncode(body["data"]["user"]);
            final user = User.fromJson(userJson);
            data = NetworkResponse(data: user, status: true);
            await _localStorageRepository
                .saveToken(jsonDecode(response.body)["token"]);
            break;
        }
      }
    } catch (e) {
      data = NetworkResponse(
          status: false, data: null, errorMessage: e.toString());
      throw (e.toString());
    }
    return data;
  }

  void signOut() async {
    _googleSignIn.signOut();
    _localStorageRepository.deleteToken();
  }
}
