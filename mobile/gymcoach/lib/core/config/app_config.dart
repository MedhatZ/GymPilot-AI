/// Central app configuration. Prefer reading PersonalMode through [PersonalModeService].
///
/// When [personalMode] is true, Flutter uses local Drift repositories and does not
/// require the ASP.NET API (see docs/standalone-personal-mode.md).
class AppConfig {
  const AppConfig({
    this.personalMode = false,
    /// Used only when personalMode is false (cloud mode).
    this.apiBaseUrl = 'https://gympilot-ai.onrender.com',
    this.defaultWeightIncrementKg = 2.5,
    this.units = 'kg',
  });

  final bool personalMode;
  final String apiBaseUrl;
  final double defaultWeightIncrementKg;
  final String units;

  static const current = AppConfig();
}
