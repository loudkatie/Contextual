# Security & Privacy

Contextual is designed as a **privacy-first ambient agent**.

## Location Data
- Processed entirely on device  
- Never uploaded  
- Never logged in production  
- Used only for geogate evaluation and moment scoring  

## Audio
- Whisper-only playback  
- No recording  
- No microphone usage  
- No voice or audio data leaves device  

## Motion
- Device motion used only for moment heuristics  
- Values not persisted  

## LLM (Future)
When integrating LLM micro-reasoning:
- Use ephemeral API mode  
- Disable retention  
- Do not send precise coordinates  
- Only send abstracted state (e.g., "arriving", "leaving")  

## Repository
Do **not** commit:
- .xcconfig  
- API keys  
- Access tokens  
- Private partner credentials  
- User-specific data  

## Device Permissions
Contextual requests:
- location (always)
- motion
- audio (background)

These are required for safe, predictable agent behavior.

