
import 'package:carros/domain/response.dart';
import 'package:carros/domain/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Response> loginGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser fuser = await _auth.signInWithCredential(credential);
    print("signed in " + fuser.displayName);

    final user = User(fuser.displayName,fuser.email,fuser.email);
    user.save();

    return Response(true,"Login efetuado com sucesso");
  }
}