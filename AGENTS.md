# AGENTS.md

## Project

- This is a hobby 2D top-down shooter made in GameMaker Studio 2.3 using GML.
- The project targets GameMaker IDE version `v2023.8.0.98`.
- It is a heavily work-in-progress sandbox project and is not expected to become a finished commercial game.
- The repository contains third-party sprites, textures, code, shaders, and other assets. Do not change licensing or attribution without an explicit request.

## Communication

- Communicate with the user in Czech unless asked otherwise.
- Keep explanations practical and understandable. The user needs to be able to maintain the resulting GML code.
- When the user asks only for analysis, do not edit any files.
- Explain important assumptions and mention anything that could not be verified.

## Editing Rules

- Read the relevant objects, scripts, parent objects, and call sites before editing.
- Make the smallest change that solves the requested problem.
- Do not refactor unrelated systems or rewrite working mechanics.
- Prefer existing project patterns and functions over creating new systems.
- Before adding a new system or state variable, check whether the project already has equivalent functionality and integrate with it instead of creating a redundant parallel solution.
- Keep GML straightforward. Avoid unnecessary abstractions, migration code, compatibility layers, or overly defensive helpers for small changes.
- Preserve all existing user changes. The working tree may already be dirty.
- Be careful with scope inside `with` blocks. Use `other` only when its scope is clear and valid.
- Never use GameMaker built-in variable names (such as `direction`, `speed`, `health`, `x`, or `y`) for custom variables or function parameters. Use descriptive names such as `move_dir`, `move_speed`, or `pos_x` instead. This does not prohibit intentional use of the actual built-in instance variables.
- Do not use `health` as a custom variable because it conflicts with GameMaker behavior in this project. Use `hp` for network values and the existing `stats.Health_points` fields for living objects.
- Keep singleplayer behavior working when changing multiplayer code.
- Multiplayer gameplay should remain server-authoritative. Keep packet read/write order and buffer types exactly matched, and avoid sending unchanged state every tick when an event-based update is enough.
- When adding a GameMaker resource or event, update all required `.yy` and `.yyp` references so it appears in the IDE.
- Do not modify generated files, external libraries, or third-party assets unless the task specifically requires it.

## Git And Builds

- Never commit, push, create branches, or otherwise publish changes unless explicitly requested.
- Do not create repository lock files or modify files inside `.git`.
- Never discard or revert changes that were not made as part of the current task.
- Do not compile or build the GameMaker project unless the user explicitly asks for it.

## Verification

- Inspect the final diff and check that only relevant files changed.
- Check new enum values against related arrays, lists, UI captions, save/load handling, and packet layouts.
- Check instance references with `instance_exists` where an instance may have been destroyed.
- Match creation and cleanup of surfaces, buffers, particle emitters, and `ds_*` data structures.
- Prefer focused static checks. If runtime verification requires GameMaker, describe the exact in-game scenario the user should test.
