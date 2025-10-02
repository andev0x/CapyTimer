//
//  UpdateView.swift
//  CapyTimer
//
//  Created by Andeph Nguyen on 9/30/25.
//

import SwiftUI

struct UpdateView: View {
    @EnvironmentObject var updateManager: UpdateManager
    @State private var showUpdateDetails = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "arrow.clockwise.circle")
                    .foregroundColor(.accentColor)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Updates")
                        .font(.headline)
                    Text(updateManager.updateAvailable ? "Update Available" : "Up to Date")
                        .font(.caption)
                        .foregroundColor(updateManager.updateAvailable ? .orange : .green)
                }
                
                Spacer()
                
                if updateManager.isCheckingForUpdates {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Button("Check") {
                        updateManager.checkForUpdates()
                    }
                    .buttonStyle(.bordered)
                    .disabled(updateManager.isCheckingForUpdates)
                }
            }
            
            if updateManager.updateAvailable, let release = updateManager.latestRelease {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Version \(release.tagName)")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        Button("View Details") {
                            showUpdateDetails = true
                        }
                        .buttonStyle(.link)
                        .font(.caption)
                    }
                    
                    if updateManager.isDownloading {
                        VStack(alignment: .leading, spacing: 4) {
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
                    } else {
                        HStack(spacing: 8) {
                            Button("Download Update") {
                                updateManager.downloadAndInstallUpdate()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(updateManager.isDownloading)
                            
                            Button("Skip This Version") {
                                updateManager.skipThisVersion()
                            }
                            .buttonStyle(.bordered)
                            
                            Button("Remind Me Later") {
                                updateManager.remindMeLater()
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                }
                .padding(.top, 4)
            }
            
            if let errorMessage = updateManager.errorMessage {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.red)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.red)
                }
                .padding(.top, 4)
            }
        }
        .sheet(isPresented: $showUpdateDetails) {
            UpdateDetailsView(release: updateManager.latestRelease)
        }
    }
}

struct UpdateDetailsView: View {
    let release: GitHubRelease?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                if let release = release {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Version \(release.tagName)")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Released: \(formatDate(release.publishedAt))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    ScrollView {
                        Text(parseReleaseNotes(release.body))
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 300)
                    
                    if !release.assets.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Downloads")
                                .font(.headline)
                            
                            ForEach(release.assets, id: \.name) { asset in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(asset.name)
                                            .font(.subheadline)
                                        Text(formatFileSize(asset.size))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    Button("Download") {
                                        if let url = URL(string: asset.downloadUrl) {
                                            NSWorkspace.shared.open(url)
                                        }
                                    }
                                    .buttonStyle(.bordered)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                } else {
                    Text("No release information available")
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding()
            .frame(width: 500, height: 400)
            .navigationTitle("Update Details")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        
        return dateString
    }
    
    private func formatFileSize(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    private func parseReleaseNotes(_ body: String) -> String {
        // Simple parsing to clean up markdown formatting
        return body
            .replacingOccurrences(of: "## ", with: "")
            .replacingOccurrences(of: "### ", with: "")
            .replacingOccurrences(of: "**", with: "")
            .replacingOccurrences(of: "*", with: "")
    }
}

#Preview {
    UpdateView()
        .environmentObject(UpdateManager.shared)
        .padding()
}
