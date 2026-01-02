import 'package:story_app_flutter_intermediate/app_config.dart';
import 'package:story_app_flutter_intermediate/main.dart' as app;

void main() {
  AppConfig(flavor: Flavor.paid, appName: 'Story App (Paid)');
  app.main();
}
