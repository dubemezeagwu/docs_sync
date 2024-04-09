// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required GoogleSignIn googleSignIn,
  }) : _googleSignIn = googleSignIn;
}
