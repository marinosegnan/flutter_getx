import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_getx/routing/middle.dart';

void main() => runApp(MyApp());

class MyApp extends GetMaterialApp {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Get Route Managment',
      initialRoute: '/home',
      getPages: appRoutes(),
    );
  }
}

appRoutes() => [
  GetPage(
    name: '/home',
    page: () => HomePage(),
    transition: Transition.leftToRightWithFade,
    transitionDuration: Duration(milliseconds: 500),
  ),
  GetPage(
    name: '/second',
    page: () => SecondPage(),
    middlewares: [Middle.istanza],
    transition: Transition.circularReveal,
    transitionDuration: Duration(milliseconds: 500),
  ),
  GetPage(
    name: '/third',
    page: () => ThirdPage(),
    middlewares: [Middle.istanza],
    transition: Transition.leftToRightWithFade,
    transitionDuration: Duration(milliseconds: 500),
  ),
];

class HomePage extends StatelessWidget {
  var val = 'vuoto'.obs;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Home'),
                Obx(() =>
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () async {
                      val.value = await
                      Get.toNamed('/second', arguments: {'someArgument': 'someInfo'});},
                  child: Text('Go to second Page che ritorna: ${val}'),
                )),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () => Get.to(ThirdPage()),
                  child: Text('Go to third Page'),
                ),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () => Get.off(() => ThirdPage()),
                  child: Text('Go to third Page and Off'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Map argumentData = Get.arguments?? Map();
    print('argomenti = $argumentData');
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Page2 ${argumentData}'),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () => Get.back(result:'ritorno'),
                  child: Text('Indietro'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Page3'),
                MaterialButton(
                  color: Colors.blue,
                  onPressed: () => Get.back(),
                  child: Text('Indietro'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}