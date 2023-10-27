import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/login_screen.dart';
import 'package:siklas/screens/widgets/tag.dart';
import 'package:siklas/view_models/initial_name_view_model.dart';
import 'package:siklas/view_models/logout_view_model.dart';

class StaffBorrowingsScreen extends StatefulWidget {
  static const String routePath = '/staff-borrowings';

  const StaffBorrowingsScreen({super.key});

  @override
  State<StaffBorrowingsScreen> createState() => _StaffBorrowingsScreenState();
}

class _StaffBorrowingsScreenState extends State<StaffBorrowingsScreen> {
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
        title: Text(
          'Peminjaman',
          style: Theme.of(context).textTheme.titleMedium
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView.separated(
          itemCount: 5,
          separatorBuilder: (context, index) => const SizedBox(height: 5,),
          itemBuilder: (context, index) {
            final Widget borrowingCard = Card(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            'https://feb.unr.ac.id/wp-content/uploads/2023/03/650ed502-a5ba-4406-8011-d739652a1e9c-1536x864.jpg',
                            fit: BoxFit.cover,
                            height: 200,
                            width: double.infinity,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black26,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'C404',
                            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        'Sosialisasi praktikum Sistem Informasi',
                        style: Theme.of(context).textTheme.titleSmall
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                      child: Row(
                        children: [
                          Tag(
                            label: '17 Oktober 2023',
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            textColor: Colors.white
                          ),
                          const SizedBox(width: 10,),
                          Tag(
                            label: '09:30 - 11:00',
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            textColor: Colors.white
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Tag(
                        label: 'Menunggu persetujuan',
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        textColor: Colors.white
                      ),
                    ),
                  ],
                ),
              ),
            );

            if (index == 0) {
              return Column(
                children: [
                  const SizedBox(height: 10,),
                  borrowingCard
                ],
              );
            }

            if (index == 4) {
              return Column(
                children: [
                  borrowingCard,
                  const SizedBox(height: 10,),
                ],
              );
            }

            return borrowingCard;
          }
        ),
      ),
    );
  }
}