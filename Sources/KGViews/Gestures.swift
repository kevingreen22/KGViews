//
//  Gestures.swift
//
//  Created by Kevin Green on 12/14/23.
//

import SwiftUI

/// An implementation with a smoother feeling drag.
public struct SmoothDrag: Gesture {
    @Binding var location: CGSize
    @GestureState private var startLocation: CGSize? = nil
    
    public init(location: Binding<CGSize>) {
        _location = location
    }
    
    public var body: some Gesture {
        simpleDrag
    }
    
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                var newLocation = startLocation ?? location
                newLocation.width += value.translation.width
                newLocation.height += value.translation.height
                self.location = newLocation
            }
            .updating($startLocation) { (value, startLocation, transaction) in
                startLocation = startLocation ?? location
            }
    }
}


// MARK: Smooth Drag Demo
fileprivate struct SmoothDrag_Demo: View {
    @State private var location = CGSize.zero
    
    var body: some View {
        Rectangle()
            .fill(Color.indigo)
            .frame(width: 100, height: 100)
            .offset(location)
            .gesture(SmoothDrag(location: $location))
    }
}

#Preview {
    SmoothDrag_Demo()
}
