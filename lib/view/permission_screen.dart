import 'dart:typed_data';

import 'package:PermissionGuard/viewmodel/convert_permission_into_readable_state.dart';
import 'package:android_package_manager/android_package_manager.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:just_audio/just_audio.dart';

class PermissionScreen extends StatefulWidget {
  final String title;
  final String helpText;
  final List<PackageInfo> appsList;

  const PermissionScreen({
    Key? key,
    required this.title,
    required this.appsList,
    required this.helpText,
  }) : super(key: key);

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PackageInfo> filteredAppsList = [];
  final player = AudioPlayer(); // Create a player

  final assetPath = "audio/risky.mp3";
  @override
  void initState() {
    super.initState();

    filteredAppsList = widget.appsList;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // async();
    });
  }

  async() async {
    // await player.setAsset("assets/audio/risky.mp3");
    // await player.setAsset("assets/audio/risky.mp3");
  }

  void filterAppsList(String query) {
    setState(() {
      filteredAppsList = widget.appsList
          .where((app) =>
              app.packageName!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.helpText,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(color: Colors.black)),
                height: 43.h,
                child: TextFormField(
                  controller: _searchController,
                  onChanged: filterAppsList,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 2),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.black,
                      ),
                      border: InputBorder.none,
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 18)),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final info = filteredAppsList[index];
                return GestureDetector(
                  onTap: () async {
                    // final player = AudioCache();
                    if (widget.title == "Risky") {
                      await player.play(AssetSource("risky.mp3"));
                    }

                    showDialog(
                      context: (context),
                      builder: (context) {
                        return Dialog(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(36),
                            ),
                            height: MediaQuery.of(context).size.height / 2,
                            width: 376.w,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 130.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Analysis',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20.w),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.w),
                                        child: FutureBuilder<Uint8List?>(
                                          future: info.applicationInfo
                                              ?.getAppIcon(),
                                          builder: (context,
                                              AsyncSnapshot<Uint8List?>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              final iconBytes = snapshot.data!;
                                              return ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                child: Image.memory(
                                                  iconBytes,
                                                  height: 48.h,
                                                  width: 48.w,
                                                  fit: BoxFit.cover,
                                                ),
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
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          FutureBuilder<String?>(
                                            future: AndroidPackageManager()
                                                .getApplicationLabel(
                                              packageName:
                                                  info.packageName ?? '',
                                            ),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                return Text(
                                                  snapshot.data!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                );
                                              }
                                              return const SizedBox.shrink();
                                            },
                                          ),
                                          Consumer(builder: (context, ref, _) {
                                            final converter = ref.watch(
                                                convertPermissiontoStringProvider
                                                    .notifier);
                                            if (info.requestedPermissions !=
                                                    null &&
                                                info.requestedPermissions!
                                                    .isNotEmpty) {
                                              return Text(
                                                converter
                                                    .convertToReadablePermission(
                                                  info.requestedPermissions![0],
                                                ),
                                              );
                                            } else {
                                              return const SizedBox.shrink();
                                            }
                                          }),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: const Text(
                                    "Granted Permissions",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 200.h,
                                  child:
                                      Consumer(builder: (context, ref, child) {
                                    final stringProvider = ref.watch(
                                        convertPermissiontoStringProvider
                                            .notifier);
                                    return SingleChildScrollView(
                                      child: Column(
                                        children:
                                            info.requestedPermissions != null
                                                ? info.requestedPermissions!
                                                    .map((permission) => Text(
                                                          stringProvider
                                                              .convertToReadablePermission(
                                                                  permission),
                                                        ))
                                                    .toList()
                                                : [],
                                      ),
                                    );
                                  }),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context)
                                                      .primaryColor),
                                        ),
                                        onPressed: () async {
                                          await DeviceApps.openAppSettings(
                                              info.packageName!);
                                        },
                                        child: const Text(
                                          "Revoke",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context)
                                                      .primaryColor),
                                        ),
                                        onPressed: () async {
                                          await DeviceApps.uninstallApp(
                                              info.packageName!);
                                        },
                                        child: const Text(
                                          "Uninstall",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.only(right: 20.w, top: 10.h, bottom: 10.h),
                    child: SizedBox(
                      height: 58,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          //image widget logo
                          Positioned(
                            left: 41.w,
                            child: FutureBuilder<Uint8List?>(
                              future: info.applicationInfo?.getAppIcon(),
                              builder: (context,
                                  AsyncSnapshot<Uint8List?> snapshot) {
                                if (snapshot.hasData) {
                                  final iconBytes = snapshot.data!;
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.memory(
                                      iconBytes,
                                      height: 48.h,
                                      width: 48.w,
                                      fit: BoxFit.cover,
                                    ),
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
                          ),
                          //title
                          Positioned(
                            left: 107.w,
                            child: FutureBuilder<String?>(
                              future:
                                  AndroidPackageManager().getApplicationLabel(
                                packageName: info.packageName ?? '',
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          //subtitle
                          Positioned(
                            top: 28.h,
                            left: 107.w,
                            child: Consumer(builder: (context, ref, _) {
                              final converter = ref.watch(
                                  convertPermissiontoStringProvider.notifier);
                              if (info.requestedPermissions != null &&
                                  info.requestedPermissions!.isNotEmpty) {
                                return Text(
                                  converter.convertToReadablePermission(
                                    info.requestedPermissions![0],
                                  ),
                                );
                              } else {
                                return const SizedBox.shrink();
                              }
                            }),
                          ),
                          //permissions count
                          Positioned(
                            left: 346.w,
                            child: Container(
                              width: 36.w,
                              height: 28.h,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Center(
                                child: Text(
                                  info.requestedPermissions?.length
                                          .toString() ??
                                      'N/A',
                                ),
                              ),
                            ),
                          ),

                          //divider
                          Positioned(
                            top: 48.h,
                            left: 107.w,
                            child:
                                SizedBox(width: 281.w, child: const Divider()),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: filteredAppsList.length,
            ),
          ),
        ],
      ),
    );
  }
}
/** AlertDialog(
                            backgroundColor: Colors.white,
                            alignment: Alignment.bottomCenter,
                            title: Text(
                              "Granted Permissions+${info.packageName!}",
                            ),
                            content: Consumer(builder: (context, ref, child) {
                              final stringProvider = ref.watch(
                                  convertPermissiontoStringProvider.notifier);
                              return SingleChildScrollView(
                                child: Column(
                                  children: info.requestedPermissions != null
                                      ? info.requestedPermissions!
                                          .map((permission) => Text(
                                              stringProvider
                                                  .convertToReadablePermission(
                                                      permission)))
                                          .toList()
                                      : [],
                                ),
                              );
                            }),
                            actions: [
                              ElevatedButton(
                                onPressed: () async {
                                  await DeviceApps.openAppSettings(
                                    info.packageName!,
                                  );
                                },
                                child: Text(
                                  "Revoke",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ), */