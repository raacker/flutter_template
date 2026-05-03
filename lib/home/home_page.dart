import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Template')),
      body: const Center(child: Icon(Icons.check_circle_outline, size: 48)),
    );
  }
}
