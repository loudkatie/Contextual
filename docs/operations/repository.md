# Repository Conventions

## Branching
- `main`: stable, production-ready artifacts.
- `develop`: integration branch (create when engineering begins).
- Feature branches use the format `feature/<description>`.

## Commits
- Prefer small, descriptive commits (present tense).
- Reference Notion/Jira IDs when available: `feat: add onboarding whisper flow (LL-123)`.

## Pull requests
- Include product context, screenshots (if UI change), and testing notes.
- Ensure documentation is updated alongside code changes.

## Folder layout
```
/ios/                 Swift packages, Xcode project, assets
/docs/                Product, design, technical documentation
/docs/product/        Vision, strategy, roadmap
/docs/design/         Experience guidelines, tone, flows
/docs/technical/      Architecture, APIs, data contracts
/docs/operations/     Process, rituals, working agreements
/scripts/             Automation (to be added)
```

Set up your local clone following `docs/operations/setup.md` so everyone shares the same
`~/04_Developer/Contextual` root path and remotes.

## Tooling
- SwiftFormat + SwiftLint for code style.
- Danger or custom GitHub Actions for PR quality (planned).
- Fastlane for build/test automation.
