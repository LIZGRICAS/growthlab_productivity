// Entidad de dominio que representa un usuario válido del sistema.
// Extiende Equatable para permitir comparaciones por valor,
// Protege sus invariantes (ej: identidad, email válido).
// No conoce UI, infraestructura ni frameworks.
// algo clave en dominio, tests y estado inmutable.

import 'package:equatable/equatable.dart';

// Entidad de dominio que representa la configuración activa del sistema.
// Modela reglas de negocio relacionadas con el comportamiento global
// de la aplicación (features, sincronización, campañas).
class AppConfig extends Equatable {

  // Indica si las funcionalidades premium están habilitadas.
  // Es una decisión de negocio, no técnica.
  final bool enablePremium;

  // Nombre o identificador de la campaña activa.
  // Puede afectar comportamiento, métricas o flujos del sistema.
  final String activeCampaign;

  // Umbral de sincronización.
  // Define, por ejemplo, cada cuántos eventos o acciones
  // se ejecuta una sincronización externa.
  // Es una regla de negocio, no de infraestructura.
  final int syncThreshold;

  // Constructor de la entidad.
  // Usa assert para proteger un invariante del dominio:
  // el umbral de sincronización no puede ser negativo.
  //
  // Se mantiene `const` porque la validación es determinística
  // y no depende de lógica compleja ni de estado externo.
  const AppConfig({
    required this.enablePremium,
    required this.activeCampaign,
    required this.syncThreshold,
  }) : assert(
        syncThreshold >= 0,
        'syncThreshold must be >= 0',
      );

  // Define igualdad por valor.
  // Dos AppConfig son iguales si todas estas propiedades coinciden,
  // independientemente de que sean instancias distintas.
  @override
  List<Object?> get props => [
        enablePremium,
        activeCampaign,
        syncThreshold,
      ];
}



// ✔️ Define **qué existe** (Entities)
// ✔️ Define **qué se puede hacer** (Use Cases)
// ✔️ Define **qué necesita del mundo exterior** (Repositories / Services)
//DEFINE las entidades del dominio (datos necesarios para representar el objeto de negocio), que son las clases que representan los objetos de negocio de la aplicación. Estas clases o reglas del negocio deben ser inmutables y deben implementar la interfaz Equatable para facilitar la comparación de objetos. 
// Las entidades SÍ pueden y DEBEN tener lógica de negocio, pero solo la que protege sus invariantes.
