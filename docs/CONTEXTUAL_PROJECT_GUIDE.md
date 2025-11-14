# Contextual — Master Project Guide
Loud Labs (2025)

Contextual is a **proactive, audio-first, geospatial agent** for iOS.
It senses the world through location, motion, and time, evaluates context, and whispers meaningful updates to the user.

This is the canonical guide for engineering, architecture, agent workflow, and development.

---

# Philosophy

Contextual is built on:
1. Ambient intelligence
2. Audio-first experiences
3. Geospatial context

Its job: whisper only at the right moment.

---

# Architecture

AppMain.swift
- loads services
- requests permissions
- hosts minimal UI and DebugView

Services:
- LocationService (geogates, regions, fused updates)
- MotionService (movement, pedometer)
- WhisperEngine (audio triggers)
- ContentService (mock now, LLM later)

Models:
- MomentState
- WhisperCandidate
- AppEvent
- Geogate

Views:
- thin SwiftUI wrappers

Agent Loop:
sense → evaluate → predict → whisper → adapt

