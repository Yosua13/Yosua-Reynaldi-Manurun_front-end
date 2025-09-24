import 'package:flutter/material.dart';
import 'package:frontend/app/config/theme/app_theme.dart';
import 'package:frontend/app/routes/app_pages.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Manajemen Produk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // Otomatis mengikuti tema sistem
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
