import 'package:PermissionGuard/viewmodel/circular_indicator%20provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProgressText extends StatelessWidget {
  const ProgressText({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      final indicator = ref.watch(progressTextProvider);

      return Text(
        indicator,
        style: const TextStyle(
          fontSize: 28,
        ),
      );
    });
  }
}
