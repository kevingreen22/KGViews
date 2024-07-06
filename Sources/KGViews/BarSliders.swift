//
//  BarSliders.swift
//
//  Created by Kevin Green on 6/1/22.
//

import SwiftUI

/// A vertical thicker finger slider.
/// Value must be between minValue and maxValue.
/// minValue defaults to 0, maxValue defaults to 1.
struct VSlider: View {
    @Binding var value: Float
    var minValue: CGFloat = 0
    var maxValue: CGFloat = 1
    var backgroundColor: Color = .gray.opacity(0.8)
    var accentColor: Color = .blue.opacity(0.8)
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .foregroundColor(backgroundColor)
                
                Rectangle()
                    .foregroundColor(accentColor)
                    .frame(height: proxy.size.height * CGFloat(self.value) / maxValue)
            }
            .cornerRadius(20)
            
            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    let offsetValue = -value.location.y + proxy.size.height
                    
                    self.value = Float(min(max(minValue, offsetValue / proxy.size.height * maxValue), maxValue))
                })
            )
        }
    }
}


/// A vertical thicker finger slider.
/// Value must be between minValue and maxValue.
/// minValue defaults to 0, maxValue defaults to 1.
struct HSlider: View {
    @Binding var value: Float
    var minValue: Float = 0
    var maxValue: Float = 1
    var backgroundColor: Color = .gray.opacity(0.8)
    var accentColor: Color = .blue.opacity(0.8)
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(backgroundColor)
                
                Rectangle()
                    .foregroundColor(accentColor)
                    .frame(width: proxy.size.width * CGFloat(self.value) / CGFloat(maxValue))
            }
            .cornerRadius(20)

            .gesture(DragGesture(minimumDistance: 0)
                .onChanged({ value in
                    self.value = min(max(minValue, Float(value.location.x / proxy.size.width) * maxValue), maxValue)
                })
            )
        }
    }
}



fileprivate struct Preview: View {
    @State var valueV: Float = 0.5
    @State var valueH: Float = 0.5
    
    var body: some View {
        VStack {
            VSlider(value: $valueV, minValue: 0, maxValue: 1)
                .frame(width: 80, height: 200)
            
            Text("Vert. - \(valueV)")
                .font(.headline)
            
            HSlider(value: $valueH, minValue: 0, maxValue: 1)
                .frame(width: 360, height: 80)
            
            Text("Hor. - \(valueH)")
                .font(.headline)
        }
    }
}

#Preview {
    Preview()
        .padding()
}
