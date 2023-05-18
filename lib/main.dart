import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:n_card_english/pages/landing_page.dart';
import 'package:n_card_english/values/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.priColor,
        backgroundColor: AppColors.bgColor,
        primarySwatch: Colors.blue,
      ),
      home: const LandingPage(),
    );
  }
}
