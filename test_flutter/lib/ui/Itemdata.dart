import 'package:flutter/material.dart';

class Itemdata extends StatefulWidget {
  const Itemdata({super.key});

  @override
  State<StatefulWidget> createState() => _ItemdataState();
}

class _ItemdataState extends State<Itemdata> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Data Page"),
      ),
    );
  }
}
