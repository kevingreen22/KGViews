//
//  StickyHeaders.swift
//
//  Created by Kevin Green on 10/13/22.
//

import SwiftUI
import UIKit

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct StickyHeader<Content>: View where Content: View {
    public var content: Content
    
    public init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            GeometryReader { proxy in
                if proxy.frame(in: .global).minY <= 0 {
                    content
                        .frame(width: proxy.size.width, height: proxy.size.height)
                } else {
                    content
                        .frame(width: proxy.size.width, height: proxy.size.height + proxy.frame(in: .global).minY)
                    
                    // sticks image to the top
                        .offset(y: -proxy.frame(in: .global).minY)
                }
            }.frame(height: 300)
        }
    }
}


@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
public struct StickyHeader2<ContentA, ContentB>: View where ContentA: View, ContentB: View {
    public var contentA: ContentA
    public var contentB: ContentB
    
    public init(@ViewBuilder _ contentA: () -> ContentA, @ViewBuilder contentB: () -> ContentB) {
        self.contentA = contentA()
        self.contentB = contentB()
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            GeometryReader { proxy in
                if proxy.frame(in: .global).minY <= 0 {
                    contentA
                        .frame(width: proxy.size.width, height: proxy.size.height)
                } else {
                    contentB
                        .frame(width: proxy.size.width, height: proxy.size.height + proxy.frame(in: .global).minY)
                    
                    // sticks image to the top
                        .offset(y: -proxy.frame(in: .global).minY)
                }
            }
        }
    }
}
  

// MARK: Sticky Header Demo
fileprivate struct StickyHeader_Demo: PreviewProvider {
    static var previews: some View {
        ScrollView(showsIndicators: false) {
            StickyHeader {
                Image(packageResource: "sticky_header", ofType: ".png")
                    .resizable()
                    .scaledToFill()
            }
            .frame(height: 100)
        }
        .background {
            Color.orange.ignoresSafeArea()
        }
    }
}

#Preview {
    ScrollView(showsIndicators: false) {
        StickyHeader {
            Image(packageResource: "sticky_header", ofType: ".png")
                .resizable()
                .scaledToFill()
        }
        .frame(height: 100)
    }
    .background {
        Color.orange.ignoresSafeArea()
    }
}



// This is used for the image resource within the package.
extension Image {
    init(packageResource name: String, ofType type: String) {
        guard let path = Bundle.module.path(forResource: name, ofType: type), let image = UIImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(uiImage: image)
    }
}
