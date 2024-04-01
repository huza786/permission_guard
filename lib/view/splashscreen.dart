import 'dart:async';

import 'package:PermissionGuard/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool startAnimation = false;
  bool showLogo = false;
  bool startRotaion = false;
  @override
  void initState() {
    super.initState();
    startAnimations();
  }

  void startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      startAnimation = true;
    });
    await Future.delayed(const Duration(milliseconds: 1500));
    setState(() {
      showLogo = true;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      startRotaion = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: AnimatedRotation(
          onEnd: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Homepage()));
          },
          turns: startRotaion ? 1 : 0,
          duration: const Duration(milliseconds: 300),
          child: AnimatedContainer(
            decoration: BoxDecoration(
              borderRadius: startAnimation
                  ? BorderRadius.circular(16)
                  : BorderRadius.circular(0),
              color: Theme.of(context).primaryColor,
            ),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeInOut,
            height: startAnimation ? 80.h : MediaQuery.of(context).size.height,
            width: startAnimation ? 80.h : MediaQuery.of(context).size.height,
            child: showLogo
                ? Image.asset(
                    'assets/Images/rocket-ship.png',
                    height: 80.h,
                    width: 80.h,
                    fit: BoxFit.cover,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}
