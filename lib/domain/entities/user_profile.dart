// Entidad de dominio que representa un usuario válido del sistema.
// Extiende Equatable para permitir comparaciones por valor,
// Protege sus invariantes (ej: identidad, email válido).
// No conoce UI, infraestructura ni frameworks.
// algo clave en dominio, tests y estado inmutable.

import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {

  // Nombre del usuario.
  // Invariante: no puede ser vacío.
  final String name;

  // Identidad única del usuario dentro del dominio.
  // Puede ser un ID de negocio, no necesariamente técnico.
  // Invariante: no puede ser vacío.
  final String identity;

  // Email del usuario.
  // Invariante: debe tener un formato válido según reglas del dominio.
  final String email;

  // Teléfono del usuario.
  // Aquí no se valida formato; se asume que no es crítico
  // o que la regla pertenece a otro nivel.
  final String phone;

  // Fecha de nacimiento (opcional).
  // No afecta invariantes principales del dominio.
  final String? dob;

  // Identificador técnico externo (Firebase).
  // Es opcional porque el usuario puede existir
  // antes de ser persistido o sincronizado.
  final String? firebaseId;

  // Constructor de la entidad.
  // Aquí se protegen las invariantes del dominio.
  UserProfile({
    required this.name,
    required this.identity,
    required this.email,
    required this.phone,
    this.dob,
    this.firebaseId,
  }) {
    // Regla de negocio: el nombre no puede ser vacío.
    if (name.trim().isEmpty) {
      throw ArgumentError('User name cannot be empty');
    }

    // Regla de negocio: la identidad es obligatoria.
    if (identity.trim().isEmpty) {
      throw ArgumentError('User identity cannot be empty');
    }

    // Regla de negocio: el email debe tener un formato válido.
    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }
  }

  // Método privado de ayuda.
  // Encapsula la lógica de validación del email
  // para no duplicarla ni exponerla fuera del dominio.
  static bool _isValidEmail(String email) {
    return email.contains('@');
  }

  // Método para crear una nueva instancia modificando
  // solo algunos campos.
  // Mantiene inmutabilidad y vuelve a pasar por validaciones
  // al llamar al constructor.
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

  // Define las propiedades que determinan igualdad por valor.
  // Dos UserProfile son iguales si todos estos campos coinciden.
  @override
  List<Object?> get props => [name, identity, email, phone, dob, firebaseId];
}


// ✔️ Define **qué existe** (Entities)
// ✔️ Define **qué se puede hacer** (Use Cases)
// ✔️ Define **qué necesita del mundo exterior** (Repositories / Services)
//DEFINE las entidades del dominio (datos necesarios para representar el objeto de negocio), que son las clases que representan los objetos de negocio de la aplicación. Estas clases o reglas del negocio deben ser inmutables y deben implementar la interfaz Equatable para facilitar la comparación de objetos. 
// Las entidades SÍ pueden y DEBEN tener lógica de negocio, pero solo la que protege sus invariantes.
