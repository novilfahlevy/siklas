import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebaseService {
  Future<QueryDocumentSnapshot?> getUserByAuthId(String userAuthId) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final users = await db.collection('users')
        .where('user_id', isEqualTo: userAuthId)
        .get();
      
      return users.docs.first;
    } on Exception catch (_) {
      // TODO
      return null;
    }
  }

  Future<DocumentSnapshot?> getUserById(String userId) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final user = await db.collection('users').doc(userId).get();
      
      return user;
    } on Exception catch (_) {
      // TODO
      return null;
    }
  }
}