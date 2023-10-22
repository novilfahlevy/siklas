import 'package:flutter/material.dart';

class UserBorrowingsScreen extends StatefulWidget {
  static const String routePath = '/borrowings';

  const UserBorrowingsScreen({super.key});

  @override
  State<UserBorrowingsScreen> createState() => _UserBorrowingsScreenState();
}

class _UserBorrowingsScreenState extends State<UserBorrowingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Text('Borrowings');
  }
}