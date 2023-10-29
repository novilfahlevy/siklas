import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/login_screen.dart';
import 'package:siklas/screens/widgets/loading_circular.dart';
import 'package:siklas/view_models/login_view_model.dart';
import 'package:siklas/view_models/logout_view_model.dart';
import 'package:siklas/view_models/main_view_model.dart';
import 'package:siklas/view_models/borrowing_histories_view_model.dart';

class MainScreen extends StatefulWidget {
  static const String routePath = '/classes';

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    if (mounted) {
      context.read<MainViewModel>().addListener(_showUserBorrowingsScreenListener);
    }

    super.initState();
  }

  void _showUserBorrowingsScreenListener() {
    if (mounted) {
      final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
      final mainViewModel = Provider.of<MainViewModel>(context, listen: false);
      final borrowingHistoriesViewModel = Provider.of<BorrowingHistoriesViewModel>(context, listen: false);

      if (mainViewModel.selectedScreenIndex == 1) {
        borrowingHistoriesViewModel.fetchBorrowingsByUserId(loginViewModel.userModel!.id);
      }
    }
  }

  Future<void> _logout() async {
    final logoutViewModel = Provider.of<LogoutViewModel>(context, listen: false);
    final isSuccessLogout = await logoutViewModel.logout();

    if (mounted && isSuccessLogout) {
      Navigator.popAndPushNamed(context, LoginScreen.routePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<MainViewModel>(
          builder: (context, state, _) =>
            Text(
              state.currentScreenTitle,
              style: Theme.of(context).textTheme.titleMedium
            )
        ),
        actions: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Consumer<LoginViewModel>(
                builder: (context, state, _) {
                  return Text(
                    state.userModel!.getInitialName(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)
                  );
                }
              ),
            ),
          ),
          const SizedBox(width: 5,),
          IconButton(
            onPressed: _logout,
            icon: Consumer<LogoutViewModel>(
              builder: (context, state, _) {
                return state.isLoggingOut
                  ? LoadingCircular(color: Theme.of(context).colorScheme.primary)
                  : Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.secondary
                    );
              }
            )
          ),
          const SizedBox(width: 5,),
        ],
      ),
      body: Consumer<MainViewModel>(
        builder: (context, state, _) => state.currentScreen
      ),
      bottomNavigationBar: Consumer<MainViewModel>(
        builder: (context, state, _) {
          return BottomNavigationBar(
            currentIndex: state.selectedScreenIndex,
            onTap: (value) => state.selectedScreenIndex = value,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.door_back_door_outlined),
                label: 'Kelas'
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Peminjaman'
              ),
            ],
          );
        }
      ),
    );
  }
}