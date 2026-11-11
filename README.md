# ConfianzaMicro

Demo de portafolio: aplicación **Flutter** para asesores de microfinanzas (login mock, clientes, tareas y menú operativo). Datos simulados — no otorga créditos ni procesa pagos reales.

**Demo en vivo (HTTPS):** https://braval16198.github.io/confianza/

> La demo corre en el navegador. No hace falta clonar el repo ni tener cuenta de GitHub para usarla. GitHub Pages es solo el hosting estático.

## Credenciales demo

| Código | Contraseña | Nombre |
|--------|------------|--------|
| `A001` | `1234` | Asesor Confianza |
| `A002` | `5678` | María González |

## Stack

- Flutter 3.9+ / Dart (Material 3)
- GoRouter (navegación)
- Provider (estado, preparado)
- SharedPreferences (sesión)
- Almacén en memoria para la demo web (sin sqflite en browser)

Arquitectura por capas: `lib/ui` · `lib/core` · `lib/domain`. Detalle en [ARCHITECTURE.md](./ARCHITECTURE.md).

## Qué hace la demo

- Splash → login con validación → menú del asesor
- Clientes: listado, búsqueda, filtros, alta/edición (mock)
- Tareas: pendientes/completadas con datos de ejemplo
- Portafolio y pantalla de info del almacén
- Stubs claros para cobranza, solicitudes, reportes, visitas y ajustes

## Desarrollo local

```bash
flutter pub get
flutter run -d chrome          # web
flutter run                    # dispositivo/emulador
flutter build web --release --base-href /confianza/
```

Requisitos: [Flutter SDK](https://docs.flutter.dev/get-started/install) estable.

## Despliegue

### GitHub Pages (preferido)

El workflow [`.github/workflows/github-pages.yml`](./.github/workflows/github-pages.yml) construye Flutter web y publica en la rama `gh-pages`.

URL esperada: `https://braval16198.github.io/confianza/`

Si Pages aún no está activo (Actions suele devolver 403 al crearlo): el owner debe hacerlo **una vez** en  
**Settings → Pages → Build and deployment → Source: Deploy from a branch → Branch: `gh-pages` / `/ (root)` → Save**.  
La rama `gh-pages` ya tiene el build; tras Save la URL queda en vivo.

### Vercel (alternativa)

1. Importa el repo en [Vercel](https://vercel.com/).
2. Framework preset: Other.
3. Build command: `flutter pub get && flutter build web --release --base-href /`
4. Output directory: `build/web`
5. Necesitas una imagen con Flutter en el build, o un Dockerfile; `vercel.json` aporta cabeceras de seguridad cuando el host lo permite.

Para base en raíz (`/`), actualiza canonical/OG/sitemap al dominio de Vercel.

## SEO / seguridad / a11y (AuditarWeb)

Incluido en `web/`:

- `lang="es"`, title, description, canonical
- Open Graph + Twitter Card + JSON-LD
- Favicon / PWA icons / `manifest.json`
- `robots.txt`, `sitemap.xml`, `.well-known/security.txt`
- Meta CSP + `referrer=strict-origin-when-cross-origin`
- Bloque HTML crawler-visible (≥250 palabras, H1) para el SPA
- Skip link básico; labels en el formulario de login

Límites de GitHub Pages: no aplica cabeceras HTTP custom (`X-Frame-Options`, CSP por header). Mitigación parcial vía meta; cabeceras completas en `vercel.json`.

## Alcance

Proyecto educativo / revisión de talento. No cumple SBS/PCI ni debe usarse en operación real.

## Licencia

Uso educativo / portafolio. Ver issues del repo para contacto.
