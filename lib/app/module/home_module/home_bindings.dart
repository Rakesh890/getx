import 'package:get/get.dart';
import 'package:getx/app/module/home_module/home_controller.dart';

class HomeBindings extends Bindings
{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put<HomeController>(HomeController());
  }

}