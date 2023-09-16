import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticatedHttpClient extends http.BaseClient {
  final http.Client _client = http.Client();
  final SharedPreferences _preferences;

  AuthenticatedHttpClient(this._preferences);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    var accessToken = _preferences.getString('accessToken') ?? '';

    request.headers['Authorization'] = 'Bearer $accessToken';
    return _client.send(request);
  }
}
