import 'dart:typed_data';
import 'package:PermissionGuard/view/components/buttoncustom.dart';
import 'package:android_package_manager/android_package_manager.dart';
import 'package:PermissionGuard/utils/colorslist.dart';
import 'package:PermissionGuard/viewmodel/filter_apps_with_permission_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PermissionListPage extends StatefulWidget {
  const PermissionListPage({Key? key}) : super(key: key);

  @override
  State<PermissionListPage> createState() => _PermissionListPageState();
}

class _PermissionListPageState extends State<PermissionListPage> {
  List<PackageInfo>? _applicationInfoList;
  AndroidPackageManager get _pm => AndroidPackageManager();

  @override
  void initState() {
    super.initState();
    final flags = PackageInfoFlags({
      PMFlag.getPermissions,
    });
    _pm.getInstalledPackages(flags: flags).then(
          (value) => setState(() => _applicationInfoList = value),
        );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: MyAppColors.secondaryColor,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                  'assets/Images/background.jpg'),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              top: MediaQuery.of(context).size.height / 12,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 30),
                    child: Material(
                      shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(36)),
                      elevation: 12,
                      child: Container(
                        height: MediaQuery.of(context).size.height / 12,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(36)),
                          color: MyAppColors.primaryColor,
                        ),
                        child: const Center(
                          child: Text(
                            'Permission Guard',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Consumer(builder: (context, ref, child) {
                        final provider = ref.watch(appListProvider.notifier);

                        return GestureDetector(
                          onTap: () async {
                            final appsWithNormalPermissions =
                                await provider.getAppsWithoutPermissions(
                                    _applicationInfoList);
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PermissionScreen(
                                  title: ' Safe Apps ',
                                  appsList: appsWithNormalPermissions,
                                ),
                              ),
                            );
                          },
                          child: const CustomButton(
                            firstText: "Safe",
                          ),
                        );
                      }),
                      Consumer(builder: (context, ref, child) {
                        final provider = ref.watch(appListProvider.notifier);

                        return GestureDetector(
                            onTap: () async {
                              final appsWithNormalPermissions = await provider
                                  .getAppsWithPermissions(_applicationInfoList);
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PermissionScreen(
                                    title: 'Risky Apps',
                                    appsList: appsWithNormalPermissions,
                                  ),
                                ),
                              );
                            },
                            child: const CustomButton(firstText: 'Risky'));
                      }),
                    ],
                  ),
                  const InformationCard()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InformationCard extends StatelessWidget {
  const InformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Material(
        borderRadius: BorderRadius.circular(36),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(36),
          ),
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width - 50,
          child: const SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Text(
                  """It's vital to prioritize understanding and managing app permissions, especially with the help of our app. Our app plays a crucial role in empowering users to identify dangerous apps that request sensitive permissions, highlighting the importance of being vigilant about these permissions. By using our app, individuals can gain insights into which apps have access to their personal data, enabling them to make informed decisions about granting permissions. This proactive approach ensures that users take into account the potential risks associated with certain app permissions and take necessary steps to protect their privacy and security. With our app's assistance, users can navigate the digital landscape more safely and confidently, making informed choices that align with their privacy preferences.""",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PermissionScreen extends StatelessWidget {
  final String title;
  final List<PackageInfo> appsList;

  const PermissionScreen({
    Key? key,
    required this.title,
    required this.appsList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColors.secondaryColor,
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: appsList.length,
        itemBuilder: (context, index) {
          final info = appsList[index];

          return GestureDetector(
            onTap: () {
              showDialog(
                  context: (context),
                  builder: (context) {
                    return AlertDialog(
                      title: const Text(
                        "Granted Permissions",
                      ),
                      content: SingleChildScrollView(
                        child: Column(
                          children: info.requestedPermissions != null
                              ? info.requestedPermissions!
                                  .map((permission) => Text(permission))
                                  .toList()
                              : [],
                        ),
                      ),
                    );
                  });
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36)),
                child: ListTile(
                  leading: FutureBuilder<Uint8List?>(
                    future: info.applicationInfo?.getAppIcon(),
                    builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
                      if (snapshot.hasData) {
                        final iconBytes = snapshot.data!;
                        return Image.memory(
                          iconBytes,
                          fit: BoxFit.fill,
                        );
                      }
                      if (snapshot.hasError) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  title: FutureBuilder<String?>(
                    future: AndroidPackageManager()
                        .getApplicationLabel(packageName: info.packageName!),
                    builder: (context, snapshot) => Text(
                      "${snapshot.data}",
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
