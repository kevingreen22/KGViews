//
//  RealBlur.swift
//
//  Created by Kevin Green on 8/20/22.
//

import SwiftUI
import UIKit

public struct RealBlur: View {
    var style: UIBlurEffect.Style = .regular
    var onTap: (() -> ())? = nil
    
    public init(style: UIBlurEffect.Style, onTap: (() -> Void)? = nil) {
        self.style = style
        self.onTap = onTap
    }

    public var body: some View {
        VisualEffect(style: style)
            .onTapGesture(perform: self.onTap ?? {} )
    }
}

fileprivate struct VisualEffect: UIViewRepresentable {
    var style: UIBlurEffect.Style = .regular
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let effectView = UIVisualEffectView()
        let blurEffect = UIBlurEffect(style: style)
        effectView.effect = blurEffect
        return effectView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}


// MARK: Real Blur Demo
fileprivate struct RealBlur_Demo: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            Image(systemName: "person.fill")
                .scaleEffect(5)
            RealBlur(style: .regular)
                .frame(width: 100, height: 100)
                .offset(x: 50)
        }
    }
}

#Preview {
    ZStack {
        Color.green.ignoresSafeArea()
        Image(systemName: "person.fill")
            .scaleEffect(5)
        RealBlur(style: .regular)
            .frame(width: 100, height: 100)
            .offset(x: 50)
    }
}
