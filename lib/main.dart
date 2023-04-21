import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'main_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1440, 1024),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Handball Annotations Helper',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: child,
          );
        },
        child: const MainScreen());
  }
}
