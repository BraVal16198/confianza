# ConfianzaMicro

**App móvil Flutter** (demo de portafolio) para asesores de microfinanzas: login mock, menú operativo, clientes, tareas y portafolio con datos simulados.

> Pieza pensada para revisión de talento en **Android**. No otorga créditos ni procesa pagos reales.

| Recurso | Enlace |
| --- | --- |
| APK (CI) | Actions → workflow **Build Android APK** → artifact `confianza-apk` |
| Preview web (opcional) | https://braval16198.github.io/confianza/ |

## Credenciales demo

| Código | Contraseña | Nombre |
|--------|------------|--------|
| `A001` | `1234` | Asesor Confianza |
| `A002` | `5678` | María González |

## Qué ver en la demo

1. Splash → login con validación  
2. Menú del asesor  
3. **Clientes**: listado, búsqueda, filtros, alta/edición (mock)  
4. **Tareas** y **portafolio** con datos de ejemplo  
5. Stubs explícitos para cobranza, solicitudes, reportes, visitas y ajustes  

## Cómo ejecutar (emulador / dispositivo)

Requisitos: Flutter estable (≥ 3.35), Android SDK, emulador o teléfono con depuración USB.

```bash
flutter pub get
flutter analyze
flutter run -d android          # emulador o device
# o APK local:
flutter build apk --release
# salida: build/app/outputs/flutter-apk/app-release.apk
```

Instalar el APK generado:

```bash
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

### Descargar APK desde GitHub Actions

1. Abre [Actions](https://github.com/BraVal16198/confianza/actions/workflows/android-apk.yml)  
2. Elige el último run exitoso en `main` (o de un PR)  
3. Descarga el artifact **`confianza-apk`** (`app-release.apk`)  

El APK de demo está firmado con **debug keys** (solo portafolio; no Play Store).

## Arquitectura

Capas limpias:

```
lib/ui      → pantallas Material 3
lib/core    → GoRouter, SessionManager, AuthService (mock), ClientService
lib/domain  → Advisor, Client, Task, Visit, MenuOption
```

Detalle: [ARCHITECTURE.md](./ARCHITECTURE.md) · calidad móvil: [docs/mobile-quality-checklist.md](./docs/mobile-quality-checklist.md)

**Stack:** Flutter / Dart · Material 3 · GoRouter · SharedPreferences · Provider (listo para ampliar estado)

## Alcance y límites

- Demo educativa / portafolio — **sin backend**, sin Firebase, sin secretos reales  
- Offline con datos mock; sin permisos peligrosos (cámara, ubicación, etc.)  
- No cumple SBS/PCI ni debe usarse en operación real  

## Preview web (secundario)

Existe un build web y un workflow de GitHub Pages solo como preview del mismo código Flutter. **La entrega principal es la app Android.** Detalles SEO/Pages viven en `web/` y `.github/workflows/github-pages.yml`; no son el foco del portafolio.

## Licencia

Uso educativo / portafolio. Contacto: [issues](https://github.com/BraVal16198/confianza/issues).
