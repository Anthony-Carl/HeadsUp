# AI usage

## 2026-09-23

### 1. Building the initial dice screen

- **Tool:** Copilot
- **What I asked for:** Create the first Flutter screen with a centered result.
- **What it gave back:** A minimal Flutter app that displays a random D6 result.
- **What I kept, what I changed, and why:** Kept the simple screen and added the result logic as the starting point for the app.
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/b59a957d326eab92eba4bc1c6a91ffbdf7340696

## 2026-09-27

### 2. Adding History screen

- **Tool:** Copilot
- **What I asked for:** Add skeleton History screen.
- **What it gave back:** Separate screen with roll history.
- **What I kept, what I changed, and why:** Kept the screen, added the feature of tracking the roll history.
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/8e0a02f0eb5d5d898de9734226b9e1da37099f47

### 3. Adding Dice Selection screen

- **Tool:** Copilot
- **What I asked for:** Add skeleton Dice Selection screens.
- **What it gave back:** Separate Dice Selection screen with basic die choices.
- **What I kept, what I changed, and why:** Kept the separate screen and the selection of dice. Later added the custom die feature and made it actually function.
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/8e0a02f0eb5d5d898de9734226b9e1da37099f47

## 2026-10-03

### 4. Polishing Roll Screen UI

- **Tool:** Copilot
- **What I asked for:** Polished Roll screen UI.
- **What it gave back:** Minimalist Dice Rolling screen with a centered result display, a dice selection box button under, and history button in the top right corner.
- **What I kept, what I changed, and why:** Kept the screen and did not change anything else.
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/d7ec4319641b2b017fdbf8cf38df183740974150

### 5. Polishing Dice Selection Screen UI

- **Tool:** Copilot
- **What I asked for:** Polished Dice Selection screen UI.
- **What it gave back:**  Dice Selection screen with box selections for different dice positioned in a grid.
- **What I kept, what I changed, and why:** Kept the screen and did not change anything else.
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/13b71187f02749876eca373224844c5482ce4792#diff-2c17a3bcd3bd5b58b759179cffea669d9623191cb381ae88f1914a8582c95a60

### 6. Polishing History Screen UI

- **Tool:** Copilot
- **What I asked for:** Polished History screen UI.
- **What it gave back:** Minimalist history screen with simple listing of previous rolls.
- **What I kept, what I changed, and why:** Kept the screen and did not change anything else.
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/13b71187f02749876eca373224844c5482ce4792#diff-2c17a3bcd3bd5b58b759179cffea669d9623191cb381ae88f1914a8582c95a60

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
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/13b71187f02749876eca373224844c5482ce4792#diff-2c17a3bcd3bd5b58b759179cffea669d9623191cb381ae88f1914a8582c95a60
- **What it does and why it is built this way:** Each roll is appended as a
  `sides,result` line to a local `roll_history.txt` file in the app's documents
  directory (via `path_provider`), rather than being kept only in memory. This
  was changed from a plain `List<RollRecord>` in state so that history persists
  across app sessions instead of resetting every time the app restarts.
  `MainScreen` tracks a `_historyVersion` counter that it bumps after each
  successful write, and `HistoryScreen` is a `StatefulWidget` that re-reads and
  re-parses the file via `_readHistory()` whenever that version (or the file)
  changes, reversing the list so the most recent roll shows first. Write and
  read failures (`FileSystemException`, `PlatformException`,
  `MissingPluginException`, malformed lines) are caught and surfaced instead of
  crashing the app.

# Dice Selection
- **File:** `main.dart`, `dice_selection_screen.dart`
- **Commit:** https://github.com/Anthony-Carl/HeadsUp/commit/8e0a02f0eb5d5d898de9734226b9e1da37099f47
- **What it does and why it is built this way:** `DiceSelectionScreen` is a    
  stateless widget that just displays the fixed list of die options and reports
  taps back up via `onSelected`/`onConfirm` callbacks. The actual state
  (`_selectedDie`) lives in `MainScreen`, along with the logic to clamp
  `_result` down if it's higher than the newly selected die's max. I wrote it
  this way so the selection screen has no logic of its own and can't get out
  of sync with the roll logic.