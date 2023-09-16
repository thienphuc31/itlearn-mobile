import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projectsem4_mobile_itlearning/constants/colors.dart';
import 'package:provider/provider.dart';
import '../constants/urlAPI.dart';
import '../widgets/ExampleSnackbar.dart';
import 'ForgotPassProvider.dart';

class ResetPasswordProvider extends ChangeNotifier {
  String token = '';
  String newPassword = '';

  void updateToken(String value) {
    token = value;
    notifyListeners();
  }

  void updateNewPassword(String value) {
    newPassword = value;
    notifyListeners();
  }

  Future<void> resetPassword(BuildContext context, String newPassword, String token) async {
    try {
      final response = await http.post(
        Uri.parse(domain + 'api/student/reset-password?token=$token&newPassword=$newPassword'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "token": token,
          "newPassword": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        // Password reset successful
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ResetPasswordDialog();
          },
        );
      } else {
        // Password reset failed
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Password reset failed.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }





}
class ResetPasswordDialog extends StatefulWidget {
  @override
  _ResetPasswordDialogState createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  bool loading = true;
  bool success = false;

  @override
  void initState() {
    super.initState();
    // Simulate a loading delay (you can replace this with your actual loading logic)
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        loading = false;
        success = true;
      });
      if (success) {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.of(context).pushNamed('/LoginMain');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/ForgotPassword/succeed.png', // Replace with the path to your image
            width: 200, // Điều chỉnh chiều rộng của ảnh
            height: 200, // Điều chỉnh chiều cao của ảnh
            fit: BoxFit.cover, // Adjust the width as needed
          ),
          SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: Text(
              success ? 'Congratulations!' : 'Congratulations!',
              style: TextStyle(fontSize: 20, color: success ? primaryBlue : primaryBlue, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Text(success ? 'Your account is ready to use.' : 'Your account is ready to use.'),
          ),
          SizedBox(height: 16),
          loading
              ? CircularProgressIndicator() // Display a loading indicator
              : success
              ? Icon(
            Icons.check_circle_outline, // Display a tick mark when loading is complete
            size: 50,
            color: Colors.green,
          )
              : Icon(
            Icons.check_circle_outline, // Display an error icon if there's an issue
            size: 50,
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
