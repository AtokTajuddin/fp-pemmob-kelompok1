import 'google_maps_script_loader_stub.dart'
    if (dart.library.html) 'google_maps_script_loader_web.dart'
    as loader;

Future<void> ensureGoogleMapsScriptLoaded(String apiKey) {
  return loader.ensureGoogleMapsScriptLoaded(apiKey);
}
