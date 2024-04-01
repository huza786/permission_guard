import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initialAppsListProvider =
    StateNotifierProvider<AppsProvider, List<PackageInfo>?>(
  (ref) {
    return AppsProvider();
  },
);

class AppsProvider extends StateNotifier<List<PackageInfo>?> {
  AppsProvider() : super([]);

  List<PackageInfo>? applicationInitialList;
  List<PackageInfo>? systemAppsList;
  List<PackageInfo>? finalAppsList;
  AndroidPackageManager get _pm => AndroidPackageManager();
  late final int riskyLength;
  late final int safeLength;
  late final int extraLength;
  Future<List<PackageInfo>?> getApps() async {
    print("gettingApps");
    final systemflags = PackageInfoFlags({
      PMFlag.getPermissions,
      PMFlag.matchSystemOnly,
    });
    final appsflag = PackageInfoFlags({
      PMFlag.getPermissions,
    });
    await _pm.getInstalledPackages(flags: appsflag).then(
          (value) => applicationInitialList = value,
        );
    await _pm.getInstalledPackages(flags: systemflags).then(
          (value) => systemAppsList = value,
        );
    finalAppsList = applicationInitialList
        ?.where((item) => !systemAppsList!.contains(item))
        .toList();
    state = finalAppsList;
    return finalAppsList;
  }
}
