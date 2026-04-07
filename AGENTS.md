# Dailyder Frontend Agent Guide

## Purpose
- Build and maintain the Dailyder Telegram Mini App and browser-friendly Flutter Web frontend.
- Support developer and admin daily reporting flows against the `dailyder` backend API.

## Architecture
- Use feature-first structure under `lib/src`.
- Keep cross-cutting code in `src/core` and `src/common`.
- Keep backend as the source of truth for workflow rules, validation, and permissions.
- Separate code into `data`, `domain`, and `presentation` layers where business logic exists.

## Folder Rules
- Put reusable platform-wide widgets in `src/core/widget` or `src/common/widgets`.
- Put feature-specific UI only inside that feature’s `presentation` folder.
- Keep API models and DTO mapping explicit inside `data/model` or `data/repository`.
- Do not place networking, routing, or persistence logic inside widgets.

## Naming
- Use full descriptive names.
- Avoid vague names like `manager`, `helper`, `utils`, `data`, or `model` unless the role is exact.
- Use consistent suffixes: `Repository`, `RepositoryImpl`, `UseCase`, `Cubit`, `State`, `Screen`, `Panel`, `Card`.

## Widget Limits
- Keep every widget under 150–200 lines.
- Do not use private widgets.
- Do not use private methods for UI composition.
- Prefer extracting sections into dedicated public widgets/files.

## State Management
- Use `Cubit` by default.
- Use `Bloc` only when event sequencing is materially clearer than intent methods on a cubit.
- Keep side effects in cubits, repositories, or use cases.
- Keep widgets focused on rendering state and dispatching user intents.

## UI and Business Logic Separation
- Widgets must not perform raw Dio calls, token reads, or JSON parsing.
- Repositories call APIs.
- Use cases coordinate repository work when the feature has meaningful business rules.
- Cubits own loading, success, and error transitions for screens.

## Flutter Web Principles
- Design for browser usage first.
- Support keyboard, mouse, and trackpad interaction.
- Use responsive layouts for narrow, medium, and wide widths.
- Keep navigation URL-driven with `go_router`.
- Provide clear loading, empty, error, and success states.
- Respect Telegram Mini App viewport behavior, but keep browser/dev mode equally usable.

## Contribution Expectations
- Every behavior change should include or update tests.
- Keep code production-ready and readable.
- Prefer explicitness over cleverness.
- Update API assumptions, route changes, and environment requirements when they change.
