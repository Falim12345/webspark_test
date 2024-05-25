abstract class SharedpreferencesRep {
  Future<void> saveInputURl(String url);
  Future<String?> loadUrl();
}
