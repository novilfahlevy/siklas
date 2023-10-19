import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/login_screen.dart';
import 'package:siklas/view_models/logout_view_model.dart';

class ClassesScreen extends StatefulWidget {
  static const String routePath = '/classes';

  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
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
        title: const Text('Daftar kelas'),
        actions: [
          const SizedBox(
            width: 30,
            height: 30,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              child: Text('NF'),
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: const Text('asd')
      ),
    );
  }
}