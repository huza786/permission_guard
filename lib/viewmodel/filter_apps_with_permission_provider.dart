import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appListProvider =
    StateNotifierProvider<AppListProvider, List<PackageInfo>>((ref) {
  return AppListProvider();
});

class AppListProvider extends StateNotifier<List<PackageInfo>> {
  AppListProvider() : super([]);
  List<PackageInfo> appsWithNormalPermissions = [];
  List<PackageInfo> appsWithDangerousPermissions = [];

  Future<List<PackageInfo>> getAppsWithPermissions(
      List<PackageInfo>? applicationInfoList) async {
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

  Future<List<PackageInfo>> getAppsWithoutPermissions(
      List<PackageInfo>? applicationInfoList) async {
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
              !permissions.any((permission) => info.requestedPermissions!
                  .map((e) => e.toLowerCase())
                  .contains(permission.toLowerCase()))) {
            appsWithoutPermissions.add(info);
          }
        }
      }
    }
    return appsWithoutPermissions;
  }
}
