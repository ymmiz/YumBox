//
//  TimerViewController.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 22/09/2024.
//

import UIKit

class TimerViewController: UIViewController {
    
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var startButton: UIButton!
    var timerViewModel: TimerViewModel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timerViewModel = TimerViewModel()
        [self.hourTextField, self.minuteTextField, self.secondTextField].forEach {
            $0?.attributedPlaceholder = NSAttributedString(string: "00", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 48, weight: .bold), NSAttributedString.Key.foregroundColor: UIColor.black])
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(Self.textFieldInputChanged(_:)), for: .editingChanged)
        }
        self.disableButton()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Self.viewTapped(_:)))
        self.view.addGestureRecognizer(tapGesture)
        self.timerViewModel.getHours().bind { hours in
            self.hourTextField.text = hours.appendZeroes()
        }
        self.timerViewModel.getMinutes().bind { minutes in
            self.minuteTextField.text = minutes.appendZeroes()
        }
        self.timerViewModel.getSeconds().bind { seconds in
            self.secondTextField.text = seconds.appendZeroes()
        }
    }
    
    @objc func textFieldInputChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if (textField == hourTextField) {
            guard let hours = Int(text) else { return }
            self.timerViewModel.setHours(to: hours)
        } else if (textField == minuteTextField) {
            guard let minutes = Int(text) else { return }
            self.timerViewModel.setMinutes(to: minutes)
        } else {
            guard let seconds = Int(text) else { return }
            self.timerViewModel.setSeconds(to: seconds)
        }
        if timerViewModel.isValid() {
            enableButton()
        } else {
            disableButton()
        }
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc func enableButton() {
        if (self.startButton.isUserInteractionEnabled == false) {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.startButton.layer.opacity = 1
            } completion: { _ in
                self.startButton.isUserInteractionEnabled.toggle()
            }
        }
    }
    
    @objc func disableButton() {
        if (self.startButton.isUserInteractionEnabled) {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.startButton.layer.opacity = 0.25
            } completion: { _ in
                self.startButton.isUserInteractionEnabled.toggle()
            }
        }
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        guard let timerStartVC = self.storyboard?.instantiateViewController(withIdentifier: "timerStartVC") as? TimerStartViewController else { return }
        timerStartVC.totalSeconds = timerViewModel.computeSeconds()
        self.present(timerStartVC, animated: true)
    }
}
 
extension TimerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 2
        let currentText: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentText.replacingCharacters(in: range, with: string) as NSString
        guard let text = textField.text else { return false }
        if (text.count == 2 && text.starts(with: "0")) {
            textField.text?.removeFirst()
            textField.text? += string
            self.textFieldInputChanged(textField)
        }
        return newString.length <= maxLength
    }
}
