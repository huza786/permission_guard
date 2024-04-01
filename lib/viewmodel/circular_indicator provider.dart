// ignore: file_names

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final circularIndicatorProvider =
    StateNotifierProvider<CircularIndicatorCount, double>((ref) {
  return CircularIndicatorCount();
});
// Provider for the text string based on the double value
final progressTextProvider = StateProvider<String>((ref) {
  final doubleValue = ref.watch(circularIndicatorProvider);
  return doubleValue < 1.0 ? 'Scanning In Progress' : 'Scanning Done';
});

class CircularIndicatorCount extends StateNotifier<double> {
  CircularIndicatorCount() : super(0.0);
  void startCount() {
    Timer.periodic(Duration(milliseconds: (25000 / 100).floor()), (timer) {
      if (state < 1.0) {
        state += 0.01;
      } else {
        timer.cancel();
      }
    });
  }
}
