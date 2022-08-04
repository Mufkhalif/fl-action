import 'package:flutter/material.dart';

class StackPage extends StatelessWidget {
  const StackPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      body: Stack(
        children: [
          for (var i = 0; i < 100; i++)
            Center(
              child: Container(
                child: Text("Selamat datang"),
              ),
            )
        ],
      ),
    );
  }
}
