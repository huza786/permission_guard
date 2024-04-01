import 'package:flutter_riverpod/flutter_riverpod.dart';

final convertPermissiontoStringProvider =
    StateNotifierProvider<ConvertPermission, String>((ref) {
  return ConvertPermission();
});

class ConvertPermission extends StateNotifier<String> {
  ConvertPermission() : super('');

  String convertToReadablePermission(String permission) {
    if (permission.contains("android.permission")) {
      String formattedPermission = permission
          .replaceAll('android.permission.', '')
          .replaceAll('_', ' ')
          .toLowerCase();

      // Capitalize the first letter of each word
      formattedPermission = formattedPermission.split(' ').map((word) {
        return word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '';
      }).join(' ');

      return formattedPermission;
    } else {
      return '';
    }
  }
}
