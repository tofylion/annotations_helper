'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "version.json": "e2028a48b329c3c115f08dfa74adb469",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/assets/json/e8a35a_01-05-00.json": "4b54a20e0cb730bffa053909c108204e",
"assets/assets/json/e0e547_00-15-00.json": "795b95a8dd9bab57eff224c9b17a0967",
"assets/assets/json/ec7a6a_01-30-00.json": "ee57010598bd39a50d9a3f1bfc6f85da",
"assets/assets/json/ad969d_01-35-00.json": "6ae0b415af40e42487367d7bc0c156ef",
"assets/assets/json/48dcd3_00-15-00.json": "52e308a08f0b77736c9fea11748e9e6f",
"assets/assets/json/48dcd3_00-06-00.json": "28992fa050a525a242a0f110eefb4215",
"assets/assets/json/e0e547_00-50-00.json": "0d3aa1f7d84a216ac28f580ea2f70316",
"assets/assets/json/e8a35a_00-14-00.json": "d987f291c833f15c32cfb470b3a91dda",
"assets/assets/json/ec7a6a_01-19-00.json": "7d0835b5d25324de444a288a65737e8b",
"assets/assets/json/ec7a6a_01-40-00.json": "40702086572ed03eb8a4b8b2db66446a",
"assets/assets/json/e0e547_00-00-00.json": "917d4bb95ae8a6c5cbf0cf20166c5c08",
"assets/assets/json/ad969d_00-15-00.json": "e4c28d8606a635caa3142923b44af8c3",
"assets/assets/json/48dcd3_00-25-00.json": "5608c7aab6981b9fc5ec2f0f364f5d3e",
"assets/assets/json/48dcd3_01-05-00.json": "c7597204a5b69ce00cffbbf87ad723bf",
"assets/assets/json/ec7a6a_00-53-00.json": "3f0057eed3080c056e1d0b5c1a78da7c",
"assets/assets/json/e8a35a_00-07-00.json": "6152619d64ee98b610975fbfccc93f2a",
"assets/assets/json/48dcd3_01-10-00.json": "2dce0584e73f81bc4e54f6e1d6c5de3a",
"assets/assets/json/ad969d_01-11-00.json": "d784f4665fa9893dac138af2142abcb8",
"assets/assets/json/ec7a6a_00-30-00.json": "5090725b5410d5be5d518cdc783481b1",
"assets/assets/json/ad969d_00-43-00.json": "57a0887f2a9f04979157867e6dfaab33",
"assets/assets/json/ad969d_00-00-30.json": "d2721fc87c1992cae1bd2c774c302105",
"assets/assets/json/e8a35a_01-14-00.json": "303ddf9a702d476f7dd24d7d0ddbe5a4",
"assets/assets/json/e8a35a_00-02-00.json": "b2cae7790bcf9d3d5a6db8c245e7c707",
"assets/assets/json/e0e547_01-00-00.json": "a9761c40ca191d18230a05d8d8cdc041",
"assets/assets/json/e0e547_00-08-00.json": "691f93ddd969c78bb17393c4a7b96842",
"assets/NOTICES": "c201f7397c7118a61fc214278e1d388b",
"assets/AssetManifest.json": "32e012972d117fef7780814b24892fd9",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/youtube_player_iframe/assets/player.html": "dc7a0426386dc6fd0e4187079900aea8",
"main.dart.js": "d03bcbbd819c614c5cceefc4d86a188f",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"manifest.json": "0dd80bb00e2039316fd1e544a7fef69e",
"index.html": "303703c426f0a5fd1e30a519d5873a92",
"/": "303703c426f0a5fd1e30a519d5873a92",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
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
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
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
