//
//  Box.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 22/09/2024.
//

import Foundation

class Box<T> {
    typealias Listener = (T) -> ()
    var value: T {
        didSet {
            listener?(value)
        }
    }
    var listener: Listener?
    init(_ value: T) {
        self.value = value
    }
    func bind(listener: Listener?) {
        self.listener = listener
    }
    func removeBinding() {
        self.listener = nil
    }
}
 
enum CountdownState {
    case suspended
    case running
    case paused
}
