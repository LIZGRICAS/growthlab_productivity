
import '../entities/user_profile.dart';

abstract class AnalyticsRepository {
  Future<void> createUserProfile(UserProfile profile);
  Future<void> updateProfileAttributes(String identity, Map<String, dynamic> attributes);
  Future<void> trackProductivityEvent(String name, Map<String, dynamic> properties);
  Future<List<String>> syncExternalData();
  Future<String> uploadProfilePhoto(String identity, List<int> bytes, {String? contentType});
}
