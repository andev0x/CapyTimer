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
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // Timer
                VStack {
                    Text(formatTime(timerManager.remainingTime))
                        .font(.system(size: 32, weight: .bold))
                        .padding(.bottom, 5)
                    
                    HStack {
                        Button(timerManager.isRunning ? "Pause" : "Start") {
                            timerManager.isRunning ? timerManager.stop() : timerManager.start()
                        }
                        Button("Reset") {
                            timerManager.reset()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                Divider()
                
                // Todo
                TodoView()
                
                Divider()
                
                // Notes
                NotesView()
                
                Divider()
                
                // Settings
                SettingsView()
            }
            .padding()
            .frame(width: 260)
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
}
