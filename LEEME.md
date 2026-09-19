# Cuentas (PWA)

App de gastos que se instala en el iPhone desde Safari y funciona sin conexión.

## Probar en local (Mac)
    cd ~/cuentas-pwa && python3 -m http.server 8000
    # abre http://localhost:8000

## Publicar gratis (GitHub Pages)
1. Crea un repositorio en GitHub y sube el contenido de esta carpeta.
2. Settings → Pages → Deploy from a branch → `main` / root.
3. Tu app quedará en `https://TU-USUARIO.github.io/NOMBRE-REPO/`.
   (Las PWA exigen HTTPS; GitHub Pages ya lo incluye.)

## Instalar en el iPhone
Abre la URL en **Safari** → Compartir → **Añadir a pantalla de inicio**.
(Tiene que ser Safari; desde Chrome en iOS no se instala como app.)

## Actualizar la app
Cambia lo que quieras, sube `VERSION` en `sw.js` (p. ej. `cuentas-v2`) y vuelve a publicar.
Sin subir `VERSION`, los móviles pueden seguir viendo la copia guardada.

## Datos
Ahora se guardan en el propio dispositivo (localStorage). Ajustes → Exportar copia hace un respaldo.
En la Fase 2 pasarán a la nube con inicio de sesión (Supabase).
