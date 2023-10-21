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
          builder: (context, state, _) => Text(state.currentScreenTitle)
        ),
        actions: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Consumer<InitialNameViewModel>(
                builder: (context, state, _) {
                  return Text(state.initialName, style: const TextStyle(color: Colors.white),);
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
                  ? const CircularProgressIndicator(
                      strokeAlign: -5.0,
                      strokeWidth: 3.0,
                    )
                  : const Icon(Icons.logout);
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
            onTap: state.setSelectedScreenIndex,
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