import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:test_flutter/constaints/urlAPI.dart';
import 'package:test_flutter/model/Account.dart';
import 'package:http/http.dart' as http;

class AccountProvider extends ChangeNotifier{
  late Account account;

  Future<void> logOut(BuildContext context) async{
    notifyListeners();
    Navigator.pushNamedAndRemoveUntil(context, "/LoginMain", (route) => false);
  }

  Future<Account?> getInforAccount() async {
    final response = await http.get(
      Uri.parse(loginAPI),
    );

    if(response.statusCode == 200){
      Map<String, dynamic> aaa = jsonDecode(response.body) as Map<String, dynamic>;
      account = Account.fromMap(aaa);

      notifyListeners();
      return account;
    }
  }
}
