//
//  FoundationExtension.swift
//  YumBox
//
//  Created by Zin Mie Mie Thet on 22/09/2024.
//

import Foundation

extension Int {
    func appendZeroes() -> String {
        if (self < 10) {
            return "0\(self)"
        } else {
            return "\(self)"
        }
    }
}
 
extension Double {
    func degreeToRadians() -> CGFloat {
        return CGFloat(self * .pi) / 180
    }
}

