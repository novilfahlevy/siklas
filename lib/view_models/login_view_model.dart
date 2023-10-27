import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siklas/models/user_model.dart';
import 'package:siklas/repositories/user_firebase_repository.dart';

class LoginViewModel extends ChangeNotifier {
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  set userModel(UserModel? userModel) {
    _userModel = userModel;
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordObscured = true;

  bool get isPasswordObscured => _isPasswordObscured;

  set isPasswordObscured(bool isObscured) {
    _isPasswordObscured = isObscured;
    notifyListeners();
  }

  void togglePasswordObscure() => isPasswordObscured = !isPasswordObscured;

  bool _isLoggingIn = false;

  bool get isLoggingIn => _isLoggingIn;

  set isLoggingIn(bool isLoggingIn) {
    _isLoggingIn = isLoggingIn;
    notifyListeners();
  }

  bool _isLoginSuccess = false;

  bool get isLoginSuccess => _isLoginSuccess;

  set isLoginSuccess(bool isLoginSuccess) {
    _isLoginSuccess = isLoginSuccess;
    notifyListeners();
  }

  Map<String, String> firebaseAuthExceptions = {
    'INVALID_LOGIN_CREDENTIALS': 'Akun dengan email dan password tersebut tidak ditemukan.',
  };

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  set errorMessage(String? errorMessage) {
    _errorMessage = errorMessage;
    notifyListeners();
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoginSuccess = false;
        isLoggingIn = true;
        errorMessage = null;

        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
        );

        final String authId = userCredential.user!.uid;
        final UserModel? user = await UserFirebaseRepository().getUserByAuthId(authId);

        if (user != null) {
          await setUserData(
            authId: authId,
            userId: user.id,
            userName: user.name,
            userRole: user.role
          );

          userModel = user;
          
          isLoginSuccess = true;

          clearForm();
        } else {
          errorMessage = 'Telah terjadi kesalahan, silakan coba lagi.';
          isLoginSuccess = false;
        }
      } on FirebaseAuthException catch (e) {
        if (firebaseAuthExceptions.containsKey(e.code)) {
          errorMessage = firebaseAuthExceptions[e.code];
        } else {
          errorMessage = e.message;
        }
      } finally {
        isLoggingIn = false;
      }
    }
  }

  Future<void> setUserData({
    required String authId,
    required String userId,
    required String userName,
    required String userRole,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authId', authId);
    await prefs.setString('userId', userId);
    await prefs.setString('userName', userName);
    await prefs.setString('userRole', userRole);
  }

  String? validateEmail(String? value) {
    if (value == '') {
      return 'Email harus diisi.';
    }

    if (!isValidEmail(value!)) {
      return 'Email tidak valid.';
    }

    return null;
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  String? validatePassword(String? value) {
    if (value == '') {
      return 'Password harus diisi.';
    }

    return null;
  }

  void clearForm() {
    emailController.clear();
    passwordController.clear();

    isPasswordObscured = true;
  }
}