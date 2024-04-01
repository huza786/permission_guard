import 'dart:typed_data';

import 'package:PermissionGuard/viewmodel/convert_permission_into_readable_state.dart';
import 'package:PermissionGuard/viewmodel/extra_permission_category_list_provider.dart';
import 'package:android_package_manager/android_package_manager.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExtraPermissionAppsScreen extends StatefulWidget {
  final String title;
  final String helpText;
  final List<PermissionCategory> appsList;

  const ExtraPermissionAppsScreen({
    Key? key,
    required this.title,
    required this.appsList,
    required this.helpText,
  }) : super(key: key);

  @override
  State<ExtraPermissionAppsScreen> createState() =>
      _ExtraPermissionAppsScreenState();
}

class _ExtraPermissionAppsScreenState extends State<ExtraPermissionAppsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PermissionCategory> filteredAppsList = [];

  @override
  void initState() {
    super.initState();
    widget.appsList
        .sort(((a, b) => a.info.packageName!.compareTo(b.info.packageName!)));

    filteredAppsList = widget.appsList;
  }

  void filterAppsList(String query) {
    setState(() {
      filteredAppsList = widget.appsList
          .where((app) =>
              app.info.packageName!.toLowerCase().contains(query.toLowerCase()))
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
              padding: const EdgeInsets.symmetric(horizontal: 62),
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
                  onTap: () {
                    showDialog(
                      context: (context),
                      builder: (context) {
                        return Dialog(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(36)),
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
                                          icon: const Icon(Icons.close))
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
                                          future: info.info.applicationInfo
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
                                                  height: 48.h,
                                                  width: 48.w,
                                                  iconBytes,
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
                                                  info.info.packageName!,
                                            ),
                                            builder: (context, snapshot) =>
                                                Text(
                                              "${snapshot.data}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          Consumer(builder: (context, ref, _) {
                                            final converter = ref.watch(
                                                convertPermissiontoStringProvider
                                                    .notifier);
                                            return Text(converter
                                                .convertToReadablePermission(
                                                    info.extraPermissions
                                                            .isNotEmpty
                                                        ? info
                                                            .extraPermissions[0]
                                                        : ''));
                                          }),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 20.h),
                                  child: const Text(
                                    "Granted Permissions",
                                    style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w600),
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
                                        children: info.extraPermissions
                                            .map((permission) => Text(
                                                stringProvider
                                                    .convertToReadablePermission(
                                                        permission)))
                                            .toList(),
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
                                                        .primaryColor)),
                                        onPressed: () async {
                                          await DeviceApps.openAppSettings(
                                            info.info.packageName!,
                                          );
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
                                                        .primaryColor)),
                                        onPressed: () async {
                                          await DeviceApps.openAppSettings(
                                            info.info.packageName!,
                                          );
                                        },
                                        child: const Text(
                                          "Uninstall",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
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
                              future: info.info.applicationInfo?.getAppIcon(),
                              builder: (context,
                                  AsyncSnapshot<Uint8List?> snapshot) {
                                if (snapshot.hasData) {
                                  final iconBytes = snapshot.data!;
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.memory(
                                      height: 48.h,
                                      width: 48.w,
                                      iconBytes,
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
                                packageName: info.info.packageName!,
                              ),
                              builder: (context, snapshot) => Text(
                                "${snapshot.data}",
                              ),
                            ),
                          ),
                          //subtitle
                          Positioned(
                            top: 28.h,
                            left: 107.w,
                            child: Consumer(builder: (context, ref, _) {
                              final converter = ref.watch(
                                  convertPermissiontoStringProvider.notifier);
                              return Text(converter.convertToReadablePermission(
                                  info.info.requestedPermissions!.isNotEmpty
                                      ? info.info.requestedPermissions![0]
                                      : ''));
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
                                  borderRadius: BorderRadius.circular(9)),
                              child: Center(
                                child: Text(
                                    info.extraPermissions.length.toString()),
                              ),
                            ),
                          ),
                          Positioned(
                              top: 48.h,
                              left: 107.w,
                              child: SizedBox(
                                  width: 281.w, child: const Divider()))
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
/** ListTile(
                        leading: FutureBuilder<Uint8List?>(
                          future: info.info.applicationInfo?.getAppIcon(),
                          builder:
                              (context, AsyncSnapshot<Uint8List?> snapshot) {
                            if (snapshot.hasData) {
                              final iconBytes = snapshot.data!;
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.memory(
                                  iconBytes,
                                  fit: BoxFit.fill,
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
                        title: FutureBuilder<String?>(
                          future: AndroidPackageManager().getApplicationLabel(
                            packageName: info.info.packageName!,
                          ),
                          builder: (context, snapshot) => Text(
                            "${snapshot.data}",
                          ),
                        ),
                        subtitle: Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Consumer(builder: (context, ref, _) {
                                  final converter = ref.watch(
                                      convertPermissiontoStringProvider
                                          .notifier);
                                  return Text(
                                      converter.convertToReadablePermission(info
                                                  .info
                                                  .requestedPermissions!
                                                  .length >
                                              0
                                          ? info.info.requestedPermissions![0]
                                          : ''));
                                }),
                                Divider(
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          )
                        ]),
                        trailing: Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 36.w,
                                height: 28.h,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(9)),
                                child: Center(
                                  child: Text(
                                      info.extraPermissions.length.toString()),
                                ),
                              ),
                              Divider()
                            ],
                          ),
                        ),
                      ), */