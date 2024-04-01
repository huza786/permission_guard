import 'package:PermissionGuard/view/components/buttons_row.dart';
import 'package:PermissionGuard/view/components/circular_progress_widget.dart';
import 'package:PermissionGuard/view/components/drawer_widget_children.dart';
import 'package:PermissionGuard/view/components/progress_text.dart';
import 'package:PermissionGuard/viewmodel/circular_indicator%20provider.dart';
import 'package:PermissionGuard/viewmodel/extra_permission_category_list_provider.dart';
import 'package:PermissionGuard/viewmodel/filter_apps_with_permission_provider.dart';
import 'package:PermissionGuard/viewmodel/get_apps_from_phone.dart';
import 'package:PermissionGuard/viewmodel/initiating_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appsProvider = ref.watch(initialAppsListProvider);

    final initialList = ref.watch(initialAppsListProvider);
    final appsFunctions = ref.watch(appListProvider.notifier);
    final extraAppsFunctions = ref.watch(extraPermissionListProvider.notifier);
    final progressprovider = ref.watch(initiatingProcess);
    Future.delayed(Durations.extralong1);

    return Scaffold(
      drawer: const NavigationDrawerHomePage(),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            CustomPaint(
              size: Size(430.w, 353.h),
              painter: MyPainter(),
            ),

            //Circular indicator animation
            const CircularProgressWidget(),

            Positioned(
              top: 450.h,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ProgressText(),
                  Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: Text(
                      '${progressprovider ? appsProvider?.length : 0} Apps have been scanned',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  //buttons to show apps based on categories
                  progressprovider
                      ? ButtonRow(finalAppsList: appsProvider)
                      : SizedBox.shrink()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Custom behind paint widget
class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    // Define the shape using canvas drawing commands
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, 3.5 * (size.height / 5))
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
