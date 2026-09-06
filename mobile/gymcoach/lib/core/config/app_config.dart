/// Central app configuration. Prefer reading PersonalMode through [PersonalModeService].
///
/// When [personalMode] is true, Flutter uses local Drift repositories and does not
/// require the ASP.NET API (see docs/standalone-personal-mode.md).
class AppConfig {
  const AppConfig({
    this.personalMode = true,
    /// Used only when personalMode is false (cloud mode).
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
