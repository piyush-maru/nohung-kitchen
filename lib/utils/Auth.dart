
// ignore_for_file: missing_return

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  String? name;
  String? email;
  String? imageUrl;

  Future<User?> signInWithGoogle() async {
    try {

      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      assert(user!.email != null);
      assert(user!.displayName != null);
      assert(user!.photoURL != null);
      name = user!.displayName;
      email = user.email;
      imageUrl = user.photoURL;
      if (name!.contains(" ")) {
        name = name!.substring(0, name!.indexOf(" "));
      }
      final User currentUser = _auth.currentUser!;
      currentUser.getIdToken();
      assert(!user.isAnonymous);
      assert(user.uid == currentUser.uid);
      return user;
    }catch(e){
      


    }
    return null;
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();
  }
}