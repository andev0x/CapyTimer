//
//  ContentView.swift
//  CapyTimer
//
//  Created by Andeph Nguyen on 9/30/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerManager: TimerManager
    @EnvironmentObject var todoManager: TodoManager
    @EnvironmentObject var notesManager: NotesManager
    @EnvironmentObject var updateManager: UpdateManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Update alert
                if updateManager.updateAvailable && updateManager.showUpdateAlert {
                    UpdateAlertView()
                }
                Card {
                    VStack(spacing: 10) {
                        // Progress ring around time label
                        let total = timerManager.isRunning ? max(timerManager.focusDuration, timerManager.breakDuration) : max(timerManager.focusDuration, timerManager.breakDuration)
                        let progress = total > 0 ? 1.0 - Double(timerManager.remainingTime) / Double(total) : 0
                        HStack(spacing: 12) {
                            ProgressRing(progress: max(0, min(1, progress)))
                                .frame(width: 54, height: 54)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(formatTime(timerManager.remainingTime))
                                    .font(.system(size: 28, weight: .bold))
                                Text(timerManager.isRunning ? "Running" : "Paused")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        HStack {
                            Button(timerManager.isRunning ? "Pause" : "Start") {
                                timerManager.isRunning ? timerManager.stop() : timerManager.start()
                            }
                            .buttonStyle(.borderedProminent)
                            Button("Reset") {
                                timerManager.reset()
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
                
                Card {
                    SectionHeader(title: "Todo List")
                    TodoView()
                }
                
                Card {
                    SectionHeader(title: "Notes")
                    NotesView()
                }
                
                Card {
                    SectionHeader(title: "Settings")
                    SettingsView()
                }
                
                Card {
                    SectionHeader(title: "Updates")
                    UpdateView()
                }
            }
            .padding()
            .frame(width: 280)
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    ContentView()
        .environmentObject(TimerManager())
        .environmentObject(TodoManager())
        .environmentObject(NotesManager())
        .environmentObject(UpdateManager.shared)
}
