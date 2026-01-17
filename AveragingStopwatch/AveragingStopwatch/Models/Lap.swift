import Foundation

struct Lap: Identifiable {
    let id = UUID()
    let number: Int
    let lapDuration: TimeInterval
    let cumulativeTime: TimeInterval

    var formattedLapDuration: String {
        formatTime(lapDuration)
    }

    var formattedCumulativeTime: String {
        formatTime(cumulativeTime)
    }

    private func formatTime(_ interval: TimeInterval) -> String {
        let minutes = Int(interval) / 60
        let seconds = Int(interval) % 60
        let hundredths = Int((interval.truncatingRemainder(dividingBy: 1)) * 100)
        return String(format: "%02d:%02d.%02d", minutes, seconds, hundredths)
    }
}
