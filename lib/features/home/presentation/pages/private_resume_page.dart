import 'package:flutter/material.dart';
import 'package:odk_flutter_template/features/home/presentation/widgets/private_resume_table_widget.dart';
import 'package:odk_flutter_template/widgets/app_page/app_bar.dart';

class PrivateResumePage extends StatelessWidget {
  const PrivateResumePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(title: const Text('私有库')),
      body: const PrivateResumeTableWidget(),
    );
  }
}
