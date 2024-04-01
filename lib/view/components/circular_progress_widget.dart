import 'package:PermissionGuard/viewmodel/circular_indicator%20provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CircularProgressWidget extends StatelessWidget {
  const CircularProgressWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final indicatorprovider = ref.watch(circularIndicatorProvider);
      final indicatorProviderClass =
          ref.watch(circularIndicatorProvider.notifier);
      indicatorProviderClass.startCount();
      int count = (indicatorprovider * 100).toInt();

      return Positioned(
        top: 78.h,
        left: 80.w,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          height: 240,
          width: 240,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Center(
                child: Text(
                  "$count%",
                  style: const TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: 240.h,
                width: 240.w,
                child: CircularProgressIndicator(
                  backgroundColor:
                      Colors.grey, // Sets the background color to black
                  strokeWidth: 24, // Sets the width of the progress bar
                  value:
                      indicatorprovider, // Sets the progress value (1.0 represents 100% progress)
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context)
                      .primaryColor), // Sets the color of the progress bar
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
