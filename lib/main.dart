import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:flutter/services.dart';

// esempio navigazione normale da uno screen all'altro

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Remove the debug banner
      //     debugShowCheckedModeBanner: false,
      title: 'navigare_getx.com',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const HomePage(),
      getPages: [
        GetPage(name: '/page-three', page: () => const PageThree()),
        GetPage(
            name: '/page-four/:data',
            page: () => const PageFour()) // Dynamic route
      ],
    );
  }
}

// Home Screen
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kindacode.com'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Navigate ising screen classes'),
            ElevatedButton(
                onPressed: () => Get.to(() => const PageOne(), arguments: {
                      'id': Random().nextInt(1000).toString()
                    }), // Passing data by using "arguments"
                child: const Text('Go to page One')),
            ElevatedButton(
                onPressed: () => Get.off(() => PageTwo()),
                child: const Text('Go to page Two (Can not go back)')),
            const Divider(),
            const Text('Navigate Using named routes'),
            OutlinedButton(
                onPressed: () => Get.toNamed('/page-three',
                    arguments: {'id': Random().nextInt(10000).toString()}),
                child: const Text('Go to page Three')),
            OutlinedButton(
                onPressed: () => Get.toNamed(
                      '/page-four/${Random().nextInt(10000)}',
                    ),
                child: const Text('Go to page Four'))
          ],
        ),
      ),
    );
  }
}

// Page One
class PageOne extends StatelessWidget {
  const PageOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page One'),
      ),
      body: Center(
        child: Text(
          Get.arguments['id'] ?? 'Page One',
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}

// Page Two
class PageTwo extends StatelessWidget {
  const PageTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Two'),
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // (optional) will center horizontally.
              children: <Widget>[
                ElevatedButton(
                    onPressed: () => Get.off(() => HomePage()),
                    child: const Text('Go Home')),
                ElevatedButton(
                    onPressed: () =>   SystemNavigator.pop(),
                    child: const Text('Exit App')),
          ]
        ),
      ),
    );
  }
}

// Page Three
class PageThree extends StatelessWidget {
  const PageThree({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Three'),
      ),
      body: Center(
        child: Text(
          Get.arguments['id'] ?? 'Page Three',
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}

// Page Four
class PageFour extends StatelessWidget {
  const PageFour({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Four'),
      ),
      body: Center(
        child: Text(
          Get.parameters['data'] ?? 'Page Four',
          style: const TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}
