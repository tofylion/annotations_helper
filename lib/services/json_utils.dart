import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, dynamic>> loadJson(String fileName) async {
  return rootBundle
      .loadString('assets/json/$fileName')
      .then((jsonStr) => jsonDecode(jsonStr));
}
