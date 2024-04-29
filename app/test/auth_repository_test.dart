import 'package:docs_sync/repository/auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements Client {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockUser extends Mock implements GoogleSignInAccount {}

void main() {
  final MockHttpClient mockHttpClient = MockHttpClient();
  final MockGoogleSignIn mockGoogleSignIn = MockGoogleSignIn();

  final AuthRepository authRepository =
      AuthRepository(googleSignIn: mockGoogleSignIn, client: mockHttpClient);
  setUp(() {});
  tearDown(() {});

  group("Auth Repository", () {
    test("signInWithGoogle returns a user when the sign in is successful",
        () async {
      final googleSignInAccount = {
        "displayName": "Test User",
        "email": "test@example.com",
        "photoUrl": "http://example.com/photo.jpg",
      };

      // TODO: Fix GoogleSignIn Identity bug for this test
      // when(() => mockGoogleSignIn.signIn())
      //     .thenAnswer((_) async => googleSignInAccount);
      when(() => mockHttpClient.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => Response('{"user": {"_id": "123"}}', 201));

      final result = await authRepository.signInWithGoogle();

      expect(result.status, true);
      expect(result.data!.uid, '123');
      expect(result.data!.name, 'Test User');
      expect(result.data!.email, 'test@example.com');
      expect(result.data!.profilePicture, 'http://example.com/photo.jpg');
    });
  });
}
