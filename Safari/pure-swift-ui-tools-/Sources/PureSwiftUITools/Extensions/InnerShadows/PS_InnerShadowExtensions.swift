//
//  PS_InnerShadowExtensions.swift
//  
//
//  Created by Adam Fordyce on 06/03/2020.
//

import PureSwiftUI

private struct InnerShadowOnViewViewModifier<S: Shape, V: View>: ViewModifier {
    
    let shapeContent: ShapeAndContent<S, V>
    let config: PS_InnerShadowConfig
    
    func body(content: Content) -> some View {
        let decoration = Color.clear.background(self.shapeContent.shape.ps_innerShadow(.fill(self.shapeContent.content), self.config))
            .clipShape(self.shapeContent.shape)
        let color = self.shapeContent.content as? Color
        return RenderIf(color != nil && color == .clear) {
            content.overlay(decoration)
        }.elseRender {
            content.background(decoration)
        }
    }
}

public extension View {
    
//    @inlinable
//    func ps_innerShadow(_ config: PS_InnerShadowConfig) -> some View {
//        ps_innerShadow(ShapeAndContent(Rectangle(), Color.clear), config)
//    }
    
    @inlinable
    func ps_innerShadow(radius: CGFloat, offset: CGPoint = .zero, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(ShapeAndContent(Rectangle(), Color.clear), radius: radius, offset: offset, color: color)
    }
    
    @inlinable
    func ps_innerShadow(radius: CGFloat, offset: CGPoint = .zero, intensity: CGFloat) -> some View {
        ps_innerShadow(ShapeAndContent(Rectangle(), Color.clear), .config(radius: radius, offset: offset, intensity: intensity))
    }

    func ps_innerShadow<S: Shape, V: View>(_ shapeContent: ShapeAndContent<S, V>, _ config: PS_InnerShadowConfig) -> some View {
        modifier(InnerShadowOnViewViewModifier(shapeContent: shapeContent, config: config))
    }
    
    @inlinable
    func ps_innerShadow<S: Shape, V: View>(_ shapeContent: ShapeAndContent<S, V>, radius: CGFloat, offset: CGPoint = .zero, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(shapeContent, .config(radius: radius, offset: offset, color: color))
    }
    
    @inlinable
    func ps_innerShadow<S: Shape, V: View>(_ shapeContent: ShapeAndContent<S, V>, radius: CGFloat, offset: CGPoint = .zero, intensity: CGFloat) -> some View {
        ps_innerShadow(shapeContent, .config(radius: radius, offset: offset, intensity: intensity))
    }

}
// MARK: ----- INNER SHADOW OFFSET AND ANGLE

public extension View {
    
    @inlinable
    func ps_innerShadow(_ config: PS_InnerShadowConfig) -> some View {
        ps_innerShadow(Color.clear, config)
    }
    
    @inlinable
    func ps_innerShadow(radius: CGFloat, offset: CGFloat, angle: Angle, intensity: CGFloat) -> some View {
        ps_innerShadow(Color.clear, radius: radius, offset: offset, angle: angle, intensity: intensity)
    }
    
    @inlinable
    func ps_innerShadow(radius: CGFloat, offset: CGFloat, angle: Angle, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(Color.clear, radius: radius, offset: offset, angle: angle, color: color)
    }
    
    @inlinable
    func ps_innerShadow<V: View>(_ content: V, _ config: PS_InnerShadowConfig) -> some View {
        ps_innerShadow(.rectangle(content), config)
    }
    
    @inlinable
    func ps_innerShadow<V: View>(_ content: V, radius: CGFloat, offset: CGFloat, angle: Angle, intensity: CGFloat) -> some View {
        ps_innerShadow(.rectangle(content), radius: radius, offset: offset, angle: angle, intensity: intensity)
    }
    
    @inlinable
    func ps_innerShadow<V: View>(_ content: V, radius: CGFloat, offset: CGFloat, angle: Angle, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(.rectangle(content), radius: radius, offset: offset, angle: angle, color: color)
    }

    @inlinable
    func ps_innerShadow<S: Shape, V: View>(_ shapeContent: ShapeAndContent<S, V>, radius: CGFloat, offset: CGFloat, angle: Angle, intensity: CGFloat) -> some View {
        ps_innerShadow(shapeContent, .config(radius: radius, offset: offset, angle: angle, intensity: intensity))
    }

    @inlinable
    func ps_innerShadow<S: Shape, V: View>(_ shapeContent: ShapeAndContent<S, V>, radius: CGFloat, offset: CGFloat, angle: Angle, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(shapeContent, .config(radius: radius, offset: offset, angle: angle, color: color))
    }
}

private struct InnerShadowOnImageViewModifier<V: View>: ViewModifier {
    
    let image: Image
    let shadowContent: V
    let config: PS_InnerShadowConfig
    
    func body(content: Content) -> some View {
        RenderIf(config.hasAngle) {
            content.modifier(PSInnerShadowImageOffsetWithAngleViewModifier(image: self.image, content: self.shadowContent, radius: self.config.radius, offset: self.config.offsetLength, angle: self.config.angle, color: self.config.color))
        }.elseRender {
            content.modifier(PSInnerShadowImageOffsetViewModifier(image: self.image, content: self.shadowContent, radius: self.config.radius, offset: self.config.offset, color: self.config.color))
        }
    }
}

public extension Image {
    
    
//    func ps_innerShadow<V: View>(_ content: V, _ config: PS_InnerShadowConfig) -> some View {
//        modifier(InnerShadowOnImageViewModifier(image: self, shadowContent: content, config: config))
//    }
    
    @inlinable
    func ps_innerShadow<V: View>(_ content: V, radius: CGFloat, offset: CGPoint = .zero, intensity: CGFloat) -> some View {
        ps_innerShadow(content, .config(radius: radius, offset: offset, intensity: intensity))
    }
    
    @inlinable
    func ps_innerShadow<V: View>(_ content: V, radius: CGFloat, offset: CGPoint = .zero, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(content, .config(radius: radius, offset: offset, color: color))
    }

    @inlinable
    func ps_innerShadow(_ config: PS_InnerShadowConfig) -> some View {
        ps_innerShadow(Color.clear, config)
    }

    @inlinable
    func ps_innerShadow(radius: CGFloat, offset: CGPoint = .zero, intensity: CGFloat) -> some View {
        ps_innerShadow(Color.clear, .config(radius: radius, offset: offset, intensity: intensity))
    }

    @inlinable
    func ps_innerShadow(radius: CGFloat, offset: CGPoint = .zero, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(Color.clear, .config(radius: radius, offset: offset, color: color))
    }

    @inlinable
    func ps_innerShadow<V: View>(_ content: V, radius: CGFloat, offset: CGFloat, angle: Angle, intensity: CGFloat) -> some View {
        ps_innerShadow(content, .config(radius: radius, offset: offset, angle: angle, intensity: intensity))
    }

    @inlinable
    func ps_innerShadow<V: View>(_ content: V, radius: CGFloat, offset: CGFloat, angle: Angle, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(content, .config(radius: radius, offset: offset, angle: angle, color: color))
    }

    @inlinable
    func ps_innerShadow(radius: CGFloat, offset: CGFloat, angle: Angle, intensity: CGFloat) -> some View {
        ps_innerShadow(.config(radius: radius, offset: offset, angle: angle, intensity: intensity))
    }

    @inlinable
    func ps_innerShadow(radius: CGFloat, offset: CGFloat, angle: Angle, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(.config(radius: radius, offset: offset, angle: angle, color: color))
    }
}

// MARK: ----- GENERIC ON SHAPE

private struct InnerShadowOnShapeViewModifier<S: Shape, V: View>: ViewModifier {
    
    let shape: S
    let fillAndContent: FillAndContent<V>
    let config: PS_InnerShadowConfig
    
    func body(content: Content) -> some View {
        RenderIf(config.hasAngle) {
            self.fillAndContent.content.clipShape(self.shape, style: self.fillAndContent.fillStyle)
                .modifier(PSInnerShadowShapeOffsetWithAngleViewModifier(shape: self.shape, fillStyle: self.fillAndContent.fillStyle, radius: self.config.radius, offset: self.config.offsetLength, angle: self.config.angle, color: self.config.color))
       }.elseRender {
        self.fillAndContent.content.clipShape(self.shape, style: self.fillAndContent.fillStyle)
            .modifier(PSInnerShadowShapeOffsetViewModifier(shape: self.shape, fillStyle: self.fillAndContent.fillStyle, radius: self.config.radius, offset: self.config.offset, color: self.config.color))
       }
    }
}

public extension Shape {
    
//    internal func addPSInnerShadow<S: Shape, V: View>(_ shape: S, _ fillAndContent: FillAndContent<V>, _ config: PS_InnerShadowConfig) -> some View {
//        modifier(InnerShadowOnShapeViewModifier(shape: shape, fillAndContent: fillAndContent, config: config))
//    }
}

// MARK: ----- GENERIC ON SHAPE STROKE

public extension Shape {
    
//    @inlinable
    func ps_innerShadow<V: View>(_ strokeAndContent: StrokeAndContent<V>, _ config: PS_InnerShadowConfig) -> some View {
        let strokedShape = stroke(style: strokeAndContent.style)
        return strokedShape.modifier(InnerShadowOnShapeViewModifier(shape: strokedShape, fillAndContent: strokeAndContent.fillAndContent, config: config))
//            .addPSInnerShadow(strokedShape, strokeAndContent.fillAndContent, config)
    }
    
    @inlinable
    func ps_innerShadow<V: View>(_ strokeAndContent: StrokeAndContent<V>, radius: CGFloat, offset: CGPoint = .zero, intensity: CGFloat) -> some View {
        ps_innerShadow(strokeAndContent, .config(radius: radius, offset: offset, intensity: intensity))
    }
    
    @inlinable
    func ps_innerShadow<V: View>(_ strokeAndContent: StrokeAndContent<V>, radius: CGFloat, offset: CGPoint = .zero, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(strokeAndContent, .config(radius: radius, offset: offset, color: color))
    }

    @inlinable
    func ps_innerShadow<V: View>(_ strokeAndContent: StrokeAndContent<V>, radius: CGFloat, offset: CGFloat, angle: Angle, intensity: CGFloat) -> some View {
        ps_innerShadow(strokeAndContent, .config(radius: radius, offset: offset, angle: angle, intensity: intensity))
    }

    @inlinable
    func ps_innerShadow<V: View>(_ strokeAndContent: StrokeAndContent<V>, radius: CGFloat, offset: CGFloat, angle: Angle, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(strokeAndContent, .config(radius: radius, offset: offset, angle: angle, color: color))
    }
}

public extension Shape {
    
    
    @inlinable
    func ps_innerShadow<V: View>(_ fillAndContent: FillAndContent<V>, radius: CGFloat, offset: CGPoint = .zero, intensity: CGFloat) -> some View {
        ps_innerShadow(fillAndContent, .config(radius: radius, offset: offset, intensity: intensity))
    }
    
    @inlinable
    func ps_innerShadow<V: View>(_ fillAndContent: FillAndContent<V>, radius: CGFloat, offset: CGPoint = .zero, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(fillAndContent, .config(radius: radius, offset: offset, color: color))
    }

    @inlinable
    func ps_innerShadow<V: View>(_ fillAndContent: FillAndContent<V>, radius: CGFloat, offset: CGFloat, angle: Angle, intensity: CGFloat) -> some View {
        ps_innerShadow(fillAndContent, .config(radius: radius, offset: offset, angle: angle, intensity: intensity))
    }

    @inlinable
    func ps_innerShadow<V: View>(_ fillAndContent: FillAndContent<V>, radius: CGFloat, offset: CGFloat, angle: Angle, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(fillAndContent, .config(radius: radius, offset: offset, angle: angle, color: color))
    }

//    @inlinable
    func ps_innerShadow<V: View>(_ fillAndContent: FillAndContent<V>, _ config: PS_InnerShadowConfig) -> some View {
        modifier(InnerShadowOnShapeViewModifier(shape: self, fillAndContent: fillAndContent, config: config))
//        self.addPSInnerShadow(self, fillAndContent, config)
    }
}

// MARK: ----- TEXT INNER SHADOW WITH OFFSET

private struct InnerShadowOnTextViewModifier<V: View>: ViewModifier {
    
    let text: Text
    let shadowContent: V
    let config: PS_InnerShadowConfig
    
    func body(content: Content) -> some View {
        RenderIf(config.hasAngle) {
            content.modifier(PSInnerShadowTextOffsetWithAngleViewModifier(text: self.text, content: self.shadowContent, radius: self.config.radius, offset: self.config.offsetLength, angle: self.config.angle, color: self.config.color))
        }.elseRender {
            content.modifier(PSInnerShadowTextOffsetViewModifier(text: self.text, content: self.shadowContent, radius: self.config.radius, offset: self.config.offset, color: self.config.color))
        }
    }
}

public extension Text {
    
//    internal func addPSInnerShadow<V: View>(_ content: V, _ config: PS_InnerShadowConfig) -> some View {
//        modifier(InnerShadowOnTextViewModifier(text: self, shadowContent: content, config: config))
//    }
    
    @inlinable
    func ps_innerShadow(radius: CGFloat, offset: CGPoint = .zero, intensity: CGFloat) -> some View {
        ps_innerShadow(Color.clear, .config(radius: radius, offset: offset, intensity: intensity))
    }
    
    @inlinable
    func ps_innerShadow<V: View>(_ content: V, radius: CGFloat, offset: CGPoint = .zero, intensity: CGFloat) -> some View {
        ps_innerShadow(content, .config(radius: radius, offset: offset, intensity: intensity))
    }

    @inlinable
    func ps_innerShadow(radius: CGFloat, offset: CGPoint = .zero, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(Color.clear, .config(radius: radius, offset: offset, color: color))
    }

    @inlinable
    func ps_innerShadow<V: View>(_ content: V, radius: CGFloat, offset: CGPoint = .zero, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(content, .config(radius: radius, offset: offset, color: color))
    }

    @inlinable
    func ps_innerShadow(_ config: PS_InnerShadowConfig) -> some View {
        ps_innerShadow(Color.clear, config)
    }

//    @inlinable
    func ps_innerShadow<V: View>(_ content: V, _ config: PS_InnerShadowConfig) -> some View {
//        addPSInnerShadow(content, config)
        modifier(InnerShadowOnTextViewModifier(text: self, shadowContent: content, config: config))
    }
}

// MARK: ----- TEXT INNER SHADOW WITH OFFSET AND ANGLE

public extension Text {
    
    @inlinable
    func ps_innerShadow(radius: CGFloat, offset: CGFloat, angle: Angle, intensity: CGFloat) -> some View {
        ps_innerShadow(Color.clear, .config(radius: radius, offset: offset, angle: angle, intensity: intensity))
    }
    
    @inlinable
    func ps_innerShadow<V: View>(_ content: V, radius: CGFloat, offset: CGFloat, angle: Angle, intensity: CGFloat) -> some View {
        ps_innerShadow(content, .config(radius: radius, offset: offset, angle: angle, intensity: intensity))
    }

    @inlinable
    func ps_innerShadow(radius: CGFloat, offset: CGFloat, angle: Angle, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(Color.clear, .config(radius: radius, offset: offset, angle: angle, color: color))
    }

    @inlinable
    func ps_innerShadow<V: View>(_ content: V, radius: CGFloat, offset: CGFloat, angle: Angle, color: Color = ps_defaultInnerShadowColor) -> some View {
        ps_innerShadow(content, .config(radius: radius, offset: offset, angle: angle, color: color))
    }

}
