import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StopwatchViewModel()
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                timerDisplay
                statisticsDisplay
                controlButtons
                lapList
            }
            .background(Color.appBackground)
            .navigationTitle("Stopwatch")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if !viewModel.laps.isEmpty {
                        ShareLink(
                            item: viewModel.generateCSV(),
                            preview: SharePreview("Lap Times", image: Image(systemName: "timer"))
                        ) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(Theme.actionBlue)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Timer Display

    private var timerDisplay: some View {
        VStack(spacing: Theme.baseUnit) {
            ZStack {
                // Glow effect when running
                if viewModel.isRunning {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Theme.activeGreen.opacity(colorScheme == .dark ? 0.08 : 0.05),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 150
                            )
                        )
                        .frame(width: 300, height: 300)
                        .animation(Theme.Animation.timerGlow, value: viewModel.isRunning)
                }

                Text(viewModel.formattedTotalTime)
                    .font(Theme.Typography.mainTimer)
                    .foregroundColor(.appPrimaryText)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
            }
            .frame(height: 120)
            .padding(.horizontal, Theme.contentMargin)

            if viewModel.totalElapsedTime > 0 {
                HStack(spacing: 4) {
                    Text("Lap \(viewModel.laps.count + 1):")
                        .foregroundColor(.appSecondaryText)
                    Text(viewModel.formattedCurrentLapTime)
                        .monospacedDigit()
                        .foregroundColor(.appSecondaryText)
                }
                .font(Theme.Typography.currentLapTimer)
                .frame(height: 32)
            } else {
                Spacer()
                    .frame(height: 32)
            }
        }
        .padding(.top, Theme.sectionSpacing)
    }

    // MARK: - Statistics Display

    private var statisticsDisplay: some View {
        Group {
            if let avgLap = viewModel.formattedAverageLapTime {
                HStack(spacing: Theme.sectionSpacing) {
                    statisticItem(label: "Avg Lap", value: avgLap)

                    if let overallAvg = viewModel.formattedOverallAverage,
                       viewModel.currentLapTime > 0 {
                        statisticItem(label: "Overall", value: overallAvg)
                    }
                }
                .frame(height: 48)
                .padding(.bottom, Theme.componentSpacing)
            } else {
                Spacer()
                    .frame(height: 48 + Theme.componentSpacing)
            }
        }
    }

    private func statisticItem(label: String, value: String) -> some View {
        HStack(spacing: 6) {
            Text("\(label):")
                .font(Theme.Typography.labels)
                .foregroundColor(.appSecondaryText)
            Text(value)
                .font(Theme.Typography.statistics)
                .monospacedDigit()
                .foregroundColor(.appPrimaryText)
        }
    }

    // MARK: - Control Buttons

    private var controlButtons: some View {
        HStack(spacing: 20) {
            // Reset / Lap button
            if viewModel.isRunning {
                StopwatchButton.lap(action: { viewModel.lap() })
            } else if viewModel.totalElapsedTime > 0 {
                StopwatchButton.reset(action: { viewModel.reset() })
            } else {
                StopwatchButton.lap(action: {}, isDisabled: true)
            }

            // Start / Stop button
            if viewModel.isRunning {
                StopwatchButton.stop(action: { viewModel.startStop() })
            } else {
                StopwatchButton.start(action: { viewModel.startStop() })
            }

            // Complete Lap button
            StopwatchButton.done(
                action: { viewModel.completeLap() },
                isDisabled: viewModel.totalElapsedTime == 0
            )
        }
        .frame(height: 100)
        .padding(.vertical, Theme.contentMargin)
    }

    // MARK: - Lap List

    private var lapList: some View {
        List {
            if viewModel.laps.isEmpty && viewModel.totalElapsedTime == 0 {
                Text("Press Start to begin timing")
                    .font(Theme.Typography.labels)
                    .foregroundColor(.appSecondaryText)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            } else {
                ForEach(Array(viewModel.laps.enumerated()), id: \.element.id) { index, lap in
                    LapRowView(
                        lap: lap,
                        isFastest: index == viewModel.fastestLapIndex,
                        isSlowest: index == viewModel.slowestLapIndex
                    )
                    .listRowBackground(Color.appSurface)
                    .listRowSeparator(.visible, edges: .bottom)
                    .listRowSeparatorTint(Color.appSecondaryText.opacity(0.2))
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .opacity
                    ))
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.appBackground)
        .animation(Theme.Animation.lapRowInsert, value: viewModel.laps.count)
    }
}

#Preview {
    ContentView()
}
