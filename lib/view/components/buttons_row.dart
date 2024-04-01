import 'package:PermissionGuard/view/components/icon_custom_button.dart';
import 'package:PermissionGuard/view/extra_permissions_apps_screen.dart';
import 'package:PermissionGuard/view/permission_screen.dart';
import 'package:PermissionGuard/viewmodel/extra_permission_category_list_provider.dart';
import 'package:PermissionGuard/viewmodel/filter_apps_with_permission_provider.dart';
import 'package:PermissionGuard/viewmodel/initiating_process.dart';
import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key, required this.finalAppsList});
  final List<PackageInfo>? finalAppsList;
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, ref, __) {
      final providerAllApps = ref.watch(initiatingProcess.notifier);
      final provider = ref.watch(appListProvider.notifier);

      return Padding(
        padding: const EdgeInsets.only(top: 38),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () async {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PermissionScreen(
                      helpText:
                          'The Following have the permissions that can alter your data like Storage,access your device location,access call logs. Unless you are sure that they are secure, you can uninstall them',
                      title: 'Risky',
                      appsList: providerAllApps.riskyapps,
                    ),
                  ),
                );
              },
              child: Animate(
                effects: [
                  ShimmerEffect(
                      stops: [0, 1],
                      duration: Durations.long4,
                      colors: [Colors.transparent, Colors.redAccent])
                ],
                child: IconCustomButton(
                  icon: 'assets/Images/risk.png',
                  bottonTitle: 'Risky',
                  countString: providerAllApps.riskyapps.length.toString(),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                // ignore: use_build_context_synchronously
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PermissionScreen(
                      helpText:
                          'The Following are the apps that do not require any potential permissions',
                      title: 'Safe',
                      appsList: providerAllApps.safeapps,
                    ),
                  ),
                );
              },
              child: IconCustomButton(
                icon: 'assets/Images/safe.png',
                bottonTitle: 'Safe',
                countString: providerAllApps.safeapps.length.toString(),
              ),
            ),
            GestureDetector(
              // ignore: use_build_context_synchronously
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExtraPermissionAppsScreen(
                              helpText:
                                  'The following Apps have access to various extra permissions and can function without having constant access to them.',
                              title: 'Extra',
                              appsList: providerAllApps.extraapps,
                            )));
              },
              child: IconCustomButton(
                icon: 'assets/Images/extra.png',
                bottonTitle: 'Extra',
                countString: providerAllApps.extraapps.length.toString(),
              ),
            ),
          ],
        ),
      );
    });
  }
}
//"The following Apps have access to various extra permissions and can function without having constant access to them."//