# Cuentas (PWA con cuentas de usuario)

App de gastos que se instala en el iPhone desde Safari, funciona sin conexión y guarda los datos
de cada persona en su propia cuenta (Supabase).

## Configurar Supabase (una sola vez)

1. **Tabla y seguridad:** Supabase → *SQL Editor* → *New query* → pega todo `supabase/schema.sql` → *Run*.
   Crea la tabla `user_data` con seguridad por filas (cada persona solo ve lo suyo) y sin acceso para `anon`.
2. **Cerrar el registro:** *Authentication* → *Sign In / Providers* → desactiva **"Allow new users to sign up"**.
   Así solo entran las personas que tú crees.
3. **Direcciones:** *Authentication* → *URL Configuration*:
   - Site URL: `https://pepect.github.io/cuentas/`
   - Redirect URLs: `https://pepect.github.io/cuentas/`
4. **Crear a tu familia:** *Authentication* → *Users* → *Add user* → *Create new user*.
   Pon el correo y una contraseña, y marca **Auto Confirm User**. Pásales la contraseña por un canal privado;
   cada persona puede cambiarla con "¿Has olvidado la contraseña?".

## Publicar (GitHub Pages)
Sube el contenido de esta carpeta al repositorio (arrastrando los archivos en la web de GitHub).
Cada vez que cambies archivos, sube también `VERSION` en `sw.js` (p. ej. `cuentas-v3`);
si no, los móviles pueden seguir viendo la copia guardada.

## Instalar en el iPhone
Abre la URL en **Safari** → Compartir → **Añadir a pantalla de inicio**.

## Cómo funcionan los datos
- Todo se guarda primero en el dispositivo y se sube a la nube cuando hay conexión.
- Sin conexión la app sigue funcionando; los cambios quedan pendientes y se suben solos al volver la red.
- Si la misma cuenta se edita en dos dispositivos a la vez, gana el último cambio de cada mes.
- Al **cerrar sesión** se borra la copia local de ese usuario en ese dispositivo.
- **Ajustes → Exportar copia** hace un respaldo en un archivo `.json`.

## Seguridad
- La clave que hay en `index.html` es la pública (`anon`). No es secreta; la protección son las reglas
  de `schema.sql`. **Nunca pongas la clave `service_role` en este proyecto.**
- La política de seguridad del navegador (CSP) solo permite conectar con este servidor y con Supabase.
- La librería de Supabase incluida en `vendor/` (versión fija), sin cargar código de terceros en tiempo de ejecución.
