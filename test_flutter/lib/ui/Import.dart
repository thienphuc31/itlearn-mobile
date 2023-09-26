import 'package:flutter/material.dart';

class Import extends StatefulWidget {
  const Import({super.key});

  @override
  State<StatefulWidget> createState() => _ImportState();
}

class _ImportState extends State<Import> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Import Item Page"),
      ),
    );
  }
}
