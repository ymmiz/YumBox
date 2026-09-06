//
//  TimerViewModel.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 22/09/2024.
//

import Foundation

class TimerViewModel {
    
    var hours = Box(0)
    var minutes = Box(0)
    var seconds = Box(0)
    
    func setHours(to value: Int) {
        self.hours.value = value
    }
    
    func setMinutes(to value: Int) {
        var newMinutes = value
        if (value >= 60) {
            newMinutes -= 60
            hours.value += 1
        }
        self.minutes.value = newMinutes
    }
    
    func setSeconds(to value: Int) {
        var newSeconds = value
        if (value >= 60) {
            newSeconds -= 60
            minutes.value += 1
        }
        if (minutes.value >= 60) {
            minutes.value -= 60
            hours.value += 1
        }
        self.seconds.value = newSeconds
    }
    
    func getHours() -> Box<Int> {
        return self.hours
    }
    
    func getMinutes() -> Box<Int> {
        return self.minutes
    }
    
    func getSeconds() -> Box<Int> {
        return self.seconds
    }
    
    func computeSeconds() -> Int {
        return (hours.value * 3600) + (minutes.value * 60) + seconds.value
    }
    
    func isValid() -> Bool {
        if (self.seconds.value > 0 || self.minutes.value > 0 || self.hours.value > 0) {
            return true
        }
        return false
    }
}
