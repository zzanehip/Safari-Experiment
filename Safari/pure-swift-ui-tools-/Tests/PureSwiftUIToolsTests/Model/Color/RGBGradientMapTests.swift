//
//  GradientTestTests.swift
//
//  Created by Adam Fordyce on 22/10/2019.
//  Copyright © 2019 Adam Fordyce. All rights reserved.
//

import Foundation
import XCTest

@testable import PureSwiftUITools

private let tolerance = 0.0001

class GradientTestTests: XCTestCase {
    
    func test_interpolatesValues_whenToValueIsLarger() {
        
        let from: Double = 0
        let to: Double = 0.5
        let fraction: Double = 0.1
        
        let result = RGBGradientMap.interpolateValue(from: from, to: to, fraction: fraction)
        
        XCTAssertEqual(result, 0.05, "Interpolated value incorrect")
        
    }
    
    func test_interpolatesValues_whenToValueIsSmaller() {
        
        let from: Double = 0.5
        let to: Double = 0
        let fraction: Double = 0.1
        
        let result = RGBGradientMap.interpolateValue(from: from, to: to, fraction: fraction)
        
        XCTAssertEqual(result, 0.45, "Interpolated value incorrect")
        
    }
    
    
    func test_interpolatesValues_whenToValueIsSame() {
        
        let from: Double = 0.5
        let to: Double = 0.5
        let fraction: Double = 0.1
        
        let result = RGBGradientMap.interpolateValue(from: from, to: to, fraction: fraction)
        
        XCTAssertEqual(result, 0.5, "Interpolated value incorrect")
        
    }
    
    func test_interpolatesColor_whenFromColorIsSmaller() {
        
        var fromColor = RGBColor(0,0,0)
        var toColor = RGBColor(1,1,1)
        var fraction = 0.3
        
        var result = RGBGradientMap.interpolateColor(from: fromColor, to: toColor, fraction: fraction)
        
        XCTAssertEqual(result, RGBColor(0.3, 0.3, 0.3), "Interpolated color incorrect")
        
        fromColor = RGBColor(0.3,0.4,0.5)
        toColor = RGBColor(0.9,0.8,0.7)
        fraction = 0.5
        
        result = RGBGradientMap.interpolateColor(from: fromColor, to: toColor, fraction: fraction)
        
        XCTAssertEqual(result, RGBColor(0.6, 0.6, 0.6), "Interpolated color incorrect")
        
    }
    
    func test_interpolatesColor_whenFromColorIsBigger() {
        
        var fromColor = RGBColor(1,1,1)
        var toColor = RGBColor(0,0,0)
        var fraction = 0.3
        
        var result = RGBGradientMap.interpolateColor(from: fromColor, to: toColor, fraction: fraction)
        
        XCTAssertEqual(result, RGBColor(0.7, 0.7, 0.7), "Interpolated color incorrect")
        
        fromColor = RGBColor(0.9,0.8,0.7)
        toColor = RGBColor(0.3,0.4,0.5)
        fraction = 0.5
        
        result = RGBGradientMap.interpolateColor(from: fromColor, to: toColor, fraction: fraction)
        
        XCTAssertEqual(result, RGBColor(0.6, 0.6, 0.6), "Interpolated color incorrect")
        
    }
    
    func test_calculateStops() {
        
        let colors = [RGBColor(0,0,0), RGBColor(0.5,0.5,0.5), RGBColor(0.7, 0.7, 0.7), RGBColor(1.0, 1.0, 1.0)]
        
        
        let result = RGBGradientMap.calculateStops(colors: colors)
        
        XCTAssertEqual(result.count, 4)
        XCTAssertEqual(result[0], 0, accuracy: tolerance)
        XCTAssertEqual(result[1], 0.333333, accuracy: tolerance)
        XCTAssertEqual(result[2], 0.666666, accuracy: tolerance)
        XCTAssertEqual(result[3], 1, accuracy: tolerance)
    }
    
    func test_calculateGradientMap_whenColorsIncreasing() {
        
        let colors = [RGBColor(0,0,0), RGBColor(0.5,0.5,0.5), RGBColor(1.0, 1.0, 1.0)]
        
        let result = RGBGradientMap.calculateGradientMap(colors: colors, resolution: 10)
        
        XCTAssertEqual(result.count, 10)
        
        XCTAssertEqual(result[0], RGBColor(0,0,0))
        XCTAssertEqual(result[1], RGBColor(0.1,0.1,0.1))
        XCTAssertEqual(result[6], RGBColor(0.6,0.6,0.6))
        XCTAssertEqual(result[9], RGBColor(1,1,1))
    }

    func test_calculateGradientMap_whenColorsRandom() {
        
        let colors = [RGBColor(0,0,0), RGBColor(0.5,0.5,0.5), RGBColor(0.2,0.2,0.2), RGBColor(0.0,0.0,0.0), RGBColor(1.0, 1.0, 1.0)]
        
        let result = RGBGradientMap.calculateGradientMap(colors: colors, resolution: 100)
        
        XCTAssertEqual(result.count, 100)
        
        XCTAssertEqual(result[0], RGBColor(0,0,0))
        XCTAssertEqual(result[24], RGBColor(0.48,0.48,0.48))
        XCTAssertEqual(result[49], RGBColor(0.212,0.212,0.212))
        XCTAssertEqual(result[74], RGBColor(0.008,0.008,0.008))
        XCTAssertEqual(result[99], RGBColor(1,1,1))
    }
}
