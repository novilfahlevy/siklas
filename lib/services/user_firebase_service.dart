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
}