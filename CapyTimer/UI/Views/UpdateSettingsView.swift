//
//  UpdateSettingsView.swift
//  CapyTimer
//
//  Created by Andeph Nguyen on 9/30/25.
//

import SwiftUI

struct UpdateSettingsView: View {
    @EnvironmentObject var updateManager: UpdateManager
    @AppStorage("autoCheckForUpdates") private var autoCheckForUpdates = true
    @AppStorage("checkForUpdatesOnLaunch") private var checkForUpdatesOnLaunch = true
    @AppStorage("updateCheckInterval") private var updateCheckInterval = 24 // hours
    
    private let checkIntervals = [
        (1, "Daily"),
        (7, "Weekly"),
        (30, "Monthly"),
        (0, "Never")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Auto-update settings
            VStack(alignment: .leading, spacing: 12) {
                Text("Automatic Updates")
                    .font(.headline)
                
                Toggle("Check for updates automatically", isOn: $autoCheckForUpdates)
                    .toggleStyle(SwitchToggleStyle())
                
                if autoCheckForUpdates {
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Check on app launch", isOn: $checkForUpdatesOnLaunch)
                            .toggleStyle(SwitchToggleStyle())
                        
                        HStack {
                            Text("Check interval:")
                                .font(.subheadline)
                            
                            Picker("Check interval", selection: $updateCheckInterval) {
                                ForEach(checkIntervals, id: \.0) { interval, label in
                                    Text(label).tag(interval)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(width: 120)
                        }
                    }
                    .padding(.leading, 20)
                }
            }
            
            Divider()
            
            // Manual update controls
            VStack(alignment: .leading, spacing: 12) {
                Text("Manual Update Check")
                    .font(.headline)
                
                HStack {
                    Button("Check Now") {
                        updateManager.checkForUpdates()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(updateManager.isCheckingForUpdates)
                    
                    if updateManager.isCheckingForUpdates {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                    
                    Spacer()
                    
                    Text("Current Version: \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Update status
            if updateManager.updateAvailable {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.orange)
                        Text("Update Available")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    if let release = updateManager.latestRelease {
                        Text("Version \(release.tagName) is available")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } else if !updateManager.isCheckingForUpdates {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("You're up to date!")
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
            }
            
            // Error message
            if let errorMessage = updateManager.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding(.top, 8)
            }
        }
        .onChange(of: autoCheckForUpdates) { newValue in
            if newValue {
                // Schedule next check
                scheduleNextUpdateCheck()
            } else {
                // Cancel scheduled checks
                UserDefaults.standard.removeObject(forKey: "nextUpdateCheck")
            }
        }
        .onChange(of: updateCheckInterval) { _ in
            if autoCheckForUpdates {
                scheduleNextUpdateCheck()
            }
        }
    }
    
    private func scheduleNextUpdateCheck() {
        guard autoCheckForUpdates && updateCheckInterval > 0 else { return }
        
        let nextCheck = Date().addingTimeInterval(TimeInterval(updateCheckInterval * 60 * 60))
        UserDefaults.standard.set(nextCheck, forKey: "nextUpdateCheck")
    }
}

#Preview {
    UpdateSettingsView()
        .environmentObject(UpdateManager.shared)
        .padding()
}
