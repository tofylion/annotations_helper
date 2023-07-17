'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"index.html": "4af59b4d8e45d1b3cd016c9600af6307",
"/": "4af59b4d8e45d1b3cd016c9600af6307",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"main.dart.js": "fea83ec8a8e9f12704777fa5c887a01e",
"version.json": "e2028a48b329c3c115f08dfa74adb469",
"canvaskit/chromium/canvaskit.js": "8c8392ce4a4364cbb240aa09b5652e05",
"canvaskit/chromium/canvaskit.wasm": "fc18c3010856029414b70cae1afc5cd9",
"canvaskit/skwasm.worker.js": "19659053a277272607529ef87acf9d8a",
"canvaskit/canvaskit.js": "76f7d822f42397160c5dfc69cbc9b2de",
"canvaskit/skwasm.wasm": "6711032e17bf49924b2b001cef0d3ea3",
"canvaskit/skwasm.js": "1df4d741f441fa1a4d10530ced463ef8",
"canvaskit/canvaskit.wasm": "f48eaf57cada79163ec6dec7929486ea",
"manifest.json": "0dd80bb00e2039316fd1e544a7fef69e",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/fonts/MaterialIcons-Regular.otf": "62ec8220af1fb03e1c20cfa38781e17e",
"assets/AssetManifest.bin": "2a6111c94763c16f7709e4beb1ddc6af",
"assets/AssetManifest.json": "c3777f272764b86df2daf030f5e9d32f",
"assets/NOTICES": "ce6597cdd95764b383c41564a93a56bc",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "57d849d738900cfd590e9adc7e208250",
"assets/packages/youtube_player_iframe/assets/player.html": "dc7a0426386dc6fd0e4187079900aea8",
"assets/assets/metadata/48dcd3_00-06-00.json": "28992fa050a525a242a0f110eefb4215",
"assets/assets/metadata/ad969d_00-00-30.json": "d2721fc87c1992cae1bd2c774c302105",
"assets/assets/metadata/ec7a6a_01-40-00.json": "40702086572ed03eb8a4b8b2db66446a",
"assets/assets/metadata/e8a35a_00-07-00.json": "6152619d64ee98b610975fbfccc93f2a",
"assets/assets/metadata/e0e547_01-00-00.json": "a9761c40ca191d18230a05d8d8cdc041",
"assets/assets/metadata/ad969d_01-35-00.json": "6ae0b415af40e42487367d7bc0c156ef",
"assets/assets/metadata/e8a35a_01-05-00.json": "4b54a20e0cb730bffa053909c108204e",
"assets/assets/metadata/e8a35a_00-02-00.json": "b2cae7790bcf9d3d5a6db8c245e7c707",
"assets/assets/metadata/ec7a6a_00-30-00.json": "5090725b5410d5be5d518cdc783481b1",
"assets/assets/metadata/ec7a6a_01-30-00.json": "ee57010598bd39a50d9a3f1bfc6f85da",
"assets/assets/metadata/48dcd3_01-05-00.json": "c7597204a5b69ce00cffbbf87ad723bf",
"assets/assets/metadata/e0e547_00-50-00.json": "0d3aa1f7d84a216ac28f580ea2f70316",
"assets/assets/metadata/48dcd3_00-25-00.json": "5608c7aab6981b9fc5ec2f0f364f5d3e",
"assets/assets/metadata/ad969d_01-11-00.json": "d784f4665fa9893dac138af2142abcb8",
"assets/assets/metadata/e0e547_00-08-00.json": "691f93ddd969c78bb17393c4a7b96842",
"assets/assets/metadata/e8a35a_00-14-00.json": "d987f291c833f15c32cfb470b3a91dda",
"assets/assets/metadata/ec7a6a_00-53-00.json": "3f0057eed3080c056e1d0b5c1a78da7c",
"assets/assets/metadata/ad969d_00-15-00.json": "e4c28d8606a635caa3142923b44af8c3",
"assets/assets/metadata/e0e547_00-00-00.json": "917d4bb95ae8a6c5cbf0cf20166c5c08",
"assets/assets/metadata/e0e547_00-15-00.json": "795b95a8dd9bab57eff224c9b17a0967",
"assets/assets/metadata/ad969d_00-43-00.json": "57a0887f2a9f04979157867e6dfaab33",
"assets/assets/metadata/48dcd3_00-15-00.json": "52e308a08f0b77736c9fea11748e9e6f",
"assets/assets/metadata/e8a35a_01-14-00.json": "303ddf9a702d476f7dd24d7d0ddbe5a4",
"assets/assets/metadata/ec7a6a_01-19-00.json": "7d0835b5d25324de444a288a65737e8b",
"assets/assets/metadata/48dcd3_01-10-00.json": "2dce0584e73f81bc4e54f6e1d6c5de3a",
"assets/assets/video_ids/youtube_ids.json": "006e52ce8d192de6b513a64fb67997b9",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
