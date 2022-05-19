import 'package:flutter/material.dart';
import 'package:get/get.dart';

// esempio navigazione bar, dialog etc
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const HomePage(),
    );
  }
}

// Home Screen
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // This function is triggered when the "Show Dialog" button pressed
  void _showDialog() async {
    await Get.dialog(AlertDialog(
      title: const Text('Dialog Title'),
      content: const Text('This is the dialog content'),
      actions: [
        TextButton(
            onPressed: () => Get.back(), // Close the dialog
            child: const Text('Close'))
      ],
    ));

    // Code that runs after the dialog disappears
    debugPrint('Dialog closed!');
  }

  // This function is triggered when the "Show SnackBar" button pressed
  void _showSnackBar() {
    Get.snackbar('SnackBar Title', 'This is a beautiful snack bar',
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.FLOATING);
  }

// This function is triggered when the "Show BottomSheet" button pressed
  void _showBottomSheet() async {
    await Get.bottomSheet(Container(
      width: double.infinity,
      height: 300,
      color: Colors.greenAccent,
      child: const Center(
        child: Text('Bottom Sheet Content'),
      ),
    ));

    // The code below will run after the bottom sheet goes away
    debugPrint('The Bottom Sheet has gone away!');
  }

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
            ElevatedButton(
                onPressed: _showDialog, child: const Text('Show Dialog')),
            ElevatedButton(
                onPressed: _showSnackBar, child: const Text('Show SnackBar')),
            ElevatedButton(
                onPressed: _showBottomSheet,
                child: const Text('Show BottomSheet')),
          ],
        ),
      ),
    );
  }
}