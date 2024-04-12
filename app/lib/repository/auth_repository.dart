// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:docs_sync/core/constants/api_constants.dart';
import 'package:docs_sync/domain/app_domain.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

final authRepositoryProvider = Provider(
    (ref) => AuthRepository(googleSignIn: GoogleSignIn(), client: Client()));

final userProvider = StateProvider<User?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;

  AuthRepository({required GoogleSignIn googleSignIn, required Client client})
      : _googleSignIn = googleSignIn,
        _client = client;

  Future<NetworkResponse<User>> signInWithGoogle() async {
    NetworkResponse<User> data = NetworkResponse(
        status: false, data: null, errorMessage: "Unexpected Error occurred");
    try {
      final GoogleSignInAccount? userAccount = await _googleSignIn.signIn();
      final User newUser = User(
          email: userAccount!.email,
          name: userAccount.displayName!,
          profilePicture: userAccount.photoUrl!,
          uid: "",
          token: "");

      var response = await _client.post(Uri.parse("$host/api/v1/users/signup"),
          body: newUser.toJson(),
          headers: {"Content-Type": "application/json; charset=UTF-8"});

      switch (response.statusCode) {
        case 201:
          final user =
              newUser.copyWith(uid: jsonDecode(response.body)["user"]["_id"]);
          data = NetworkResponse(data: user, status: true);
      }
    } catch (e) {
      data = NetworkResponse(
          status: false, data: null, errorMessage: e.toString());
      throw (e.toString());
    }
    return data;
  }

  // void signInWithGoogle() async {
  //   GoogleSignInAccount? googleSignInAccount = kIsWeb
  //       ? await (_googleSignIn.signInSilently())
  //       : await (_googleSignIn.signIn());

  //   if (kIsWeb && googleSignInAccount == null) {
  //     googleSignInAccount = await _googleSignIn.signIn();
  //   }
  // }
}
