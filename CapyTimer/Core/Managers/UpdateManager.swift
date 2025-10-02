//
//  UpdateManager.swift
//  CapyTimer
//
//  Created by Andeph Nguyen on 9/30/25.
//

import Foundation
import SwiftUI

// MARK: - Update Models
struct GitHubRelease: Codable {
    let tagName: String
    let name: String
    let body: String
    let publishedAt: String
    let assets: [GitHubAsset]
    
    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
        case name
        case body
        case publishedAt = "published_at"
        case assets
    }
}

struct GitHubAsset: Codable {
    let name: String
    let downloadUrl: String
    let size: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case downloadUrl = "browser_download_url"
        case size
    }
}

// MARK: - Update Manager
class UpdateManager: ObservableObject {
    static let shared = UpdateManager()
    
    @Published var isCheckingForUpdates = false
    @Published var isDownloading = false
    @Published var downloadProgress: Double = 0.0
    @Published var latestRelease: GitHubRelease?
    @Published var updateAvailable = false
    @Published var errorMessage: String?
    @Published var showUpdateAlert = false
    
    private let githubRepo = "andev0x/CapyTimer"
    private let currentVersion: String
    private var downloadTask: URLSessionDownloadTask?
    
    private init() {
        // Get current app version
        self.currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    // MARK: - Public Methods
    
    func checkForUpdates() {
        guard !isCheckingForUpdates else { return }
        
        isCheckingForUpdates = true
        errorMessage = nil
        
        Task {
            do {
                let release = try await fetchLatestRelease()
                await MainActor.run {
                    self.latestRelease = release
                    self.isCheckingForUpdates = false
                    self.updateAvailable = isNewerVersion(release.tagName)
                    
                    if self.updateAvailable {
                        self.showUpdateAlert = true
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Failed to check for updates: \(error.localizedDescription)"
                    self.isCheckingForUpdates = false
                }
            }
        }
    }
    
    func downloadAndInstallUpdate() {
        guard let release = latestRelease,
              let dmgAsset = release.assets.first(where: { $0.name.hasSuffix(".dmg") }) else {
            errorMessage = "No DMG file found in the latest release"
            return
        }
        
        isDownloading = true
        downloadProgress = 0.0
        
        let documentsPath = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(dmgAsset.name)
        
        // Remove existing file if it exists
        try? FileManager.default.removeItem(at: destinationURL)
        
        downloadTask = URLSession.shared.downloadTask(with: URL(string: dmgAsset.downloadUrl)!) { [weak self] localURL, response, error in
            DispatchQueue.main.async {
                self?.isDownloading = false
                
                if let error = error {
                    self?.errorMessage = "Download failed: \(error.localizedDescription)"
                    return
                }
                
                guard let localURL = localURL else {
                    self?.errorMessage = "Download failed: No local file"
                    return
                }
                
                do {
                    // Move downloaded file to Downloads folder
                    try FileManager.default.moveItem(at: localURL, to: destinationURL)
                    
                    // Open the DMG file
                    NSWorkspace.shared.open(destinationURL)
                    
                    // Show success message
                    self?.showUpdateSuccessAlert()
                    
                } catch {
                    self?.errorMessage = "Failed to save update: \(error.localizedDescription)"
                }
            }
        }
        
        // Monitor download progress
        let observation = downloadTask?.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
            DispatchQueue.main.async {
                self?.downloadProgress = progress.fractionCompleted
            }
        }
        
        downloadTask?.resume()
    }
    
    func skipThisVersion() {
        guard let release = latestRelease else { return }
        UserDefaults.standard.set(release.tagName, forKey: "skippedVersion")
        updateAvailable = false
        showUpdateAlert = false
    }
    
    func remindMeLater() {
        showUpdateAlert = false
        // Schedule a reminder for later (e.g., next app launch)
        UserDefaults.standard.set(Date().addingTimeInterval(24 * 60 * 60), forKey: "nextUpdateCheck")
    }
    
    // MARK: - Private Methods
    
    private func fetchLatestRelease() async throws -> GitHubRelease {
        let url = URL(string: "https://api.github.com/repos/\(githubRepo)/releases/latest")!
        
        var request = URLRequest(url: url)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        request.setValue("CapyTimer/\(currentVersion)", forHTTPHeaderField: "User-Agent")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw UpdateError.networkError
        }
        
        return try JSONDecoder().decode(GitHubRelease.self, from: data)
    }
    
    private func isNewerVersion(_ latestVersion: String) -> Bool {
        // Skip if this version was already skipped
        let skippedVersion = UserDefaults.standard.string(forKey: "skippedVersion")
        if skippedVersion == latestVersion {
            return false
        }
        
        return compareVersions(currentVersion, latestVersion) < 0
    }
    
    private func compareVersions(_ version1: String, _ version2: String) -> Int {
        let v1Components = version1.components(separatedBy: ".").compactMap { Int($0) }
        let v2Components = version2.components(separatedBy: ".").compactMap { Int($0) }
        
        let maxLength = max(v1Components.count, v2Components.count)
        
        for i in 0..<maxLength {
            let v1 = i < v1Components.count ? v1Components[i] : 0
            let v2 = i < v2Components.count ? v2Components[i] : 0
            
            if v1 < v2 { return -1 }
            if v1 > v2 { return 1 }
        }
        
        return 0
    }
    
    private func showUpdateSuccessAlert() {
        let alert = NSAlert()
        alert.messageText = "Update Downloaded"
        alert.informativeText = "The update has been downloaded to your Downloads folder. Please install it manually."
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    // MARK: - Auto-check on launch
    
    func checkForUpdatesOnLaunch() {
        // Check if we should skip the check based on last check time
        if let nextCheckDate = UserDefaults.standard.object(forKey: "nextUpdateCheck") as? Date,
           nextCheckDate > Date() {
            return
        }
        
        // Check for updates in the background
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 2.0) {
            self.checkForUpdates()
        }
    }
}

// MARK: - Update Errors
enum UpdateError: LocalizedError {
    case networkError
    case invalidResponse
    case noUpdateAvailable
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network error occurred while checking for updates"
        case .invalidResponse:
            return "Invalid response from update server"
        case .noUpdateAvailable:
            return "No updates available"
        }
    }
}
