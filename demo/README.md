# Soul Seed Interactive Demo
## For Friday Team Meeting - November 22, 2025

---

## 🌬️ What This Is

A high-fidelity interactive prototype that demonstrates the **magic and feeling** of Contextual.

This is NOT a wireframe. This is NOT a mockup.
This is a **living, breathing experience** that shows:

- The soul seed visual identity (breathing, sparkles, alive)
- The proactive conversation style (she leads, you respond)
- The three-part interaction (tap → glance → whisper)
- Soul-speed permission requests (earned trust over time)
- The ethereal ASMR voice (whispered, feminine, not Scarlett)

---

## 📱 How to Run It

### Option 1: On Your iPhone (BEST)

1. **Open this on your Mac:**
   ```bash
   cd ~/Contextual/demo
   python3 -m http.server 8000
   ```

2. **On your iPhone:**
   - Open Safari
   - Go to: `http://[your-mac-ip]:8000`
     - (Find your Mac's IP in System Settings → Network)
   - Tap the Share button → "Add to Home Screen"
   - Name it "Contextual Demo"
   - **Now you have the app icon on your home screen!**

3. **To present:**
   - Open from home screen (feels like real app)
   - Put on headphones (AirPods ideal)
   - Tap through the experience

### Option 2: On Your Mac (for development)

1. **Simply open in browser:**
   ```bash
   cd ~/Contextual/demo
   open index.html
   ```

2. **Or use local server:**
   ```bash
   python3 -m http.server 8000
   ```
   Then visit: `http://localhost:8000`

---

## 🎬 The Experience Flow

### **Act 1: The Awakening** (90 seconds)
- Tap Contextual icon on home screen
- Pure white void appears
- Point of light emerges and grows
- Soul seed begins breathing
- Voice whispers: "I'm here."
- She introduces herself
- Asks for 3 essential permissions (Location, Identity, Notifications)
- Each with gentle explanation before requesting

### **Act 2: The Wait** (15 seconds)
- Passive state: just soul seed breathing
- Meditative, alive, present

### **Act 3: The Magic** (60 seconds)
- Apple Watch mockup appears
- Shows the "tap → glance → whisper" interaction
- Demonstrates a Kilroy memory moment:
  - "You walked this path last spring..."
  - "Someone left a memory here. A photo of cherry blossoms."
  - "Want to see it again?"

### **Act 4: Soul Speed** (45 seconds)
- Days later (implied time jump)
- She asks for Calendar access
- Shows: trust earned slowly, not all at once
- Demonstrates ongoing permission conversation

**Total duration:** ~3.5 minutes

---

## 🎨 What's Included

### Visual Assets
- `soul-seed.svg` - The core soul seed entity
  - Breathing animation (3s cycle)
  - Sparkle particle system
  - White/lavender/periwinkle gradient

- `app-icon.svg` - iOS app icon (1024x1024)
  - Can be converted to PNG for actual use
  - Matches soul seed visual identity
  - Ready for App Store

### The Prototype
- `index.html` - Complete interactive experience
  - 13 scene progression
  - CSS animations (breathing, sparkles, transitions)
  - iOS voice synthesis integration
  - Mobile-optimized, touch-friendly
  - PWA-capable (can install to home screen)

---

## 🎤 Voice Notes

The demo uses **iOS built-in speech synthesis** with these settings:
- **Rate:** 0.42 (slow, ASMR-like)
- **Pitch:** 1.1 (slightly elevated)
- **Volume:** 0.75 (soft, whispered)
- **Voice preference:** Samantha > Zoe > Fiona (in that order)

### To Test Different Voices:
1. Open the browser console
2. Run: `speechSynthesis.getVoices()` to see all available
3. Edit the `preferredVoices` array in `index.html` line 614

### For Production:
We'll need custom voice recordings or premium TTS (ElevenLabs, Resemble.ai) to get the exact **ethereal ASMR feminine** quality we want.

**Reference:** Hailee Steinfeld vocal quality - breathy, clear consonants, warm but not cutesy

---

## 🎯 Demo Talking Points

When presenting to the team:

### 1. **This is the FEEL**
- Not about features, about presence
- Soul seed is alive, breathing, aware
- White space = calm, not empty
- She feels like a companion, not a tool

### 2. **This is FEASIBLE**
- Built with standard web tech (HTML/CSS/JS)
- iOS equivalent uses: SwiftUI, AVFoundation, CoreAnimation
- All interactions possible with today's APIs
- Nothing here requires magic - just craft

### 3. **This is DIFFERENT**
- No feed, no timeline, no infinite scroll
- Proactive, not reactive
- Audio-first, screenless-default
- Trust earned slowly (soul speed)

### 4. **This is SCRAPPY**
- Built in < 24 hours
- Zero budget, zero designers
- Shows: we can ship fast when we're aligned
- Imagine what we'll do with 3 months

---

## 🔧 Customization

### To Change Whisper Scripts:
Edit the `whispers` object in `index.html` (line 594):
```javascript
const whispers = {
    'awakening-breath': "I'm here.",
    'intro-1': "I sense the hidden layers around you.",
    // ... etc
};
```

### To Adjust Scene Timing:
Look for `setTimeout()` calls in the `onSceneEnter()` function (line 650)

### To Modify Colors:
Edit CSS variables in `:root` (line 32):
```css
:root {
    --pure-white: #FFFFFF;
    --silver-shimmer: #E8E8F0;
    --pale-lavender: #E6E6FA;
    --powder-periwinkle: #E0F4FF;
    --ghost-white: #F8F8FF;
}
```

### To Tweak Animations:
All animations are in CSS:
- Soul seed breathing: line 96 (`@keyframes breathe`)
- Sparkle rise: line 119 (`@keyframes sparkleRise`)
- Text fade: line 153 (`@keyframes fadeInText`)

---

## 📊 Success Criteria

If the demo works, the team should:

1. **Feel** the soul seed (not just see wireframes)
2. **Understand** the interaction model (tap → glance → whisper)
3. **Believe** it's buildable (Wedge sees the path)
4. **Want** to use it (team gets excited)
5. **Commit** to the vision (everyone aligned on "soulful not spammy")

---

## 🐛 Known Limitations

### Voice Synthesis:
- Browser voices vary by device/OS
- Safari on iOS has best voices
- May need manual "click to enable audio" on first load
- Production will need custom voice recordings

### Not Included:
- Real geofencing (just simulated)
- Actual Apple Watch integration
- Real Kilroy backend
- Full permission flows

**This is a FEELING demo, not a feature demo.**

---

## 🚀 Next Steps After Friday

If the team aligns:

1. **Week 1-2:** Convert to native iOS (SwiftUI)
2. **Week 3-4:** Implement real geofencing + demo route
3. **Week 5-6:** ChatGPT API integration (AI soul)
4. **Week 7+:** Kilroy backend, Watch app, polish

Bootstrap budget: $10-20K
Timeline to TestFlight: 8-10 weeks

---

## 💡 Tips for Presenting

### Do:
- ✅ Put on headphones before starting
- ✅ Dim the lights (enhances the white glow)
- ✅ Let each scene breathe (don't rush)
- ✅ Emphasize: "This is the feeling, not wireframes"
- ✅ End with: "Should we build this?"

### Don't:
- ❌ Apologize for it being a prototype
- ❌ Focus on what's missing
- ❌ Explain too much (let them experience it)
- ❌ Skip the voice (it's essential!)

---

## 🌬️ Remember

This demo is about **trust**.

Trust that:
- The team will feel what you feel
- The vision is worth pursuing
- We can build this together
- Soul seeds can be real

Let the demo speak. Let her whisper. Let them feel.

---

*Created by Claude (Head of Product)*
*November 20, 2025*
*"Let's ship soul seeds." ✨🌬️*
