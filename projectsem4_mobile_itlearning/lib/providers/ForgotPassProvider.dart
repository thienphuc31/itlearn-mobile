import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/AuthenticatedHttpClient.dart';
import '../constants/urlAPI.dart';
import '../models/ApiResponse.dart';
import '../screens/Forgot&ResetPass/AuthorizationCode.dart';
import '../widgets/ExampleSnackbar.dart';
import 'AccountProvider.dart';

class ForgotPassProvider extends ChangeNotifier {
  bool _Loading = false;
  String _token = '';
  void setToken(String token) {
    _token = token;
    notifyListeners();
  }
  String getToken() {
    return _token;
  }
  bool get Loading => _Loading;

  Future<void> setLoading(bool value) async {
    _Loading = value;

    notifyListeners();
  }


  Future<void> sendVerifyCode(String email, BuildContext context) async {
    setLoading(true);

    try {
      final response = await http.post(
        Uri.parse(domain + 'api/student/forgot-password?email=$email'),
        headers: {"Content-Type": "application/json;charset=UTF-8"},
        body: jsonEncode({
          "email": email,
        }),
      );

      setLoading(false);

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body);
        final data = parsedResponse['data'];
        Provider.of<ForgotPassProvider>(context, listen: false).setToken(data.toString());

      }else {
        setLoading(false);
        final apiResponse = ApiResponse.fromJson(json.decode(response.body));
        SnackBarShowError(context, apiResponse.message);
         // Trả về null khi có lỗi để bạn có thể xử lý tùy theo tình huống
      }
    } catch (e) {
      setLoading(false);
      SnackBarShowError(context, "Switch to a different IP or a different WiFi");
      print(e);
      // Trả về null khi có lỗi để bạn có thể xử lý tùy theo tình huống
    }
  }


}
