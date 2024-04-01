import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconCustomButton extends StatelessWidget {
  final String icon;
  final String bottonTitle;
  final String countString;
  const IconCustomButton(
      {super.key,
      required this.icon,
      required this.bottonTitle,
      required this.countString});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Animate(
          effects: const [
            ShimmerEffect(
                stops: [0, 1], colors: [Colors.transparent, Colors.redAccent])
          ],
          child: Material(
              elevation: 4,
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                height: 109.h,
                width: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        icon,
                        width: 30.h,
                        height: 30.w,
                      ),
                      Text(countString),
                    ]),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(bottonTitle),
        ),
      ],
    );
  }
}
