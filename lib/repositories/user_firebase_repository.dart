import 'package:siklas/models/user_model.dart';
import 'package:siklas/repositories/interfaces/user_repository_interface.dart';
import 'package:siklas/services/user_firebase_service.dart';

class UserFirebaseRepository implements UserRepositoryInterface {
  @override
  Future<UserModel?> getUserByAuthId(String userAuthId) async {
    final UserFirebaseService service = UserFirebaseService();
    final userDoc = await service.getUserByAuthId(userAuthId);

    if (userDoc != null) {
      return UserModel(
        id: userDoc.id,
        authId: userAuthId,
        name: userDoc.get('name'),
        role: userDoc.get('role')
      );
    }

    return null;
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    final UserFirebaseService service = UserFirebaseService();
    final userDoc = await service.getUserById(userId);

    if (userDoc != null) {
      return UserModel(
        id: userDoc.id,
        authId: userDoc.get('user_id'),
        name: userDoc.get('name'),
        role: userDoc.get('role')
      );
    }

    return null;
  }
}