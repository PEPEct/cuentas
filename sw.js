/* Service worker de Cuentas: la app funciona sin conexión.
   Sube VERSION cada vez que cambies archivos de la app para que los móviles se actualicen. */
const VERSION = "cuentas-v3";
const SHELL = [
  "./",
  "index.html",
  "vendor/supabase-2.116.0.js",
  "manifest.webmanifest",
  "icons/icon-192.png",
  "icons/icon-512.png",
  "icons/apple-touch-icon.png",
  "fonts/bricolage-latin.woff2",
  "fonts/bricolage-latin-ext.woff2",
  "fonts/instrument-latin.woff2",
  "fonts/instrument-latin-ext.woff2"
];

self.addEventListener("install", e => {
  // cache:"reload" evita que el navegador nos dé copias antiguas de su propia caché HTTP
  e.waitUntil(
    caches.open(VERSION)
      .then(c => c.addAll(SHELL.map(u => new Request(u, {cache: "reload"}))))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", e => {
  e.waitUntil(
    caches.keys()
      .then(keys => Promise.all(keys.filter(k => k !== VERSION).map(k => caches.delete(k))))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", e => {
  const req = e.request;
  if (req.method !== "GET") return;
  const url = new URL(req.url);
  // Solo gestionamos archivos propios; las llamadas a otros servidores (p. ej. la base de datos) pasan directas.
  if (url.origin !== self.location.origin) return;

  // Páginas: primero la red (para recibir actualizaciones) y, sin conexión, la copia guardada.
  if (req.mode === "navigate") {
    e.respondWith(
      fetch(req, {cache: "no-cache"})
        .then(res => { const copy = res.clone(); caches.open(VERSION).then(c => c.put("index.html", copy)); return res; })
        .catch(() => caches.match("index.html"))
    );
    return;
  }

  // Resto de archivos: primero la copia guardada.
  e.respondWith(
    caches.match(req).then(hit => hit || fetch(req).then(res => {
      const copy = res.clone();
      caches.open(VERSION).then(c => c.put(req, copy));
      return res;
    }))
  );
});
