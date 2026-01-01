import 'package:flutter/material.dart';

class AddStoryPage extends StatelessWidget {
  const AddStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Story'),
      ),
      body: const Center(
        child: Text('Add Story Page'),
      ),
    );
  }
}
