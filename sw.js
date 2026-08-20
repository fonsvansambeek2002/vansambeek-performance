const CACHE_NAME = 'vsp-portal-v20';
const PRECACHE_URLS = [
  '/',
  'index.html',
  'login.html',
  'portal.html',
  'offline.html',
  'manifest.json',
  'assets/app.css',
  'assets/supabase-config.js',
  'assets/logo.png',
  'assets/fons.jpg',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(PRECACHE_URLS))
  );
  self.skipWaiting();
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((key) => key !== CACHE_NAME).map((key) => caches.delete(key)))
    )
  );
  self.clients.claim();
});

// Treat HTML/navigation and core scripts as always-fresh: network-first,
// falling back to cache only when offline. This prevents the app from
// serving a stale portal.html after a new deploy.
function isFreshFirst(request, url) {
  if (request.mode === 'navigate') return true;
  return /\.(html)$/.test(url.pathname) || url.pathname.endsWith('/');
}

self.addEventListener('fetch', (event) => {
  const { request } = event;
  if (request.method !== 'GET') return;

  const url = new URL(request.url);
  if (url.hostname.includes('supabase.co') || url.hostname.includes('googleapis.com') || url.hostname.includes('gstatic.com')) return;

  // Network-first for HTML so users always get the latest version online.
  if (isFreshFirst(request, url)) {
    event.respondWith(
      fetch(request)
        .then((response) => {
          if (response.ok) {
            const clone = response.clone();
            caches.open(CACHE_NAME).then((cache) => cache.put(request, clone));
          }
          return response;
        })
        .catch(() => caches.match(request).then((cached) => cached || caches.match('offline.html')))
    );
    return;
  }

  // Cache-first with background refresh for static assets.
  event.respondWith(
    caches.match(request).then((cached) => {
      const network = fetch(request)
        .then((response) => {
          if (response.ok) {
            const clone = response.clone();
            caches.open(CACHE_NAME).then((cache) => cache.put(request, clone));
          }
          return response;
        })
        .catch(() => cached || caches.match('offline.html'));
      return cached || network;
    })
  );
});
