import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/firebase_options.dart';
import 'package:siklas/screens/classes_screen.dart';
import 'package:siklas/screens/login_screen.dart';
import 'package:siklas/screens/splash_screen.dart';
import 'package:siklas/view_models/logout_view_model.dart';
import 'package:siklas/view_models/login_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:siklas/view_models/splash_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginViewModel>(create: (context) => LoginViewModel(),),
        ChangeNotifierProvider<LogoutViewModel>(create: (context) => LogoutViewModel(),),
        ChangeNotifierProvider<SplashViewModel>(create: (context) => SplashViewModel(),)
      ],
      child: const App(),
    )
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Siklas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder()
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: const BeveledRectangleBorder()
          )
        ),
      ),
      initialRoute: SplashScreen.routePath,
      routes: {
        SplashScreen.routePath: (context) => const SplashScreen(),
        LoginScreen.routePath: (context) => const LoginScreen(),
        ClassesScreen.routePath: (context) => const ClassesScreen(),
      },
    );
  }
}