import SwiftUI

struct LapRowView: View {
    let lap: Lap
    let isFastest: Bool
    let isSlowest: Bool

    var textColor: Color {
        if isFastest {
            return .green
        } else if isSlowest {
            return .red
        }
        return .primary
    }

    var body: some View {
        HStack {
            Text("Lap \(lap.number)")
                .foregroundColor(textColor)
                .frame(width: 70, alignment: .leading)

            Spacer()

            Text(lap.formattedLapDuration)
                .foregroundColor(textColor)
                .monospacedDigit()

            Spacer()

            Text(lap.formattedCumulativeTime)
                .foregroundColor(.secondary)
                .monospacedDigit()
        }
        .padding(.vertical, 8)
    }
}
