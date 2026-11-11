# ConfianzaMicro

Demo de portafolio: aplicación **Flutter** para asesores de microfinanzas (login mock, clientes, tareas y menú operativo). Datos simulados — no otorga créditos ni procesa pagos reales.

**Demo en vivo:** https://braval16198.github.io/confianza/

> Corre en el navegador. No hace falta clonar el repo ni tener cuenta de GitHub para usarla.

## Credenciales demo

| Código | Contraseña | Nombre |
|--------|------------|--------|
| `A001` | `1234` | Asesor Confianza |
| `A002` | `5678` | María González |

## Stack

- Flutter 3.35 / Dart (Material 3)
- GoRouter · SharedPreferences · almacén en memoria (web)
- Capas: `lib/ui` · `lib/core` · `lib/domain` — detalle en [ARCHITECTURE.md](./ARCHITECTURE.md)

## Qué hace la demo

- Splash → login con validación → menú del asesor
- Clientes: listado, búsqueda, filtros, alta/edición (mock)
- Tareas y portafolio con datos de ejemplo
- Stubs claros para cobranza, solicitudes, reportes, visitas y ajustes

## Desarrollo local

```bash
flutter pub get
flutter run -d chrome
flutter build web --release --base-href /confianza/ --web-resources-cdn
```

## Despliegue

Push a `main` dispara [Deploy GitHub Pages](./.github/workflows/github-pages.yml) → rama `gh-pages` → https://braval16198.github.io/confianza/

Alternativa Vercel: build `flutter build web --release --base-href /`, output `build/web`; cabeceras en `vercel.json`.

## SEO / seguridad / a11y (AuditarWeb)

En `web/`:

- `lang="es"`, title, description, canonical, H1 + texto crawler (≥250 palabras)
- Open Graph + Twitter Card (+ alt/dimensiones de imagen)
- JSON-LD: Organization, WebSite, WebApplication, FAQPage
- `robots.txt` (bots IA permitidos), `sitemap.xml`, `llms.txt`
- Aviso legal y privacidad (sin analítica → sin banner de cookies)
- Meta CSP, referrer, Permissions-Policy; favicon / PWA / `security.txt`
- Skip link; labels y tooltips en login

Límite de GitHub Pages: no aplica cabeceras HTTP custom; HSTS sí viene del host. Meta mitiga; cabeceras completas en `vercel.json`.

## Alcance

Proyecto educativo / revisión de talento. No cumple SBS/PCI ni debe usarse en operación real.

## Licencia

Uso educativo / portafolio. Contacto: [issues](https://github.com/BraVal16198/confianza/issues).
