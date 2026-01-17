import SwiftUI

struct LapRowView: View {
    let lap: Lap
    let isFastest: Bool
    let isSlowest: Bool

    private var accentColor: Color {
        if isFastest {
            return Theme.activeGreen
        } else if isSlowest {
            return Theme.stopRed
        }
        return .appPrimaryText
    }

    private var labelColor: Color {
        if isFastest {
            return Theme.activeGreen
        } else if isSlowest {
            return Theme.stopRed
        }
        return .appSecondaryText
    }

    var body: some View {
        HStack {
            // Lap number - left aligned
            Text("Lap \(lap.number)")
                .font(Theme.Typography.lapNumber)
                .foregroundColor(labelColor)
                .frame(width: 70, alignment: .leading)

            Spacer()

            // Lap duration - center
            Text(lap.formattedLapDuration)
                .font(Theme.Typography.lapTimes)
                .foregroundColor(accentColor)
                .monospacedDigit()

            Spacer()

            // Cumulative time - right aligned
            Text(lap.formattedCumulativeTime)
                .font(Theme.Typography.lapTimes)
                .foregroundColor(.appSecondaryText)
                .monospacedDigit()
        }
        .padding(.vertical, Theme.componentSpacing)
        .padding(.horizontal, Theme.baseUnit / 2)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Lap \(lap.number), time \(lap.formattedLapDuration), total \(lap.formattedCumulativeTime)")
        .accessibilityHint(isFastest ? "Fastest lap" : (isSlowest ? "Slowest lap" : ""))
    }
}

#Preview {
    List {
        LapRowView(
            lap: Lap(number: 1, lapDuration: 32.45, cumulativeTime: 32.45),
            isFastest: true,
            isSlowest: false
        )
        LapRowView(
            lap: Lap(number: 2, lapDuration: 45.12, cumulativeTime: 77.57),
            isFastest: false,
            isSlowest: true
        )
        LapRowView(
            lap: Lap(number: 3, lapDuration: 38.90, cumulativeTime: 116.47),
            isFastest: false,
            isSlowest: false
        )
    }
    .listStyle(.plain)
}
