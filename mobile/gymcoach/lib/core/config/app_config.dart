/// Central app configuration. Prefer reading PersonalMode through [PersonalModeService].
class AppConfig {
  const AppConfig({
    this.personalMode = true,
    this.apiBaseUrl = 'http://10.0.2.2:5080',
    this.defaultWeightIncrementKg = 2.5,
    this.units = 'kg',
  });

  final bool personalMode;
  final String apiBaseUrl;
  final double defaultWeightIncrementKg;
  final String units;

  static const current = AppConfig();
}
