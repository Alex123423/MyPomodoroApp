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
    var time = 1500

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        stopButton.isEnabled = true
        stopButton.alpha = 1
        if !isTimerStarted {
            startTimer()
            isTimerStarted = true
            playButton.setImage(UIImage(named: "pauseImage"), for: .normal)
        } else {
            timer.invalidate()
            isTimerStarted = false
            playButton.setImage(UIImage(named: "playImage"), for: .normal)
        }
    }


    @IBAction func stopButtonTapped(_ sender: Any) {
        stopButton.isEnabled = true
        stopButton.alpha = 0.5
        timer.invalidate()
        time = 1500
        isTimerStarted = false
        timerLabel.text = "25:00"
    }

    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }

    @objc func updateTimer() {
        time -= 1
        timerLabel.text = formatTime()
    }

    func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }

}


