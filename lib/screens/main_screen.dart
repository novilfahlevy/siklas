import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/login_screen.dart';
import 'package:siklas/view_models/initial_name_view_model.dart';
import 'package:siklas/view_models/logout_view_model.dart';
import 'package:siklas/view_models/main_view_model.dart';

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
      Provider.of<InitialNameViewModel>(context, listen: false).getInitialName();
    }

    super.initState();
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
              child: Consumer<InitialNameViewModel>(
                builder: (context, state, _) {
                  return Text(
                    state.initialName,
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
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
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