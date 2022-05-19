import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Alcuni casi di controller:
// di default il controller e' unico

void main() async {
  runApp(GetMaterialApp(
    initialRoute: '/home',
    routingCallback: (Routing? routing) {
      print('ROUTING to: ${routing?.current}');},
    getPages: [
      GetPage(name: '/home', page: () => Pagina1()),
      GetPage(name: '/home2', page: () => Pagina2(), binding: HomeBinding2()),
    ],
  ));
}

class HomeBinding2 implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Page2Controller());
  }
}

class Page1Controller extends GetxController {
  var count = 0.obs; // quanti click ho fatto su questa istanza

  void increment() {
    count.value++;
  }

  void rinfresca() {
    update();
  }

  static var instances = -1;
  static String lastTag = '';

  static String newTag() {
    // per avere tanti istanze di controller della stessa classe,
    // devo associargli un Tag univoco
    // devo creare un nome che non confligga con gli altri Controller!!! se no baco strano
    instances++;
    lastTag = '__' + instances.toString();
    return lastTag;
  }

  @override
  onInit() {
    print('homecontroller.oninit()');
  }
}

class PageControllerShared extends GetxController {
  // questo controller invece controlla i click totali, non ha Tag ed e' condiviso
  // tra tutti le HomeView
  var total = 0.obs;
  void increment() => total++;
}

class Page2Controller extends GetxController {
  var count1 = 0.obs;
  void increment() => count1++;
}

class Pagina1 extends StatelessWidget {
  PageControllerShared controllerShared = Get.put(PageControllerShared());

  // variante che usa get.put esplicito anziche' usare i bindings
  // perche' non riesco a usare il tag per la view e come chiave del controller instance,
  // cosi invece si

  late Page1Controller controller;
  late String tag;

  Pagina1() {
    // ogni volta che creo una istanza associo un Tag, che mi serve per creare un suo specifico controller
    tag = Page1Controller.newTag();
    controller = Get.put<Page1Controller>(Page1Controller(), tag: tag);
  }

  @override
  Widget build(context) {
    Map argumentData = Get.arguments ?? Map();
    print('argomenti = $argumentData');
    return Scaffold(
        appBar: AppBar(title: Text("counter")),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .center, // (optional) will center horizontally.
                children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Obx(() =>
                      Text("clicks su questa istanza :${controller.count}"))),
              // qui uso getBuilder perche' devo trovare il controller specifico di questa  istanza
              GetBuilder<Page1Controller>(
                  // diversamente dall'uso di Obx(), la rebuild in questo modo non e' automatica
                  // ma avviene se richiamo update()
                  // voglio usare lo stesso tag di tutta la pagina
                  tag: tag, // necessario per trovare la giusta istanza
                  init: controller,
                  builder: (mycontroller) =>
                      Text("clicks senza Obx(): ${mycontroller.count}")),
              Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // (optional) will center horizontally.
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('click totali:')),
                    SizedBox(width: 20),
                    Obx(() => Text("${controllerShared.total}")),
                  ]),
              ElevatedButton(
                  onPressed: (() async {
                    // se volessi un risultato indietro
                    var result = await Get.toNamed('/home2');
                    print('risultato=: ${result}');
                  }), // aggiunge allo stack delle finestre
                  child: const Text('Go to page Two')),
              TextButton(
                child: Text(
                  'AGGIORNA',
                  style: TextStyle(fontSize: 20.0),
                ),
                onPressed: () {
                  controller.rinfresca();
                },
              ),
            ])),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            controller.increment();
            controllerShared.increment();
          },
        ));
  }
}

class Pagina2 extends GetView<Page2Controller> {
  @override
  Widget build(context) => WillPopScope(
      child: Scaffold(
          appBar: AppBar(title: Text("counter")),
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // (optional) will center horizontally.
                  children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment
                        .center, // (optional) will center horizontally.
                    children: <Widget>[
                      Text('clicks:'),
                      SizedBox(width: 20),
                      Obx(() => Text("${controller.count1}")),
                    ]),
                ElevatedButton(
                    onPressed: (() {
                      // print('tag=$tag');
                      // HomeControllerMany contr = Get.find<HomeControllerMany>();//(tag:'0');
                      //    Get.toNamed('/home',
                      Get.offNamed('/home'); //,preventDuplicates: false);
                    }), // rimpiaza sullo stack finestre
                    child: const Text('elimina screen vai a Pagina1')),
                ElevatedButton(
                    onPressed: (() {
                      Get.toNamed('/home', arguments: {
                        //parametri di esempio  per destinatario
                        'aa': 'bb'
                      }); //,preventDuplicates: false);
                    }), // rimpiaza sullo stack finestre
                    child: const Text('aggiungi screen vai a Pagina1')),
              ])),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => controller.increment(),
          )),
      onWillPop: () async {
        Get.back(result: 'Risultato da Pagina2');
        return true;
      });
}
