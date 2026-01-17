import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StopwatchViewModel()
    @State private var showingShareSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                timerDisplay
                statisticsDisplay
                controlButtons
                lapList
            }
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
                        }
                    }
                }
            }
        }
    }

    // MARK: - Timer Display

    private var timerDisplay: some View {
        VStack(spacing: 8) {
            Text(viewModel.formattedTotalTime)
                .font(.system(size: 72, weight: .thin, design: .monospaced))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
                .padding(.horizontal)

            if viewModel.totalElapsedTime > 0 {
                HStack {
                    Text("Lap \(viewModel.laps.count + 1):")
                        .foregroundColor(.secondary)
                    Text(viewModel.formattedCurrentLapTime)
                        .monospacedDigit()
                        .foregroundColor(.secondary)
                }
                .font(.title3)
            }
        }
        .padding(.vertical, 32)
    }

    // MARK: - Statistics Display

    private var statisticsDisplay: some View {
        Group {
            if let avgLap = viewModel.formattedAverageLapTime {
                VStack(spacing: 4) {
                    HStack {
                        Text("Avg Lap:")
                            .foregroundColor(.secondary)
                        Text(avgLap)
                            .monospacedDigit()
                            .fontWeight(.medium)
                    }

                    if let overallAvg = viewModel.formattedOverallAverage,
                       viewModel.currentLapTime > 0 {
                        HStack {
                            Text("Overall Avg:")
                                .foregroundColor(.secondary)
                            Text(overallAvg)
                                .monospacedDigit()
                        }
                        .font(.subheadline)
                    }
                }
                .padding(.bottom, 16)
            }
        }
    }

    // MARK: - Control Buttons

    private var controlButtons: some View {
        HStack(spacing: 20) {
            // Reset / Lap button
            Button {
                if viewModel.isRunning {
                    viewModel.lap()
                } else if viewModel.totalElapsedTime > 0 {
                    viewModel.reset()
                }
            } label: {
                Text(viewModel.isRunning ? "Lap" : (viewModel.totalElapsedTime > 0 ? "Reset" : "Lap"))
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(width: 80, height: 80)
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .clipShape(Circle())
            }
            .disabled(!viewModel.isRunning && viewModel.totalElapsedTime == 0)

            // Start / Stop button
            Button {
                viewModel.startStop()
            } label: {
                Text(viewModel.isRunning ? "Stop" : "Start")
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(width: 80, height: 80)
                    .background(viewModel.isRunning ? Color.red.opacity(0.2) : Color.green.opacity(0.2))
                    .foregroundColor(viewModel.isRunning ? .red : .green)
                    .clipShape(Circle())
            }

            // Complete Lap button
            Button {
                viewModel.completeLap()
            } label: {
                Text("Done")
                    .font(.title3)
                    .fontWeight(.medium)
                    .frame(width: 80, height: 80)
                    .background(Color.blue.opacity(0.2))
                    .foregroundColor(.blue)
                    .clipShape(Circle())
            }
            .disabled(viewModel.totalElapsedTime == 0)
        }
        .padding(.vertical, 20)
    }

    // MARK: - Lap List

    private var lapList: some View {
        List {
            if viewModel.laps.isEmpty && viewModel.totalElapsedTime == 0 {
                Text("Press Start to begin timing")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .listRowBackground(Color.clear)
            } else {
                ForEach(Array(viewModel.laps.enumerated()), id: \.element.id) { index, lap in
                    LapRowView(
                        lap: lap,
                        isFastest: index == viewModel.fastestLapIndex,
                        isSlowest: index == viewModel.slowestLapIndex
                    )
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    ContentView()
}
