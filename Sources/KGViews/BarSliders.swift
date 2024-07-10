//
//  BarSliders.swift
//
//  Created by Kevin Green on 6/1/22.
//

import SwiftUI

/// A vertical thicker finger slider.
/// Value must be between minValue and maxValue.
/// minValue defaults to 0, maxValue defaults to 1.
public struct VSlider: View {
    @Binding var value: Float
    var minValue: CGFloat = 0
    var maxValue: CGFloat = 1
    var backgroundColor: Color = .gray
    var accentColor: Color = .blue
    
    public init(value: Binding<Float>, minValue: CGFloat = 0, maxValue: CGFloat = 1, backgroundColor: Color = .gray, accentColor: Color = .gray) {
        _value = value
        self.minValue = minValue
        self.maxValue = maxValue
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                Rectangle()
                    .foregroundColor(backgroundColor.opacity(0.8))
                
                Rectangle()
                    .foregroundColor(accentColor.opacity(0.8))
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
public struct HSlider: View {
    @Binding var value: Float
    var minValue: Float = 0
    var maxValue: Float = 1
    var backgroundColor: Color = .gray
    var accentColor: Color = .blue
    
    public init(value: Binding<Float>, minValue: Float = 0, maxValue: Float = 1, backgroundColor: Color = .gray, accentColor: Color = .blue) {
        _value = value
        self.minValue = minValue
        self.maxValue = maxValue
        self.backgroundColor = backgroundColor
        self.accentColor = accentColor
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(backgroundColor.opacity(0.8))
                
                Rectangle()
                    .foregroundColor(accentColor.opacity(0.8))
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
            Spacer()
            
            VSlider(value: $valueV, minValue: 0, maxValue: 1)
                .frame(width: 80, height: 200)
            
            Text("Vertical - \(valueV)")
                .font(.headline)
            
            Spacer()
            
            HSlider(value: $valueH, minValue: 0, maxValue: 1)
                .frame(width: 360, height: 80)
            
            Text("Horizontal - \(valueH)")
                .font(.headline)
            
            Spacer()
        }
    }
}

#Preview {
    Preview()
        .padding()
}
