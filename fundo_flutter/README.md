# Fundo Flutter (jobdesk-6)

Flutter + Firebase app that mirrors the Fundo mobile features, including Google Maps powered location capture for transactions.

## Prerequisites

- Flutter 3.24.x SDK
- A Firebase project configured with Auth, Firestore, and Storage (see `FIREBASE_AUTH_SETUP.md`)
- A Google Maps / Places API key with Maps JavaScript, Places, and Geolocation APIs enabled

## Environment setup

1. Install dependencies

   ```bash
   flutter pub get
   ```

2. Copy the Maps env template and add your API key (never commit the real key):

   ```bash
   copy env\maps.env.example env\maps.env  # Windows
   # or: cp env/maps.env.example env/maps.env
   ```

   ```env
   GOOGLE_MAPS_API_KEY=your_real_key_here
   ```

3. Configure Firebase per `FIREBASE_AUTH_SETUP.md` if you have not already.

## Running the app

Use `--dart-define` (or the handy file variant) so the key reaches runtime:

```bash
flutter run -d chrome --dart-define-from-file=env/maps.env
# or, for any target
flutter run --dart-define=GOOGLE_MAPS_API_KEY=your_real_key_here
```

Tips:

- Chrome usually blocks geolocation on `http://localhost`; allow the permission prompt and prefer `https://` (Flutter automatically serves over HTTPS when possible).
- For Android/iOS, also add the same key to the respective platform configs if you use native Google Maps SDKs.

## Testing

```bash
flutter test
```

## Helpful docs

- [Flutter Google Maps setup guide](https://docs.flutter.dev/ui/widgets/google-maps)
- [Google Maps API key best practices](https://developers.google.com/maps/api-key-best-practices)
