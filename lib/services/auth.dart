import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user object
  AppUser _userFromFirebaseUser(User? user) {
    return AppUser(uid: user?.uid);
  }

  // auth change user stream
  Stream<AppUser> get user {
    return _auth.authStateChanges()
      // .map((User? user) => _userFromFirebaseUser(user));
      .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user as User;
      return _userFromFirebaseUser(user);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign with email & pass
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user as User;
      return _userFromFirebaseUser(user);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user as User;
      await DatabaseService(uid: user.uid).updateUserData("New crew member", "0", 100);
      print("Brew record created");
      return _userFromFirebaseUser(user);
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    }
    catch(e) {
      print(e.toString());
      return null;
    }
  }
}