//
//  RoundedCorner.swift
//
//  Created by Kevin Green on 9/3/22.
//

import SwiftUI

/// Rounds the given corners with the given radius to the specified corner of a rect.
public struct KGRoundedCorner: Shape {
    public var corners: UIRectCorner
    public var radius: CGFloat
    
    public init(corners: UIRectCorner, radius: CGFloat) {
        self.corners = corners
        self.radius = radius
    }
    
    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
