import 'package:flutter/material.dart';
import 'package:n_card_english/values/app_colors.dart';
import 'package:n_card_english/values/app_styles.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() {
    return _FavoritesPageState();
  }
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Your Favorites",
          style: AppStyles.h4.copyWith(color: AppColors.priColor),
        ),
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.keyboard_arrow_left_sharp,
            size: 30,
          ),
        ),
      ),
      body: Container(
        child: Center(
          child: Text("To do", style: AppStyles.h3,),
        ),
      ),
    );
  }
}
