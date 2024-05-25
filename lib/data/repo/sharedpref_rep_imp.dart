import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repo/sharedpreferences_rep.dart';

class SharedpreferencesRepImp implements SharedpreferencesRep {
  @override
  Future<String?> loadUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('apiUrl');
    return savedUrl;
  }

  @override
  Future<void> saveInputURl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiUrl', url);
  }
}
