import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat/core/constants/app_configs.dart';
import 'package:chat/core/constants/layout_dimensions.dart';
import 'package:chat/core/theme/theme.dart';
import 'package:chat/utils/helpers/toast.dart';
import 'package:chat/utils/routes/app_routes.dart';
import 'package:chat/utils/routes/route_generator.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: LayoutDimensions.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, _) => MaterialApp(
        title: AppConfigs.appName,
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        navigatorObservers: [toastNavigatorObserver],
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: AppRoutes.initial,
        theme: AppTheme.themeData,
        builder: (context, child) {
          final toastBuilder = fTostBuilder();
          final childWithToast = toastBuilder(context, child);
          return MediaQuery.withClampedTextScaling(
            minScaleFactor: 1,
            maxScaleFactor: 1,
            child: childWithToast,
          );
        },
      ),
    );
  }
}
