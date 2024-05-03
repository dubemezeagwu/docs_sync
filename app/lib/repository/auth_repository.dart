// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:docs_sync/core/constants/api_constants.dart';
import 'package:docs_sync/domain/app_domain.dart';
import 'package:docs_sync/repository/local_storage_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository()));

final userProvider = StateProvider<User?>((ref) => null);

final appStatusProvider = StateProvider<bool>((ref) => false);

// final userFutureProvider = FutureProvider<User>((ref) async {
//   try {
//     final data = await ref.read(authRepositoryProvider).getUserData();
//     if (data.data!= null) {
//       ref.read(userProvider.notifier).state = data.data;
//       return data;
//     } else {
//       throw Exception("User data not found");
//     }
//   } catch (e) {
//     throw Exception(e.toString());
//   }
// });

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
        case 201:
          final user = newUser.copyWith(
            uid: jsonDecode(response.body)["data"]["user"]["_id"],
          );
          data = NetworkResponse(data: user, status: true);
          _localStorageRepository.saveToken(jsonDecode(response.body)["token"]);
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
          case 200:
            final body = jsonDecode(response.body);
            final userJson = jsonEncode(body["data"]["user"]);
            final user = User.fromJson(userJson);
            data = NetworkResponse(data: user, status: true);
            await _localStorageRepository
                .saveToken(jsonDecode(response.body)["token"]);
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
