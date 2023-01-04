//
//  KGDeviceViews.swift
//
//  Created by Kevin Green on 9/8/22.
//

import SwiftUI

public struct KGDeviceViews {
    
    /// A visual representation of an iPhone with Dynamic Island.
    static func iPhoneIsland(strokeColor: Color = .primary, fillColor: Color = .clear) -> some View {
            ZStack {
                // iPhone Frame
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(strokeColor, lineWidth: 3.0)
                    .background(fillColor.cornerRadius(18))
                
                // Lock button
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(strokeColor, lineWidth: 3.0)
                    .frame(width: 2, height: 30)
                    .offset(x: 75, y: -87)
                
                // Volume up button
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(strokeColor, lineWidth: 3.0)
                    .frame(width: 2, height: 20)
                    .offset(x: -75, y: -100)
                
                // Volume down button
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(strokeColor, lineWidth: 3.0)
                    .frame(width: 2, height: 20)
                    .offset(x: -75, y: -70)
                
                // Dynamic Island
                Capsule()
                    .fill(strokeColor)
                    .frame(width: 40, height: 12)
                    .offset(y: -138)
            }
            .frame(width: 150, height: 300)
    }
    
    /// A visual representation of an iPhone with face ID notch.
    static func iPhoneNotch(strokeColor: Color = .primary, fillColor: Color = .clear) -> some View {
            ZStack {
                //iPhone frame
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(strokeColor, lineWidth: 3.0)
                    .background(fillColor.cornerRadius(18))
                
                // Lock button
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(strokeColor, lineWidth: 3.0)
                    .frame(width: 2, height: 30)
                    .offset(x: 75, y: -87)
                
                // Volume up button
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(strokeColor, lineWidth: 3.0)
                    .frame(width: 2, height: 20)
                    .offset(x: -75, y: -100)
                
                // Volume down button
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .stroke(strokeColor, lineWidth: 3.0)
                    .frame(width: 2, height: 20)
                    .offset(x: -75, y: -70)
                
                // Top notch
                Rectangle()
                    .fill(strokeColor)
                    .frame(width: 70, height: 12)
                    .clipShape(KGRoundedCorner(corners: [.bottomLeft, .bottomRight], radius: 15))
                    .offset(y: -142)
            }
            .frame(width: 150, height: 300)
    }

    
    /// A visual representation of an iPhone with home button.
    static func iPhoneHomeButton(strokeColor: Color = .primary, fillColor: Color = .clear) -> some View {
        
        ZStack {
            // iPhone frame
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(strokeColor, lineWidth: 3.0)
                .background(fillColor.cornerRadius(18))
            
            // Lock button
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(strokeColor, lineWidth: 3.0)
                .frame(width: 2, height: 30)
                .offset(x: 75, y: -87)
            
            // Volume up button
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(strokeColor, lineWidth: 3.0)
                .frame(width: 2, height: 20)
                .offset(x: -75, y: -100)
            
            // Volume down button
            RoundedRectangle(cornerRadius: 15, style: .continuous)
                .stroke(strokeColor, lineWidth: 3.0)
                .frame(width: 2, height: 20)
                .offset(x: -75, y: -70)
            
            // Home button
            Rectangle()
                .fill(strokeColor)
                .frame(width: 20, height: 20)
                .clipShape(Circle())
                .offset(y: 135)
        }
        .frame(width: 150, height: 300)
    }
    
}




// MARK: Preview
fileprivate struct TestView: View {
    var body: some View {
        KGDeviceViews.iPhoneHomeButton()
        KGDeviceViews.iPhoneNotch()
        KGDeviceViews.iPhoneIsland()
    }
}

fileprivate struct KGDeviceViews_Preview: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
