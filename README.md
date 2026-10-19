# ScamShield

A small Flutter web prototype for learning how to spot scams. It has two short lessons, a simulated inbox, one scripted phone scenario, XP, and local progress. Everything is simulated; the messages contain no live links.

## Run

Install the [Flutter SDK](https://docs.flutter.dev/get-started/install), then run:

```sh
flutter pub get
flutter run -d chrome
```

For a production web bundle:

```sh
flutter build web
```

Progress is stored in the browser with `shared_preferences`. The prototype has no account or backend, so clearing browser site data resets progress.

## Scope

This is a website prototype of the broader ScamShield concept. It is not the complete mobile MVP from the original project plan. The web app demonstrates the main navigation, lesson feedback, message classification, a phone response, and progress tracking. Android and iOS scaffolding can be added later with `flutter create --platforms=android,ios .`.
