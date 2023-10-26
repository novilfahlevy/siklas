import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/classes_screen.dart';
import 'package:siklas/screens/login_screen.dart';
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

  void _redirectBasedOnRole(String? uid) {
    Navigator.pushReplacementNamed(
      context,
      (uid == null) ? LoginScreen.routePath : ClassesScreen.routePath
    );
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