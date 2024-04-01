import 'package:PermissionGuard/view/components/icon_custom_button.dart';
import 'package:PermissionGuard/view/extra_permissions_apps_screen.dart';
import 'package:PermissionGuard/view/permission_screen.dart';
import 'package:PermissionGuard/viewmodel/extra_permission_category_list_provider.dart';
import 'package:PermissionGuard/viewmodel/filter_apps_with_permission_provider.dart';
import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key, required this.finalAppsList});
  final List<PackageInfo>? finalAppsList;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      final extraProvider = ref.watch(extraPermissionListProvider.notifier);
      final provider = ref.watch(appListProvider.notifier);
      return Padding(
        padding: const EdgeInsets.only(top: 38),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                final appsWithNormalPermissions =
                    provider.getAppsWithPermissions(finalAppsList);
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PermissionScreen(
                      helpText:
                          'The Following have the permissions that can alter your data like Storage,access your device location,access call logs. Unless you are sure that they are secure, you can uninstall them',
                      title: 'Risky',
                      appsList: appsWithNormalPermissions,
                    ),
                  ),
                );
              },
              child: const IconCustomButton(
                icon: 'assets/Images/risk.png',
                bottonTitle: 'Risky',
                countString: '8',
              ),
            ),
            GestureDetector(
              onTap: () async {
                final appsWithNormalPermissions =
                    provider.getAppsWithoutPermissions(finalAppsList);
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PermissionScreen(
                      helpText:
                          'The Following are the apps that do not require any potential permissions',
                      title: 'Safe',
                      appsList: appsWithNormalPermissions,
                    ),
                  ),
                );
              },
              child: const IconCustomButton(
                icon: 'assets/Images/safe.png',
                bottonTitle: 'Safe',
                countString: '87',
              ),
            ),
            GestureDetector(
              // ignore: use_build_context_synchronously
              onTap: () async {
                final appsWithNormalPermissions =
                    extraProvider.getAppsWithExtraPermissions(finalAppsList);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExtraPermissionAppsScreen(
                              helpText:
                                  'The following Apps have access to various extra permissions and can function without having constant access to them.',
                              title: 'Safe',
                              appsList: appsWithNormalPermissions,
                            )));
              },
              child: const IconCustomButton(
                icon: 'assets/Images/extra.png',
                bottonTitle: 'Extra',
                countString: '9',
              ),
            ),
          ],
        ),
      );
    });
  }
}
//"The following Apps have access to various extra permissions and can function without having constant access to them."//