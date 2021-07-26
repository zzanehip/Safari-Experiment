//
//  RGBColor.swift
//
//  Created by Adam Fordyce on 22/10/2019.
//  Copyright © 2019 Adam Fordyce. All rights reserved.
//

import PureSwiftUI

import SwiftUI

public struct RGBA: Hashable {
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double
    
    public init(_ r: Double, _ g: Double, _ b: Double, _ a: Double = 1) {
        self.red = r
        self.green = g
        self.blue = b
        self.alpha = a
    }
    
    private static let equalsTolerance = 0.0001
    
    public static func == (lhs: RGBA, rhs: RGBA) -> Bool {
        return abs(lhs.red - rhs.red) <= equalsTolerance &&
            abs(lhs.green - rhs.green) <= equalsTolerance &&
            abs(lhs.blue - rhs.blue) <= equalsTolerance
    }
}

// MARK: ----- INTERPOLATION

public extension RGBA {

    func interpolate(to targetColor: RGBA, fraction: Double) -> RGBA {
        Self.interpolateColor(from: self, to: targetColor, fraction: fraction)
    }

    static func interpolateColor(from: RGBA, to: RGBA, fraction: Double) -> RGBA {

        return RGBA(
            interpolateValue(from: from.red, to: to.red, fraction: fraction),
            interpolateValue(from: from.green, to: to.green, fraction: fraction),
            interpolateValue(from: from.blue, to: to.blue, fraction: fraction),
            interpolateValue(from: from.alpha, to: to.alpha, fraction: fraction)
        )
    }

    static func interpolateValue(from: Double, to: Double, fraction: Double) -> Double {

        let range = to - from
        let fractionalRange = range * fraction
        return from + fractionalRange
    }
}

// MARK: ----- SYSTEM COLORS

public extension RGBA {

    // SwiftUI colors
    static let white = RGBA(1, 1, 1)
    static let black = RGBA(0, 0, 0)
    static let gray = RGBA(142 / 255, 142 / 255, 142 / 255)
    static let red = RGBA(1,58 / 255, 48 / 255)
    static let green = RGBA(52.0 / 255 , 199.0 / 255, 89.0 / 255)
    static let blue = RGBA(0, 122 / 255, 1)
    static let orange = RGBA(1, 149 / 255, 0)
    static let yellow = RGBA(1, 204 / 255, 1.0 / 255)
    static let pink = RGBA(1, 44 / 255, 85 / 255)
    static let purple = RGBA(175 / 255, 82 / 255, 222 / 255)
    static let clear = RGBA(0, 0, 0, 0)
    
    // pure colors
    static let pureRed = RGBA(1, 0, 0)
    static let pureGreen = RGBA(0, 1, 0)
    static let pureBlue = RGBA(0, 0, 1)
    static let pureYellow = RGBA(1, 1, 0)
    static let pureMagenta = RGBA(1, 0, 1)
    static let pureOrange = RGBA(1, 0.5, 0)
    static let purePurple = RGBA(0.5, 0, 0.5)
}

// MARK: ----- OPACITY

public extension RGBA {

    func withRed(_ value: Double) -> RGBA {
        var newRGB = self
        newRGB.red = value
        return newRGB
    }
    
    func withGreen(_ value: Double) -> RGBA {
        var newRGB = self
        newRGB.green = value
        return newRGB
    }
    
    func withBlue(_ value: Double) -> RGBA {
        var newRGB = self
        newRGB.blue = value
        return newRGB
    }

    func withOpacity(_ value: Double) -> RGBA {
        var newRGB = self
        newRGB.alpha = value
        return newRGB
    }
}

// MARK: ----- TYPE COERCION

public extension RGBA {
    
    var asColor: Color {
        Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
    }
    
    var asCGColor: CGColor {
        CGColor(srgbRed: red.asCGFloat, green: green.asCGFloat, blue: blue.asCGFloat, alpha: alpha.asCGFloat)
    }

    #if !os(watchOS)
    #if canImport(UIKit)
    var asUIColor: UIColor {
        UIColor(ciColor: asCIColor)
    }
    #endif

    var asCIColor: CIColor {
        CIColor(red: red.asCGFloat, green: green.asCGFloat, blue: blue.asCGFloat, alpha: alpha.asCGFloat)
    }
    #else
    var asUIColor: UIColor {
      UIColor(cgColor: asCGColor)
    }
    #endif
}

// MARK: ----- FOUNDATION EXTENSIONS

#if !os(watchOS)
public extension CIColor {
    
    var asRGBA: RGBA {
        return RGBA(self.red.asDouble, self.green.asDouble, self.blue.asDouble, self.alpha.asDouble)
    }
}

#if canImport(UIKit)
public extension UIColor {
    
    var asRGBA: RGBA {
        CIColor(color: self).asRGBA
    }
}
#endif

public extension CGColor {
    
    static let clear = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0)
    
    var asRGBA: RGBA {
        CIColor(cgColor: self).asRGBA
    }
}
#endif
