import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class Controller extends GetxController {
  // la classe controller contiene delle variabili che serbvono a costruire la UI
  // in questo esempio semplice basta definire la classe coi metodi
  // associarla a un Widget, e recuperarla dove serve ovy=unque nel codice
  // il Controller puo' essere acceduto, modificato e osservato da chiunque,
  // le variabili del controller sono quindi condivise fra i vari Widget

  static bool started = false;

  // la seguente variabile conta quante istanze di Pagina2 sono sullo stack

  var attive = 0.obs;

  void aggiungi() {
    attive++;
  }

  void togli() {
    attive--;
  }

  Controller() {
    initTimer();
  }

  void initTimer() {
    if (!started) {
      started = true;
      Timer.periodic(Duration(seconds: 3), (timer) {
        // ogni 3 secondi
        somma1();
      });
    }
  }

  var count = 0.obs;
  void somma1() {
    count++;
  }

  void moltiplica() {
    // questo metodo e' chiamato da Pagina2, anche se il controller e' creato
    // da pagina1. per modificare un RXint, occorre usare il campo .value
    print('tipo di count: ${count.runtimeType}');
    count.value *= 2;
  }
}

class Pagina2 extends StatelessWidget {
  final Controller controller  = Get.find();
   //
   // Pagina2({Key? key}) : super(key: key) {
   //   // trucco per mettere nel costruttore l'aggiornamento del numero di istanze
   //   // fuori dalla build()
   // Future.delayed(Duration(milliseconds: 20),
   //         () {  controller.aggiungi();  });
   // }
  @override
  Widget build(BuildContext context) {
    print("Pagina2 istanza ${controller.attive}");
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
            title: Obx(() => Text("Pagina2 istanza ${controller.attive}"))),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(() => Text(
                    'clicks: ${controller.count}',
                  )),
              ElevatedButton(
                child: Text('goto Route 1'),
                onPressed: () {
                  Get.to(() => Pagina1());
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Text(' *= 2'),
          onPressed: () {
            controller.moltiplica();
          },
        ),
      ),
      onWillPop: () async {
        // decrementa le Pagina2 attive
        controller.togli();
        return true;
      },
    );
  }
}

class Pagina1 extends StatelessWidget {
  final controller = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("counter")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  'clicks: ${controller.count}',
                )),
            ElevatedButton(
              child: Text(' goto Route 2'),
              onPressed: () {
                controller.aggiungi();
                Get.to(() => Pagina2());
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          controller.somma1();
        },
      ),
    );
  }
}

void main() => runApp(GetMaterialApp(home: Pagina1()));
