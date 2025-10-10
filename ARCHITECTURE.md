# Arquitectura de ConfianzaMicro

## Diagrama de Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                        UI Layer                             │
├─────────────────────────────────────────────────────────────┤
│  SplashScreen  │  LoginScreen  │  MenuScreen  │  Other...   │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                     Core Layer                              │
├─────────────────────────────────────────────────────────────┤
│  AppRouter  │  SessionManager  │  AuthService  │  Services  │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                    Domain Layer                             │
├─────────────────────────────────────────────────────────────┤
│  Advisor  │  Client  │  Task  │  Visit  │  MenuOption      │
└─────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────┐
│                  External Services                          │
├─────────────────────────────────────────────────────────────┤
│  Firebase Auth  │  Firestore  │  SharedPreferences         │
└─────────────────────────────────────────────────────────────┘
```

## Flujo de Navegación

```
SplashScreen (2s) → LoginScreen → MenuScreen
                                      │
                                      ▼
                    ┌─────────────────────────────────┐
                    │         Menu Options            │
                    ├─────────────────────────────────┤
                    │ Portfolio │ Clients │ Tasks     │
                    │ Collections │ Requests │ Reports │
                    │ Visits │ Settings               │
                    └─────────────────────────────────┘
```

## Patrones de Diseño Implementados

### 1. Singleton Pattern
- **SessionManager**: Garantiza una única instancia para gestión de sesión
- **AuthService**: Servicio centralizado de autenticación

### 2. Repository Pattern (Preparado)
- **AuthRepository**: Abstracción para operaciones de autenticación
- **ClientRepository**: Preparado para gestión de clientes
- **TaskRepository**: Preparado para gestión de tareas

### 3. Observer Pattern
- **GoRouter**: Sistema de navegación reactivo
- **Streams**: Para cambios de estado de autenticación

### 4. Factory Pattern
- **Modelos**: Métodos `fromMap()` para creación desde datos
- **MenuOptions**: Creación de opciones de menú

## Responsabilidades por Capa

### UI Layer (`lib/ui/`)
- **Pantallas**: Gestión de interfaz de usuario
- **Widgets**: Componentes reutilizables
- **Navegación**: Flujo entre pantallas

### Core Layer (`lib/core/`)
- **Router**: Configuración de rutas
- **Services**: Lógica de negocio y servicios
- **Constants**: Configuraciones globales

### Domain Layer (`lib/domain/`)
- **Models**: Entidades de negocio
- **Use Cases**: Reglas de negocio (futuro)
- **Interfaces**: Contratos de servicios (futuro)

## Flujo de Autenticación

```
1. Usuario ingresa credenciales
2. AuthService valida (mock o Firebase)
3. SessionManager guarda sesión
4. Navegación a MenuScreen
5. Persistencia en SharedPreferences
```

## Gestión de Estado

### Actual (Simple)
- **SessionManager**: Estado global de sesión
- **Local State**: setState en widgets

### Futuro (Provider/Riverpod)
- **AuthProvider**: Estado de autenticación
- **ClientProvider**: Estado de clientes
- **TaskProvider**: Estado de tareas

## Persistencia de Datos

### Local
- **SharedPreferences**: Configuración y sesión
- **SQLite/Hive**: Datos offline (futuro)

### Remoto
- **Firebase Auth**: Autenticación
- **Firestore**: Base de datos en la nube
- **REST API**: Servicios externos (futuro)

## Seguridad

### Implementado
- **Validación local**: Campos requeridos
- **Persistencia segura**: SharedPreferences
- **Navegación protegida**: Verificación de sesión

### Futuro
- **JWT Tokens**: Autenticación segura
- **Encriptación**: Datos sensibles
- **Biometría**: Autenticación biométrica

## Escalabilidad

### Preparado para
- **Módulos**: Separación por funcionalidad
- **Testing**: Estructura testable
- **CI/CD**: Configuración para automatización
- **Multiplataforma**: iOS, Web, Desktop

## Métricas y Monitoreo

### Futuro
- **Analytics**: Firebase Analytics
- **Crashlytics**: Reportes de errores
- **Performance**: Monitoreo de rendimiento
- **Logs**: Sistema de logging

## Consideraciones de Performance

### Implementado
- **Lazy Loading**: Carga bajo demanda
- **Image Optimization**: Optimización de imágenes
- **Memory Management**: Gestión eficiente de memoria

### Futuro
- **Caching**: Cache inteligente
- **Pagination**: Paginación de listas
- **Background Sync**: Sincronización en segundo plano

