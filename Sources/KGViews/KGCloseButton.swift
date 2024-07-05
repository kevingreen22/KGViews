//
//  KGCloseButton.swift
//
//
//  Created by Kevin Green on 1/1/24.
//

import SwiftUI

public extension View {
    
    /// Easy close button overlay, with an optional closure action.
    func closeButton(
        alignment: Alignment = .topTrailing,
        iconName: String = "xmark",
        withBackground: Bool = true,
        action: (()->())? = nil
    ) -> some View {
        self.overlay(alignment: alignment) {
            CloseButton(iconName: iconName, withBackground: withBackground, action: action)
        }
    }
    
}

public struct CloseButton: View {
    var iconName: String = "xmark"
    var withBackground: Bool = true
    var action: (()->())? = nil
    
    @Environment(\.dismiss) private var dismiss
    
    public init(iconName: String = "xmark", withBackground: Bool = true, action: (()->Void)? = nil) {
        self.iconName = iconName
        self.withBackground = withBackground
        self.action = action
    }
    
    public var body: some View {
        Button {
            action?()
            dismiss()
        } label: {
            Image(systemName: iconName)
                .foregroundStyle(Color.white)
                .padding(8)
                .background {
                    if withBackground {
                        Color.gray.opacity(0.7).blur(radius: 3.0)
                    }
                }
                .shadow(radius: 10)
                .clipShape(Circle())
        }
        .ignoresSafeArea()
    }
}


// MARK: Demo
#Preview {
    return VStack {
        Text("Close button")
    }
    .frame(width: 300, height: 300)
    .background { Color.red }
    .closeButton()
}

