//
//  TimerManager.swift
//  CapyTimer
//
//  Created by Andeph Nguyen on 9/30/25.
//

import Foundation
import UserNotifications
import AVFoundation

class TimerManager: ObservableObject {
    @Published var remainingTime: Int = 25 * 60
    @Published var isRunning = false
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer?   // Keep a reference to the player

    var focusDuration = 25 * 60
    var breakDuration = 5 * 60

    func start() {
        guard !isRunning else { return }
        isRunning = true
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.stop()
                NotificationManager.shared.sendNotification(
                    title: "Pomodoro Finished",
                    body: "Time for a break!"
                )
                self.playSound()
            }
        }
    }

    func stop() {
        isRunning = false
        timer?.invalidate()
        timer = nil
    }

    func reset(to focus: Bool = true) {
        stop()
        remainingTime = focus ? focusDuration : breakDuration
    }

    // MARK: - Play Sound
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "capysound", withExtension: "wav") else {
            print("⚠️ Could not find capysound.mp3 in the app bundle")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("⚠️ Failed to play sound: \(error.localizedDescription)")
        }
    }
}
