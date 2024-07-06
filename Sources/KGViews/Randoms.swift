//
//  Randoms.swift
//

import SwiftUI

public extension View {
    
    /// Prevents the view from moving upwards when the keyboard is shown.
    ///
    /// Created by Kevin Green on 11/24/23.
    func staticViewWithKeyboard() -> some View {
        GeometryReader { _ in
            self
        }
        .ignoresSafeArea(.keyboard)
    }
    
    
    /// A quicker easier way to border a view via a shape overlay.
    func bordered<S:Shape>(shape: S, color: Color, lineWidth: CGFloat = 1) -> some View {
        self.overlay {
            shape.stroke(color, lineWidth: lineWidth)
        }
    }
    
    /// Adds a shaped border to the view.
    func addBorder<S: ShapeStyle>(_ content: S, lineWidth: CGFloat = 1, cornerRadius: CGFloat = 0) -> some View {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
            .overlay(roundedRect.strokeBorder(content, lineWidth: lineWidth))
    }
    
}

