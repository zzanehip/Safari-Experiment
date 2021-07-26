//
//  GradientMap.swift
//
//  Created by Adam Fordyce on 22/10/2019.
//  Copyright © 2019 Adam Fordyce. All rights reserved.
//

public struct GradientMap {
    
    private var internalGradientMap: [(color: Color, rgba: RGBA)]
    
    public var count: Int {
        self.internalGradientMap.count
    }
    
    public init(_ colors: [RGBA], withResolution resolution: Int) {
        self.internalGradientMap = GradientMap.calculateGradientMap(colors: colors, resolution: resolution)
    }
    
    public subscript(index: Int) -> Color? {
        get {
            return internalMapValue(at: index)?.color
        }
    }
    
    public subscript(index: Int, default defaultColor: Color) -> Color {
        get {
            self[index] ?? defaultColor
        }
    }
    
    private func internalMapValue(at index: Int) -> (color: Color, rgba: RGBA)? {
        if index > internalGradientMap.count - 1 || index < 0 {
            return nil
        } else {
            return internalGradientMap[index]
        }
    }
    
    public static func calculateGradientMap(colors: [RGBA], resolution: Int) -> [(color: Color, rgba: RGBA)] {
        
        var toReturn = [(color: Color, rgba: RGBA)]()
        
        let stops = GradientMap.calculateStops(colors: colors)
        
        toReturn.append((colors.first!.asColor, colors.first!))
        
        let deltaPerPoint = 1 / resolution.asDouble
        
        for point in 1..<(resolution - 1) {
            
            let fraction = deltaPerPoint * point.asDouble
            let colorToInterpolate: (from: RGBA, to: RGBA, fraction: Double) = calculateInterpolationColors(colors: colors, stops: stops, fraction: fraction)
            
            let rgba = colorToInterpolate.from.interpolate(to: colorToInterpolate.to, fraction: colorToInterpolate.fraction)
            
            toReturn.append((rgba.asColor, rgba))
        }
        toReturn.append((colors.last!.asColor, colors.last!))
        
        return toReturn
    }
    
    public static func calculateStops(colors: [RGBA]) -> [Double] {
            
        let fractionPerStop = 1 / (colors.count.asDouble - 1)
        
        var stops = [Double]()
        
        stops.append(0)
        for i in 1..<(colors.count - 1) {
            stops.append(fractionPerStop * i.asDouble)
        }
        stops.append(1)
        
        return stops
    }
    
    public static func calculateInterpolationColors(colors: [RGBA], stops: [Double], fraction: Double) -> (RGBA, RGBA, Double) {
        
        var startIndex = 0
        var endIndex = stops.count - 1
        
        for i in 1..<stops.count {
            
            if stops[i] < fraction {
                startIndex = i
            } else {
                endIndex = i
                break
            }
        }
        let startFraction = stops[startIndex]
        let endFraction = stops[endIndex]
        let relativeFraction = (fraction - startFraction) / (endFraction - startFraction)
        
        return (colors[startIndex], colors[endIndex], relativeFraction)
    }
}

// MARK: ----- ACCESSORS FOR COLOR TYPES

public extension GradientMap {

    private func fractionAsIndex(_ fraction: Double) -> Int {
        (fraction * (count - 1).asDouble).asInt
    }
    
    func colorAt(_ fraction: Double, default defaultColor: Color = .clear) -> Color {
        self[fractionAsIndex(fraction)] ?? defaultColor
    }

    func colorAt(index: Int, default defaultColor: Color = .clear) -> Color {
        self[index] ?? defaultColor
    }
    
    func rgbaAt(_ fraction: Double, default defaultColor: RGBA = .clear) -> RGBA {
        internalMapValue(at: fractionAsIndex(fraction))?.rgba ?? defaultColor
    }

    func rgbaAt(index: Int, default defaultColor: RGBA = .clear) -> RGBA {
        internalMapValue(at: index)?.rgba ?? defaultColor
    }

    #if !os(watchOS)
    func ciColorAt(_ fraction: Double, default defaultColor: CIColor = .clear) -> CIColor {
        internalMapValue(at: fractionAsIndex(fraction))?.rgba.asCIColor ?? defaultColor
    }

    func ciColorAt(index: Int, default defaultColor: CIColor = .clear) -> CIColor {
        internalMapValue(at: index)?.rgba.asCIColor ?? defaultColor
    }
    #endif

    #if canImport(UIKit)
    func uiColorAt(_ fraction: Double, default defaultColor: UIColor = .clear) -> UIColor {
        internalMapValue(at: fractionAsIndex(fraction))?.rgba.asUIColor ?? defaultColor
    }

    func uiColorAt(index: Int, default defaultColor: UIColor = .clear) -> UIColor {
        internalMapValue(at: index)?.rgba.asUIColor ?? defaultColor
    }
    #endif

    #if !os(watchOS)
    func cgColorAt(_ fraction: Double, default defaultColor: CGColor = .clear) -> CGColor {
        internalMapValue(at: fractionAsIndex(fraction))?.rgba.asCGColor ?? defaultColor
    }

    func cgColorAt(index: Int, default defaultColor: CGColor = .clear) -> CGColor {
        internalMapValue(at: index)?.rgba.asCGColor ?? defaultColor
    }
    #else
    func cgColorAt(_ fraction: Double, default defaultColor: CGColor = UIColor.clear.cgColor) -> CGColor {
        internalMapValue(at: fractionAsIndex(fraction))?.rgba.asCGColor ?? defaultColor
    }

    func cgColorAt(index: Int, default defaultColor: CGColor = UIColor.clear.cgColor) -> CGColor {
        internalMapValue(at: index)?.rgba.asCGColor ?? defaultColor
    }
    #endif
}
