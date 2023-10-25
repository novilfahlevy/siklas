import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siklas/models/user_model.dart';
import 'package:siklas/repositories/user_firebase_repository.dart';

class LoginViewModel extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  
  final TextEditingController passwordController = TextEditingController();

  Map<String, String> firebaseAuthExceptions = {
    'INVALID_LOGIN_CREDENTIALS': 'Akun dengan email dan password tersebut tidak ditemukan.',
  };

  bool isPasswordObscured = true;

  bool isLoggingIn = false;

  bool _isLoginSuccess = false;

  String? _errorMessage;

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoggingIn = true;
        setErrorMessage(null);
        
        notifyListeners();

        final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
        );
        final String authId = userCredential.user!.uid;
        
        final UserModel? user = await UserFirebaseRepository().getUserByAuthId(authId);
        final String userName = user!.name;
        final String userRole = user.role;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.id);
        await prefs.setString('userName', userName);
        await prefs.setString('userInitialName', user.getInitialName());
        await prefs.setString('userRole', userRole);
        
        clearForm();
        setIsLoginSuccess(true);
      } on FirebaseAuthException catch (e) {
        if (firebaseAuthExceptions.containsKey(e.code)) {
          setErrorMessage(firebaseAuthExceptions[e.code]);
        } else {
          setErrorMessage(e.message);
        }
      } finally {
        isLoggingIn = false;
        notifyListeners();
      }
    }
  }

  void togglePasswordObscure() {
    isPasswordObscured = !isPasswordObscured;
    notifyListeners();
  }

  String? getErrorMessage() {
    return _errorMessage;
  }

  void setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  bool getIsLoginSuccess() {
    return _isLoginSuccess;
  }

  void setIsLoginSuccess(bool isLoginSuccess) {
    _isLoginSuccess = isLoginSuccess;
    notifyListeners();
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
  }
}