# ScamShield

A small Flutter web prototype for learning how to spot scams. It has two short lessons, a text-message phone preview, a simulated email inbox, one scripted phone scenario, XP, and local progress. Everything is simulated; the messages contain no live links.

Open **Practice → Text imitation** to view fictional texts in a phone interface. Choose **This is a scam** or **This looks safe** to get immediate feedback, then use **Send next text** to try another. Your reviewed and correct counts, plus any XP earned, appear on the Home scoreboard and persist in this browser. This is a UI draft: replies and real SMS delivery are not connected.

The home banner uses sprites from [Kenney's Pixel Platformer pack](https://kenney.nl/assets/pixel-platformer), licensed under [CC0](assets/art/kenney_pixel_platformer/LICENSE.txt). The phone and shield logo is drawn in Flutter, with a matching SVG favicon. The bundled Silkscreen font is licensed under the [SIL Open Font License](assets/fonts/OFL.txt).

## Run

Install the [Flutter SDK](https://docs.flutter.dev/get-started/install), then run:

```sh
flutter pub get
flutter run -d web-server
```

Open the local URL printed by Flutter in your browser.

For a production web bundle:

```sh
flutter build web
```

Progress is stored in the browser with `shared_preferences`. The prototype has no account or backend, so clearing browser site data resets progress.

## Scope

This is a website prototype of the broader ScamShield concept. It is not the complete mobile MVP from the original project plan. The web app demonstrates the main navigation, lesson feedback, message classification, a phone response, and progress tracking. Android and iOS scaffolding can be added later with `flutter create --platforms=android,ios .`.
