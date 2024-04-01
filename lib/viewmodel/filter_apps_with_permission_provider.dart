import 'package:PermissionGuard/viewmodel/extra_permission_category_list_provider.dart';
import 'package:PermissionGuard/viewmodel/get_apps_from_phone.dart';
import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appListProvider =
    StateNotifierProvider<AppListProvider, List<PackageInfo>>((ref) {
  return AppListProvider();
});
// final filterListProgressProvider = StateNotifierProvider<bool>((ref) {
//   final initialList = ref.watch(initialAppsListProvider);
//   final appsFunctions = ref.watch(appListProvider.notifier);
//   final extraAppsFunctions = ref.watch(extraPermissionListProvider.notifier);
//   appsFunctions.getAppsWithPermissions(initialList);
//   appsFunctions.getAppsWithPermissions(initialList);
//   extraAppsFunctions.getAppsWithExtraPermissions(initialList);
//   return true
// });

class AppListProvider extends StateNotifier<List<PackageInfo>> {
  AppListProvider() : super([]);
  List<PackageInfo> appsWithNormalPermissions = [];
  List<PackageInfo> appsWithDangerousPermissions = [];

  List<PackageInfo> getAppsWithPermissions(
      List<PackageInfo>? applicationInfoList) {
    List<String> permissions = [
      "android.permission.CAMERA",
      "android.permission.RECORD_AUDIO", // Microphone
      "android.permission.ACCESS_FINE_LOCATION", // Precise Location
      "android.permission.READ_CONTACTS",
      "android.permission.SEND_SMS",
      "android.permission.READ_CALL_LOG", // Call Logs
      "android.permission.READ_EXTERNAL_STORAGE", // Storage
      "android.permission.READ_CALENDAR", // Calendar
      "android.permission.BLUETOOTH",
      "android.permission.NFC",
    ];
    final List<PackageInfo> appsWithoutPermissions = [];

    if (applicationInfoList != null) {
      for (final info in applicationInfoList) {
        if (!info.isApex! &&
            !(info.applicationInfo!.packageName!.startsWith('com.android') ||
                info.applicationInfo!.packageName!.startsWith('com.google') ||
                info.applicationInfo!.packageName!.startsWith('com.vivo') ||
                info.applicationInfo!.packageName!.startsWith('com.oppo') ||
                info.applicationInfo!.packageName!.startsWith('com.infinix') ||
                info.applicationInfo!.packageName!.startsWith('com.nokia') ||
                info.applicationInfo!.packageName!.startsWith('com.samsung') ||
                info.applicationInfo!.packageName!.startsWith('com.media'))) {
          if (info.requestedPermissions == null ||
              permissions.any((permission) => info.requestedPermissions!
                  .map((e) => e.toLowerCase())
                  .contains(permission.toLowerCase()))) {
            appsWithoutPermissions.add(info);
            state = appsWithoutPermissions;
          }
        }
      }
    }
    return appsWithoutPermissions;
  }

  List<PackageInfo> getAppsWithoutPermissions(
      List<PackageInfo>? applicationInfoList) {
    final List<PackageInfo> appsWithoutPermissions = [];

    if (applicationInfoList != null) {
      for (final info in applicationInfoList) {
        if (!info.isApex! &&
            !(info.applicationInfo!.packageName!.startsWith('com.android') ||
                info.applicationInfo!.packageName!.startsWith('com.google') ||
                info.applicationInfo!.packageName!.startsWith('com.vivo') ||
                info.applicationInfo!.packageName!.startsWith('com.oppo') ||
                info.applicationInfo!.packageName!.startsWith('com.infinix') ||
                info.applicationInfo!.packageName!.startsWith('com.nokia') ||
                info.applicationInfo!.packageName!.startsWith('com.samsung') ||
                info.applicationInfo!.packageName!.startsWith('com.media'))) {
          if (info.requestedPermissions == null ||
              info.requestedPermissions!.isEmpty ||
              containsOnlySafePermissions(info.requestedPermissions!)) {
            appsWithoutPermissions.add(info);
          }
        }
      }
    }
    return appsWithoutPermissions;
  }

  bool containsOnlySafePermissions(List<String> permissions) {
    List<String> safePermissions = [
      "android.permission.BLUETOOTH",
      "android.permission.BLUETOOTH_ADMIN",
      "android.permission.NFC",
      "android.permission.INTERNET",
      "android.permission.ACCESS_NETWORK_STATE",
      // Add other safe permissions as needed
    ];

    for (var permission in permissions) {
      if (!safePermissions.contains(permission.toLowerCase())) {
        return false; // Contains at least one non-safe permission
      }
    }
    return true; // Contains only safe permissions
  }
}
