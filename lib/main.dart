import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:innovahub_app/core/network/dio_helper.dart';
import 'package:innovahub_app/core/services/cache_services.dart';

import 'config/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CacheService.init();
  await DioHelper.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 893),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          routes: AppRouter.routes(),
          navigatorKey: AppRouter.navigatorKey,
          initialRoute: AppRouter.initRoute,
        );
      },
    );
  }
}
