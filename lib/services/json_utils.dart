import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;

Future<Map<String, dynamic>> loadJson(String fileName,
    {String? assetPath}) async {
  return rootBundle
      .loadString(path.join('assets/', assetPath, fileName))
      .then((jsonStr) => jsonDecode(jsonStr));
}
