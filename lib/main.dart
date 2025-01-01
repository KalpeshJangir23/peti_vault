import 'package:flutter/material.dart';
import 'package:peti_vault/presentation/login-SignUp/screen/login_signUp.dart';
import 'package:peti_vault/presentation/user_percent/user_percent_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StackingContainers(),
    );
  }
}
