import 'package:cloud_firestore/cloud_firestore.dart';

class UserFirebaseService {
  Future<QueryDocumentSnapshot?> getUser(String userId) async {
    try {
      final FirebaseFirestore db = FirebaseFirestore.instance;
      final users = await db.collection('users')
        .where('user_id', isEqualTo: userId)
        .get();
      
      return users.docs.first;
    } on Exception catch (_) {
      // TODO
      return null;
    }
  }
}