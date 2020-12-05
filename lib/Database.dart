import 'package:cloud_firestore/cloud_firestore.dart';
import 'user.dart';
import 'workdetails.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

//collection reference
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('Notes');
  Future updateUserData(
      String work, String name, String description, int importance) async {
    return await notes.doc(uid).set({
      'work': work,
      'name': name,
      'description': description,
      'importance': importance,
    });
  }

  //workdetails list from snapshot
  List<details> _workdetailsFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return details(
        work: doc.data()['work'] ?? '',
        name: doc.data()['name'] ?? '',
        description: doc.data()['description'] ?? '',
        importance: doc.data()['importance'] ?? 0,
      );
    }).toList();
  }

  //userStream from snapshot
  userStream _userStreamFromSnapshot(DocumentSnapshot snapshot) {
    return userStream(
      uid: uid,
      work: snapshot.data()['work'],
      name: snapshot.data()['name'],
      description: snapshot.data()['description'],
      importance: snapshot.data()['importance: '],
    );
  }

  //get notes stream
  Stream<List<details>> get Notes {
    return notes.snapshots().map(_workdetailsFromSnapshot);
  }

  Stream<userStream> get UserStream {
    return notes.doc(uid).snapshots().map(_userStreamFromSnapshot);
  }
}
