import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_config.dart';

/// Single place to resolve Personal Mode. Avoid scattering flags across UI.
abstract interface class PersonalModeService {
  bool get isEnabled;
  AppConfig get config;
}

class DefaultPersonalModeService implements PersonalModeService {
  DefaultPersonalModeService(this.config);
  @override
  final AppConfig config;
  @override
  bool get isEnabled => config.personalMode;
}

final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.current);

final personalModeServiceProvider = Provider<PersonalModeService>((ref) {
  return DefaultPersonalModeService(ref.watch(appConfigProvider));
});
