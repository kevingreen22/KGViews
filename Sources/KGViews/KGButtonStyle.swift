//
//  KGButtonStyle.swift
//
//  Created by Kevin Green on 10/27/22.
//

import SwiftUI

/// Scales the button view down when pressed, and back up when let go.
/// The total durataion is 0.5 seconds. When adding a visual animation/transition after the press of the button, be sure to delay that animation/transition this amount of time.
public struct KGScaledButtonStyle: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.94 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

