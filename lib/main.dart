import 'package:flutter/material.dart';
import 'package:lambox_pharm/pages/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:lambox_pharm/models/form_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FormData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lambox Pharm',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
