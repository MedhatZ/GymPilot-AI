import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/repository_providers.dart';
import '../../data/repositories/repository_contracts.dart';
import '../config/personal_mode_service.dart';
import '../network/api_client.dart';
import 'token_storage.dart';

enum AuthStatus { unknown, signedOut, signedIn, needsOnboarding }

class AuthState {
  const AuthState({
    required this.status,
    this.email,
    this.userId,
  });

  final AuthStatus status;
  final String? email;
  final String? userId;

  AuthState copyWith({AuthStatus? status, String? email, String? userId}) =>
      AuthState(
        status: status ?? this.status,
        email: email ?? this.email,
        userId: userId ?? this.userId,
      );
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._api, this._tokens, this._personal, this._onboarding)
      : super(const AuthState(status: AuthStatus.unknown));

  final ApiClient _api;
  final TokenStorage _tokens;
  final PersonalModeService _personal;
  final OnboardingRepository _onboarding;

  Future<void> bootstrap() async {
    if (_personal.isEnabled) {
      await _bootstrapPersonal();
      return;
    }

    final token = await _tokens.readAccessToken();
    if (token == null) {
      state = const AuthState(status: AuthStatus.signedOut);
      return;
    }
    await _loadCloudProfileStatus();
  }

  /// Personal Mode: fully on-device. Never calls personal-bootstrap or backend.
  Future<void> _bootstrapPersonal() async {
    final complete = await _onboarding.isOnboardingComplete();
    final profile = await _onboarding.getProfile();
    state = AuthState(
      status: complete ? AuthStatus.signedIn : AuthStatus.needsOnboarding,
      email: profile?['displayName']?.toString() ?? 'personal',
      userId: 'personal-local',
    );
  }

  Future<void> _loadCloudProfileStatus() async {
    try {
      final complete = await _onboarding.isOnboardingComplete();
      final profile = await _onboarding.getProfile();
      state = AuthState(
        status: complete ? AuthStatus.signedIn : AuthStatus.needsOnboarding,
        email: profile?['displayName']?.toString(),
      );
    } catch (_) {
      state = const AuthState(status: AuthStatus.needsOnboarding);
    }
  }

  Future<void> register(String email, String password, String displayName) async {
    final res = await _api.dio.post('/api/auth/register', data: {
      'email': email,
      'password': password,
      'displayName': displayName,
    });
    await _tokens.saveTokens(
      access: res.data['accessToken'] as String,
      refresh: res.data['refreshToken'] as String,
    );
    state = AuthState(
      status: AuthStatus.needsOnboarding,
      email: email,
      userId: res.data['userId']?.toString(),
    );
  }

  Future<void> login(String email, String password) async {
    final res = await _api.dio.post('/api/auth/login', data: {
      'email': email,
      'password': password,
    });
    await _tokens.saveTokens(
      access: res.data['accessToken'] as String,
      refresh: res.data['refreshToken'] as String,
    );
    await _loadCloudProfileStatus();
  }

  Future<void> markOnboarded() async {
    state = state.copyWith(status: AuthStatus.signedIn);
  }

  Future<void> signOut() async {
    if (_personal.isEnabled) {
      await bootstrap();
      return;
    }
    await _tokens.clear();
    state = const AuthState(status: AuthStatus.signedOut);
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    ref.watch(apiClientProvider),
    ref.watch(tokenStorageProvider),
    ref.watch(personalModeServiceProvider),
    ref.watch(onboardingRepositoryProvider),
  );
});

final authBootstrapProvider = FutureProvider<void>((ref) async {
  await ref.read(authControllerProvider.notifier).bootstrap();
});
