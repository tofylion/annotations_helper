import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Config extends ChangeNotifier {
  int _timeBeforeFrame = 5; //In seconds
  int get timeBeforeFrame => _timeBeforeFrame;

  void setTimeBeforeFrame(int time) {
    _timeBeforeFrame = time;
    notifyListeners();
  }
}

// Provider for the config
final configProvider = ChangeNotifierProvider((ref) => Config());
