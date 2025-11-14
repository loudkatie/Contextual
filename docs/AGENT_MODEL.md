# Contextual Agent Model

Contextual is not an app.  
It is an **agent** that senses, evaluates, predicts, and whispers.

## Core Loop

sense → evaluate → schedule → whisper → adapt

### sense
Collect active sensor data:
- geolocation  
- movement  
- time of day  
- device state  
- user patterns  

### evaluate
Decide whether the moment is meaningful:
- entering a geogate  
- slowing down  
- stopping  
- returning to a routine place  
- time-based heuristics  

### schedule
Determine if whisper should fire now or wait.

### whisper
Deliver a soft audio cue.  
No notifications unless fallback is needed.

### adapt
Learn from:
- accepted whispers  
- ignored whispers  
- repeated triggers  
- user timing patterns  

