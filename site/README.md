# Static web build (ConfianzaMicro)

Salida Flutter web con `base-href=/` para hosting en raíz (Cursor / Vercel).
CanvasKit se carga desde CDN de Google (`--web-resources-cdn`).

No editar a mano: regenerar con:

```bash
flutter build web --release --base-href / --web-resources-cdn
# copiar build/web → site/ (sin carpeta canvaskit)
```

Para GitHub Pages del repo se usa el workflow (base `/confianza/`), no esta carpeta.
