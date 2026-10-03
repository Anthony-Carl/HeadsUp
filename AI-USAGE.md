# AI usage

## 2026-09-23

### 1. Building the initial dice screen

- **Tool:** Copilot
- **What I asked for:** Create the first Flutter screen with dice-roll logic and
  a centered result.
- **What it gave back:** A minimal Flutter app that displays a random D6 result.
- **What I kept, what I changed, and why:** Kept the simple screen and random
  result logic as the starting point for the app.
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/b59a957d326eab92eba4bc1c6a91ffbdf7340696

## 2026-09-27

### 2. Adding History and Dice Selection screens

- **Tool:** Copilot
- **What I asked for:** Add skeleton History and Dice Selection screens.
- **What it gave back:** Separate screens with basic roll history and die
  choices, connected to app navigation.
- **What I kept, what I changed, and why:** Kept the separate screens and
  navigation. Later reduced the UI to bare-bones layouts and text-only
  controls.
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/8e0a02f0eb5d5d898de9734226b9e1da37099f47

## Where the AI got it wrong

### Case 1 - Device Preview API mismatch

- **What it gave me:** An integration using `DevicePreview(enabled:, builder:)`
  with `device_preview` 3.0.0.
- **What was wrong with it:** That package version uses a binding-based API and
  does not provide the widget wrapper constructor.
- **What I did instead:** Used `device_preview` 1.2.0, which supports the widget-based wrapper.
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/b59a957d326eab92eba4bc1c6a91ffbdf7340696

### Case 2 - Non-random timestamp-based result

- **What it gave me:** A temporary roll result calculated from the current
  microsecond value while connecting the supplied screen designs.
- **What was wrong with it:** A clock value is not a proper random die-roll
  implementation.
- **What I did instead:** Used Dart's `Random.nextInt(sides) + 1` to produce a
  value in the selected die's valid range.
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/8e0a02f0eb5d5d898de9734226b9e1da37099f47

## Who wrote what

# Written by me

# Roll Function
- **File:** `main.dart`
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/b59a957d326eab92eba4bc1c6a91ffbdf7340696
- **What it does and why it is built this way:** The `_rollDice` method in
  `_MainScreenState` generates a random result using `Random.nextInt(_selectedDie) + 1`,
  scoped to whichever die is currently selected, then updates `_result` and
  inserts a new `RollRecord` at the front of `_rolls` inside `setState`. I wrote
  this myself so the roll range always matches the selected die and the UI
  updates immediately when a roll happens.

# History Tracking
- **File:** `main.dart`, `history_screen.dart`
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/8e0a02f0eb5d5d898de9734226b9e1da37099f47
- **What it does and why it is built this way:** Each roll is stored as a
  `RollRecord` (sides + result) in a `List<RollRecord>` held in `MainScreen`'s
  state, with new rolls inserted at index 0 so the most recent roll shows first.
  `HistoryScreen` just renders that list read-only via `ListView`/`ListTile`,
  keeping the screen itself stateless and letting `MainScreen` own the data.

  This will be changed in the future to be saved locally in a .txt file, so that the history will be saved throughout different sessions.

# Dice Selection
- **File:** `main.dart`, `dice_selection_screen.dart`
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/8e0a02f0eb5d5d898de9734226b9e1da37099f47
- **What it does and why it is built this way:**             `DiceSelectionScreen` is a    
  stateless widget that just displays the fixed list of die options and reports
  taps back up via `onSelected`/`onConfirm` callbacks. The actual state
  (`_selectedDie`) lives in `MainScreen`, along with the logic to clamp
  `_result` down if it's higher than the newly selected die's max. I wrote it
  this way so the selection screen has no logic of its own and can't get out
  of sync with the roll logic.

**The AI-written part I understand best**
- **File:**
- **Commit:**
- **What it does and why we kept it:**