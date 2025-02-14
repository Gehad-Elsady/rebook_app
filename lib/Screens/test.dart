import 'package:animated_notch_bottom_bar/src/notch_bottom_bar_controller.dart';
import 'package:flutter/material.dart';

class Test1 extends StatelessWidget {
  const Test1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Center(
        child: Text('Test 1'),
      ),
    );
  }
}

class Test2 extends StatelessWidget {
  const Test2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: Center(
        child: Text('Test 2'),
      ),
    );
  }
}

class Test3 extends StatelessWidget {
  const Test3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: Text('Test 3'),
      ),
    );
  }
}

class Test4 extends StatelessWidget {
  const Test4({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      child: Center(
        child: Text('Test 4'),
      ),
    );
  }
}
