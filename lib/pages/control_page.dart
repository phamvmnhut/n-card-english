import 'package:flutter/material.dart';
import 'package:n_card_english/values/app_colors.dart';
import 'package:n_card_english/values/app_styles.dart';
import 'package:n_card_english/values/share_keys.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  _ControlPageState createState() {
    return _ControlPageState();
  }
}

class _ControlPageState extends State<ControlPage> {
  late SharedPreferences prefs;

  double slideValue = 5;

  @override
  void initState() {
    super.initState();
    initValue();
  }

  initValue() async {
    prefs = await SharedPreferences.getInstance();
    int counter = prefs.getInt(ShareKeys.counter) ?? 5;
    setState(() {
      slideValue = counter.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Your Control",
          style: AppStyles.h4.copyWith(
            color: AppColors.priColor,
          ),
        ),
        leading: InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setInt(ShareKeys.counter, slideValue.toInt());

            Navigator.pop(context);
          },
          child: const Icon(
            Icons.keyboard_arrow_left_sharp,
            size: 30,
          ),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Spacer(),
            Text(
              "How much a number word at once",
              style: AppStyles.h5,
            ),
            const Spacer(),
            Text(
              "${slideValue.toInt()}",
              style: AppStyles.h1.copyWith(
                color: AppColors.priColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                "Slide to set",
                style: AppStyles.h5.copyWith(
                  color: AppColors.secondColor,
                ),
              ),
            ),
            Slider(
              value: slideValue,
              min: 5,
              max: 25,
              divisions: 20,
              activeColor: AppColors.priColor,
              inactiveColor: AppColors.secondColor,
              onChanged: (val) {
                setState(() {
                  slideValue = val;
                });
              },
            ),
            const Spacer(),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
