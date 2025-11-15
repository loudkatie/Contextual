# API & Integration Surface — Contextual

Contextual is designed to run primarily **on-device**, with optional cloud extensions that enhance
accuracy, personalization, and partner integrations. This document defines the network boundary and
the minimal APIs required for the system to function.

The design goals:
- preserve user privacy  
- minimize network calls  
- ensure stability across updates  
- keep the system responsive even without connectivity  

---

# 1. API Boundary Design

The app uses three categories of APIs:

### **1. Whisper Inference API (optional)**
Used when local heuristics need refinement from an LLM.

### **2. Opportunity API (optional)**
Fetches real-world opportunities:
- restaurant availability  
- store benefits  
- event triggers  
- partner signals  

### **3. Diagnostics API (opt-in only)**
Receives anonymized logs for debugging and model tuning.

All API calls use:
- HTTPS  
- short payloads  
- structured JSON  
- versioned endpoints (`/v1/...`)  

---

# 2. Whisper Inference API

**Endpoint:**  
`POST /v1/inference/whisper`

**Purpose:**  
Convert whisper candidates + context into a short, natural-language whisper.

**Request Example:**
```
{
  "candidateType": "opportunity",
  "contextSummary": "User just arrived at a restaurant during lunch.",
  "userPreferences": ["likes_italian"],
  "safetyFlags": []
}
```

**Response Example:**
```
{
  "whisper": "A table for two just opened up here.",
  "confidence": 0.92
}
```

### Behavior:
- If the API fails or times out, the on-device fallback model is used.
- If connectivity is offline, the app whispers only from local rules.

---

# 3. Opportunity API

Supports future partner integrations.

**Endpoint:**  
`GET /v1/opportunities/nearby`

**Query params:**
- `category` (optional)  
- `userProfile` (optional abstracted tags)  
- `timeOfDay`  
- `gateCategory`  

**Response Example:**
```
{
  "opportunities": [
    {
      "id": "open_table_124",
      "type": "restaurant",
      "message": "Table available at 12:45",
      "expiresAt": "2025-03-02T12:50:00Z"
    }
  ]
}
```

Opportunities are treated as *candidate inputs* to the Whisper Engine.

---

# 4. Diagnostics API (opt-in only)

Never enabled by default.

**Endpoint:**  
`POST /v1/diagnostics/batch`

**Payload Example:**
```
{
  "batchId": "8a1e2d02",
  "events": [
    {
      "type": "location.enter_gate",
      "timestamp": "2025-03-02T19:42:11Z"
    }
  ],
  "deviceInfo": "iPhone17,2",
  "appVersion": "1.0.3"
}
```

Diagnostics are encrypted and used solely for:
- crash debugging  
- geogate tuning  
- inference evaluation  

No user identity is retained.

---

# 5. API Versioning

All endpoints live under `/v1/`.  

When changes are required, new endpoints are added:  
- `/v2/inference/whisper`  
- `/v2/opportunities/...`  

Old ones remain temporarily supported to prevent client breakage.

---

# 6. Offline Mode

Contextual is architected so that **offline mode still works**:

- region monitoring continues  
- whisper candidates generate normally  
- only the LLM reasoning layer uses local fallback models  
- no opportunity data is fetched unless cached  

Offline mode must feel:
- graceful  
- invisible  
- stable  

---

# 7. Rate Limits & Safety

- Whisper inference → max 4 calls per hour  
- Opportunity fetch → debounced (no more than 1 call per 15 minutes)  
- Diagnostics → batched to avoid noise  

If the user disables data usage, all cloud calls are paused.

---

APIs exist to **enhance**, not power, the intelligence — Contextual always defaults to on-device
behavior for speed, safety, and trust.
