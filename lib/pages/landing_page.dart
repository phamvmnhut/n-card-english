import 'package:flutter/material.dart';
import 'package:n_card_english/pages/home_page.dart';
import 'package:n_card_english/values/app_colors.dart';
import 'package:n_card_english/values/app_styles.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text("Welcome to", style: AppStyles.h3),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "English",
                    style: AppStyles.h2.copyWith(
                      color: AppColors.priColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Text("Quotes",
                        textAlign: TextAlign.end,
                        style: AppStyles.h4.copyWith(height: 0.5)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 72),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                                context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (route) => false);
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(const CircleBorder()),
                    padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
                    backgroundColor: MaterialStateProperty.all(AppColors.priColor), // <-- Button color
                    overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                      if (states.contains(MaterialState.pressed)) return AppColors.secondColor; // <-- Splash color
                    }),
                  ),
                  child: const Icon(Icons.arrow_right_alt_outlined, size: 50,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
