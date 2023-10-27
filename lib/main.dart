import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:siklas/firebase_options.dart';
import 'package:siklas/screens/borrowing_history_screen.dart';
import 'package:siklas/screens/class_screen.dart';
import 'package:siklas/screens/create_borrowing_screen.dart';
import 'package:siklas/screens/borrowing_screen.dart';
import 'package:siklas/screens/login_screen.dart';
import 'package:siklas/screens/main_screen.dart';
import 'package:siklas/screens/splash_screen.dart';
import 'package:siklas/screens/borrowing_histories_screen.dart';
import 'package:siklas/screens/staff_borrowing_screen.dart';
import 'package:siklas/screens/staff_borrowings_screen.dart';
import 'package:siklas/view_models/borrowing_history_view_model.dart';
import 'package:siklas/view_models/borrowings_view_model.dart';
import 'package:siklas/view_models/class_view_model.dart';
import 'package:siklas/view_models/classes_view_model.dart';
import 'package:siklas/view_models/create_borrowing_view_model.dart';
import 'package:siklas/view_models/borrowing_view_model.dart';
import 'package:siklas/view_models/logout_view_model.dart';
import 'package:siklas/view_models/login_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:siklas/view_models/main_view_model.dart';
import 'package:siklas/view_models/schedule_view_model.dart';
import 'package:siklas/view_models/splash_view_model.dart';
import 'package:siklas/view_models/borrowing_histories_view_model.dart';
import 'package:siklas/view_models/staff_borrowing_view_model.dart';
import 'package:siklas/view_models/staff_borrowings_view_model.dart';
import 'theme.dart';

void main() async {
  await initializeDateFormatting('id');
  
  Intl.systemLocale = 'id';
  
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginViewModel>(create: (context) => LoginViewModel(),),
        ChangeNotifierProvider<LogoutViewModel>(create: (context) => LogoutViewModel(),),
        ChangeNotifierProvider<SplashViewModel>(create: (context) => SplashViewModel(),),
        ChangeNotifierProvider<MainViewModel>(create: (context) => MainViewModel(),),
        ChangeNotifierProvider<ClassesViewModel>(create: (context) => ClassesViewModel(),),
        ChangeNotifierProvider<ClassViewModel>(create: (context) => ClassViewModel(),),
        ChangeNotifierProvider<ScheduleViewModel>(create: (context) => ScheduleViewModel(),),
        ChangeNotifierProvider<BorrowingsViewModel>(create: (context) => BorrowingsViewModel(),),
        ChangeNotifierProvider<CreateBorrowingViewModel>(create: (context) => CreateBorrowingViewModel(),),
        ChangeNotifierProvider<BorrowingViewModel>(create: (context) => BorrowingViewModel(),),
        ChangeNotifierProvider<BorrowingHistoriesViewModel>(create: (context) => BorrowingHistoriesViewModel(),),
        ChangeNotifierProvider<BorrowingHistoryViewModel>(create: (context) => BorrowingHistoryViewModel(),),
        ChangeNotifierProvider<StaffBorrowingsViewModel>(create: (context) => StaffBorrowingsViewModel(),),
        ChangeNotifierProvider<StaffBorrowingViewModel>(create: (context) => StaffBorrowingViewModel(),),
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
      locale: const Locale('id'),
      title: 'Siklas',
      theme: theme,
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routePath,
      routes: {
        SplashScreen.routePath: (context) => const SplashScreen(),
        LoginScreen.routePath: (context) => const LoginScreen(),
        MainScreen.routePath: (context) => const MainScreen(),
        ClassScreen.routePath: (context) => const ClassScreen(),
        CreateBorrowingScreen.routePath: (context) => const CreateBorrowingScreen(),
        BorrowingScreen.routePath: (context) => const BorrowingScreen(),
        BorrowingHistoriesScreen.routePath: (context) => const BorrowingHistoriesScreen(),
        BorrowingHistoryScreen.routePath: (context) => const BorrowingHistoryScreen(),
        StaffBorrowingsScreen.routePath: (context) => const StaffBorrowingsScreen(),
        StaffBorrowingScreen.routePath: (context) => const StaffBorrowingScreen(),
      },
    );
  }
}