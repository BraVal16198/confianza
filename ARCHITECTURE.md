# Arquitectura — ConfianzaMicro (móvil)

Demo Flutter centrada en **Android**. Capas:

```
UI (lib/ui) → Core (lib/core) → Domain (lib/domain)
```

| Capa | Responsabilidad |
| --- | --- |
| **UI** | Splash, login, menú, clientes, tareas, portafolio, stubs Material 3 |
| **Core** | GoRouter, `SessionManager`, `AuthService` (mock), `ClientService`, persistencia ligera |
| **Domain** | `Advisor`, `Client`, `Task`, `Visit`, `MenuOption` |

## Flujo

`Splash` → `Login` (`A001`/`1234` o `A002`/`5678`) → `Menú` → módulos operativos (clientes / tareas / portafolio); resto stubs.

Sesión en SharedPreferences. Datos de demo en memoria — sin API remota ni secretos.

## Android

- `minSdk` / `targetSdk` vía Flutter SDK  
- Release de demo firmado con debug keys (CI sube `app-release.apk`)  
- Sin permisos peligrosos en el manifest  

## Preview web (opcional)

El mismo código puede compilares a web (`web/` + workflow Pages). Es un canal secundario de preview; la arquitectura y el README priorizan móvil.
