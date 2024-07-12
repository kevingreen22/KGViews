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

public extension Shape {
    /// Adds rounded corners to a Shape.
    /// - Parameters:
    ///   - corners: The corners to apply the rounding to.
    ///   - radius: The amount of roundness to apply to the corners.
    func roundCorner(_ corners: UIRectCorner, radius: CGFloat = 20) -> some View {
        KGRoundedCorner(corners: corners, radius: radius)
    }
}


// MARK: Rounded Corner Demo
fileprivate struct RoundedCorner_Demo: PreviewProvider {
    static var previews: some View {
        VStack {
            Rectangle()
                .roundCorner(.bottomRight, radius: 30)
                .foregroundStyle(Color.red)
                .frame(width: 100, height: 100)
            
            KGRoundedCorner(corners: .bottomLeft, radius: 10)
                .fill(Color.orange)
                .frame(width: 100, height: 100)
        }
    }
}

#Preview {
    VStack {
        Rectangle()
            .roundCorner(.bottomRight, radius: 30)
            .foregroundStyle(Color.red)
            .frame(width: 100, height: 100)
        
        KGRoundedCorner(corners: .bottomLeft, radius: 10)
            .fill(Color.orange)
            .frame(width: 100, height: 100)
    }
}
