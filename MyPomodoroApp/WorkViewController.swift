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
    var maxWorkTime    = 5
    var maxRelaxTime   = 3
    var currentTime    = 0
    var openingLabel = "00:05"

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
            timer.invalidate()
            playButton.setImage(UIImage(named: "playImage"), for: .normal)
            // Timer not started, start it
        } else {
            startTimer()
            isTimerStarted = true
            playButton.setImage(UIImage(named: "pauseImage"), for: .normal)
        }
    }


    @IBAction func stopButtonTapped(_ sender: Any) {
        stopButton.isEnabled = false
        isWorkTimer = true
        stopButton.alpha = 0.5
        playButton.setImage(UIImage(named: "playImage"), for: .normal)
        timer.invalidate()
        currentTime = 5
        isTimerStarted = false
        timerLabel.text = openingLabel
        timerLabel.textColor = .systemRed
    }

    func startTimer() {
        if (!isPaused || !isTimerStarted) {
            currentTime = maxWorkTime
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        if isWorkTimer {
            currentTime -= 1

            // Timer reached zero, start the relax timer
            if currentTime < 0 {
                isWorkTimer = false
                currentTime = maxRelaxTime
                timerLabel.textColor = .systemGreen
            }
        } else {
            currentTime -= 1

            // Timer reached max relax, start the work timer again
            if currentTime < 0 {
                isWorkTimer = true
                timerLabel.textColor = .systemRed
                currentTime = maxWorkTime
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


