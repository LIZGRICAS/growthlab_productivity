
import '../../domain/entities/user_profile.dart';

class CleverTapDataSource {
  Future<void> onUserLogin(UserProfile user) async {
    final Map<String, dynamic> profile = {
      'Name': user.name,
      'Identity': user.identity, // String numérico sin puntos
      'Email': user.email,
      'Phone': user.phone,
    };
    await Future.delayed(const Duration(milliseconds: 800));
    print('[CleverTap Native] onUserLogin: $profile');
  }

  Future<void> profilePush(String identity, Map<String, dynamic> data) async {
    await Future.delayed(const Duration(milliseconds: 600));
    print('[CleverTap Native] profilePush ($identity): $data');
  }

  Future<void> trackEvent(String name, Map<String, dynamic> props) async {
    await Future.delayed(const Duration(milliseconds: 500));
    print('[CleverTap Native] eventTrack: $name -> $props');
  }
}
