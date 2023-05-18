import 'package:flutter/material.dart';
import 'package:n_card_english/values/app_colors.dart';
import 'package:n_card_english/values/app_styles.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const AppButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        decoration: const BoxDecoration(
          color: AppColors.priColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.secondColor,
              offset: Offset(1, 3),
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Text(
          label,
          style: AppStyles.h5,
        ),
      ),
    );
  }
}
