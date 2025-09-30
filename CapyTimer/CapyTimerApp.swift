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
    
    var body: some Scene {
        MenuBarExtra("CapyTimer", systemImage: "timer") {
            ContentView()
                .environmentObject(timerManager)
                .environmentObject(todoManager)
                .environmentObject(notesManager)
        }
    }
}
