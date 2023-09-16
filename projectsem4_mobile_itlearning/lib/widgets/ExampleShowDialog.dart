
import 'package:flutter/material.dart';
import 'package:projectsem4_mobile_itlearning/constants/colors.dart';
Future<void> ExampleShowDialogSuccess(BuildContext context,String dialogContent) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Success'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: primaryBlue,
              size: 60,
            ),
            SizedBox(height: 10),
            Text(
              dialogContent,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.headline6,
              primary: Colors.blue,
            ),
            child: const Text('Back to Home'),
            onPressed: () {
              Navigator.popAndPushNamed(context, "/Main");
            },
          ),
        ],
      );
    },
  );
}

Future<void> ExampleShowDialogError(BuildContext context, String dialogContent) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Error'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error,
              color: Colors.red,
              size: 60,
            ),
            SizedBox(height: 10),
            Text(
              dialogContent,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: TextStyle(fontSize: 18, color: Colors.blue),
            ),
            child: const Text('Back to Home'),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, "/Main",(route) => false,);
            },
          ),
        ],
      );
    },
  );
}
AlertDialog ExampleAlertError(BuildContext context,String stringContent) {
  return AlertDialog(
    content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Icon(
            Icons.error,
            color: Colors.red,
            size: 40,
          ),
          SizedBox(height: 10),
          Text(
            stringContent,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    actions: <Widget>[
      TextButton(
        child: Text('OK', style: TextStyle(color: Colors.blue)),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/Main", (route) => false);
        },
      ),
    ],
  );
}

AlertDialog ExampleAlertSuccess(String stringContent,BuildContext context) {
  return AlertDialog(
    content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Icon(
            Icons.check,
            color: Colors.red,
            size: 40,
          ),
          SizedBox(height: 10),
          Text(
            stringContent,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
    actions: <Widget>[
      TextButton(
        child: Text('OK', style: TextStyle(color: Colors.blue)),
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/Main", (route) => false);
        },
      ),
    ],
  );
}

