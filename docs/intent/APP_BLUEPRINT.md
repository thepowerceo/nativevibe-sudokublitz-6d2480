# APP_BLUEPRINT

> Auto-generated: 2026-03-31T16:36:24.565Z
> Version: 1

## Overview

- **App Name**: sudoku_blitz
- **Screens**: 3
- **Total Files**: 44
- **Package**: sudoku_blitz

## Navigation

- **Router Type**: go_router
- **Initial Route**: /

### Routes

- `/` → **Root**
- `/game` → **Game**
- `/scoreboard` → **Scoreboard**
- `lib/screens/home_screen.dart` → **HomeScreen**
- `lib/screens/game_screen.dart` → **GameScreen**
- `lib/screens/scoreboard_screen.dart` → **ScoreboardScreen**

## State Management

- **Primary**: provider
- **Secondary**: setState

### State Files

- `lib/providers/app_provider.dart`

## Authentication

- **Provider**: none

## Data Services

- **Storage Strategy**: none

### Services

- **SudokuService** (api): `lib/services/sudoku_service.dart`
- **ScoreboardService** (api): `lib/services/scoreboard_service.dart`

### Models

- **SudokuPuzzle**: `lib/models/sudoku_puzzle.dart`
- **Score**: `lib/models/score.dart`
- **UserProfile**: `lib/models/user_profile.dart`

## Flows

### Start and Play a Sudoku Game (core_task)

1. **User opens the app** - ``
2. **User selects a difficulty level (Easy, Medium, Hard)** - ``
3. **App generates and displays a new Sudoku puzzle** - ``
4. **User fills in cells to solve the puzzle** - ``
5. **App validates the solution and calculates the score upon completion** - ``

### View Scoreboards (core_task)

1. **User navigates to the scoreboard screen** - ``
2. **User views top scores globally** - ``
3. **User views top scores per difficulty level** - ``
4. **User views their personal best scores** - ``

## Shared UI

- **Styling Approach**: custom_theme
- **Has Design Tokens**: Yes
- **Theme Location**: `lib/theme/app_theme.dart`

### Common Components

- **ScoreboardCard** (used 2x): `lib/widgets/scoreboard_card.dart`
- **DifficultyCard** (used 1x): `lib/widgets/difficulty_card.dart`
- **ScoreboardList** (used 1x): `lib/widgets/scoreboard_list.dart`

## Weak Points

- **[medium]** multiple_entry_points: 2 entry points detected without consistent auth guards
  - _Fix: Add a centralized auth redirect in your router configuration_
- **[low]** orphan_routes: 3 screen(s) not registered in router
  - _Fix: Add these screens to your router configuration or remove unused files_
- **[low]** other: Mixed state management: provider + setState
  - _Fix: Consider standardizing on provider for consistency_

## Invariants

- **[navigation/ppim]** Use go_router for navigation _(strict)_
- **[state/ppim]** Use provider for state management _(strict)_

---

_Last Built: 2026-02-12T18:47:36.802Z_