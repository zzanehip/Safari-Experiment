//
//  PS_InnerShadowModel.swift
//  
//
//  Created by Adam Fordyce on 06/03/2020.
//

import PureSwiftUI

public let ps_defaultInnerShadowColor = Color(white: 0.56)

private func convertIntensityToColor(_ intensity: CGFloat) -> Color {
    return Color(white: 1 - intensity.asDouble.clamped(to: 1, spanZero: false))
}

public struct PS_InnerShadowConfig {
    
    let radius: CGFloat
    let offsetLength: CGFloat!
    let offset: CGPoint!
    let angle: Angle!
    let color: Color!
    
    private init(radiusInternal: CGFloat, offsetLength: CGFloat? = nil, offset: CGPoint? = nil, angle: Angle? = nil, color: Color = ps_defaultInnerShadowColor) {
        self.radius = radiusInternal
        self.offsetLength = offsetLength
        self.offset = offset
        self.angle = angle
        self.color = color
    }
    
    public init(radius: CGFloat, offsetLength: CGFloat, angle: Angle, color: Color = ps_defaultInnerShadowColor) {
        self.init(radiusInternal: radius, offsetLength: offsetLength, angle: angle, color: color)
    }
    
    public init(radius: CGFloat, offsetLength: CGFloat, angle: Angle, intensity: CGFloat) {
        self.init(radius: radius, offsetLength: offsetLength, angle: angle, color: convertIntensityToColor(intensity))
    }

    public init(radius: CGFloat, offset: CGPoint, color: Color = ps_defaultInnerShadowColor) {
        self.init(radiusInternal: radius, offset: offset, color: color)
    }
    
    public init(radius: CGFloat, offset: CGPoint, intensity: CGFloat) {
        self.init(radius: radius, offset: offset, color: convertIntensityToColor(intensity))
    }
    
    public init(radius: CGFloat, color: Color = ps_defaultInnerShadowColor) {
        self.init(radiusInternal: radius, offset: .zero, color: color)
    }
    
    public init(radius: CGFloat, intensity: CGFloat) {
        self.init(radius: radius, offset: .zero, intensity: intensity)
    }
    
    var hasAngle: Bool {
        angle != nil
    }
}

public extension PS_InnerShadowConfig {
    
    static func config(radius: CGFloat, intensity: CGFloat) -> PS_InnerShadowConfig {
        config(radius: radius, offset: .zero, intensity: intensity)
    }
    
    static func config(radius: CGFloat, color: Color = ps_defaultInnerShadowColor) -> PS_InnerShadowConfig {
        config(radius: radius, offset: .zero, color: color)
    }
    
    static func config(radius: CGFloat, offset: CGFloat, angle: Angle, intensity: CGFloat) -> PS_InnerShadowConfig {
        config(radius: radius, offset: offset, angle: angle, color: convertIntensityToColor(intensity))
    }
    
    static func config(radius: CGFloat, offset: CGFloat, angle: Angle, color: Color = ps_defaultInnerShadowColor) -> PS_InnerShadowConfig {
        PS_InnerShadowConfig(radius: radius, offsetLength: offset, angle: angle, color: color)
    }

    static func config(radius: CGFloat, offset: CGPoint, intensity: CGFloat) -> PS_InnerShadowConfig {
        config(radius: radius, offset: offset, color: convertIntensityToColor(intensity))
    }
    
    static func config(radius: CGFloat, offset: CGPoint, color: Color = ps_defaultInnerShadowColor) -> PS_InnerShadowConfig {
        PS_InnerShadowConfig(radius: radius, offset: offset, color: color)
    }
}

public struct FillAndContent<V: View> {
    let fillStyle: FillStyle
    let content: V?
    
    public init(_ fillStyle: FillStyle, _ content: V?) {
        self.fillStyle = fillStyle
        self.content = content
    }
}

public extension FillAndContent {
    
    static var fill: FillAndContent<Color> {
        fill(Color.clear)
    }
    
    static func fill(eoFill: Bool = false, antialiased: Bool = true) -> FillAndContent<Color> {
        fill(Color.clear, eoFill: eoFill, antialiased: antialiased)
    }
    
    static func fill<V: View>(_ content: V, eoFill: Bool = false, antialiased: Bool = true) -> FillAndContent<V> {
        FillAndContent<V>(FillStyle(eoFill: eoFill, antialiased: antialiased), content)
    }
}

public struct StrokeAndContent<V: View> {
    let style: StrokeStyle
    let fillAndContent: FillAndContent<V>
    
    public init(_ style: StrokeStyle, _ fillAndContent: FillAndContent<V>) {
        self.style = style
        self.fillAndContent = fillAndContent
    }
}

public extension StrokeAndContent {
    static func stroke(lineWidth: CGFloat) -> StrokeAndContent<Color> {
        stroke(Color.clear, lineWidth: lineWidth)
    }
    
    static func stroke<V: View>(_ content: V, lineWidth:CGFloat) -> StrokeAndContent<V> {
        StrokeAndContent<V>(StrokeStyle(lineWidth: lineWidth), .fill(content))
    }
    
    static func stroke(style: StrokeStyle) -> StrokeAndContent<Color> {
        stroke(Color.clear, style: style)
    }
    
    static func stroke<V: View>(_ content: V, style: StrokeStyle) -> StrokeAndContent<V> {
        StrokeAndContent<V>(style, .fill(content))
    }
}

public struct ShapeAndContent<S: Shape, V: View> {
    let shape: S
    let content: V?
    
    public init(_ shape: S, _ content: V? = nil) {
        self.shape = shape
        self.content = content
    }
}

public extension ShapeAndContent {
    
    static var circle: ShapeAndContent<Circle, Color> {
        circle(Color.clear)
    }
    
    static func circle<V: View>(_ content: V? = nil) -> ShapeAndContent<Circle, V> {
        ShapeAndContent<Circle, V>(Circle(), content)
    }
    
    static var ellipse: ShapeAndContent<Ellipse, Color> {
        ellipse(Color.clear)
    }
    
    static func ellipse<V: View>(_ content: V? = nil) -> ShapeAndContent<Ellipse, V> {
        ShapeAndContent<Ellipse, V>(Ellipse(), content)
    }
    
    static var capsule: ShapeAndContent<Capsule, Color> {
        capsule(Color.clear)
    }
    
    static func capsule<V: View>(_ content: V? = nil) -> ShapeAndContent<Capsule, V> {
        ShapeAndContent<Capsule, V>(Capsule(), content)
    }

    static var rectangle: ShapeAndContent<Rectangle, Color> {
        rectangle(Color.clear)
    }
    
    static func rectangle<V: View>(_ content: V? = nil) -> ShapeAndContent<Rectangle, V> {
        ShapeAndContent<Rectangle, V>(Rectangle(), content)
    }
    
    static func roundedRectangle(_ cornerRadius: CGFloat) -> ShapeAndContent<RoundedRectangle, Color> {
        roundedRectangle(cornerRadius, Color.clear)
    }
    
    static func roundedRectangle<V: View>(_ cornerRadius: CGFloat, _ content: V? = nil) -> ShapeAndContent<RoundedRectangle, V> {
        ShapeAndContent<RoundedRectangle, V>(RoundedRectangle(cornerRadius), content)
    }
}
