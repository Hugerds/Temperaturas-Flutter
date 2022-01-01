import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:temperatua_flutter/core/routes.dart';
import 'package:temperatua_flutter/view/initial_view.dart';

class Pages {
  static List<GetPage> getPages = [
    GetPage(
      name: Routes.initialRoute,
      page: () => ResponsiveSizer(builder: (context, orientation, screenType) {
        return const InitialView();
      }),
    ),
  ];
}
