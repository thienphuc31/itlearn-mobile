import 'dart:async';
import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatefulWidget {
  final Duration initialDuration;
  final Function onTimeout;

  CountdownTimerWidget({
    required this.initialDuration,
    required this.onTimeout,
  });

  @override
  _CountdownTimerWidgetState createState() => _CountdownTimerWidgetState();
}

class _CountdownTimerWidgetState extends State<CountdownTimerWidget> {
  late Timer _timer;
  late Duration _remaining;

  @override
  void initState() {
    super.initState();

    _remaining = widget.initialDuration;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (!mounted) return;
      if (_remaining.inSeconds <= 1) {
        timer.cancel();
        await widget.onTimeout();
      } else {
        setState(() {
          _remaining -= Duration(seconds: 1);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    return Text(
      'Thời gian còn lại: ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
      style: TextStyle(fontSize: 16),
    );
  }
}