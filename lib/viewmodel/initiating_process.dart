import 'package:PermissionGuard/viewmodel/extra_permission_category_list_provider.dart';
import 'package:PermissionGuard/viewmodel/filter_apps_with_permission_provider.dart';
import 'package:PermissionGuard/viewmodel/get_apps_from_phone.dart';
import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final initiatingProcess = StateNotifierProvider<InitiatingProcess, bool>(
    (ref) => InitiatingProcess());

class InitiatingProcess extends StateNotifier<bool> {
  InitiatingProcess() : super(false);
  List<PackageInfo> riskyapps = [];
  List<PackageInfo> safeapps = [];
  List<PermissionCategory> extraapps = [];

  Future<void> initProcess(WidgetRef ref) async {
    state = false;
    final appsProvider = ref.watch(initialAppsListProvider.notifier);
    //Firstly we will get the apps
    final filteringprovider = ref.watch(appListProvider.notifier);
    final extraPermissions = ref.watch(extraPermissionListProvider.notifier);
    final apps = await appsProvider.getApps();
    riskyapps = filteringprovider.getAppsWithPermissions(apps);
    safeapps = filteringprovider.getAppsWithoutPermissions(apps);
    extraapps = extraPermissions.getAppsWithExtraPermissions(apps);
    state = true;
  }
}
