import 'package:PermissionGuard/utils/colorslist.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String firstText;

  const CustomButton({
    super.key,
    required this.firstText,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      elevation: 12,
      child: Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          border: Border.all(color: MyAppColors.secondaryColor, width: 8),
          shape: BoxShape.circle,
          color: MyAppColors.primaryColor,
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              softWrap: true,
              firstText,
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            const Text(
              softWrap: true,
              'Apps',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        )),
      ),
    );
  }
}
