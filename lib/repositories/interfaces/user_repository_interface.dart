import 'package:siklas/models/user_model.dart';

abstract class UserRepositoryInterface {
  Future<UserModel?> find(String userId);
}