//
//  Extensions.swift
//  NearMe
//
//  Created by Giovanni Corte on 25/05/2021.
//

import Foundation
import SwiftUI

extension Double {
    func distanceInKm() -> Double {
        let distanceInKm = self / 1000
        let roundedDistance: Double = distanceInKm.roundToDecimal(2)
        return roundedDistance
    }
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalize() {
        self = self.capitalizingFirstLetter()
    }
}

extension Color {
    static let mainGreen = Color("mainColor")
}

extension View {
    func getPopupMaxWidth() -> CGFloat {
        let screenRect = UIScreen.main.bounds
        let screenWidth = screenRect.size.width
        return (screenWidth * 2) / 3
    }
    
    func getToolBarHeight()  -> CGFloat {
        let screenRect = UIScreen.main.bounds
        let screenHeight = screenRect.size.height
        return screenHeight / 10
    }
}
