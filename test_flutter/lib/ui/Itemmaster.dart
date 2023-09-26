import 'package:flutter/material.dart';

class Itemmaster extends StatefulWidget {
  const Itemmaster({super.key, required locationName, required id, required quantity, required recieveNo, required dateImport, required qcAcceptQuantity});

  @override
  State<StatefulWidget> createState() => _ItemmasterState();
}

class _ItemmasterState extends State<Itemmaster> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Item Master Page"),
      ),
    );
  }
}
