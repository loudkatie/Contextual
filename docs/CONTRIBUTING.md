# Contributing to Contextual

## Branch Model
main — stable  
dev — integration  
feature/<name> — new work  
fix/<name> — bug fixes  

## Rules
- No direct commits to main  
- All work goes through PRs  
- PRs must include a summary, test notes, and media if UI  
- Keep PRs small and scoped  

## Commits
feat: add whisper cooldown  
fix: motion drift handling  
refactor: extract location pipeline  

## Code Review
- Verify no secrets  
- Confirm background modes remain correct  
- Ensure no blocking operations on the main thread  
