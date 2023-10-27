import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/models/class_model.dart';
import 'package:siklas/screens/login_screen.dart';
import 'package:siklas/screens/staff_borrowing_screen.dart';
import 'package:siklas/screens/widgets/tag.dart';
import 'package:siklas/view_models/login_view_model.dart';
import 'package:siklas/view_models/logout_view_model.dart';
import 'package:siklas/view_models/staff_borrowing_view_model.dart';
import 'package:siklas/view_models/staff_borrowings_view_model.dart';

class StaffBorrowingsScreen extends StatefulWidget {
  static const String routePath = '/staff-borrowings';

  const StaffBorrowingsScreen({super.key});

  @override
  State<StaffBorrowingsScreen> createState() => _StaffBorrowingsScreenState();
}

class _StaffBorrowingsScreenState extends State<StaffBorrowingsScreen> {
  @override
  void initState() {
    final StaffBorrowingsViewModel staffBorrowingsViewModel = Provider.of<StaffBorrowingsViewModel>(context, listen: false);
    staffBorrowingsViewModel.fetchNotYetRespondedBorrowings();

    super.initState();
  }

  void _goToStaffBorrowingScreen(String borrowingId) {
    Provider
      .of<StaffBorrowingViewModel>(context, listen: false)
      .fetchBorrowingById(borrowingId);
    
    Navigator.pushNamed(context, StaffBorrowingScreen.routePath);
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
        child: Consumer<StaffBorrowingsViewModel>(
          builder: (context, state, _) {
            if (state.isFetchingBorrowings) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.borrowings.isEmpty) {
              return const Center(child: Text('Tidak ada peminjaman'));
            }

            return ListView.separated(
              itemCount: state.borrowings.length,
              separatorBuilder: (context, index) => const SizedBox(height: 5,),
              itemBuilder: (context, index) {
                final Widget borrowingCard = GestureDetector(
                  onTap: () => _goToStaffBorrowingScreen(state.borrowings[index].id),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder(
                            future: state.borrowings[index].getClassModel(),
                            builder: (context, AsyncSnapshot<ClassModel?> snapshot) {
                              if (snapshot.hasData) {
                                return Stack(
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
                                        snapshot.data!.name,
                                        style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                
                              return const SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeAlign: 6.0,
                                    strokeWidth: 3.0,
                                  ),
                                )
                              );
                            }
                          ),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              state.borrowings[index].title,
                              style: Theme.of(context).textTheme.titleSmall
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, left: 8, right: 8),
                            child: Row(
                              children: [
                                Tag(
                                  label: state.borrowings[index].dateFormatted(),
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  textColor: Colors.white
                                ),
                                const SizedBox(width: 10,),
                                Tag(
                                  label: '${state.borrowings[index].timeFromFormatted(context)} - ${state.borrowings[index].timeUntilFormatted(context)}',
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
                              label: state.borrowings[index].getStatus(),
                              backgroundColor: state.borrowings[index].status == 0
                                ? Theme.of(context).colorScheme.secondary
                                : state.borrowings[index].status == 1
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.primary,
                              textColor: Colors.white
                            ),
                          ),
                        ],
                      ),
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

                if (index == state.borrowings.length - 1) {
                  return Column(
                    children: [
                      borrowingCard,
                      const SizedBox(height: 10,),
                    ],
                  );
                }

                return borrowingCard;
              }
            );
          }
        ),
      ),
    );
  }
}