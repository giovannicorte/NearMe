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
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        if shouldHide { hidden() }
        else { self }
    }
}

extension Color {
    
    static let mainGreen = Color("mainColor")
    
}
