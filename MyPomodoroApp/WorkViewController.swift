//
//  WorkViewController.swift
//  MyPomodoroApp
//
//  Created by Alexey Davidenko on 20.01.2022.
//

import UIKit

class WorkViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!

    var timer = Timer()
    var isTimerStarted = false
    var isWorkTimer    = true
    var isPaused       = false
    var maxWorkTime    = Timer.Metrics.workTime
    var maxRelaxTime   = Timer.Metrics.restTime
    var currentTime    = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        // Ensure stop button is accessible
        stopButton.isEnabled = true
        stopButton.alpha = 1

        // Timer started, act as pause button
        if isTimerStarted {
            isPaused = true
            isTimerStarted = false
            timer.invalidate()
            playButton.setImage(UIImage(named: "playImage"), for: .normal)
            // Timer not started, start it.
        } else {
            startTimer()
            isPaused = false
            isTimerStarted = true
            playButton.setImage(UIImage(named: "pauseImage"), for: .normal)
        }
    }

    @IBAction func stopButtonTapped(_ sender: Any) {
        stopButton.alpha = 0.5
        playButton.setImage(UIImage(named: "playImage"), for: .normal)
        timerLabel.textColor = .systemRed
        timer.invalidate()
        currentTime = Timer.Metrics.workTime
        isWorkTimer = true
        isTimerStarted = false
        timerLabel.text = Timer.Labels.workLabel
    }

    func startTimer() {
        if (!isPaused || !isTimerStarted) && timerLabel.textColor == .systemRed {
            currentTime = maxWorkTime
        } else if (!isPaused || !isTimerStarted) && timerLabel.textColor == .systemGreen {
            currentTime = maxRelaxTime
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        if isWorkTimer {
            currentTime -= 1

            // Timer reached zero, start the relax timer
            if (currentTime < 0) {
                currentTime = Timer.Metrics.restTime
                isWorkTimer = false
                isTimerStarted = false
                timer.invalidate()
                playButton.setImage(UIImage(named: "playImage"), for: .normal)
                timerLabel.textColor = .systemGreen
            }
        } else {
            currentTime -= 1

            // Timer reached max relax, start the work timer again
            if (currentTime < 0) {
                currentTime = Timer.Metrics.workTime
                isWorkTimer = true
                isTimerStarted = false
                timer.invalidate()
                playButton.setImage(UIImage(named: "playImage"), for: .normal)
                timerLabel.textColor = .systemRed
            }
        }

        timerLabel.text = formatTime()
    }

    func formatTime() -> String {
        let minutes = Int(currentTime) / 60 % 60
        let seconds = Int(currentTime) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}

extension Timer {
    enum Metrics {
        static let workTime = 5
        static let restTime = 3
    }

    enum Labels {
        static let workLabel = "00:05"
    }
}
