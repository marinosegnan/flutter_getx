import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Middle extends GetMiddleware {

  static Middle istanza = Middle();
  static Middle get() => istanza;

  @override
  RouteSettings? redirect(String? route) => null;

  @override
  GetPage? onPageCalled(GetPage? page) => page;

  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    print('in Middle.onBindingsStart()');
    return bindings;
}

  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) => page;

  @override
  Widget onPageBuilt(Widget page) {

    print('in Middle.onPageBuilt() ');
    return page;
  }

  @override
  void onPageDispose() {
    print('in Middle.onPageDispose()');

  }
}