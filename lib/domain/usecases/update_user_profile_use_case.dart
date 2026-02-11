// Importa el contrato del repositorio del dominio.
// El caso de uso depende de una abstracción,
// no de una implementación concreta (Clean Architecture).
import '../../domain/repositories/analytics_repository.dart';

// Caso de uso de dominio.
// Representa la acción de negocio: "actualizar el perfil de un usuario".
//
// Orquesta la operación y aplica reglas de flujo,
// pero no conoce detalles de infraestructura (API, SDK, DB, etc.).
class UpdateUserProfileUseCase {

  // Dependencia hacia el repositorio del dominio.
  // Se inyecta desde el Composition Root.
  final AnalyticsRepository repository;

  // Constructor del caso de uso.
  // Permite invertir dependencias y facilitar testing.
  UpdateUserProfileUseCase(this.repository);

  // Ejecuta el caso de uso.
  //
  // identity:
  //   Identificador del usuario dentro del dominio.
  //   El caso de uso asume que representa un usuario válido.
  //
  // attributes:
  //   Conjunto de atributos a actualizar.
  //   El formato concreto se delega al repositorio.
  //
  // El caso de uso NO:
  // - Construye payloads técnicos
  // - Decide cómo se persisten los datos
  // - Conoce plataformas externas
  //
  // Su única responsabilidad es coordinar la intención de negocio.
  Future<void> call(String identity, Map<String, dynamic> attributes) {
    return repository.updateProfileAttributes(identity, attributes);
  }
}
