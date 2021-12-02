import 'package:brew_crew/models/brew.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({this.uid});

  final CollectionReference brewCollection = FirebaseFirestore.instance.collection("brews");

  Future updateUserData (String name, String sugars, int strength) async {
    return await brewCollection.doc(uid).set({
      "name": name,
      "sugars": sugars,
      "strength": strength,
    });
  }

  // brew list from SnapShot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Brew(
          name: doc.get('name') ?? '',
          sugars: doc.get('sugars') ?? '0',
          strength: doc.get('strength') ?? 0,
      );
    }).toList();
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.get("name"),
      sugars: snapshot.get("sugars"),
      strength: snapshot.get("strength"),
    );
  }

  // get brews stream on any update in database
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}