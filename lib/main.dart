import 'package:PermissionGuard/view/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: ScreenUtilInit(
          designSize: const Size(430, 932),
          builder: (context, _) {
            return MaterialApp(
              themeMode: ThemeMode.system,
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  primaryColor: const Color(0XFF26D2C8),
                  fontFamily: 'Montserrat'),
              home: const SplashScreen(),
            );
          }),
    );
  }
}
