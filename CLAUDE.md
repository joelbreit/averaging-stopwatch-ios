# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A stopwatch iOS application with lap timing and averaging features, built with SwiftUI. The app tracks lap times, calculates averages, and can export data to CSV.

## Architecture

### Tech Stack
- **Platform**: iOS 17+
- **Framework**: SwiftUI
- **Language**: Swift 5

### Project Structure
```
AveragingStopwatch/
├── AveragingStopwatch.xcodeproj/
└── AveragingStopwatch/
    ├── AveragingStopwatchApp.swift      # @main app entry point
    ├── Models/
    │   └── Lap.swift                     # Lap data model with formatting
    ├── ViewModels/
    │   └── StopwatchViewModel.swift      # Timer logic, state, CSV export
    ├── Views/
    │   ├── ContentView.swift             # Main stopwatch UI
    │   └── LapRowView.swift              # Lap row with min/max coloring
    └── Assets.xcassets/
```

### Key Components
- **StopwatchViewModel**: `@MainActor` ObservableObject managing timer state, lap recording, statistics calculation, and CSV generation
- **Lap**: Struct holding lap number, duration, cumulative time with formatted string computed properties
- **ContentView**: Main UI with timer display, control buttons, and lap list
- **LapRowView**: Individual lap row that highlights fastest (green) and slowest (red) laps

### Features
- **Timer**: 100Hz update rate using `Timer.scheduledTimer`
- **Lap tracking**: Records individual lap durations and cumulative times
- **Statistics**: Average lap time for completed laps + overall average including active lap
- **Current lap time**: Displays time for active lap separately from total time
- **Min/Max highlighting**: Fastest lap in green, slowest in red (requires 2+ laps)
- **CSV export**: ShareLink exports lap data with statistics
- **Complete lap button**: Stops timer and records final lap in one action
- **Styling**: Uses system colors for automatic light/dark mode support

## Build Commands

```bash
# Build from command line
cd AveragingStopwatch
xcodebuild -project AveragingStopwatch.xcodeproj -scheme AveragingStopwatch -destination 'platform=iOS Simulator,name=iPhone 15' build
```