//
//  TimerStartViewController.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 22/09/2024.
//

import UIKit
import AVFoundation
 
class TimerStartViewController: UIViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var timerContainerView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var pauseResumeView: UIView!
    @IBOutlet weak var resetView: UIView!
    @IBOutlet weak var pauseResumeButton: UIButton!
    var startTime: Date?
    var pauseTime: Date?
    var timerSeconds = 0
    var totalSeconds = 0 {
        didSet {
            timerSeconds = totalSeconds
        }
    }
    var player: AVAudioPlayer?

    lazy var timerEndAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 0
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = true
        return strokeEnd
    }()
    
    lazy var timerResetAnimation: CABasicAnimation = {
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        strokeEnd.toValue = 1
        strokeEnd.duration = 1
        strokeEnd.fillMode = .forwards
        strokeEnd.isRemovedOnCompletion = false
        return strokeEnd
    }()
    
    let timeAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .bold), .foregroundColor: UIColor.black]
    let semiBoldAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .bold), .foregroundColor: UIColor.black]
    let timerTrackLayer = CAShapeLayer()
    let timerCircleFillLayer = CAShapeLayer()
    var timerState: CountdownState = .suspended
    var countdownTimer = Timer()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        [pauseResumeView, resetView].forEach {
            guard let view = $0 else { return }
            view.layer.opacity = 0
            view.isUserInteractionEnabled = false
        }
        [playView, pauseResumeView, resetView].forEach { $0?.layer.cornerRadius = 17 }
        timerView.transform = timerView.transform.rotated(by: 270.degreeToRadians())
        timerLabel.transform = timerLabel.transform.rotated(by: 90.degreeToRadians())
        timerContainerView.transform = timerContainerView.transform.rotated(by: 90.degreeToRadians())
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appWillEnterForeground() {
        guard timerState == .running, let startTime = startTime else { return }
        
        let elapsedTime = Date().timeIntervalSince(startTime)
        let remainingTime = max(Double(totalSeconds) - elapsedTime, 0)
        let strokeProgress = CGFloat(remainingTime) / CGFloat(totalSeconds)
        timerCircleFillLayer.strokeEnd = strokeProgress
        timerEndAnimation.duration = remainingTime
        timerCircleFillLayer.add(timerEndAnimation, forKey: "timerEnd")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.setupLayers()
            self.updateLabels()
        }
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        self.timerTrackLayer.removeFromSuperlayer()
        self.timerCircleFillLayer.removeFromSuperlayer()
        countdownTimer.invalidate()
        self.dismiss(animated: true)
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        guard timerState == .suspended else { return }
        self.timerEndAnimation.duration = Double(self.totalSeconds)
        animatePauseButton(symbolName: "pause.fill")
        animatePlayPauseResetViews(timerPlaying: false)
        startTimer()
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        self.timerState = .suspended
        self.timerSeconds = self.totalSeconds
        resetTimer()
        self.timerCircleFillLayer.add(timerResetAnimation, forKey: "reset")
        animatePauseButton(symbolName: "play.fill")
        animatePlayPauseResetViews(timerPlaying: true)
    }
    
    @IBAction func pauseResumeButtonPressed(_ sender: Any) {
        switch timerState {
        case .running:
            self.timerState = .paused
            self.pauseTime = Date()
            self.timerCircleFillLayer.strokeEnd = CGFloat(timerSeconds) / CGFloat(totalSeconds)
            self.resetTimer()
            
            animatePauseButton(symbolName: "play.fill")
        case .paused:
            if timerSeconds <= 0 {
                timerSeconds = totalSeconds  // Reset the timer if it's finished
                self.timerCircleFillLayer.strokeEnd = CGFloat(timerSeconds) / CGFloat(totalSeconds)
            }
            self.timerState = .running
            self.timerEndAnimation.duration = Double(self.totalSeconds) + 1
            self.startTimer()
            animatePauseButton(symbolName: "pause.fill")
        default: break
        }
    }
    
    func setupLayers() {
        let radius = self.timerView.frame.width < self.timerView.frame.height ? self.timerView.frame.width / 2 : self.timerView.frame.height / 2
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: timerView.frame.height / 2, y: timerView.frame.width / 2), radius: radius, startAngle: 0, endAngle: 360.degreeToRadians(), clockwise: true)
        self.timerTrackLayer.path = arcPath.cgPath
        self.timerTrackLayer.strokeColor = UIColor.white.cgColor
        self.timerTrackLayer.lineWidth = 20
        self.timerTrackLayer.fillColor = UIColor.clear.cgColor
        self.timerTrackLayer.lineCap = .round
        self.timerCircleFillLayer.path = arcPath.cgPath
        self.timerCircleFillLayer.strokeColor = UIColor.gray.cgColor
        self.timerCircleFillLayer.lineWidth = 21
        self.timerCircleFillLayer.fillColor = UIColor.clear.cgColor
        self.timerCircleFillLayer.lineCap = .round
        self.timerCircleFillLayer.strokeEnd = 1
        self.timerView.layer.addSublayer(timerTrackLayer)
        self.timerView.layer.addSublayer(timerCircleFillLayer)
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.timerContainerView.layer.cornerRadius = self.timerContainerView.frame.width / 2
        }
    }
    
    func animatePauseButton(symbolName: String) {
        UIView.transition(with: pauseResumeView, duration: 0.3, options: .transitionCrossDissolve) {
            self.pauseResumeButton.setImage(UIImage(systemName: symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)), for: .normal)
        }
    }
    
    func animatePlayPauseResetViews(timerPlaying: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.playView.layer.opacity = timerPlaying ? 1 : 0
            self.pauseResumeView.layer.opacity = timerPlaying ? 0 : 1
            self.resetView.layer.opacity = timerPlaying ? 0 : 1
        } completion: { [weak self] _ in
            [self?.pauseResumeView, self?.resetView].forEach {
                guard let view = $0 else { return }
                view.isUserInteractionEnabled = timerPlaying ? false : true
            }
        }
    }
    
    func startTimer() {
        startTime = Date()
        updateLabels()
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.timerSeconds -= 1
            self.updateLabels()
            if (self.timerSeconds == 0) {
                self.resetTimer()
                //self.playSound()
                DispatchQueue.main.async {
                    self.playSound()
                }
            }
        }
        self.timerState = .running
        self.timerCircleFillLayer.add(self.timerEndAnimation, forKey: "timerEnd")
    }
    
    func updateLabels() {
        let seconds = self.timerSeconds % 60
        let minutes = self.timerSeconds / 60 % 60
        let hours = self.timerSeconds / 3600
        if hours > 0 {
            let hoursCount = String(hours).count
            let minutesCount = String(minutes).count
            let secondsCount = String(seconds).count
            let timeString = "\(hours)h \(minutes)m \(seconds.appendZeroes())s"
            let attributedString = NSMutableAttributedString(string: timeString, attributes: semiBoldAttributes)
            attributedString.addAttributes(timeAttributes, range: NSRange(location: 0, length: hoursCount))
            attributedString.addAttributes(timeAttributes, range: NSRange(location: hoursCount + 2, length: minutesCount))
            attributedString.addAttributes(timeAttributes, range: NSRange(location: hoursCount + 2 + minutesCount + 2, length: secondsCount))
            self.timerLabel.attributedText = attributedString
        } else {
            let minutesCount = String(minutes).count
            let secondsCount = String(seconds.appendZeroes()).count
            let timeString = "\(minutes)m  \(seconds.appendZeroes())s"
            let attributedString = NSMutableAttributedString(string: timeString, attributes: semiBoldAttributes)
            attributedString.addAttributes(timeAttributes, range: NSRange(location: 0, length: minutesCount))
            attributedString.addAttributes(timeAttributes, range: NSRange(location: minutesCount + 3, length: secondsCount))
            self.timerLabel.attributedText = attributedString
        }
    }
    
    func resetTimer() {
        self.countdownTimer.invalidate()
        self.timerCircleFillLayer.removeAllAnimations()
        updateLabels()
    }
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "timer", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
