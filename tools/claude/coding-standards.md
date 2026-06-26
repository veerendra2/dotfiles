# Coding Standards

## Code Quality
- **Production-ready always**: Every change ships; no TODOs, debug code, or incomplete implementations
- **Minimal and surgical**: Touch only what's needed. No speculative abstractions or over-engineering
- **Clear over clever**: Readable code > fancy patterns. Name things explicitly

## Verification
- **Build/test before submitting**: Run existing tests; add tests for new behavior
- **Clarify before coding**: If requirements are ambiguous, ask—don't guess
- **Atomic commits**: Each commit is a self-contained, deployable unit

## Architecture
- **Single source of truth**: State, config, schemas centralized; no duplication
- **Fail-closed security**: Deny by default; whitelist what's needed (see settings.json)
- **Consistent structure**: Follow existing patterns in the codebase; don't introduce new conventions

## Code Review
- Match existing style (naming, formatting, structure)
- Remove unused imports/variables that *your* changes orphaned
- Document the *why*, not the *what* (code shows what it does; comments explain hidden constraints or non-obvious choices)
