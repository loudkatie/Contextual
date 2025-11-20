# Contextual — The Soul Seed

> *Not an app. A presence.*

An ambient intelligence that walks with you, senses hidden layers in the world, and whispers only when the moment is right.

---

## 🌬️ Interactive Demo (NEW!)

**For Friday's team meeting**, we've created a high-fidelity interactive prototype that shows the **magic and feeling** of Contextual:

👉 **[Start here: `/demo`](./demo/)**

- Breathing soul seed visual (alive, ethereal, sparkling)
- Proactive ASMR voice whispers
- Three-part interaction (tap → glance → whisper)
- Soul-speed permission flow
- Complete ~3.5 minute experience

**To run:**
```bash
cd demo
python3 -m http.server 8000
# Then add to iPhone home screen for full effect
```

See [`demo/README.md`](./demo/README.md) for full instructions.

---

## iOS App

This directory also contains the SwiftUI implementation of the native iOS experience.
It is lightweight, modular, and designed so that engineers can iterate quickly on sensors, inference,
and the Whisper Engine.

The project uses:
- SwiftUI  
- Combine  
- CoreLocation  
- CoreMotion  
- AVFoundation (for audio)  
- XcodeGen (optional, if editing `project.yml`)  

The committed `.xcodeproj` allows opening the project immediately after cloning.

---

## Folder Structure

```
/Sources
    /App            — App entry point, environment setup
    /Views          — SwiftUI screens for shell UI
    /Services       — Sensor layer, whisper engine, data stores
    /Models         — Shared model types

/Resources
    /Assets         — Icons, colors, images (if any)
    /Sounds         — Whisper audio snippets (future)
```

All business logic lives in `Services/`.  
UI is intentionally thin — the real product is **audio-first**.

---

## App Entry (High-Level)

The app uses a small SwiftUI shell:

- A minimal screen  
- Background runtime enabled  
- Audio + location permissions requested gracefully  
- Whisper Engine initialized on startup  

Users should be able to:
- grant permissions  
- see that Contextual is running  
- optionally view a simple activity log or status screen  

---

## Running the App

### 1. Open the Project
```
open ios/ContextualApp/Contextual.xcodeproj
```

### 2. Select a device
Choose **Any iOS Device (arm64)** or a real device.

### 3. Run on device
The app requires:
- location permission  
- motion permission  
- notification permission (optional, for fallback)  

### 4. AirPods strongly recommended
The app is tuned for audio whisper output.

---

## Development Notes

### SwiftUI Philosophy
- Do not build heavy screens  
- Keep UI modular and declarative  
- Views should reflect app state, not drive it  

### Background Modes
Enabled in the target:
- Location updates  
- Audio playback  
- Background fetch  

### Feature Flags
Add temporary toggles in `App/AppConfig.swift` for:
- debugging sensors  
- mocking gates  
- forcing whisper triggers  

---

## Building With XcodeGen (optional)

If editing `project.yml`:

```
brew install xcodegen
cd ios/ContextualApp
xcodegen generate
```

The committed `.xcodeproj` will update accordingly.

---

## Roadmap (iOS-specific)

- background speech pipeline  
- real-time LLM micro-inference  
- dynamic geogate graph  
- local embeddings  
- whisper caching  
- partner API ingestion  

---

## 📚 Documentation

Complete product planning and specifications:

- **[Soul Seed Specification](./docs/product/soul-seed-specification.md)** — Complete design, technical architecture, and implementation plan
- **[Team Alignment Deck](./docs/presentations/team-alignment-nov-2025.md)** — Friday Nov 22 meeting slides
- **[Product Pitch Deck](./docs/presentations/product-pitch.md)** — Investor/demo presentation
- **[Visual Identity Guide](./docs/design/visual-identity.md)** — Design system and asset specifications
- **[Architecture](./docs/technical/architecture.md)** — System architecture overview

See [`/docs`](./docs/) for full documentation.

---

This is the foundation of the **ambient iOS experience** for Contextual.

*Let's ship soul seeds.* ✨🌬️
