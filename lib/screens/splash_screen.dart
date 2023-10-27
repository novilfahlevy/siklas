import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/models/user_model.dart';
import 'package:siklas/screens/classes_screen.dart';
import 'package:siklas/screens/login_screen.dart';
import 'package:siklas/screens/staff_borrowings_screen.dart';
import 'package:siklas/view_models/login_view_model.dart';
import 'package:siklas/view_models/splash_view_model.dart';

class SplashScreen extends StatefulWidget {
  static const String routePath = '/';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Provider.of<SplashViewModel>(context, listen: false)
      .checkIsUserLoggedIn()
      .then(_redirectBasedOnRole);
    
    super.initState();
  }

  void _redirectBasedOnRole(UserModel? userModel) async {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    if (userModel == null) {
      Navigator.pushReplacementNamed(context, LoginScreen.routePath);
    } else {
      loginViewModel.userModel = userModel;
      
      Navigator.pushReplacementNamed(
        context,
        (userModel.role == 'mahasiswa')
          ? ClassesScreen.routePath
          : StaffBorrowingsScreen.routePath
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(
            strokeAlign: 12.0,
            strokeWidth: 6.0,
          )
        )
      ),
    );
  }
}