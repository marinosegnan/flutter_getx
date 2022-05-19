import 'package:flutter/material.dart';
import 'package:get/get.dart';
// esempio Getx di uso delle route e middleware per intercettare
// i cambi di pagina
// in questo esempio abbiamo tre pagine: Home,Login,User
// si entra in Home e NON si e' autenticati
// si puo' fare login, e poi entrare in User
// se si fa subito User, si e' prima portati a Login
// e dopo il Login si arriva a User.
// Logout semplicemente fa ripartie tutto



class GlobalMiddleware extends GetMiddleware {
  final authController = Get.find<AuthController>();

  @override
  RouteSettings? redirect(String? route) {
    // se non sono autenticato e non sono su Home oppure Login
    // vengo mandato a Login, poi proseguo colla pagina successiva
    return authController.authenticated || route == '/login' || route == '/home'
        ? null
        : RouteSettings(name: '/login', arguments: {'page': route});
  }
}

void main() {
  // Authcontroller inizializzato subito
  Get.put(AuthController());
  runApp(GetMaterialApp(
    initialRoute: '/home',
    getPages: [
      GetPage(
        name: '/home',
        page: () => HomePage(),
        middlewares: [GlobalMiddleware()],
      ),
      GetPage(
        name: '/login',
        page: () => LoginPage(),
        middlewares: [GlobalMiddleware()],
      ),
      GetPage(
        name: '/user',
        page: () => UserPage(),
        middlewares: [GlobalMiddleware()],
      ),
    ],
  ));
}

class AuthController extends GetxController {
  final _authenticated = false.obs;
  final _username = Rxn<String>();

  bool get authenticated => _authenticated.value;
  set authenticated(value) => _authenticated.value = value;
  String? get username => _username.value;
  set username(value) => _username.value = value;

  @override
  void onInit() {
    ever(_authenticated, (value) {
      print('init, user = ${value}');
      if (value != null) {
        username = 'Mar';
      }
    });
    super.onInit();
  }
}

class HomePage extends StatelessWidget {
  final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('HOME')),
        body: Column(children: [
          Center(
            child: Obx(() => Text('User: ${controller.username}')),
          ),
          ElevatedButton(
            child: Text('Login'),
            onPressed: () {
              //   Get.snackbar('ciao', 'ciao');
              Get.toNamed('/login');
            },
          ),
          ElevatedButton(
            child: Text('Logout'),
            onPressed: () {
              controller.authenticated = false;
            },
          ),
          ElevatedButton(
            child: Obx(() => Text('User',
                style: TextStyle(
                    backgroundColor:
                        controller.authenticated ? Colors.green : Colors.red))),
            onPressed: () {
              Get.toNamed('/user');
            },
            style: stile(context),
          ),
        ]));
  }
}

class LoginPage extends StatelessWidget {
  final AuthController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    Map argumentData = Get.arguments ?? Map();
    print('argomenti login = $argumentData');
    if (controller.authenticated) {
      Future.delayed(Duration(seconds: 5), () {
        // cancella la pagina dopo 5 secondi
        Navigator.of(context).pop();
      });
      return Scaffold(
          appBar: AppBar(title: Text('Login')),
          body: Center(child: Text('you are already logged')));
    } else
      return Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Center(
          child: ElevatedButton(
            child: Text('Login'),
            onPressed: () {
              controller.authenticated = true;
              if (argumentData.isEmpty) {
                // nessuna destinazione successiva
                Get.back();
              } else {
                Get.offNamed(argumentData['page']);
              }
            },
          ),
        ),
      );
  }
}

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User')),
      body: Center(
        child: ElevatedButton(
          child: Text(
            'Back home',
            style: TextStyle(backgroundColor: Colors.green),
          ),
          onPressed: () {
            Get.offNamed('/home');
          },
          style: stile(context),
        ),
      ),
    );
  }
}

ButtonStyle stile(BuildContext context) {
  return ElevatedButton.styleFrom(
      primary: Colors.yellow,
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
}

// da SO, si puo' aggiungere parametri alla route anche cosi':

//
// class AuthMiddleware extends GetMiddleware {
//   RouteSettings? redirect(String? route) {
//     String returnUrl = Uri.encodeFull(route ?? '');
//     return !isAuthenticated
//         ? RouteSettings(name: "/login?return=" + returnUrl)
//         : null;
//   }
//
//   //after successful login...
//   String returnUrl = Get.parameters['return'] ?? '/';
//   Get.offAllNamed(returnUrl);