<p align="center">
  <img src="https://raw.githubusercontent.com/andev0x/description-image-archive/refs/heads/main/capy-timer/capytimerapp.png" width="200" />
</p>

<p align="center">
  <a href="https://github.com/andev0x/CapyTimer/releases/latest">
    <img src="https://img.shields.io/github/v/release/andev0x/CapyTimer?color=blue&label=Download&logo=apple&logoColor=white" />
  </a>
  <a href="https://github.com/andev0x/CapyTimer/stargazers">
    <img src="https://img.shields.io/github/stars/andev0x/CapyTimer?style=social" />
  </a>
  <a href="https://github.com/andev0x/CapyTimer/fork">
    <img src="https://img.shields.io/github/forks/andev0x/CapyTimer?style=social" />
  </a>
</p>

----



## CapyTimer (macOS Menu Bar Pomodoro + Todos + Notes)

CapyTimer is a lightweight macOS menu bar app built with SwiftUI. It combines a Pomodoro timer with a simple todo list and quick notes, designed for focus and flow.

### Demo


<img src="https://github.com/andev0x/description-image-archive/blob/main/capy-timer/capy-timer-icon.gif?raw=true" />


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
├── CapyTimerApp.swift                    # Main app entry point
├── CapyTimer.entitlements               # App entitlements
├── Core/                                # Business logic and data management
│   ├── Managers/                        # Manager classes
│   │   ├── TimerManager.swift          # Timer functionality
│   │   ├── TodoManager.swift           # Todo list management
│   │   ├── NotesManager.swift          # Notes management
│   │   └── NotificationManager.swift   # Notification handling
│   └── Models/                         # Data models (ready for future expansion)
├── UI/                                  # User interface components
│   ├── Views/                          # SwiftUI views
│   │   ├── ContentView.swift           # Main content view
│   │   ├── TodoView.swift              # Todo list view
│   │   ├── NotesView.swift             # Notes view
│   │   └── SettingsView.swift          # Settings view
│   ├── Components/                     # Reusable UI components (ready for future expansion)
│   └── Theme/                          # Design system and styling
│       └── CapyTheme.swift             # Theme, colors, and UI components
└── Resources/                          # App resources
    ├── Images/                         # Image assets
    │   └── Assets.xcassets/            # App icons and color sets
    └── Sounds/                         # Audio files
        └── capysound.wav              # Timer completion sound
```

### Contributing
PRs welcome. Keep code clear and consistent with existing SwiftUI style. Prefer reusable components in `CapyTheme.swift`.

### 📥 Installation
1. Go to [Latest Release](https://github.com/andev0x/CapyTimer/releases/latest).
2. Download the `.dmg` file.
3. Drag **CapyTimer.app** into your Applications folder.

> How to use it:
Open the Terminal application.
    Type `xattr -cr ` (note the trailing space).
    Drag the application or file you want to modify from Finder into the Terminal window. This will automatically populate the full path of the item.
    Press Enter to execute the command.

### License
[MIT](LICENSE)


