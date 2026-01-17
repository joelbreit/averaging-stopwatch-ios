# Averaging Stopwatch

A stopwatch iOS app with lap timing and averaging features. Displays your fastest/slowest lap and keeps track of average lap time (for completed laps and live including the active lap).

## Features

- Real-time timer with 100Hz update rate
- Lap tracking with individual and cumulative times
- Average lap time calculations (completed laps + overall including current)
- Min/max lap highlighting (green for fastest, red for slowest)
- CSV export with statistics
- "Complete Lap" button to stop timer and record final lap in one action
- Automatic light/dark mode support

## Technology

- **Platform**: iOS 17+
- **Framework**: SwiftUI
- **Language**: Swift 5

## Project Structure

```
AveragingStopwatch/
├── AveragingStopwatch.xcodeproj/
└── AveragingStopwatch/
    ├── AveragingStopwatchApp.swift      # App entry point
    ├── Models/
    │   └── Lap.swift                     # Lap data model
    ├── ViewModels/
    │   └── StopwatchViewModel.swift      # Timer logic & state management
    ├── Views/
    │   ├── ContentView.swift             # Main stopwatch UI
    │   └── LapRowView.swift              # Individual lap row component
    └── Assets.xcassets/                  # App icons & colors
```

## Run this Project

1. Clone this repository
2. Open `AveragingStopwatch/AveragingStopwatch.xcodeproj` in Xcode
3. Select a simulator or device
4. Build and run (Cmd+R)