//
//  CapyTimerApp.swift
//  CapyTimer
//
//  Created by Andeph Nguyen on 9/30/25.
//

import SwiftUI

@main
struct CapyTimerApp: App {
    @StateObject private var timerManager = TimerManager()
    @StateObject private var todoManager = TodoManager()
    @StateObject private var notesManager = NotesManager()
    @StateObject private var updateManager = UpdateManager.shared
    
    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(timerManager)
                .environmentObject(todoManager)
                .environmentObject(notesManager)
                .environmentObject(updateManager)
                .frame(width: 320, height: 420)
                .padding()
                .onAppear {
                    // Check for updates on launch if enabled
                    if UserDefaults.standard.bool(forKey: "checkForUpdatesOnLaunch") {
                        updateManager.checkForUpdatesOnLaunch()
                    }
                }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "timer")
                Text("\(formatTime(timerManager.remainingTime))")
                    .font(.system(.body, design: .monospaced))
            }
        }
        .menuBarExtraStyle(.window)
    }
}

// MARK: - Time Formatter
func formatTime(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let secs = seconds % 60
    return String(format: "%02d:%02d", minutes, secs)
}
