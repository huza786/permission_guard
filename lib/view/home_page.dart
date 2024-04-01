import 'package:PermissionGuard/view/components/buttons_row.dart';
import 'package:PermissionGuard/view/components/circular_progress_widget.dart';
import 'package:PermissionGuard/view/components/drawer_widget_children.dart';
import 'package:PermissionGuard/view/components/progress_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Homepage extends ConsumerStatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  List<PackageInfo>? applicationInitialList;
  List<PackageInfo>? systemAppsList;
  List<PackageInfo>? finalAppsList;
  AndroidPackageManager get _pm => AndroidPackageManager();
  late final int riskyLength;
  late final int safeLength;
  late final int extraLength;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getApps();
    });
  }

  Future<void> getApps() async {
    final systemflags = PackageInfoFlags({
      PMFlag.getPermissions,
      PMFlag.matchSystemOnly,
    });
    final appsflag = PackageInfoFlags({
      PMFlag.getPermissions,
    });
    await _pm.getInstalledPackages(flags: appsflag).then(
          (value) => setState(() => applicationInitialList = value),
        );
    await _pm.getInstalledPackages(flags: systemflags).then(
          (value) => setState(() => systemAppsList = value),
        );
    finalAppsList = applicationInitialList
        ?.where((item) => !systemAppsList!.contains(item))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
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
                      '${finalAppsList?.length ?? 0} Apps have been scanned',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  //buttons to do somethings
                  ButtonRow(finalAppsList: finalAppsList),
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
