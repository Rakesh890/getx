
import 'package:get/get.dart';
import 'package:getx/app/module/home_module/home_bindings.dart';
import 'package:getx/app/module/home_module/home_page.dart';

import 'app_routes.dart';

abstract class AppPages
{
  static final pages = [
    GetPage(
      name: Routes.HOME,
      page: () => const HomePage(),
      binding: HomeBindings(),
      transition: Transition.rightToLeft,
    ),

  ];
}

