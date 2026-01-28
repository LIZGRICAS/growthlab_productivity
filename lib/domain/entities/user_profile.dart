
import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String name;
  final String identity;
  final String email;
  final String phone;
  final String? dob;

  const UserProfile({
    required this.name,
    required this.identity,
    required this.email,
    required this.phone,
    this.dob,
  });

  UserProfile copyWith({String? dob}) {
    return UserProfile(
      name: name,
      identity: identity,
      email: email,
      phone: phone,
      dob: dob ?? this.dob,
    );
  }

  @override
  List<Object?> get props => [name, identity, email, phone, dob];
}
