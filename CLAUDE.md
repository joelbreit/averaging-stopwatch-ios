# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A stopwatch iOS application with lap timing and averaging features, built SwiftUI. The app tracks lap times, calculates averages, and can export data to CSV.

## Architecture

### Tech Stack
- **Language**: Swift

### Key Features To Implement
- **Timer logic**: Update in real-time
- **Lap tracking**: Records individual lap durations and cumulative times
- **Statistics**: Calculates average lap time for completed laps and overall average including active lap
- **Current lap time**: Displays time for active lap separately from total time
- **Min/Max highlighting**: Fastest lap shown in green, slowest in red (requires 2+ laps)
- **CSV export**: Downloads lap data with statistics
- **Complete lap button**: Stops timer and records final lap in one action
- **Styling**: Light and dark mode styling