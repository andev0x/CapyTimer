## CapyTimer (macOS Menu Bar Pomodoro + Todos + Notes)

CapyTimer is a lightweight macOS menu bar app built with SwiftUI. It combines a Pomodoro timer with a simple todo list and quick notes, designed for focus and flow.

### Features
- Pomodoro timer with configurable focus and break durations
- Menu bar window with compact, touch-friendly UI
- Todo list with check/strike and delete
- Notes pane for quick jotting
- Local notification when a session finishes
- Optional sound at end of session (bundled `capysound.wav`)

### Screens
- Timer with progress, start/pause, reset
- Todo list with add, complete, remove
- Notes editor
- Settings for durations

### Requirements
- macOS 14+
- Xcode 15+

### Getting Started
1. Open the project:
   - Double-click `CapyTimer.xcodeproj`
2. Build and run (⌘R) with the `CapyTimer` scheme.
3. Grant notification permission on first launch.

### Sound
The project includes `CapyTimer/capysound.wav`. The app plays this sound at the end of a focus session. Replace it with another short WAV if desired (same name), or adjust the resource name in `TimerManager.playSound()`.

### Configuration
- In the app window, set focus and break minutes in Settings and press Save. The timer resets using the new durations.

### Project Structure
```
CapyTimer/
  CapyTimerApp.swift         // App entry, environment objects, MenuBarExtra
  ContentView.swift          // Main layout
  TimerManager.swift         // Timer logic + notifications + sound
  TodoManager.swift          // Todo model and actions
  NotesManager.swift         // Notes state
  NotificationManager.swift  // Permission + local notification helper
  CapyTheme.swift            // Reusable styles and UI components
  NotesView.swift            // Notes UI
  TodoView.swift             // Todos UI
  SettingsView.swift         // Settings UI
  Assets.xcassets            // Colors & app icon
```

### Contributing
PRs welcome. Keep code clear and consistent with existing SwiftUI style. Prefer reusable components in `CapyTheme.swift`.

### License
MIT


