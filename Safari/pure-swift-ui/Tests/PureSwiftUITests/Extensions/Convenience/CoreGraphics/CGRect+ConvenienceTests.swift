//
//  CGRect+Tests.swift
//  
//
//  Created by Adam Fordyce on 25/11/2019.
//

import XCTest
@testable import PureSwiftUI

class CGRectConvenienceExtensionsTests: XCTestCase {
    
    let x: CGFloat = 2
    let y: CGFloat = 4
    let width: CGFloat = 8
    let height: CGFloat = 10
    
    var midX: CGFloat {
        x + width * 0.5
    }
    
    var midY: CGFloat {
        y + height * 0.5
    }
    
    var maxX: CGFloat {
        x + width
    }
    
    var maxY: CGFloat {
        y + height
    }
    
    var halfWidth: CGFloat {
        width * 0.5
    }
    
    var halfHeight: CGFloat {
        height * 0.5
    }
    
    var size: CGSize {
        CGSize(width: width, height: height)
    }
    
    var rect: CGRect {
        CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    }
}

// MARK: ----- INIT

extension CGRectConvenienceExtensionsTests {
    
    func testInit() {
        XCTAssertEqual(CGRect(x, y, width, height), rect)
        XCTAssertEqual(CGRect(width, height), CGRect(0, 0, width, height))
        XCTAssertEqual(CGRect(.point(x, y), .size(width, height)), rect)
    }
    
    func testInitFromAndToPoint() {
        XCTAssertEqual(CGRect(from: .point(x, y), to: .point(x + width, y + height)), rect)
    }
    
}

// MARK: ----- INIT WITH ANCHOR

extension CGRectConvenienceExtensionsTests {
    
    func testRegionWithSize() {
        let expected = CGRect(rect.bottomTrailing.offset(CGPoint(-5, -5)), .square(5))
        
        XCTAssertEqual(CGRect(rect.bottomTrailing.x, rect.bottomTrailing.y, 5, 5, anchor: .bottomTrailing), expected)
        XCTAssertEqual(CGRect(5, 5, anchor: .bottomTrailing), CGRect(-5, -5, 5, 5))
        XCTAssertEqual(CGRect(rect.bottomTrailing, .square(5), anchor: .bottomTrailing), expected)
        XCTAssertEqual(CGRect(rect.bottomTrailing, .square(5), anchor: .bottomTrailing), expected)
    }
}

// MARK: ----- STATIC INITIALISERS

extension CGRectConvenienceExtensionsTests {
    
    func testStaticInit() {
        XCTAssertEqual(CGRect.rect(.point(x, y), .size(width, height)), rect)
        XCTAssertEqual(CGRect.rect(x, y, width, height), rect)
    }
}

// MARK: ----- DIMENSIONS

extension CGRectConvenienceExtensionsTests {
    
    
    func testDimensions() {
        XCTAssertEqual(rect.center, CGPoint(midX, midY))
        XCTAssertEqual(rect.topLeading, CGPoint(x, y))
        XCTAssertEqual(rect.top, CGPoint(midX, y))
        XCTAssertEqual(rect.topTrailing, CGPoint(maxX, y))
        XCTAssertEqual(rect.leading, CGPoint(x, midY))
        XCTAssertEqual(rect.trailing, CGPoint(maxX, midY))
        XCTAssertEqual(rect.bottomLeading, CGPoint(x, maxY))
        XCTAssertEqual(rect.bottom, CGPoint(midX, maxY))
        XCTAssertEqual(rect.bottomTrailing, CGPoint(maxX, maxY))
        XCTAssertEqual(rect.extent, rect.bottomTrailing)
        XCTAssertEqual(rect.halfWidth, width * 0.5)
        XCTAssertEqual(rect.halfHeight, height * 0.5)
        XCTAssertEqual(rect.minDimension, width)
        XCTAssertEqual(rect.maxDimension, height)
    }
}

// MARK: ----- CLAMPED

extension CGRectConvenienceExtensionsTests {
    
    func testClampedSize() {
        let expectedResult = CGSize(maxX, maxY)
        let result = CGRect(x, y, 0, 20).clampedSize(from: maxX, to: maxY)
        
        XCTAssertEqual(result, expectedResult)
    }
}

// MARK: ----- SCALED

extension CGRectConvenienceExtensionsTests {
    
    func testScaled() {
        XCTAssertEqual(rect.widthScaled(0.5), width * 0.5)
        XCTAssertEqual(rect.heightScaled(0.5), height * 0.5)
        XCTAssertEqual(rect.xScaled(0.5), rect.midX)
        XCTAssertEqual(rect.yScaled(0.5), rect.midY)
        XCTAssertEqual(rect.sizeScaled(0.5), CGSize(width * 0.5, height * 0.5))
        XCTAssertEqual(rect.sizeScaled(.point(0.5)), CGSize(width * 0.5, height * 0.5))
        XCTAssertEqual(rect.sizeScaled(.vector(0.5)), CGSize(width * 0.5, height * 0.5))
        XCTAssertEqual(rect.sizeScaled(.size(0.5)), CGSize(width * 0.5, height * 0.5))
        XCTAssertEqual(rect.sizeScaled(0.1, 0.5), CGSize(width * 0.1, height * 0.5))
    }
}

// MARK: ----- INSET

extension CGRectConvenienceExtensionsTests {
    
    func testInset() {
        let topInset: CGFloat = 1
        let leadingInset: CGFloat = 2
        let bottomInset: CGFloat = 3
        let trailingInset: CGFloat = 4
        
        XCTAssertEqual(rect.inset(topInset, leadingInset, bottomInset, trailingInset),
                       CGRect(x + leadingInset, y + topInset, width - trailingInset - leadingInset, height - bottomInset - topInset))
        XCTAssertEqual(rect.inset([.top, .trailing], leadingInset),
                       CGRect(x, y + leadingInset, width - leadingInset, height - leadingInset))
        
        XCTAssertEqual(rect.insetTop(topInset), rect.inset(.top, topInset))
        
        XCTAssertEqual(rect.insetLeading(leadingInset), rect.inset(.leading, leadingInset))
        
        XCTAssertEqual(rect.insetBottom(bottomInset), rect.inset(.bottom, bottomInset))
        
        XCTAssertEqual(rect.insetTrailing(trailingInset), rect.inset(.trailing, trailingInset))
        
        XCTAssertEqual(rect.hInset(leadingInset), rect.inset([.leading, .trailing], leadingInset))
        XCTAssertEqual(rect.vInset(topInset), rect.inset([.top, .bottom], topInset))
        
        XCTAssertEqual(rect.inset(topInset), rect.inset(.all, topInset))
    }
}

// MARK: ----- SCALE

extension CGRectConvenienceExtensionsTests {
    
    func testRegionWithScale() {
        XCTAssertEqual(rect.scaled(CGSize(0.5, 0.5), at: rect.bottomTrailing, anchor: .bottomTrailing),
                       CGRect(rect.bottomTrailing.offset(rect.sizeScaled(-0.5)), CGSize(4, 5)))
        XCTAssertEqual(rect.scaled(0.5, at: rect.bottomTrailing, anchor: .bottomTrailing),
                       CGRect(rect.bottomTrailing.offset(rect.sizeScaled(-0.5)), CGSize(4, 5)))
        XCTAssertEqual(rect.xScaled(0.5, at: rect.bottomTrailing, anchor: .bottomTrailing),
                       CGRect(rect.top, CGSize(4, 10)))
        XCTAssertEqual(rect.yScaled(0.5, at: rect.bottomTrailing, anchor: .bottomTrailing),
                       CGRect(rect.leading, CGSize(8, 5)))
    }
}

// MARK: ----- OFFSET

extension CGRectConvenienceExtensionsTests {
    
    func testOffsetAnchor() {
        XCTAssertEqual(rect.offset(anchor: .bottomTrailing), CGRect(x - width, y - height, width, height))
        XCTAssertEqual(rect.offset(anchor: UnitPoint(-0.5, -0.5)), CGRect(x + 4, y + 5, width, height))
        
        let expected = CGRect(CGPoint(2 * x, 2 * y), size)
        XCTAssertEqual(rect.offset(x, y), expected)
        XCTAssertEqual(rect.offset(CGPoint(x, y)), expected)
        XCTAssertEqual(rect.offset(CGSize(x, y)), expected)
        XCTAssertEqual(rect.offset(CGVector(x, y)), expected)

        XCTAssertEqual(rect.xOffset(x), CGRect(CGPoint(x + x, y), size))
        XCTAssertEqual(rect.yOffset(y), CGRect(CGPoint(x, y + y), size))
    }
}

// MARK: ----- OFFSET WITH FACTOR

extension CGRectConvenienceExtensionsTests {
    
    func testOffsetAnchorWithFactor() {
        XCTAssertEqual(rect.offset(anchor: .bottomTrailing, factor: 0.5), CGRect(x - width * 0.5, y - height * 0.5, width, height))
        XCTAssertEqual(rect.offset(anchor: .bottomTrailing, factor: .square(0.5)), CGRect(x - width * 0.5, y - height * 0.5, width, height))
        XCTAssertEqual(rect.offset(anchor: UnitPoint(-0.5, -0.5), factor: 0.5), CGRect(x + 2, y + 2.5, width, height))
        
        let expected = CGRect(CGPoint(x + x * 0.5, y + y * 0.5), size)
        XCTAssertEqual(rect.offset(x, y, factor: 0.5), expected)
        XCTAssertEqual(rect.offset(x, y, factor: .square(0.5)), expected)
        XCTAssertEqual(rect.offset(CGPoint(x, y), factor: 0.5), expected)
        XCTAssertEqual(rect.offset(CGSize(x, y), factor: 0.5), expected)
        XCTAssertEqual(rect.offset(CGVector(x, y), factor: 0.5), expected)
        XCTAssertEqual(rect.offset(CGPoint(x, y), factor: .square(0.5)), expected)
        XCTAssertEqual(rect.offset(CGSize(x, y), factor: .square(0.5)), expected)
        XCTAssertEqual(rect.offset(CGVector(x, y), factor: .square(0.5)), expected)

        XCTAssertEqual(rect.xOffset(x, factor: 0.5), CGRect(CGPoint(x + x * 0.5, y), size))
        XCTAssertEqual(rect.yOffset(y, factor: 0.5), CGRect(CGPoint(x, y + y * 0.5), size))
    }
}

