//
//  StickyHeaders.swift
//
//  Created by Kevin Green on 10/13/22.
//

import SwiftUI

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
  


// MARK: Preview
fileprivate struct StickyHeader_Preview: PreviewProvider {
    static var previews: some View {
        ScrollView(showsIndicators: false) {
            StickyHeader {
                Image(systemName: "person")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(.green)
            }
            .frame(height: 300)
        }
        .background {
            Color.blue.ignoresSafeArea()
        }
    }
}
