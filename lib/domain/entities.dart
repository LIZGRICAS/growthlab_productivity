
import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String name;
  final String identity;
  final String email;
  final String phone;
  final String? dob;
  final String? firebaseId;

  const UserProfile({
    required this.name,
    required this.identity,
    required this.email,
    required this.phone,
    this.dob,
    this.firebaseId,
  });

  UserProfile copyWith({String? dob, String? firebaseId}) {
    return UserProfile(
      name: name,
      identity: identity,
      email: email,
      phone: phone,
      dob: dob ?? this.dob,
      firebaseId: firebaseId ?? this.firebaseId,
    );
  }

  @override
  List<Object?> get props => [name, identity, email, phone, dob, firebaseId];
}

class AppConfig extends Equatable {
  final bool enablePremium;
  final String activeCampaign;

  const AppConfig({required this.enablePremium, required this.activeCampaign});

  @override
  List<Object?> get props => [enablePremium, activeCampaign];
}
