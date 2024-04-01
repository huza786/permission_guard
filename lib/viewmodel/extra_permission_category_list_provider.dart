import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final extraPermissionListProvider =
    StateNotifierProvider<ExtraPermissionListProvider, List<PackageInfo>>(
        (ref) {
  return ExtraPermissionListProvider();
});

class ExtraPermissionListProvider extends StateNotifier<List<PackageInfo>> {
  ExtraPermissionListProvider() : super([]);

  List<PermissionCategory> getAppsWithExtraPermissions(
      List<PackageInfo>? applicationInfoList) {
    List<PermissionCategory> appsWithExtraPermissions = [];

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
          int category = info.applicationInfo!.category!;
          List<String> permissions = info.requestedPermissions ?? [];
          List<String> requiredPermissions = _getRequiredPermissions(category);

          List<String> extraPermissions =
              _getExtraPermissions(permissions, requiredPermissions);

          if (extraPermissions.isNotEmpty) {
            appsWithExtraPermissions.add(
              PermissionCategory(
                info: info,
                category: category,
                extraPermissions: extraPermissions,
              ),
            );
          }
        }
      }
    }

    return appsWithExtraPermissions;
  }

  List<String> _getRequiredPermissions(int category) {
    switch (category) {
      case 1: // Game
        return [
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
          'android.permission.VIBRATE',
          'android.permission.WAKE_LOCK',
        ];
      case 2: // Audio
        return [
          'android.permission.RECORD_AUDIO',
          'android.permission.MODIFY_AUDIO_SETTINGS',
          'android.permission.WAKE_LOCK',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
        ];
      case 3: // Social Media
        return [
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.CAMERA',
          'android.permission.RECORD_AUDIO',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
          'android.permission.VIBRATE',
        ];
      case 4: // Health & Fitness
        return [
          'android.permission.BODY_SENSORS',
          'android.permission.ACCESS_FINE_LOCATION',
          'android.permission.ACTIVITY_RECOGNITION',
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
        ];
      case 5: // Education
        return [
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
        ];
      case 6: // Photography
        return [
          'android.permission.CAMERA',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
        ];
      case 7: // Travel & Local
        return [
          'android.permission.ACCESS_FINE_LOCATION',
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
        ];
      case 8: // Shopping
        return [
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.CAMERA',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
        ];
      case 9: // Business
        return [
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.READ_CONTACTS',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
        ];
      case 10: // Finance
        return [
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.READ_CONTACTS',
          'android.permission.READ_EXTERNAL_STORAGE',
          'android.permission.WRITE_EXTERNAL_STORAGE',
        ];
      case 11: // News & Magazines
        return [
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
        ];
      case 12: // Lifestyle
        return [
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.CAMERA',
          'android.permission.RECORD_AUDIO',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
          'android.permission.VIBRATE',
        ];
      case 13: // Productivity
        return [
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.READ_CALENDAR',
          'android.permission.WRITE_CALENDAR',
          'android.permission.READ_CONTACTS',
          'android.permission.WRITE_CONTACTS',
          'android.permission.READ_EXTERNAL_STORAGE',
          'android.permission.WRITE_EXTERNAL_STORAGE',
        ];
      case 14: // Tools
        return [
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
        ];
      case 15: // Communication
        return [
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.READ_CONTACTS',
          'android.permission.SEND_SMS',
          'android.permission.RECEIVE_SMS',
          'android.permission.READ_EXTERNAL_STORAGE',
          'android.permission.WRITE_EXTERNAL_STORAGE',
        ];
      case 16: // Entertainment
        return [
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
        ];
      case 17: // Weather
        return [
          'android.permission.ACCESS_FINE_LOCATION',
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
        ];
      case 18: // Personalization
        return [
          'android.permission.SET_WALLPAPER',
        ];
      case 19: // Social
        return [
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
        ];
      case 20: // Maps & Navigation
        return [
          'android.permission.ACCESS_FINE_LOCATION',
          'android.permission.INTERNET',
          'android.permission.ACCESS_NETWORK_STATE',
          'android.permission.WRITE_EXTERNAL_STORAGE',
          'android.permission.READ_EXTERNAL_STORAGE',
        ];
      default:
        return [];
    }
  }

  List<String> _getExtraPermissions(
      List<String> permissions, List<String> requiredPermissions) {
    List<String> extraPermissions = [];

    for (String permission in permissions) {
      if (!requiredPermissions.contains(permission)) {
        extraPermissions.add(permission);
      }
    }
    return extraPermissions;
  }
}

class PermissionCategory {
  final PackageInfo info;
  final int category;
  final List<String> extraPermissions;

  PermissionCategory({
    required this.info,
    required this.category,
    required this.extraPermissions,
  });
}
