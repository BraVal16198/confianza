# ConfianzaMicro - Sistema de Microfinanzas

Una aplicación Flutter para la gestión de microfinanzas, diseñada para asesores financieros.

## Características

- **Autenticación**: Sistema de login con credenciales mock para desarrollo
- **Gestión de Sesiones**: Persistencia de sesión del usuario
- **Navegación**: Sistema de navegación fluido entre pantallas
- **Interfaz Moderna**: Diseño Material Design 3 con animaciones
- **Arquitectura Limpia**: Separación de responsabilidades (UI, Core, Domain)

## Estructura del Proyecto

```
lib/
├── core/
│   ├── router/          # Configuración de navegación
│   └── services/        # Servicios (Auth, Session)
├── domain/
│   └── models/          # Modelos de datos
└── ui/
    └── screens/         # Pantallas de la aplicación
```

## Funcionalidades Implementadas

### ✅ Completadas
- Pantalla de Splash con animación
- Sistema de Login con validación
- Menú principal del asesor
- Gestión de sesiones
- Navegación entre pantallas
- Pantallas stub para futuras funcionalidades

### 🚧 En Desarrollo
- Gestión de Clientes
- Gestión de Tareas
- Portafolio de Clientes
- Sistema de Cobranza
- Gestión de Solicitudes
- Reportes
- Sistema de Visitas
- Configuración

## Credenciales de Prueba

Para probar la aplicación, usa estas credenciales:

| Código | Contraseña | Nombre |
|--------|------------|--------|
| A001   | 1234       | Asesor Confianza |
| A002   | 5678       | María González |

## Instalación y Ejecución

1. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

2. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

3. **Para Android**:
   ```bash
   flutter run -d android
   ```

4. **Para iOS**:
   ```bash
   flutter run -d ios
   ```

## Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo
- **Firebase**: Backend y autenticación
- **Go Router**: Navegación
- **Shared Preferences**: Persistencia local
- **Provider**: Gestión de estado (preparado para futuras implementaciones)

## Arquitectura

La aplicación sigue los principios de **Clean Architecture**:

- **Domain Layer**: Modelos de negocio y reglas
- **Core Layer**: Servicios y configuración
- **UI Layer**: Pantallas y widgets

## Paradigmas de Programación

- **POO**: Clases para modelos, servicios y pantallas
- **Orientado a Eventos**: Gestión de eventos de UI
- **Programación Estructurada**: Validaciones y flujos de control
- **Patrón Singleton**: SessionManager para gestión de sesión

## Próximos Pasos

1. Implementar persistencia local con SQLite/Hive
2. Integrar API REST real
3. Añadir funcionalidades de cámara y geolocalización
4. Implementar notificaciones push
5. Añadir sincronización offline

## Contribución

Este proyecto está en desarrollo activo. Las contribuciones son bienvenidas.

## Licencia

Este proyecto es privado y está destinado para uso educativo.