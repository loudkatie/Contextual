# Data Contracts — Contextual

This document defines the interfaces between the iOS app, the inference engine, and any cloud-based
services. The goal is to guarantee stability, minimize payload sizes, and ensure privacy across all
data flows.

Contextual uses **highly abstracted**, **privacy-preserving**, **low-cardinality** data contracts.
No raw GPS coordinates or personal identifiers are ever transmitted to an LLM unless the user opts
into diagnostics.

---

# 1. Event Schema

Events represent raw signals from the environment.

```
Event {
  id: UUID
  type: EventType
  timestamp: ISO8601
  payload: Dictionary<String, Any>
}
```

### `EventType` examples:
- `location.enter_gate`
- `location.exit_gate`
- `motion.state_change`
- `user.preference_change`
- `time.schedule_trigger`
- `device.audio_output_complete`

---

# 2. Geogate Schema

A geogate is a lightweight representation of a place of significance.

```
Geogate {
  id: String
  category: GeogateCategory
  radius: Float
  confidence: Float
  metadata: GateMetadata
}
```

### `GeogateCategory` examples:
- `restaurant`
- `store`
- `transit`
- `memory`
- `home`
- `work`

### `GateMetadata` may include:
- name (string)
- loyalty program tags
- partner ID (optional)
- visit score (0–1)

---

# 3. Whisper Candidate Schema

Candidates are generated locally before LLM reasoning.

```
WhisperCandidate {
  id: String
  gateId: String?
  type: WhisperType
  reason: String
  score: Float
  context: WhisperContext
}
```

### `WhisperType` examples:
- `opportunity`
- `benefit`
- `memory`
- `social`
- `intention_reminder`

### `WhisperContext`:
```
WhisperContext {
  locationCategory: String?
  timeOfDay: String?
  recentWhispers: [String]
  userPreferences: [String]
}
```

---

# 4. LLM Payload Schema

Only abstracted, non-identifying information is sent to LLMs.

```
LLMPayload {
  candidateType: String
  contextSummary: String
  userPreferences: [String]
  safetyFlags: [String]
}
```

### Example payload:
```
{
  "candidateType": "opportunity",
  "contextSummary": "User just entered a restaurant gate at lunchtime.",
  "userPreferences": ["likes_italian", "prefers_quiet"],
  "safetyFlags": []
}
```

### Explicitly **not** included:
- lat/long coordinates  
- full user profile  
- raw movement history  
- personal identifiers  

---

# 5. Whisper Output Schema

Final whisper message chosen by the Whisper Engine.

```
WhisperOutput {
  id: String
  message: String
  type: WhisperType
  confidence: Float
}
```

Example:
```
{
  "id": "whisper_4729",
  "message": "A table for two just opened up here.",
  "type": "opportunity",
  "confidence": 0.91
}
```

---

# 6. Local Preference Schema

Stored on-device only.

```
UserPreferences {
  doNotDisturbZones: [String]
  mutedCategories: [String]
  recentWhispers: [String]
  homeLocationApprox: String?
  workLocationApprox: String?
}
```

---

# 7. Diagnostics Schema (opt-in only)

If the user enables diagnostics, small batches of anonymized events may be sent:

```
DiagnosticBatch {
  batchId: UUID
  anonymizedEvents: [Event]
  deviceInfo: String
  appVersion: String
}
```

Diagnostics are used strictly for:
- crash replication  
- whisper misfire debugging  
- geogate tuning  

Never for personalization or monetization.

---

Data contracts ensure the system remains predictable, safe, and respectful while enabling the
intelligence that makes Contextual magical.
