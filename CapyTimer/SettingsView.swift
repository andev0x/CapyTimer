//
//  SettingsView.swift
//  CapyTimer
//
//  Created by Andeph Nguyen on 9/30/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var timerManager: TimerManager
    @State private var focusMinutes: String = ""
    @State private var breakMinutes: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Focus (min)")
                    .frame(width: 90, alignment: .leading)
                TextField("25", text: $focusMinutes)
                    .frame(width: 60)
                    .textFieldStyle(CompactTextFieldStyle())
            }
            HStack {
                Text("Break (min)")
                    .frame(width: 90, alignment: .leading)
                TextField("5", text: $breakMinutes)
                    .frame(width: 60)
                    .textFieldStyle(CompactTextFieldStyle())
            }
            HStack(spacing: 8) {
                Button("Save") { save() }
                    .buttonStyle(.borderedProminent)
                Button("Reset Defaults") { resetDefaults() }
                    .buttonStyle(.bordered)
            }
            .padding(.top, 4)
        }
        .onAppear(perform: load)
    }
    
    private func load() {
        focusMinutes = String(timerManager.focusDuration / 60)
        breakMinutes = String(timerManager.breakDuration / 60)
    }
    
    private func save() {
        if let f = Int(focusMinutes) { timerManager.focusDuration = max(1, f) * 60 }
        if let b = Int(breakMinutes) { timerManager.breakDuration = max(1, b) * 60 }
        timerManager.reset()
    }
    
    private func resetDefaults() {
        timerManager.focusDuration = 25 * 60
        timerManager.breakDuration = 5 * 60
        load()
        timerManager.reset()
    }
}
