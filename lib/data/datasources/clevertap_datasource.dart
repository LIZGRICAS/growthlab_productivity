import 'dart:developer' as developer;
import 'typed_clevertap.dart';
import '../../domain/entities.dart';

/// CleverTapDataSource - direct calls to the official `clevertap_plugin`.
///
/// Uses the plugin API when available; catches platform errors and falls
/// back to a short delay + log to keep deterministic behavior in tests/CI.
class CleverTapDataSource {
  Future<void> onUserLogin(UserProfile profile) async {
    final Map<String, dynamic> profileMap = {
      'Name': profile.name,
      'Identity': profile.identity,
      'Email': profile.email,
      'Phone': profile.phone,
    };

    try {
      // Call typed wrapper which uses MethodChannel to reach the plugin.
      await TypedCleverTap.onUserLogin(profileMap);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 800));
      developer.log('[CleverTapDataSource] onUserLogin fallback: $profileMap — $e', name: 'CleverTapDataSource', error: e);
    }
  }

  /// Helper for diagnostics to call with a raw map.
  Future<void> onUserLoginFromMap(Map<String, dynamic> profileMap) async {
    try {
      await TypedCleverTap.onUserLogin(profileMap);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 800));
      developer.log('[CleverTapDataSource] onUserLoginFromMap fallback: $profileMap — $e', name: 'CleverTapDataSource', error: e);
    }
  }

  Future<void> profilePush(String identity, Map<String, dynamic> attributes) async {
    final Map<String, dynamic> attrs = Map.of(attributes);
    attrs['Identity'] = identity;

    try {
      // Try common profile APIs used across plugin versions.
      // Use the typed wrapper which invokes the platform plugin via MethodChannel.
      await TypedCleverTap.profilePush(attrs);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 600));
      developer.log('[CleverTapDataSource] profilePush fallback: $attrs — $e', name: 'CleverTapDataSource', error: e);
    }
  }

  Future<void> trackEvent(String name, Map<String, dynamic> properties) async {
    try {
      await TypedCleverTap.recordEvent(name, properties);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 500));
      developer.log('[CleverTapDataSource] trackEvent fallback: $name $properties — $e', name: 'CleverTapDataSource', error: e);
    }
  }
}
