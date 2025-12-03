import 'dart:async';
import 'dart:html' as html;

Future<void> ensureGoogleMapsScriptLoaded(String apiKey) async {
  if (apiKey.isEmpty) {
    throw StateError('Missing Google Maps API key for web runtime');
  }

  final alreadyLoaded = html.document
      .querySelectorAll('script')
      .whereType<html.ScriptElement>()
      .any(_isGoogleMapsScript);
  if (alreadyLoaded) {
    return;
  }

  final completer = Completer<void>();
  final script = html.ScriptElement()
    ..src =
        'https://maps.googleapis.com/maps/api/js?key=$apiKey&libraries=places'
    ..defer = true
    ..async = true;

  script.onError.first.then((event) {
    completer.completeError(
      StateError('Failed to load Google Maps script: $event'),
    );
  });
  script.onLoad.first.then((_) => completer.complete());
  html.document.head?.append(script);
  return completer.future;
}

bool _isGoogleMapsScript(html.ScriptElement element) {
  final src = element.src;
  return src.contains('maps.googleapis.com/maps/api/js');
}
