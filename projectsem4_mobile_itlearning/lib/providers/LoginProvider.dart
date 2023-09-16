import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/AuthenticatedHttpClient.dart';
import '../constants/urlAPI.dart';
import '../models/ApiResponse.dart';
import '../widgets/ExampleSnackbar.dart';
import 'AccountProvider.dart';

class LoginProvider extends ChangeNotifier {
  bool _Loading = false;

  bool get Loading => _Loading;

  Future<void> setLoading(bool value) async {
    _Loading = value;

    notifyListeners();
  }


  Future<void> dangnhap(String username, String pass, BuildContext context) async {
    setLoading(true);

    try {
      var response = await http.post(
        Uri.parse(loginAPI),
        headers: {"Content-Type": "application/json;charset=UTF-8"},
        body: jsonEncode({
          "username": username,
          "password": pass,
        }),
      );

      setLoading(false);

      if (response.statusCode == 200) {
        var responseMap = json.decode(response.body) as Map<String, dynamic>;
        var dataMap = responseMap['data'] as Map<String, dynamic>;
        var accessToken = dataMap['accessToken'] as String;

        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('accessToken', accessToken);

        final accountProvider = Provider.of<AccountProvider>(context, listen: false);
        await accountProvider.getInforAccount();
        final fullname = accountProvider.account.fullName;
        final phone = accountProvider.account.phone;
        final address = accountProvider.account.address;
        final dob = accountProvider.account.dob;

        if (fullname == "null" || phone == "null" || address == "null" || dob =="null") {
          Navigator.pushNamed(context, '/EditStudentPage');
        } else {
          Navigator.pushNamed(context, '/Main');
        }
      } else {
        setLoading(false);
        var apiResponse = ApiResponse.fromJson(json.decode(response.body));
        SnackBarShowError(context, apiResponse.message);
        return;
      }
    } catch (e) {
      setLoading(false);
      SnackBarShowError(context, "Switch to a different IP or a different WiFi");
      print(e);
    }
  }

}
