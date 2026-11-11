# Arquitectura de ConfianzaMicro

## Capas

```
UI (lib/ui) → Core (lib/core) → Domain (lib/domain)
```

- **UI:** pantallas Material 3 (splash, login, menú, clientes, tareas, portafolio, stubs).
- **Core:** GoRouter, SessionManager, AuthService (mock), ClientService, almacén en memoria.
- **Domain:** Advisor, Client, Task, Visit, MenuOption.

## Flujo

`Splash` → `Login` (A001/1234 o A002/5678) → `Menú` → módulos (clientes/tareas/portafolio operativos; resto stubs).

Sesión en SharedPreferences (web: almacenamiento del navegador). Datos de demo en memoria — sin sqflite ni Firebase en el alcance actual.

## Web / SEO

Plantilla en `web/`: `lang=es`, meta/OG/Twitter, JSON-LD (Organization + WebApplication + FAQ), CSP/referrer meta, `robots.txt`, `sitemap.xml`, `llms.txt`, aviso legal y privacidad. Deploy: workflow → rama `gh-pages`.
