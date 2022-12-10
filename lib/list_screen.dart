import 'package:flutter/material.dart';

class ListScreen extends StatelessWidget {
  final String title;
  const ListScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "List Screen"
            ),
            Text(
               title
            ),
          ],
        ),
      ),
    );
  }
}
