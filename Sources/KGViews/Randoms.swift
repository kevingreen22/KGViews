//
//  StaticViewWithKeyboard.swift
//

import SwiftUI

public extension View {
    
    /// Prevents the view from moving upwards when the keyboard is shown.
    ///
    /// Created by Kevin Green on 11/24/23.
    func staticViewWithKeyboard() -> some View {
        GeometryReader { _ in
            self
        }
        .ignoresSafeArea(.keyboard)
    }
    
    ///  Dismisses the keyboard
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



//


public extension View {
    
}
#endif
