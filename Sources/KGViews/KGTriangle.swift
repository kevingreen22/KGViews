//
//  Triangle.swift
//
//  Created by Kevin Green on 6/29/24.
//

import SwiftUI

public enum TriangleCorners: Sendable, CaseIterable {
    case top, bottomLeft, bottomRight, all
}

/// Triangle Shape with optional rounded corners.
public struct Triangle: Shape {
    let cornerRadius: CGFloat
    let corners: [TriangleCorners]
    
    init(cornerRadius: CGFloat = 0, on corners: TriangleCorners...) {
        self.cornerRadius = cornerRadius
        self.corners = corners
    }
    
    init(cornerRadius: CGFloat = 0) {
        self.cornerRadius = cornerRadius
        self.corners = [TriangleCorners.all]
    }
    
    public func path(in rect: CGRect) -> Path {
        let width = rect.width
        let height = rect.height
        
        // The triangle's three corners.
        let bottomLeft = CGPoint(x: 0, y: height)
        let bottomRight = CGPoint(x: width, y: height)
        let topMiddle = CGPoint(x: rect.midX, y: 0)
        
        // We'll start drawing from the bottom middle of the triangle,
        // the midpoint between the two lower corners.
        let bottomMiddle = CGPoint(x: rect.midX, y: height)
        
        // Draw three arcs to trace the triangle.
        var path = Path()
        path.move(to: bottomMiddle)
        path.addArc(tangent1End: bottomRight, tangent2End: topMiddle, radius: corners.contains(.all) ? cornerRadius : (corners.contains(.bottomRight) ? cornerRadius : 0))
        path.addArc(tangent1End: topMiddle, tangent2End: bottomLeft, radius: corners.contains(.all) ? cornerRadius : (corners.contains(.top) ? cornerRadius : 0))
        path.addArc(tangent1End: bottomLeft, tangent2End: bottomRight, radius: corners.contains(.all) ? cornerRadius : (corners.contains(.bottomLeft) ? cornerRadius : 0))
        path.addLine(to: bottomMiddle)
        
        return path
    }
}



// MARK: Triangle shape Demo
private struct Demo: View {
    @State var selectedCorners = 0
    
    var body: some View {
        VStack {
            Picker(selection: $selectedCorners, label: Text("Corners")) {
                Text("None").tag(0)
                Text("All").tag(1)
                Text("Top").tag(2)
                Text("Left").tag(3)
                Text("Right").tag(4)
            }.pickerStyle(.segmented)
            Spacer()
            switch selectedCorners {
            case 0: ExampleTriangle(corners: nil)
            case 1: ExampleTriangle(corners: .all)
            case 2: ExampleTriangle(corners: .top)
            case 3: ExampleTriangle(corners: .bottomLeft)
            case 4: ExampleTriangle(corners: .bottomRight)
            default: EmptyView()
            }
            Spacer()
        }
        .animation(.easeInOut(duration: 1.3), value: selectedCorners)
        .padding()
    }
}

private struct ExampleTriangle: View {
    var corners: TriangleCorners? = nil
    
    var body: some View {
        if corners == nil {
            Triangle()
                .fill(Color.indigo)
                .frame(width: 300, height: 300)
                .transition(.scale)
        } else {
            Triangle(cornerRadius: 20, on: corners!)
                .fill(Color.indigo)
                .frame(width: 300, height: 300)
                .transition(.identity)
        }
    }
}

#Preview {
    Demo()
}

