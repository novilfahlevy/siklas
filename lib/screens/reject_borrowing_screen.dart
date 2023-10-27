import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:siklas/screens/widgets/loading_circular.dart';
import 'package:siklas/view_models/reject_borrowing_view_model.dart';
import 'package:siklas/view_models/staff_borrowing_view_model.dart';

class RejectBorrowingScreen extends StatefulWidget {
  static const String routePath = '/reject-borrowing';

  const RejectBorrowingScreen({super.key});

  @override
  State<RejectBorrowingScreen> createState() => _RejectBorrowingScreenState();
}

class _RejectBorrowingScreenState extends State<RejectBorrowingScreen> {
  @override
  void initState() {
    if (mounted) {
      context.read<RejectBorrowingViewModel>().addListener(_messageSubmittedListener);
    }

    super.initState();
  }

  void _messageSubmittedListener() {
    if (mounted) {
      final rejectBorrowingViewModel = Provider.of<RejectBorrowingViewModel>(context, listen: false);
      
      if (rejectBorrowingViewModel.isMessageSubmitted) {
        ScaffoldMessenger
          .of(context)
          .showSnackBar(const SnackBar(content: Text('Peminjaman telah ditolak.')));

        Provider
          .of<StaffBorrowingViewModel>(context, listen: false)
          .fetchBorrowingById(rejectBorrowingViewModel.borrowingId);

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tolak peminjaman', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Consumer<RejectBorrowingViewModel>(
          builder: (context, state, _) {
            return Form(
              key: state.formKey,
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: state.descriptionController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      label: Text('Keterangan'),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 5,
                    validator: state.validateMessage,
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      disabledBackgroundColor: Colors.red,
                    ),
                    onPressed: state.isSubmittingMessage ? null : state.submitMessage,
                    child: state.isSubmittingMessage
                      ? const LoadingCircular()
                      : const Text('Tolak peminjaman')
                  ),
                ],
              ),
            );
          }
        )
      ),
    );
  }
}