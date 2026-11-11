# Checklist de calidad móvil — ConfianzaMicro

Lista corta para revisión de talento / QA de la demo Android.

## Permisos

- [x] Sin permisos peligrosos en `AndroidManifest` (no cámara, ubicación, contactos ni micrófono).
- [x] App label legible: `ConfianzaMicro` (no el package scaffold).
- [ ] Si se añaden permisos reales, justificarlos en README y pedirlos en runtime.

## Datos demo / offline

- [x] Auth mock local (`A001`/`1234`, `A002`/`5678`) — sin backend.
- [x] Clientes, tareas y portafolio con datos en memoria / SharedPreferences.
- [x] Funciona sin red tras instalar el APK (demo offline).
- [x] Mensajes de stub claros en módulos aún no implementados.

## Secretos

- [x] Sin API keys, tokens ni Firebase en el repo.
- [x] Firmado release de demo con debug keys (solo portafolio; no Play Store).
- [x] Credenciales de demo documentadas; no son secretos reales.

## Accesibilidad básica

- [x] Labels en campos de login (código / contraseña).
- [x] Contraste Material 3 razonable en tema claro.
- [x] Targets táctiles de botones con padding amplio.
- [ ] Probar TalkBack / semántica en listas de clientes (mejora continua).
- [ ] Revisar tamaños de fuente con escalado del sistema al 150%.

## Build / entrega

- [x] `flutter analyze` limpio (sin errors).
- [x] `flutter build apk --release` vía CI (artifact `confianza-apk`).
- [x] README orientado a móvil (emulador / dispositivo / APK).

## No es producción

- [x] README deja claro: demo educativa, no crédito real ni compliance SBS/PCI.
