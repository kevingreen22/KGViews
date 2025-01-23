//
//  PagingIndicator.swift
//
//  Created by Kevin Green on 1/23/25.
//

import SwiftUI

/// A custom paging indicator with an animating effect on the current page indicator.
/// - Parameters:
///   - currentPage: A state variable containing the current page index.
///   - activeTint: The color of the active page indicator. Defaults to xcassets accent color.
///   - inactiveTint: The color of the inactive page indicators. Defaults to xcassets accent color with opacity.
@available(iOS 14.0, *)
public struct PagingIndicator: View {
    @Binding var currentPage: Int
    var pageCount: Int
    var activeTint: Color = .accentColor
    var inactiveTint: Color = .accentColor.opacity(0.15)
    
    private var screenWidth: CGFloat {
        guard let scene = UIApplication.shared.connectedScenes.first,
              let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
              let window = windowSceneDelegate.window,
              let width = window?.bounds.width
        else {
            return UIScreen.main.bounds.width
        }
        return width
    }
    
    public var body: some View {
        let segmentWidth = screenWidth/CGFloat(pageCount)
        HStack(spacing: 8) {
            ForEach(1...pageCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: segmentWidth/2)
                    .frame(width: currentPage == index ? segmentWidth : segmentWidth/CGFloat(pageCount), height: 8)
                    .foregroundColor(currentPage == index ? activeTint : inactiveTint)
                    .onTapGesture {
                        currentPage = index
                    }
                    .animation(.easeInOut, value: currentPage)
            }
        }
    }
}



// MARK: Preivew
struct PreviewHelper: View {
    @State var currentPage = 1
    var pageCount = 5
    
    var body: some View {
        VStack {
            Spacer()
            Button("Next Page") {
                if currentPage < pageCount {
                    currentPage += 1
                } else {
                    currentPage = 1
                }
            }.buttonStyle(.borderedProminent)
            Spacer()
            
            PagingIndicator(currentPage: $currentPage, pageCount: pageCount)
        }
    }
}

struct PagingIndicator_Preview: PreviewProvider {
    static var previews: some View {
        PreviewHelper()
    }
}
