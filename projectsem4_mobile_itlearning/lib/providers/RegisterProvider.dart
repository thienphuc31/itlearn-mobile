import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../constants/urlAPI.dart';
import '../models/ApiResponse.dart';
import '../models/userRegister.dart';
import '../widgets/ExampleSnackbar.dart';


class RegisterProvider extends ChangeNotifier {
  bool _loadingRegister = false;
  bool get getLoading => _loadingRegister;

  Future<void> setLoading(bool value) async {
    _loadingRegister = value;
    notifyListeners();
  }

  Future<void> register(UserRegister newUser, BuildContext context) async {
    setLoading(true);

    try {
      var response = await http.post(
        Uri.parse(registerAPI),
        headers: {"Content-Type": "application/json;charset=UTF-8"},
        body: json.encode(newUser.toJson()),
      );

      if (response.statusCode == 200) {
        var apiResponse = ApiResponse.fromJson(json.decode(response.body));
        setLoading(false);

        if (apiResponse.success) {
          SnackBarShowSuccess(context, apiResponse.message);
          Navigator.pushNamedAndRemoveUntil(
              context, "/LoginMain", (route) => false);
        } else {
          SnackBarShowError(context, apiResponse.message);
        }
      } else {
        setLoading(false);
        var apiResponse = ApiResponse.fromJson(json.decode(response.body));
        SnackBarShowError(context, apiResponse.message);
        return;
      }
    } catch (e) {
      setLoading(false);
      SnackBarShowError(
          context, "Switch to a different IP or a different WiFi");
      print(e);
    }
  }
}
