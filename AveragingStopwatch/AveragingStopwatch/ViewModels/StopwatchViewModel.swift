import Foundation
import SwiftUI

@MainActor
class StopwatchViewModel: ObservableObject {
    @Published private(set) var isRunning = false
    @Published private(set) var totalElapsedTime: TimeInterval = 0
    @Published private(set) var currentLapTime: TimeInterval = 0
    @Published private(set) var laps: [Lap] = []

    private var timer: Timer?
    private var startTime: Date?
    private var accumulatedTime: TimeInterval = 0
    private var lapStartTime: TimeInterval = 0

    // MARK: - Computed Properties

    var formattedTotalTime: String {
        formatTime(totalElapsedTime)
    }

    var formattedCurrentLapTime: String {
        formatTime(currentLapTime)
    }

    var averageLapTime: TimeInterval? {
        guard !laps.isEmpty else { return nil }
        let totalLapTime = laps.reduce(0) { $0 + $1.lapDuration }
        return totalLapTime / Double(laps.count)
    }

    var overallAverageIncludingCurrent: TimeInterval? {
        let lapCount = laps.count + (currentLapTime > 0 ? 1 : 0)
        guard lapCount > 0 else { return nil }
        let totalTime = laps.reduce(0) { $0 + $1.lapDuration } + currentLapTime
        return totalTime / Double(lapCount)
    }

    var formattedAverageLapTime: String? {
        guard let avg = averageLapTime else { return nil }
        return formatTime(avg)
    }

    var formattedOverallAverage: String? {
        guard let avg = overallAverageIncludingCurrent else { return nil }
        return formatTime(avg)
    }

    var fastestLapIndex: Int? {
        guard laps.count >= 2 else { return nil }
        return laps.enumerated().min(by: { $0.element.lapDuration < $1.element.lapDuration })?.offset
    }

    var slowestLapIndex: Int? {
        guard laps.count >= 2 else { return nil }
        return laps.enumerated().max(by: { $0.element.lapDuration < $1.element.lapDuration })?.offset
    }

    // MARK: - Actions

    func startStop() {
        if isRunning {
            pause()
        } else {
            start()
        }
    }

    func lap() {
        guard isRunning || totalElapsedTime > 0 else { return }
        recordLap()
    }

    func completeLap() {
        guard totalElapsedTime > 0 else { return }
        if isRunning {
            pause()
        }
        if currentLapTime > 0 {
            recordLap()
        }
    }

    func reset() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        totalElapsedTime = 0
        currentLapTime = 0
        accumulatedTime = 0
        lapStartTime = 0
        laps = []
    }

    // MARK: - Private Methods

    private func start() {
        startTime = Date()
        isRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateTime()
            }
        }
    }

    private func pause() {
        timer?.invalidate()
        timer = nil
        accumulatedTime = totalElapsedTime
        isRunning = false
    }

    private func updateTime() {
        guard let startTime = startTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        totalElapsedTime = accumulatedTime + elapsed
        currentLapTime = totalElapsedTime - lapStartTime
    }

    private func recordLap() {
        let lapDuration = currentLapTime
        let lap = Lap(
            number: laps.count + 1,
            lapDuration: lapDuration,
            cumulativeTime: totalElapsedTime
        )
        laps.insert(lap, at: 0)
        lapStartTime = totalElapsedTime
        currentLapTime = 0
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        let hundredths = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }

    // MARK: - CSV Export

    func generateCSV() -> String {
        var csv = "Lap,Lap Time,Cumulative Time\n"

        for lap in laps.reversed() {
            csv += "\(lap.number),\(lap.formattedLapDuration),\(lap.formattedCumulativeTime)\n"
        }

        csv += "\n"
        if let avgLap = formattedAverageLapTime {
            csv += "Average Lap Time,\(avgLap)\n"
        }
        if let overallAvg = formattedOverallAverage {
            csv += "Overall Average,\(overallAvg)\n"
        }
        csv += "Total Time,\(formattedTotalTime)\n"

        return csv
    }
}
