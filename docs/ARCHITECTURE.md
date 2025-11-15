# Contextual Architecture

Contextual is a sensor-driven ambient agent.  
Its intelligence lives in the Services layer; UI is intentionally thin.

## Layers

App Layer  
- SwiftUI shell  
- Environment setup  
- Permissions  
- DebugView entry  

Services Layer  
- LocationService  
- MotionService  
- WhisperEngine  
- ContentService (mock → LLM future)  
- MomentState evaluation  

Models Layer  
- data structures for geogates, events, moments, whisper candidates  

Views Layer  
- presentation only  
- must not contain business logic  

## Data Flow

Sensors  
↓  
Services  
↓  
MomentState  
↓  
WhisperEngine  
↓  
Audio Output  

## Agent Loop

sense → evaluate → predict → whisper → adapt

