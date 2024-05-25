import 'package:flutter/material.dart';

import 'presentation/pages/input_url_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ApiUrlInputScreen(),
    );
  }
}
