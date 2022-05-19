import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatelessWidget {
  var _counter = 0.obs;  // la variabile adesso e' osservabile
  @override
  Widget build(context) => Scaffold(
      appBar: AppBar(title: Text("counter")),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment
                .center, // (optional) will center horizontally.
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              // Obx(..) rende osservabile la vraibile, e' sufficiente!!!!
              Obx(() => Text(
                    "$_counter",
                    style: Theme.of(context).textTheme.headline4,
                  )),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        tooltip: 'Increment',
        onPressed: () => _counter++,
      ));
}
