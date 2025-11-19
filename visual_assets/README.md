# Contextual Visual Assets Package

Complete visual asset collection for the Contextual pitch presentation.

## 🎨 Design DNA

**Style:** Ethereal, iridescent, fairy-wing aesthetic
**Feel:** Matte luminosity (not glossy), translucent, delicate, alive

### Color Palette

| Color Name | Hex Code | Usage |
|------------|----------|-------|
| Pure White | `#FFFFFF` | Foundation, backgrounds |
| Silver Shimmer | `#E8E8F0` | Sparkles, accents |
| Pale Lavender | `#E6E6FA` | Primary accent, UI elements |
| Powder Periwinkle | `#E0F4FF` | Gradients, glows |
| Ghost White | `#F8F8FF` | Subtle backgrounds |

**Forbidden Colors:** NO black, NO pink, NO gold

---

## 📁 Asset Files

### 1. **soulseed_main.png** (1200x1200px)
![Soul Seed Main Visual]
- **Purpose:** Hero image of the soul seed orb
- **Features:**
  - Central glowing orb with white-to-lavender gradient
  - Silver sparkle particles drifting upward
  - Subtle breathing/glow pulse effect
  - Matte finish, ethereal appearance
- **Use Case:** Main product visual, presentation opener, website hero

---

### 2. **color_palette.png** (1920x400px)
![Color Palette Board]
- **Purpose:** Official brand color reference
- **Features:**
  - 5 color swatches displayed horizontally
  - Each swatch labeled with name and hex code
  - Clean, minimal layout on white background
- **Use Case:** Brand guidelines, design reference, pitch deck color slide

---

### 3. **interaction_flow.png** (1920x600px)
![Interaction Flow Diagram]
- **Purpose:** Show the three-step interaction pattern
- **Features:**
  - **Stage 1 - Watch (Haptic):** "tap tap" notification
  - **Stage 2 - Watch (Glance):** Mini soul seed + message preview
  - **Stage 3 - AirPods (Whisper):** Voice response delivery
  - Arrows showing flow progression
- **Use Case:** User journey explanation, interaction design slides

---

### 4. **watch_mockup.png** (800x800px)
![Apple Watch UI Mockup]
- **Purpose:** Watch interface demonstration
- **Features:**
  - Apple Watch square screen with black bezel
  - Mini soul seed at top center
  - Message text: "Katie, I found something for you. Now?"
  - Two buttons: "Yes" and "Later" (lavender tint)
- **Use Case:** Hardware integration demo, UI design showcase

---

### 5. **iphone_mockup.png** (800x1600px)
![iPhone Passive State]
- **Purpose:** Show ambient companion state on iPhone
- **Features:**
  - iPhone frame outline
  - Full white screen with large centered soul seed
  - Breathing/glowing effect
  - No UI chrome - pure ambient experience
  - Silver sparkles surrounding the seed
- **Use Case:** Passive state demo, ambient UI concept

---

### 6. **sparkle_comparison.png** (1920x600px)
![Sparkle Trail States]
- **Purpose:** Show emotional states through sparkle patterns
- **Features:**
  - **Calm:** Lazy upward spiraling sparkles
  - **Excited:** Faster swirling sparkles
  - **Passionate:** Tight whirling sparkler effect
  - All silver sparkles with slight lavender edges
- **Use Case:** Personality expression, visual language explanation

---

### 7. **ftue_visual.png** (800x1400px)
![First Time User Experience]
- **Purpose:** Onboarding journey visualization
- **Features:**
  - Vertical timeline with 4 stages
  - **Awakening:** Single bright point appears
  - **Breathing:** Orb begins to pulse gently
  - **Permissions:** Location, Motion, Calendar checkmarks
  - **Promise:** Calm breathing orb (ready state)
  - Minimal connecting lines in lavender
- **Use Case:** Onboarding flow, FTUE presentation

---

### 8. **magic_types.png** (1920x600px)
![Three Magic Types]
- **Purpose:** Explain the three categories of contextual moments
- **Features:**
  - **Memories:** Layered ghost images icon - "Timely recalls of past moments"
  - **Perks:** Star/sparkle icon - "Unexpected delights and discoveries"
  - **Time:** Clock icon - "Perfect moment awareness"
  - Icons in silver/lavender gradient
- **Use Case:** Feature categorization, value proposition

---

### 9. **architecture.png** (1920x1080px)
![Architecture Diagram]
- **Purpose:** Technical system overview
- **Features:**
  - Clean 4-layer system diagram
  - **Layer 1:** iOS App (iPhone + Apple Watch)
  - **Layer 2:** Core Services (Location, Motion, Calendar, Health, Contacts)
  - **Layer 3:** AI Soul Layer (Context Engine, ChatGPT API, Memory Store)
  - **Layer 4:** Backend (Database, APIs, Cloud Sync)
  - Simple boxes with connecting arrows
  - Lavender accents, thin lines
- **Use Case:** Technical architecture slide, investor deck

---

### 10. **mood_board.png** (1920x1080px)
![Mood Board Layout]
- **Purpose:** Visual reference guide for design aesthetic
- **Features:**
  - 3×3 grid layout with reference concepts
  - Includes placeholders for:
    - Fairy wings (translucent, delicate)
    - Dragonfly wing iridescence
    - Silver shimmer effects
    - Soft white clouds
    - Moonlight through silk
    - Butterfly wing scales
    - Dandelion seed with backlight
    - Vellum/rice paper texture
    - Northern lights (purple/blue only)
- **Use Case:** Design inspiration, aesthetic direction, team alignment

---

## 🎯 Usage Guidelines

### For Presentations
1. Use **soulseed_main.png** as your hero image
2. Show **color_palette.png** early to establish visual language
3. Use **interaction_flow.png** to explain user experience
4. Demo UI with **watch_mockup.png** and **iphone_mockup.png**
5. Explain personality with **sparkle_comparison.png**
6. Show onboarding with **ftue_visual.png**
7. Categorize features with **magic_types.png**
8. Close technical section with **architecture.png**

### For Design Reference
- **mood_board.png** guides aesthetic decisions
- **color_palette.png** ensures brand consistency
- All assets maintain matte luminosity aesthetic
- No glossy or plastic-looking elements

### Asset Characteristics
- **Background:** Pure white (#FFFFFF) on all images
- **Resolution:** High-res, presentation-ready
- **Format:** PNG with transparency where appropriate
- **Style:** Consistent ethereal aesthetic across all assets

---

## 🔧 Technical Details

All assets were generated programmatically using Python/Pillow to ensure:
- Perfect color accuracy
- Consistent spacing and layout
- Scalable and reproducible designs
- Easy iteration and updates

### Regenerating Assets
To regenerate all assets:
```bash
cd /home/user/Contextual/visual_assets
python3 generate_assets.py
```

---

## 📝 Design Philosophy

The soul seed is **not** a glass bubble - it's more like:
- A translucent fairy wing membrane with internal depth
- Vellum or rice paper with light behind it
- Butterfly wings catching moonlight
- **Matte luminosity, never glossy or plastic-looking**

Sparkles should look like:
- Dust motes catching moonlight
- **NOT** stars or glitter
- Silver shimmer with subtle lavender edges

Overall feeling:
- Ethereal
- Delicate
- Alive
- Almost too bright to look at directly

---

## 📦 File Manifest

```
visual_assets/
├── README.md (this file)
├── generate_assets.py (generator script)
├── soulseed_main.png (1200x1200)
├── color_palette.png (1920x400)
├── interaction_flow.png (1920x600)
├── watch_mockup.png (800x800)
├── iphone_mockup.png (800x1600)
├── sparkle_comparison.png (1920x600)
├── ftue_visual.png (800x1400)
├── magic_types.png (1920x600)
├── architecture.png (1920x1080)
└── mood_board.png (1920x1080)
```

---

**Created:** November 2025
**For:** Contextual - Ambient AI Companion
**Style:** Ethereal, Iridescent, Fairy-Wing Aesthetic
