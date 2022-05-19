import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: '/home',   // prima route da mostrare
    getPages: [  // tutte le pagine (una sola a titolo esempio
      GetPage(name: '/home', page: () => HomeView(), binding: HomeBinding()),
    ],
  ));
}

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    // inizializzo qui ad esempio il controller della pagina
    Get.lazyPut(() => HomeController());
  }
}

class HomeController extends GetxController {
  var count = 0.obs;
  void increment() => count++;
}

class HomeView extends GetView<HomeController> {
  // estendo GetView e non Stateless nel caso abbia un solo controller
  // in questo caso mi e' reso automaticamente disponibile come attributo
  @override
  Widget build(context) => Scaffold(
      appBar: AppBar(title: Text("counter")),
      body: Center(
        child: Obx(() => Text("${controller.count}")),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: controller.increment,  // non serve dichiarare controller !
      ));
}
