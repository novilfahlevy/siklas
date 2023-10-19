class UserModel {
  String userId;
  String name;
  String role;

  UserModel({ required this.userId, required this.name, required this.role });

  String getInitialName() {
    final userName = name.split(' ');

    if (userName.length == 1) {
      return name[0][0];
    }

    return userName[0][0] + userName[1][0];
  }
}