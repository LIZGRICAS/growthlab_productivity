// Define los casos de uso relacionados con permisos, como solicitar permisos de cámara o ubicación. Estos casos de uso interactúan con el servicio de permisos para realizar las solicitudes necesarias y devolver el resultado al dominio o a la capa de presentación.
//El dominio sí puede depender de servicios abstractos, Solicitar permisos es una acción de negocio, Aunque se ejecuta en plataforma, la decisión vive en dominio.
import '../../platform/permission_service.dart';


class RequestPermissionUseCase {
  final PermissionService _service;
  RequestPermissionUseCase(this._service);

  Future<bool> requestCamera() => _service.requestCameraPermission();
  Future<bool> requestLocation() => _service.requestLocationPermission();
}

//UI → Bloc → RequestPermissionUseCase → PermissionService → Platform
//Dominio decide qué permiso pedir y delega al servicio de permisos para que lo ejecute. El dominio no sabe nada de la plataforma, solo sabe que tiene un servicio de permisos que le permite solicitar permisos. El dominio no tiene lógica de negocio, solo coordina la llamada al servicio de permisos. El dominio no sabe nada de la plataforma, solo sabe que tiene un servicio de permisos que le permite solicitar permisos.
//Plataforma decide cómo pedirlo