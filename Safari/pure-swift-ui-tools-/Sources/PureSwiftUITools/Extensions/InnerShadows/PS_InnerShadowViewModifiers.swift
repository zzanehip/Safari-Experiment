//
//  PS_InnerShadowViewModifiers.swift
//  
//
//  Created by Adam Fordyce on 06/03/2020.
//

import PureSwiftUI

internal extension CGPoint {
    
    var asAnimatablePair: AnimatablePair<CGFloat, CGFloat> {
        AnimatablePair(x, y)
    }
}

internal extension AnimatablePair where First == CGFloat, Second == CGFloat {
    
    var asCGPoint: CGPoint {
        CGPoint(first, second)
    }
}

// MARK: ----- INTERIOR SHADOW SHAPE VIEW MODIFIERS

internal struct PSInnerShadowShapeOffsetViewModifier<S: Shape>: AnimatableModifier {
    let shape: S
    let fillStyle: FillStyle
    var offset: CGPoint
    var radius: CGFloat
    var color: Color
    
    
    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, CGFloat> {
        get {
            AnimatablePair(AnimatablePair(offset.x, offset.y), radius)
        }
        set {
            offset = newValue.first.asCGPoint
            radius = newValue.second
        }
    }
    
    init(shape: S, fillStyle: FillStyle, radius: CGFloat, offset: CGPoint = .zero, color: Color) {
        self.shape = shape
        self.fillStyle = fillStyle
        self.radius = radius
        self.offset = offset
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content.modifier(PSInnerShadowForShapeViewModifier(shape: shape, fillStyle: fillStyle, offset: offset, radius: radius, color: color))
    }
}

internal struct PSInnerShadowShapeOffsetWithAngleViewModifier<S: Shape>: AnimatableModifier {
    let shape: S
    let fillStyle: FillStyle
    var offset: CGFloat
    var angle: Angle
    var radius: CGFloat
    var color: Color
    
    var animatableData: AnimatablePair<AnimatablePair<CGFloat, Double>, CGFloat> {
        get {
            AnimatablePair(AnimatablePair(offset, angle.degrees), radius)
        }
        set {
            offset = newValue.first.first
            angle = newValue.first.second.degrees
            radius = newValue.second
        }
    }
    
    init(shape: S, fillStyle: FillStyle, radius: CGFloat, offset: CGFloat = 0, angle: Angle = .top, color: Color) {
        self.shape = shape
        self.fillStyle = fillStyle
        self.radius = radius
        self.offset = offset
        self.angle = angle
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content.modifier(PSInnerShadowForShapeViewModifier(shape: shape, fillStyle: fillStyle, offset: .point(offset, angle), radius: radius, color: color))
    }
}

private struct PSInnerShadowForShapeViewModifier<S: Shape>: ViewModifier {

    let shape: S
    let fillStyle: FillStyle
    var offset: CGPoint
    var radius: CGFloat
    var color: Color

    func body(content: Content) -> some View {
        content.overlay(
            ZStack {
                shape.fill(self.color, style: fillStyle)
                shape.fill(Color.white, style: fillStyle)
                    .blur(self.radius)
                    .offset(self.offset)
            }
            .clipShape(shape)
            .drawingGroup()
            .blendMode(.multiply)
        )
    }
}

// MARK: ----- IMAGE VIEW MODIFIERS

internal struct PSInnerShadowImageOffsetViewModifier<V: View>: AnimatableModifier {
    let image: Image
    let content: V
    var offset: CGPoint
    var radius: CGFloat
    var color: Color
    
    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, CGFloat> {
        get {
            AnimatablePair(AnimatablePair(offset.x, offset.y), radius)
        }
        set {
            offset = newValue.first.asCGPoint
            radius = newValue.second
        }
    }
    
    init(image: Image, content: V, radius: CGFloat, offset: CGPoint = .zero, color: Color) {
        self.image = image
        self.content = content
        self.radius = radius
        self.offset = offset
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content.modifier(PSInnerShadowForImageViewModifier(image: image, content: self.content, radius: radius, offset: offset, color: color))
    }
}

internal struct PSInnerShadowImageOffsetWithAngleViewModifier<V: View>: AnimatableModifier {
    
    let image: Image
    let content: V
    var offset: CGFloat
    var angle: Angle
    var radius: CGFloat
    var color: Color
    
    var animatableData: AnimatablePair<AnimatablePair<CGFloat, Double>, CGFloat> {
        get {
            AnimatablePair(AnimatablePair(offset, angle.degrees), radius)
        }
        set {
            offset = newValue.first.first
            angle = newValue.first.second.degrees
            radius = newValue.second
        }
    }
    
    init(image: Image, content: V, radius: CGFloat, offset: CGFloat = 0, angle: Angle = .top, color: Color) {
        self.image = image
        self.content = content
        self.radius = radius
        self.offset = offset
        self.angle = angle
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content.modifier(PSInnerShadowForImageViewModifier(image: image, content: self.content, radius: radius, offset: .point(offset, angle), color: color))
    }
}

private struct PSInnerShadowForImageViewModifier<V: View>: ViewModifier {
    
    let image: Image
    let content: V
    var offset: CGPoint
    var radius: CGFloat
    var color: Color
    
    init(image: Image, content: V, radius: CGFloat, offset: CGPoint, color: Color) {
        self.image = image
        self.content = content
        self.radius = radius
        self.offset = offset
        self.color = color
    }
    
    func body(content: Content) -> some View {
        
        let templateImage = image.renderingMode(.template)
        let whiteTemplate = templateImage.foregroundColor(.white)
        return image
            .background(self.content.mask(whiteTemplate))
            .overlay(
                ZStack {
                    templateImage.foregroundColor(color)
                    templateImage.foregroundColor(.white).blur(radius).offset(self.offset)
                }
                .mask(whiteTemplate)
                .blendMode(.multiply)
        )
        .foregroundColor(Color.clear)
    }
}

// MARK: ----- TEXT INTERIOR SHADOW

internal struct PSInnerShadowTextOffsetViewModifier<V: View>: AnimatableModifier {
    let text: Text
    let content: V
    var offset: CGPoint
    var radius: CGFloat
    var color: Color
    
    var animatableData: AnimatablePair<AnimatablePair<CGFloat, CGFloat>, CGFloat> {
        get {
            AnimatablePair(AnimatablePair(offset.x, offset.y), radius)
        }
        set {
            offset = newValue.first.asCGPoint
            radius = newValue.second
        }
    }
    
    init(text: Text, content: V, radius: CGFloat, offset: CGPoint = .zero, color: Color) {
        self.text = text
        self.content = content
        self.radius = radius
        self.offset = offset
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content.modifier(PSInnerShadowForTextViewModifier(text: text, content: self.content, radius: radius, offset: offset, color: color))
    }
}

internal struct PSInnerShadowTextOffsetWithAngleViewModifier<V: View>: AnimatableModifier {
    
    let text: Text
    let content: V
    var offset: CGFloat
    var angle: Angle
    var radius: CGFloat
    var color: Color
    
    var animatableData: AnimatablePair<AnimatablePair<CGFloat, Double>, CGFloat> {
        get {
            AnimatablePair(AnimatablePair(offset, angle.degrees), radius)
        }
        set {
            offset = newValue.first.first
            angle = newValue.first.second.degrees
            radius = newValue.second
        }
    }
    
    init(text: Text, content: V, radius: CGFloat, offset: CGFloat = 0, angle: Angle = .top, color: Color) {
        self.text = text
        self.content = content
        self.radius = radius
        self.offset = offset
        self.angle = angle
        self.color = color
    }
    
    func body(content: Content) -> some View {
        content.modifier(PSInnerShadowForTextViewModifier(text: text, content: self.content, radius: radius, offset: .point(offset, angle), color: color))
    }
}

private struct PSInnerShadowForTextViewModifier<V: View>: ViewModifier {
    
    let text: Text
    let content: V
    var offset: CGPoint
    var radius: CGFloat
    var color: Color
    
    init(text: Text, content: V, radius: CGFloat, offset: CGPoint, color: Color) {
        self.text = text
        self.content = content
        self.radius = radius
        self.offset = offset
        self.color = color
    }
    
    func body(content: Content) -> some View {
        let whiteContent = text.foregroundColor(.white)
        
        return text
            .overlay(self.content.mask(whiteContent))
            .overlay(
                ZStack {
                    text.foregroundColor(color)
                    text.foregroundColor(.white).blur(radius).offset(offset)
                }
                .mask(whiteContent)
                .blendMode(.multiply)
        )
            .foregroundColor(Color.clear)
        
    }
}
