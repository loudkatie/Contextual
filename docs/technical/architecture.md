# Technical Architecture — Contextual

Contextual is an iOS-first, audio-first assistant built on three layers:

1. **Sensors** — collect lightweight context (location, motion, time, environment).
2. **Inference** — determine what matters right now.
3. **Whisper Engine** — decide *whether* to speak and *what* to say.

This architecture is designed for low battery usage, high responsiveness, and behavior that feels
native to walking through the world with AirPods.

---

# 1. System overview

```
+----------------------+
|      iOS App         |
|  (Swift / SwiftUI)   |
+----------+-----------+
           |
           v
+----------------------+      +-----------------------+
|   Sensor Layer       | ---> |   Inference Engine    |
|  (Location, Motion)  |      |   (LLM + heuristics)  |
+----------------------+      +-----------------------+
           |                              |
           |                              v
           |                    +-----------------------+
           +------------------> |   Whisper Engine      |
                                |  (rules + ranking)    |
                                +-----------+-----------+
                                            |
                                            v
                                +-----------------------+
                                |  Audio Output (TTS)   |
                                +-----------------------+
```

---

# 2. Sensor layer

This layer collects continuous but lightweight environmental signals:

### **Location**
- CoreLocation
- region monitoring (geofences)
- significant location change fallback
- high accuracy only near gates

### **Motion**
- CoreMotion activity classification:
  - walking  
  - running  
  - stationary  
  - automotive  

### **Temporal context**
- time of day  
- day of week  
- recency of last whisper  

### **User state**
Stored locally:
- home coordinates  
- work coordinates  
- favorite places  
- behavioral patterns  

All raw data is minimized and kept on-device unless the user opts into cloud sync.

---

# 3. Inference engine

The inference layer determines the meaning of the current moment.

It blends:

### **Rule-based signals**
- entering/exiting geogates  
- arriving vs passing-by detection  
- stop-motion detection (user has paused)  

### **Statistical patterns**
- time-of-day likelihood  
- habit models  
- frequency capping  

### **LLM reasoning (using OpenAI or on-device models)**
Provide:
- relevance ranking  
- tone selection  
- optional personalization  
- suppression of noise  

Only *lightweight* payloads are sent to the LLM:
- location category  
- intent candidate  
- persona preference  
- safety constraints  

No raw location trails are transmitted.

---

# 4. Whisper engine

The whisper engine is responsible for the **final decision**:

### Whisper = **Trigger + Relevance + Safety + Timing**

It decides:
1. *Should we whisper at all?*
2. *Which whisper has the highest contextual value?*
3. *How do we phrase it so it’s under 2 seconds and feels intuitive?*

### Decision model:
- input: ranked candidates  
- filter: safety + repetition + do-not-disturb windows  
- output: single whisper or silence  

### Whisper types:
- opportunity whispers (restaurant table opened)  
- benefit whispers (store credit, deals, expiring points)  
- memory whispers (Kilroy integration)  
- social proximity whispers  
- intention reminders  

The engine must default to **silence** unless confidence is high.

---

# 5. Audio output

Whispers are played using:
- AVSpeechSynthesizer  
- custom voice tuning  
- adaptive volume  
- soft fade-in  

Future:
- on-device audio snippets  
- pre-rendered micro-phrases for ultra-fast delivery  

---

# 6. Data flow

```
[CoreLocation] ---> (Gate Trigger) ---> Candidate Generator
[CoreMotion] ---------------------------> /
[Time/Schedule] ------------------------>/

Candidate Generator ---> LLM Reasoner ---> Whisper Engine ---> Audio
```

---

# 7. Reliability & performance

- Continuous location updates are minimized to preserve battery.
- Region monitoring handles 90% of gate detection.
- LLM calls are capped and cached.
- Whisper engine runs on the main thread only when output is required.
- Background modes enabled:
  - location  
  - audio  

---

# 8. Security & privacy

- No raw GPS trails leave the device.
- User preferences stored in encrypted local storage.
- Whispers are ephemeral and not logged unless the user enables diagnostics.
- LLM payloads scrub identifiers:
  - no lat/long  
  - no personally identifiable info  
  - high-level categories only  

---

Contextual’s architecture optimizes for:
- responsiveness  
- trust  
- battery efficiency  
- hyper-personal relevance  

…all to deliver **the lightest possible proactive AI experience.**
