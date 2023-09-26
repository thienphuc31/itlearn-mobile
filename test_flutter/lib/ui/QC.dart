import 'package:flutter/material.dart';

class QC extends StatefulWidget {
  const QC({super.key});

  @override
  State<StatefulWidget> createState() => _QCState();
}

class _QCState extends State<QC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QC Page"),
      ),
    );
  }
}
