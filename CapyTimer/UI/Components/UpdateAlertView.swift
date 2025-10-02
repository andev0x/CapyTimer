//
//  UpdateAlertView.swift
//  CapyTimer
//
//  Created by Andeph Nguyen on 9/30/25.
//

import SwiftUI

struct UpdateAlertView: View {
    @EnvironmentObject var updateManager: UpdateManager
    @State private var showDetails = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "arrow.down.circle.fill")
                    .foregroundColor(.orange)
                    .font(.title)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Update Available")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    if let release = updateManager.latestRelease {
                        Text("Version \(release.tagName) is ready to download")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            }
            
            if let release = updateManager.latestRelease {
                VStack(alignment: .leading, spacing: 8) {
                    Text("What's New:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    
                    Text(parseReleaseNotes(release.body))
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            
            HStack(spacing: 12) {
                Button("Download Now") {
                    updateManager.downloadAndInstallUpdate()
                }
                .buttonStyle(.borderedProminent)
                .disabled(updateManager.isDownloading)
                
                Button("View Details") {
                    showDetails = true
                }
                .buttonStyle(.bordered)
                
                Spacer()
                
                Button("Skip This Version") {
                    updateManager.skipThisVersion()
                }
                .buttonStyle(.bordered)
                
                Button("Remind Me Later") {
                    updateManager.remindMeLater()
                }
                .buttonStyle(.bordered)
            }
            
            if updateManager.isDownloading {
                VStack(spacing: 8) {
                    HStack {
                        Text("Downloading...")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(Int(updateManager.downloadProgress * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    ProgressView(value: updateManager.downloadProgress)
                        .progressViewStyle(LinearProgressViewStyle())
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(NSColor.controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(Color.orange.opacity(0.3), lineWidth: 1)
        )
        .sheet(isPresented: $showDetails) {
            if let release = updateManager.latestRelease {
                UpdateDetailsView(release: release)
            }
        }
    }
    
    private func parseReleaseNotes(_ body: String) -> String {
        // Simple parsing to clean up markdown formatting
        return body
            .replacingOccurrences(of: "## ", with: "")
            .replacingOccurrences(of: "### ", with: "")
            .replacingOccurrences(of: "**", with: "")
            .replacingOccurrences(of: "*", with: "")
            .replacingOccurrences(of: "\n", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

#Preview {
    UpdateAlertView()
        .environmentObject(UpdateManager.shared)
        .padding()
}
