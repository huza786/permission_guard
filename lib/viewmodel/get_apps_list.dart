





/*   final systemflags = PackageInfoFlags({
      PMFlag.getPermissions,
      PMFlag.matchSystemOnly,
    });
    final appsflag = PackageInfoFlags({
      PMFlag.getPermissions,
    });
    _pm.getInstalledPackages(flags: appsflag).then(
          (value) => setState(() => applicationInitalList = value),
        );
    _pm.getInstalledPackages(flags: systemflags).then(
          (value) => setState(() => systemAppsList = value),
        );
    finalAppsList = applicationInitalList
        ?.where((item) => !systemAppsList!.contains(item))
        .toList();*/