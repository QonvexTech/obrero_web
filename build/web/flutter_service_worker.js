'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "2f077950b435d3e4f40a3cd4577df698",
"index.html": "63866f1fdc37af257341b3c9b6381def",
"/": "63866f1fdc37af257341b3c9b6381def",
"firebase-messaging-sw.js": "b6508d4755d9b70c807e6880fa09bceb",
"main.dart.js": "09e86c21e0bcf456a0a11978b199002f",
"404.html": "0a27a4163254fc8fce870c8cc3a3f94f",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/favicon-16x16.png": "981e69b806d4709d1504d5d0b46dfeb4",
"icons/favicon.ico": "118931c2e36ce3d63ab0b4c0cdad9808",
"icons/apple-icon.png": "54375171c0f478e593d673654948541d",
"icons/apple-icon-144x144.png": "1d6cc3c35d715036df91f26c03105737",
"icons/android-icon-192x192.png": "6ef1c4ecd519504d94d397104f8df5aa",
"icons/apple-icon-precomposed.png": "54375171c0f478e593d673654948541d",
"icons/apple-icon-114x114.png": "1ee0eabc82db4858b72e9a97e810534d",
"icons/ms-icon-310x310.png": "62dd67ec79c350c7152031abee6320b0",
"icons/ms-icon-144x144.png": "1d6cc3c35d715036df91f26c03105737",
"icons/apple-icon-57x57.png": "1399faecbe28c4ccfe0a939e5332e373",
"icons/apple-icon-152x152.png": "f49db6e4ae120075ef43dac299d76a0e",
"icons/ms-icon-150x150.png": "edfe5b37bb66340889209ae19731066e",
"icons/android-icon-72x72.png": "178fdbb27dd3e44e843bde7dd926f917",
"icons/android-icon-96x96.png": "3d02f3b3868f3b2e95e1f359199d61c9",
"icons/android-icon-36x36.png": "645f03b0dc74d5cb58057de6c25e43c1",
"icons/apple-icon-180x180.png": "6ebfa659a0671d8fea1811251b827a01",
"icons/favicon-96x96.png": "3d02f3b3868f3b2e95e1f359199d61c9",
"icons/manifest.json": "b58fcfa7628c9205cb11a1b2c3e8f99a",
"icons/android-icon-48x48.png": "af9e8dd96674db6e66e2b717f0c5a544",
"icons/apple-icon-76x76.png": "73e1907c0f90cbeb93dfd2bb78e7008f",
"icons/apple-icon-60x60.png": "6c557fc6837c319f9260f5e3c4cbda35",
"icons/browserconfig.xml": "653d077300a12f09a69caeea7a8947f8",
"icons/android-icon-144x144.png": "1d6cc3c35d715036df91f26c03105737",
"icons/apple-icon-72x72.png": "178fdbb27dd3e44e843bde7dd926f917",
"icons/apple-icon-120x120.png": "b2c13d402f06bd32d1f6fc5d08129601",
"icons/favicon-32x32.png": "5fff3f89b44b73fb4176206fd7a533ad",
"icons/ms-icon-70x70.png": "ff4604ea06c6e131bb3af698db3d0eae",
"manifest.json": "d617dbb20fc51ead51cff8bbf13c0dd2",
"assets/AssetManifest.json": "1528ecae6c82be656cd04d388f388f22",
"assets/NOTICES": "331373f9653681ac6d9cad9de3d63d67",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/assets/images/admin.jpg": "de9b37f03f318e679ec4d64e178ec654"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
