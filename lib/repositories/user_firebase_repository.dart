import 'package:siklas/models/user_model.dart';
import 'package:siklas/repositories/interfaces/user_repository_interface.dart';
import 'package:siklas/services/user_firebase_service.dart';

class UserFirebaseRepository implements UserRepositoryInterface {
  @override
  Future<UserModel?> find(String userId) async {
    final UserFirebaseService service = UserFirebaseService();
    final userDoc = await service.getUser(userId);

    if (userDoc != null) {
      return UserModel(
        userId: userDoc.get('user_id'),
        name: userDoc.get('name'),
        role: userDoc.get('role')
      );
    }

    return null;
  }
}