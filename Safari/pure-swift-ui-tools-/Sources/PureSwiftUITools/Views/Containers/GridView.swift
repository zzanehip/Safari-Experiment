//
//  GridView.swift
//  PureSwiftUIToolsProvingGround
//
//  Created by Adam Fordyce on 18/01/2020.
//  Copyright © 2020 Adam Fordyce. All rights reserved.
//

import SwiftUI
import PureSwiftUI

public struct GridView<Content: View>: View {
    let columns: Int
    let rows: Int
    let spacing: CGFloat
    let content: (Int, Int) -> Content
    
    public init(_ columns: Int, _ rows: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.init(columns, rows, spacing: 0, content: content)
    }
    
    public init(_ size: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.init(size, size, spacing: 0, content: content)
    }
    
    public init(_ size: Int, spacing: CGFloat, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.init(size, size, spacing: spacing, content: content)
    }
    
    public init(_ columns: Int, _ rows: Int, spacing: CGFloat, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.columns = columns
        self.rows = rows
        self.spacing = spacing
        self.content = content
    }
    
    public var body: some View {
        VStack(spacing: self.spacing) {
            ForEach(0..<self.rows, id: \.self) { row in
                HStack(spacing: self.spacing) {
                    ForEach(0..<self.columns, id: \.self) { column in
                        self.content(column, row)
                    }
                }
            }
        }
    }
}


