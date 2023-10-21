import 'package:flutter/material.dart';

class BorrowingsScreen extends StatefulWidget {
  static const String routePath = '/borrowings';

  const BorrowingsScreen({super.key});

  @override
  State<BorrowingsScreen> createState() => _BorrowingsScreenState();
}

class _BorrowingsScreenState extends State<BorrowingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Text('Borrowings');
  }
}