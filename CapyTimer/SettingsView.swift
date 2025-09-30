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
        VStack(alignment: .leading) {
            Text("Settings")
                .font(.headline)
            
            HStack {
                Text("Focus (minutes):")
                TextField("", text: $focusMinutes)
                    .frame(width: 50)
                    .textFieldStyle(.roundedBorder)
            }
            
            HStack {
                Text("Break (minutes):")
                TextField("", text: $breakMinutes)
                    .frame(width: 50)
                    .textFieldStyle(.roundedBorder)
            }
            
            Button("Save") {
                if let f = Int(focusMinutes) {
                    timerManager.focusDuration = f * 60
                }
                if let b = Int(breakMinutes) {
                    timerManager.breakDuration = b * 60
                }
                timerManager.reset()
            }
            .padding(.top, 5)
        }
        .onAppear {
            focusMinutes = String(timerManager.focusDuration / 60)
            breakMinutes = String(timerManager.breakDuration / 60)
        }
    }
}
