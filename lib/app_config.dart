enum Flavor { free, paid }

class AppConfig {
  final Flavor flavor;
  final String appName;

  static AppConfig? _instance;

  factory AppConfig({required Flavor flavor, required String appName}) {
    _instance ??= AppConfig._internal(flavor, appName);
    return _instance!;
  }

  AppConfig._internal(this.flavor, this.appName);

  static AppConfig get instance => _instance!;

  static bool get isPaid => _instance!.flavor == Flavor.paid;
}
