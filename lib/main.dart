import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'otp_validator/auth/feature/login_screen/providers/login_provider.dart';
import 'otp_validator/auth/feature/login_screen/widget/login_screen_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider())
      ],
      child: MaterialApp(
        title: 'Otp Validator',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:  LoginScreenWidget(),
      ),
    );
  }
}
